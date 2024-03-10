/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::payload::Payload;
use crate::core::project::VerdeProject;
use anyhow::Context;
use notify::{RecommendedWatcher, RecursiveMode, Watcher};
use notify_debouncer_full::{new_debouncer, DebounceEventResult, DebouncedEvent, Debouncer, FileIdMap};
use std::{path::PathBuf, sync::Arc, time::Duration};
use tokio::sync::mpsc;

// See trunk for a good notify watcher implementation
// Watcher: https://github.com/trunk-rs/trunk/blob/main/src/watch.rs
// Move watcher specific code to watcher.rs the above example has a ignore file example
// Ignore file example can be used with the glob rules to create payload structs

/// The duration for the debounce watcher events.
const DEBOUNCE_DURATION: Duration = Duration::from_secs(2);

type VerdeDebouncer = Debouncer<RecommendedWatcher, FileIdMap>;

/// The Verde watcher.
pub struct VerdeWatcher {
  /// The verde project associated with this watcher.
  project: Arc<VerdeProject>,

  /// The debouncer watching for file system events.
  debouncer: VerdeDebouncer,

  /// The debounced event receiver channel.
  watch_rx: mpsc::Receiver<DebouncedEvent>,

  /// The payload sender channel.
  payload_tx: mpsc::Sender<Payload>,

  /// The payload receiver channel.
  payload_rx: mpsc::Receiver<Payload>,
}

impl VerdeWatcher {
  /// Create a new Verde watcher for the specified project.
  pub fn new(project: &Arc<VerdeProject>) -> anyhow::Result<Self> {
    let (watch_tx, watch_rx) = mpsc::channel(1); // watch send/receive queue 1 item
    let (payload_tx, payload_rx) = mpsc::channel::<Payload>(1); // payload send/receive queue 1 item

    let watch_project = Arc::clone(project);
    let root = watch_project.root.as_ref().unwrap().clone();
    let debouncer = create_watcher(watch_tx, vec![root])?;

    Ok(Self {
      project: watch_project,
      debouncer,
      watch_rx,
      payload_tx,
      payload_rx,
    })
  }

  /// Starts listening for events.
  pub async fn start(mut self) {
    loop {
      if let Some(ev) = self.watch_rx.recv().await {
        self.transform_event(ev).await;
      }
    }
  }

  /// Transforms the debounced event into a payload event.
  async fn transform_event(&mut self, event: DebouncedEvent) {}
}

/// Creates a new file system watcher piping events to the watch transmitter.
pub fn create_watcher(watch_tx: mpsc::Sender<DebouncedEvent>, paths: Vec<PathBuf>) -> anyhow::Result<VerdeDebouncer> {
  // Create watcher (in the future we can probably allow specifying polling explicitly for rare cases)
  let mut debouncer = new_debouncer(
    DEBOUNCE_DURATION,
    None,
    move |result: DebounceEventResult| match result {
      Ok(events) => events.into_iter().for_each(|event| {
        let _ = watch_tx.blocking_send(event);
      }),
      Err(error) => error.iter().for_each(|error| println!("{error:?}")),
    },
  )
  .with_context(|| "failed to create watcher")?;

  // Setup watcher and cache for each specified root
  for path in paths {
    debouncer
      .watcher()
      .watch(&path, RecursiveMode::Recursive)
      .with_context(|| format!("Failed to watch {path:?} for file changes."))?;

    debouncer.cache().add_root(&path, RecursiveMode::Recursive);
  }

  Ok(debouncer)
}
