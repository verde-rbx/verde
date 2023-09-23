/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
pub mod project;
pub mod session;

use self::project::VerdeProject;
use self::session::{SessionState, VerdeSession};
use std::fs::File;

pub struct VerdeCore {
    /// Current loaded project file
    pub project: Option<VerdeProject>,

    pub session: Option<VerdeSession>,
}

// TODO: Should builder syntax be separated into VerdeCoreBuilder?
impl VerdeCore {
    pub fn new() -> Self {
        VerdeCore {
            project: None,
            session: None,
        }
    }

    /// Sets the current Verde Project
    pub fn project(&mut self, path: &str) -> &mut Self {
        match self.project {
            Some(_) => println!("A project has already been specified"),
            None => {
                let mut project_file = File::open(path).unwrap();
                let created_project = VerdeProject::from(&mut project_file);
                self.project = created_project.ok();
            }
        }

        self
    }

    /// Starts a new Verde Session
    pub fn start_session(&mut self) -> &mut Self {
        match &self.session {
            None => self.session = Some(VerdeSession::default()),
            Some(session) => {
                match session.state {
                    SessionState::Active => println!("Session is already active"),
                    SessionState::Offline => session.start(),
                    SessionState::Error => session.get_latest_error(),
                };
            }
        };

        self
    }
}

impl Default for VerdeCore {
    fn default() -> Self {
        Self::new()
    }
}
