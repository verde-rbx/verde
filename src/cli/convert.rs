/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use clap::{Parser, ValueHint};
use std::path::PathBuf;

use crate::adapters::convert_project;

#[derive(Parser)]
/// Converts support project formats to the Verde project
pub struct ConvertArgs {
    // TODO: Allow to omit project path to auto detect project in CWD
    /// The project file to convert.
    #[arg(short, long, value_hint=ValueHint::FilePath)]
    project: PathBuf,

    /// The format to convert from.
    #[arg(short, long)]
    format: Option<String>,
}

impl ConvertArgs {
    pub fn execute(self) {
        let path = self.project.as_path();
        let project = convert_project(path);
        if let Ok(project) = project {
            project.save();
            println!("Successfully converted project.")
        }
    }
}
