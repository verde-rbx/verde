/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
mod init;
mod serve;

use self::init::InitArgs;
use self::serve::ServeArgs;
use clap::Parser;

#[derive(Parser)]
#[command(author, version, about, long_about = None, propagate_version = true)]
pub struct VerdeCli {
    #[command(subcommand)]
    command: Commands,
}

impl VerdeCli {
    pub fn execute(self) {
        match self.command {
            Commands::Serve(command) => command.execute(),
            Commands::Init(command) => command.execute(),
        }
    }
}

#[derive(Parser)]
pub enum Commands {
    Serve(ServeArgs),
    Init(InitArgs),
}
