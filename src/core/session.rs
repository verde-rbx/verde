/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::api;
use crate::core::VerdeProject;
use notify::RecommendedWatcher;
use notify_debouncer_full::{
  new_debouncer,
  notify::{RecursiveMode, Watcher},
  DebounceEventHandler, DebounceEventResult, Debouncer, FileIdMap,
};
use std::{
  net::{IpAddr, Ipv4Addr, SocketAddr},
  sync::Arc,
  time::Duration,
};
use tokio::runtime::{Builder, Runtime};

pub const DEFAULT_HOST: IpAddr = IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1));
pub const DEFAULT_PORT: u16 = 3000;

/// Manages the Verde Session and state.
pub struct VerdeSession {
  /// The hostname the session will listen on.
  pub host: IpAddr,

  /// The port the session will listen on.
  pub port: u16,

  /// The current state of the session.
  pub state: SessionState,

  /// The project tied to the session.
  pub project: Arc<VerdeProject>,

  /// The tokio runtime for asynchronous tasks
  runtime: Runtime,
}

/// Describes the current state of the session.
pub enum SessionState {
  /// Session is actively watching and synchronising files.
  Active,

  /// Session is not externally accessible and is closed.
  Offline,

  /// Session encountered an error and cannot continue.
  Error,
}

impl VerdeSession {
  /// Creates a new VerdeSession.
  ///
  /// This is the same as calling
  /// ```rs
  /// VerdeSession::default()
  /// ```
  pub fn new(project: &Arc<VerdeProject>) -> Self {
    VerdeSession {
      project: Arc::clone(project),
      ..Default::default()
    }
  }

  /// Setup watcher and watch for changes
  pub fn watch<F: DebounceEventHandler>(&self, handler: F) -> Box<Debouncer<RecommendedWatcher, FileIdMap>> {
    let mut debouncer = new_debouncer(Duration::from_secs(2), None, handler).unwrap();

    let project = Arc::clone(&self.project);
    let root = project.root.as_ref().unwrap();
    debouncer.watcher().watch(root, RecursiveMode::Recursive).unwrap();
    debouncer.cache().add_root(root, RecursiveMode::Recursive);
    Box::new(debouncer)
  }

  /// Starts the session and begins listening
  pub fn start(&self) {
    println!("Serving on port {}", self.port);

    // Setup watcher
    let debouncer = self.watch(|result: DebounceEventResult| match result {
      Ok(events) => events.iter().for_each(|event| println!("{event:?}")),
      Err(error) => error.iter().for_each(|error| println!("{error:?}")),
    });

    // Start listening on api
    self.runtime.block_on(async {
      let api = api::get_api(Arc::clone(&self.project));
      warp::serve(api).run(SocketAddr::new(self.host, self.port)).await;
    });

    debouncer.stop();
    println!("Stopped watching..");
  }
}

impl Default for VerdeSession {
  fn default() -> Self {
    Self {
      host: DEFAULT_HOST,
      port: DEFAULT_PORT,
      state: SessionState::Offline,
      project: Arc::default(),
      runtime: Builder::new_multi_thread().enable_all().build().unwrap(),
    }
  }
}
