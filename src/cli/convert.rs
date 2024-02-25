/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::{adapters::convert_project, core::project};
use anyhow::bail;
use clap::{Parser, ValueHint};
use std::path::PathBuf;

#[derive(Parser)]
/// Converts supported project formats to the Verde project.
pub struct ConvertArgs {
  // TODO: Allow to omit project path to auto detect project in CWD
  /// The project file to convert.
  project: PathBuf,

  /// The format to convert from.
  #[arg(short, long)]
  format: Option<String>,

  /// Where to output.
  #[arg(short, long, value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
  out: PathBuf,
}

impl ConvertArgs {
  pub fn execute(self) -> anyhow::Result<()> {
    // Confirm path
    let path = self.project.as_path();
    if !path.is_file() {
      bail!("'project' must point to a file. Got {}", path.display());
    }

    // Convert and save project
    let project = convert_project(path)?;
    project.save_to(&self.out)?;
    println!(
      "Successfully converted {:#?} to Verde project. Saved to {:#?}",
      path.file_name().unwrap(),
      self.out.display()
    );

    Ok(())
  }
}
