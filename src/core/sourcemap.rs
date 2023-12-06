/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::project::{Node, VerdeProject};
use serde::{Deserialize, Serialize};
use std::path::Path;

/// The sourcemap schema has been defined by Rojo and adopted by third parties becoming the standard.
#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct VerdeSourcemap<'a> {
    /// The name of the node.
    pub name: &'a str,

    /// The Roblox class name.
    pub class_name: &'a str,

    /// The file paths associated with the node.
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub file_paths: Vec<&'a Path>,

    /// Child nodes.
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub children: Vec<VerdeSourcemap<'a>>,
}

fn populate_children(tree: &Node) -> Option<Vec<VerdeSourcemap<'_>>> {
    if let Some(contents) = &tree.contents {
        let mut children = Vec::with_capacity(contents.len());

        for (key, child) in contents.iter() {
            let child_contents = match child.contents {
                Some(_) => populate_children(child),
                None => Some(vec![]),
            };

            // TODO: Use node helper to get className
            // TODO: Use node helper to get files under base path
            children.push(VerdeSourcemap {
                name: key,
                class_name: key,
                file_paths: vec![],
                children: child_contents.unwrap(),
            })
        }

        return Some(children);
    }

    None
}

impl<'a> VerdeSourcemap<'a> {
    pub fn from_project(project: &'a VerdeProject) -> Self {
        let populated_children = populate_children(&project.tree);
        VerdeSourcemap {
            name: &project.name,
            class_name: "DataModel",
            file_paths: vec![],
            children: populated_children.unwrap(),
        }
    }
}
