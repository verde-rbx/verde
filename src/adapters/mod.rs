/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
mod rojo;

use std::path::Path;

/// Detects the project file type
pub fn detect_project(path: &Path) -> Option<&Path> {
    if path.is_file() {
        if path.ends_with(".project.json") {
            return Some(path);
        }
    } else {
        for _entry in path.read_dir().expect("Failed to read directory").flatten() {
            todo!("Check each entry for a project path");
        }
    }

    None
}

/// Converts the project file type using an adapter to a Verde project
pub fn convert_project() {}
