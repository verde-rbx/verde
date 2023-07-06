/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use super::VerdeCommand;
use crate::core::VerdeCore;
use clap::{Parser, ValueHint};
use std::{net::IpAddr, path::PathBuf};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
pub struct ServeArgs {
    #[arg(long, alias="path", value_hint=ValueHint::FilePath)]
    project: PathBuf,

    #[arg(long, alias="address", value_hint=ValueHint::Hostname)]
    host: IpAddr,

    #[arg(short, long)]
    port: u32,
}

impl VerdeCommand for ServeArgs {
    fn execute(self) {
        println!("Serving on port {}", self.port);

        let session = VerdeCore::new(self.project.as_path()).unwrap();
        println!("Project Name: {}", session.project.name);
    }
}
