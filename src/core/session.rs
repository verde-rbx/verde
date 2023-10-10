/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::api;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
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
    pub fn new() -> Self {
        Self::default()
    }

    /// Starts the session and begins listening
    pub fn start(&self) {
        println!("Serving on port {}", self.port);
        self.runtime.block_on(async {
            let routes = api::get_routes();
            warp::serve(routes).run(SocketAddr::new(self.host, self.port)).await;
        })
    }

    pub fn get_latest_error(&self) {}
}

impl Default for VerdeSession {
    fn default() -> Self {
        Self {
            host: DEFAULT_HOST,
            port: DEFAULT_PORT,
            state: SessionState::Offline,
            runtime: Builder::new_multi_thread().enable_all().build().unwrap(),
        }
    }
}
