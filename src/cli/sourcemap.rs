/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::{
    project::{self, VerdeProject},
    sourcemap::VerdeSourcemap,
};
use clap::{Parser, ValueHint};
use std::{fs::File, path::PathBuf};

#[derive(Parser)]
/// Creates a sourcemap using the project file.
///
pub struct SourcemapArgs {
    #[arg(value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
    project: PathBuf,
}

impl SourcemapArgs {
    pub fn execute(self) -> anyhow::Result<()> {
        let mut proj_file = File::open(self.project)?;
        let proj = VerdeProject::from(&mut proj_file)?;
        let sourcemap = VerdeSourcemap::from_project(&proj);

        // TODO: Do we want file output as well?
        println!("{}", serde_json::to_string(&sourcemap)?);

        Ok(())
    }
}
