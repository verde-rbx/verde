/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
pub mod project;

use std::{error::Error, fs, path::Path};

use self::project::VerdeProject;

pub struct VerdeCore {
    /// Current loaded project file
    pub project: VerdeProject,
}

impl VerdeCore {
    pub fn new(src: &Path) -> Result<VerdeCore, Box<dyn Error>> {
        let project_file = fs::read_to_string(src)?;

        Ok(VerdeCore {
            project: serde_yaml::from_str(project_file.as_ref()).unwrap(),
        })
    }

    pub fn start_session(self) {}
}
