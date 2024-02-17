/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
pub mod project;
pub mod session;
pub mod sourcemap;

use self::project::VerdeProject;
use self::session::{SessionState, VerdeSession};
use anyhow::bail;
use std::fs::File;

pub struct VerdeCore {
  /// Current loaded project file
  pub project: Option<VerdeProject>,

  pub session: Option<VerdeSession>,
}

// TODO: I think this is redundent and session/project should be their own thing
//       Session relies on project so making them in this structure makes it difficult to pass them around
impl VerdeCore {
  pub fn new() -> Self {
    VerdeCore {
      project: None,
      session: None,
    }
  }

  /// Sets the current Verde Project
  pub fn project(&mut self, path: &str) -> anyhow::Result<&mut Self> {
    match self.project {
      Some(_) => println!("A project has already been specified"),
      None => {
        let mut project_file = File::open(path)?;
        self.project = Some(VerdeProject::from(&mut project_file)?);
      }
    }

    Ok(self)
  }

  /// Starts a new Verde Session
  pub fn start_session(&mut self) -> anyhow::Result<&mut Self> {
    if let Some(project) = self.project.take() {
      match &self.session {
        None => self.session = Some(VerdeSession::default()),
        Some(session) => {
          match session.state {
            SessionState::Active => println!("Session is already active"),
            SessionState::Offline => session.start(project),
            SessionState::Error => session.get_latest_error(),
          };
        }
      };
    } else {
      bail!("Please ensure a project is loaded before starting a session.");
    }

    Ok(self)
  }
}

impl Default for VerdeCore {
  fn default() -> Self {
    Self::new()
  }
}
