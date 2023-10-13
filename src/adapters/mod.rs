/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
mod rojo;

use crate::core::project::VerdeProject;
use anyhow::bail;
use std::{
    fs::{self, File},
    io::Read,
    path::Path,
};

/// Available adapter types
enum Adapters {
    Rojo,
}

/// Detects the project file type
fn detect_project(path: &Path) -> Option<Adapters> {
    if path.is_file() {
        let file_name = path.file_name().unwrap().to_str().unwrap();
        let suffix = file_name.split_once('.').unwrap().1;
        return match suffix {
            "project.json" => Some(Adapters::Rojo),
            _ => None,
        };
    } else {
        for _entry in path.read_dir().expect("Failed to read directory").flatten() {
            todo!("Check each entry for a project path");
        }
    }

    None
}

/// Converts the project file type using an adapter to a Verde project
pub fn convert_project(path: &Path) -> anyhow::Result<VerdeProject> {
    let project_type = detect_project(path);

    // Open file and read contents
    let buffer = fs::read_to_string(path)?;
    let converted = match project_type {
        Some(Adapters::Rojo) => rojo::convert(&buffer),
        None => bail!("Unable to detect project type."),
    }?;

    Ok(converted)
}
