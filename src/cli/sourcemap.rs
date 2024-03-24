/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::{
  project::{self, VerdeProject},
  sourcemap::VerdeSourcemap,
};
use anyhow::{bail, Context};
use clap::{Parser, ValueHint};
use std::{fs::File, io::Write, path::PathBuf};

#[derive(Parser)]
/// Creates a new sourcemap file using a project file.
pub struct SourcemapArgs {
  /// The project file to create a sourcemap of.
  #[arg(value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
  project: PathBuf,

  /// Sourcemap output file. Leaving unspecified will output to stdout.
  #[arg(short, long, value_hint=ValueHint::FilePath, default_value = None)]
  out: Option<PathBuf>,
}

impl SourcemapArgs {
  pub fn execute(self) -> anyhow::Result<()> {
    // Confirm path
    let path = self.project.as_path();
    if !path.is_file() {
      bail!("'project' must point to a file. Got {path:?}");
    }

    // Open file and create sourcemap from project
    let proj = VerdeProject::try_from(&self.project)?;
    let sourcemap = VerdeSourcemap::from(&proj);

    // Output to 'out' file or stdout.
    match self.out {
      Some(out) => {
        let json_output = serde_json::to_vec(&sourcemap)?;
        let mut out_file = File::create(&out).context("Failed to create file.")?;
        out_file
          .write_all(&json_output)
          .context("Failed to write json to buffer.")?;

        println!("Generated sourcemap and saved to {:?}.", out.display());
        Ok(())
      }
      None => {
        let json_output = serde_json::to_string(&sourcemap)?;
        println!("{json_output:?}");
        Ok(())
      }
    }
  }
}
