// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
mod convert;
mod init;
mod serve;
mod sourcemap;

use std::fmt::Display;

use crate::cli::convert::ConvertArgs;
use crate::cli::init::InitArgs;
use crate::cli::serve::ServeArgs;
use crate::cli::sourcemap::SourcemapArgs;
use anyhow::Context;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about, long_about = None, propagate_version = true)]
pub struct VerdeCli {
  #[command(subcommand)]
  command: Commands,
}

impl VerdeCli {
  pub fn execute(self) -> anyhow::Result<()> {
    match &self.command {
      Commands::Convert(command) => command.execute(),
      Commands::Init(command) => command.execute(),
      Commands::Serve(command) => command.execute(),
      Commands::Sourcemap(command) => command.execute(),
    }
    .with_context(|| format!("Error whilst executing command {}", self.command))
  }
}

#[derive(Subcommand)]
pub enum Commands {
  Convert(ConvertArgs),
  Init(InitArgs),
  Serve(ServeArgs),
  Sourcemap(SourcemapArgs),
}

impl Display for Commands {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    match &self {
      Commands::Convert(_) => f.write_str("Convert"),
      Commands::Init(_) => f.write_str("Init"),
      Commands::Serve(_) => f.write_str("Serve"),
      Commands::Sourcemap(_) => f.write_str("Sourcemap"),
    }
  }
}
