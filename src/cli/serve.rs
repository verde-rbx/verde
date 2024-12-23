// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use anyhow::bail;
use clap::{Parser, ValueHint};
use std::{net::IpAddr, path::PathBuf};
use verde::core::{project, session, VerdeCore};

/// Starts the Verde synchronisation server.
///
/// Loads the project file and begins watching the configured
/// files for changes. An api accessible through the host and port
/// will provide access to the watched files for use by the Verde
/// studio plugin.
#[derive(Parser)]
pub struct ServeArgs {
  /// The project file to configure the server with.
  ///
  /// A valid Verde yaml project which contains the filepath
  /// configuration for the file watcher and mappings for the Roblox
  /// DataModel.
  #[arg(long, alias="path", value_hint=ValueHint::FilePath, default_value = project::DEFAULT_PROJECT)]
  project: PathBuf,

  /// The host ip address to serve and listen to requests on.
  #[arg(long, alias="address", value_hint=ValueHint::Hostname, default_value_t = session::DEFAULT_HOST)]
  host: IpAddr,

  /// The port to serve and listen to requests on.
  #[arg(short, long, default_value_t = session::DEFAULT_PORT)]
  port: u16,
}

impl ServeArgs {
  pub fn execute(&self) -> anyhow::Result<()> {
    // Validate path is a file
    let path = self.project.as_path();
    if !path.is_file() {
      bail!("'project' must point to a file. Got {}", path.display());
    }

    // Create core if path can be stringified.
    if let Some(path_str) = path.to_str() {
      VerdeCore::new().project(path_str)?.start_session()?;
    } else {
      bail!("No path specified.")
    }

    // Cleanup
    println!("Session ended gracefully.");
    Ok(())
  }
}
