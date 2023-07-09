/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

/// Manages the Verde Session and state
pub struct VerdeSession {
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

impl Default for VerdeSession {
    fn default() -> Self {
        Self {
            state: SessionState::Offline,
        }
    }
}
