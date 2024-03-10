/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
pub mod payload;
pub mod project;
pub mod session;
pub mod sourcemap;
pub mod watcher;

use crate::core::project::VerdeProject;
use crate::core::session::{SessionState, VerdeSession};
use anyhow::bail;
use std::path::PathBuf;
use std::sync::Arc;

#[derive(Default)]
pub struct VerdeCore {
  /// Current loaded project file
  pub project: Option<Arc<VerdeProject>>,

  pub session: Option<VerdeSession>,
}

// TODO: I think this is redundent and session/project should be their own thing
//       Session relies on project so making them in this structure makes it difficult to pass them around
impl VerdeCore {
  /// Creates the Verde Core using defaults.
  pub fn new() -> Self {
    Self::default()
  }

  /// Sets the current Verde Project
  pub fn project(&mut self, path_str: &str) -> anyhow::Result<&mut Self> {
    match self.project {
      Some(_) => println!("A project has already been specified"),
      None => {
        let path = PathBuf::from(path_str);
        let project = VerdeProject::try_from(&path)?;
        self.project = Some(Arc::new(project));
      }
    }

    Ok(self)
  }

  /// Starts a new Verde Session
  pub fn start_session(&self) -> anyhow::Result<&Self> {
    if let Some(project) = &self.project {
      let session = VerdeSession::new(project);
      match session.state {
        SessionState::Active => println!("Session is already active"),
        SessionState::Offline => session.start()?,
        SessionState::Error => println!("Session has entered an errored state."),
      };
    } else {
      bail!("Please ensure a project is loaded before starting a session.");
    }

    Ok(self)
  }
}
