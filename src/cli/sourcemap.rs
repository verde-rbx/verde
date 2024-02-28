/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::{
  project::{self, VerdeProject},
  sourcemap::VerdeSourcemap,
};
use anyhow::bail;
use clap::{Parser, ValueHint};
use std::path::PathBuf;

#[derive(Parser)]
/// Creates a sourcemap using the project file.
pub struct SourcemapArgs {
  #[arg(value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
  project: PathBuf,
}

impl SourcemapArgs {
  pub fn execute(self) -> anyhow::Result<()> {
    // Confirm path
    let path = self.project.as_path();
    if !path.is_file() {
      bail!("'project' must point to a file. Got {}", path.display());
    }

    // Open file and create sourcemap from project
    let path_str = path.to_str().unwrap_or(project::DEFAULT_PROJECT);
    let proj = VerdeProject::try_from(path_str)?;
    let sourcemap = VerdeSourcemap::from_project(&proj);

    // TODO: Do we want file output as well?
    println!("{}", serde_json::to_string(&sourcemap)?);

    Ok(())
  }
}
