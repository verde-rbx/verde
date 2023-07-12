/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
pub mod project;
pub mod session;

use self::project::VerdeProject;
use self::session::{SessionState, VerdeSession};
use std::error::Error;

pub struct VerdeCore {
    /// Current loaded project file
    pub project: VerdeProject,

    pub session: VerdeSession,
}

// TODO: Builder syntax? VerdeCore.project(Path).start_session()
impl VerdeCore {
    pub fn new() -> Result<VerdeCore, Box<dyn Error>> {
        Ok(VerdeCore {
            project: VerdeProject::new(None),
            session: VerdeSession::default(),
        })
    }

    /// Starts a new Verde Session
    pub fn start_session(self) {
        match self.session.state {
            SessionState::Active => println!(""),
            SessionState::Offline => self.session.start(),
            SessionState::Error => self.session.get_latest_error(),
        };
    }
}
