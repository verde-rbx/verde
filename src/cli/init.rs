/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use crate::core::project::VerdeProject;
use clap::Parser;
use std::{fs::File, io::Write};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
pub struct InitArgs {}

impl InitArgs {
    pub fn execute(self) {
        let project = VerdeProject::default();
        let project_yaml = serde_yaml::to_string(&project)
            .expect("Failed to serialise project")
            .into_bytes();

        let mut project_file = File::create("default.project.yaml").expect("Could not create project file");
        project_file.write(&project_yaml).expect("Failed to write to project");
        project_file.flush().expect("Failed to flush file");

        println!("New project setup");
    }
}
