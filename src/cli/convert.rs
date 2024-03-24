/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::{adapters::convert_project, core::project};
use anyhow::bail;
use clap::{Parser, ValueHint};
use std::path::PathBuf;

/// Converts supported project formats to the Verde project.
///
/// Verde will accept a number of project formats from different Roblox
/// synchronisation tools and convert them into the Verde project format.
/// An adapter will be selected either automatically or manually using
/// the format argument.
#[derive(Parser, Debug)]
pub struct ConvertArgs {
  /// The project file to convert.
  ///
  /// The input project file must be a supported project file type, this
  /// currently means only *.project.json files using the Rojo structure.
  project: PathBuf,

  /// The format to convert from.
  ///
  /// This overrides the automatic formatter to force Verde to convert using
  /// a specified adapter. Currently, only the Rojo adapter is supported.
  #[arg(short, long)]
  format: Option<String>,

  /// The output project.
  ///
  /// This is the file to output after converting the project.
  #[arg(short, long, value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
  out: PathBuf,
}

impl ConvertArgs {
  pub fn execute(&self) -> anyhow::Result<()> {
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
