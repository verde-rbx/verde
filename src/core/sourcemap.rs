/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use super::project::VerdeProject;
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

/// The sourcemap schema has been defined by Rojo and adopted by third parties becoming the standard.
/// Ideally, we would want to migrate this to something like types.d.ts?
#[derive(Serialize, Deserialize)]
struct Sourcemap<'a> {
    /// The name of the node.
    pub name: &'a str,

    /// The Roblox class name.
    pub class_name: &'a str,

    /// The file paths associated with the node.
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub file_paths: Vec<PathBuf>,

    /// Child nodes.
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub children: Vec<Sourcemap<'a>>,
}

impl<'a> Sourcemap<'a> {
    pub fn from_project(project: &VerdeProject) {
        
    }
}
