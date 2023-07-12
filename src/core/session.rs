/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use std::net::{IpAddr, Ipv4Addr};

pub const DEFAULT_HOST: IpAddr = IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1));
pub const DEFAULT_PORT: u32 = 3000;

/// Manages the Verde Session and state.
pub struct VerdeSession {
    /// The hostname the session will listen on.
    pub host: IpAddr,

    /// The port the session will listen on.
    pub port: u32,

    /// The current state of the session.
    pub state: SessionState,
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

/// Adds the default implementation for VerdeSession
impl Default for VerdeSession {
    fn default() -> Self {
        Self {
            host: DEFAULT_HOST,
            port: DEFAULT_PORT,
            state: SessionState::Offline,
        }
    }
}
