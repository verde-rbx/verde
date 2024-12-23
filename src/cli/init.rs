// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use anyhow::Context;
use clap::Parser;
use verde::core::project::VerdeProject;

/// Initialise a new Verde project.
///
/// This will initialise a new project using Verde defaults.
/// A verde.yaml file, and a src directory containing
/// a client script, server script and a module script will be
/// created in the CWD.
#[derive(Parser)]
pub struct InitArgs {}

impl InitArgs {
  pub fn execute(&self) -> anyhow::Result<()> {
    let project = VerdeProject::default();
    project.save().context("Failed to save project file.")?;

    println!("Successfully initialised new Verde project");
    Ok(())
  }
}
