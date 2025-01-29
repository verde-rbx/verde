// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
#![forbid(unsafe_code)]

mod cli;

use clap::Parser;

fn main() -> anyhow::Result<()> {
  let command = cli::VerdeCli::parse();
  command.execute()?;
  Ok(())
}
