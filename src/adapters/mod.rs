/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
mod rojo;

use std::{fs::File, path::Path};

use crate::core::project::VerdeProject;

enum Adapters {
    Rojo,
}

/// Detects the project file type
fn detect_project(path: &Path) -> Option<Adapters> {
    if path.is_file() {
        let file_name = path.file_name().unwrap().to_str().unwrap();
        let suffix = file_name.split_once(".").unwrap().1;
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
pub fn convert_project(path: &Path) -> Result<VerdeProject, ()> {
    let project_type = detect_project(path);
    let mut file = File::open(path).unwrap();

    let converted = match project_type {
        Some(Adapters::Rojo) => rojo::convert(&mut file),
        None => todo!("Implement custom error struct for adapters"),
    };

    if let Ok(project) = converted {
        return Ok(project);
    }

    // Utilise custom error struct
    Err(())
}
