/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use crate::core::project::VerdeProject;
use clap::Parser;

#[derive(Parser)]
/// Initialises a new Verde project with defaults
pub struct InitArgs {}

impl InitArgs {
    pub fn execute(self) {
        let project = VerdeProject::default();
        project.save();

        println!("New project setup");
    }
}
