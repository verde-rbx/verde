// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use crate::core::payload::{Payload, PayloadAction, PayloadInstance};
use crate::core::project::VerdeProject;
use anyhow::{bail, Context};
use notify::{RecommendedWatcher, RecursiveMode, Watcher};
use notify_debouncer_full::{new_debouncer, DebounceEventResult, DebouncedEvent, Debouncer, FileIdMap};
use std::{
  path::PathBuf,
  str::FromStr,
  sync::{Arc, RwLock},
  time::Duration,
};
use tokio::sync::mpsc;

/// The duration for the debounce watcher events.
const DEBOUNCE_DURATION: Duration = Duration::from_secs(2);

type VerdeDebouncer = Debouncer<RecommendedWatcher, FileIdMap>;

/// The Verde watcher.
pub struct VerdeWatcher {
  /// The debouncer watching for file system events.
  _debouncer: VerdeDebouncer,

  /// The debounced event receiver channel.
  watch_rx: mpsc::Receiver<DebouncedEvent>,

  /// The payload.
  pub payload: Arc<RwLock<Payload>>,
}

impl VerdeWatcher {
  /// Create a new Verde watcher for the specified project.
  pub fn new(project: &Arc<VerdeProject>) -> anyhow::Result<Self> {
    let (watch_tx, watch_rx) = mpsc::channel(1); // watch send/receive queue 1 item

    // Create debounce watcher
    let node_paths = project.tree.get_paths();
    let paths = node_paths
      .keys()
      .filter_map(|s| match PathBuf::from_str(s) {
        Ok(e) => {
          if e.try_exists().is_ok_and(|f| f) {
            e.canonicalize().ok()
          } else {
            None
          }
        }
        Err(_) => None,
      })
      .collect();

    let _debouncer = create_watcher(watch_tx, paths)?;

    // Create initial payload
    let payload = Arc::new(RwLock::new(Payload::default()));

    Ok(Self {
      _debouncer,
      watch_rx,
      payload,
    })
  }

  /// Starts listening for events.
  pub async fn start(&mut self) {
    loop {
      if let Some(ev) = self.watch_rx.recv().await {
        self.transform_event(ev).await
      }
    }
  }

  /// Transforms the debounced event into a payload event.
  async fn transform_event(&mut self, event: DebouncedEvent) {
    // We only want to track file changes.
    if let Some(file_path) = event.paths.first() {
      if !file_path.is_file() {
        return;
      }

      // Get the Node associated with file
      // - Create Roblox instance path (game.workspace.x)
      //      init.lua -> game.workspace.parent_dir
      //      *.lua -> game.workspace.parent_dir.script
      // - Get Classname (Script, ModuleScript, LocalScript)

      // Then add to Payload
      if let Ok(mut payload) = self.payload.try_write() {
        let payload_instance = PayloadInstance {
          instance: file_path.to_string_lossy().into_owned(),
          value: None,
        };

        let action = match event.kind {
          notify::EventKind::Remove(_) => PayloadAction::Delete(payload_instance),
          _ => PayloadAction::Change(payload_instance),
        };

        payload.add_payload(action)
      }
    }
  }
}

/// Creates a new file system watcher piping events to the watch transmitter.
pub fn create_watcher(watch_tx: mpsc::Sender<DebouncedEvent>, paths: Vec<PathBuf>) -> anyhow::Result<VerdeDebouncer> {
  // We shouldnt get any empty paths if project is correct
  if paths.is_empty() {
    bail!("Unable to find any directories to watch. Please check your project file.");
  }

  // Create watcher (in the future we can probably allow specifying polling explicitly for rare cases)
  let mut debouncer = new_debouncer(
    DEBOUNCE_DURATION,
    None,
    move |result: DebounceEventResult| match result {
      Ok(events) => events.into_iter().for_each(|event| {
        watch_tx.blocking_send(event).unwrap();
      }),
      Err(error) => error.iter().for_each(|error| println!("{error:?}")),
    },
  )
  .with_context(|| "failed to create watcher")?;

  // Setup watcher and cache for each specified root
  // The paths should be canonicalized so we dont need to do any extra processing
  for path in paths {
    debouncer
      .watcher()
      .watch(&path, RecursiveMode::Recursive)
      .with_context(|| format!("Failed to watch {path:?} for file changes."))?;

    debouncer.cache().add_root(&path, RecursiveMode::Recursive);
  }

  Ok(debouncer)
}
