/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use serde::{self, Deserialize};
use serde_json;
use std::{collections::BTreeMap, error::Error, fs::File, io::Read, net::IpAddr};

use crate::core::project::{Node, VerdeProject};

// Rojo project structure taken from the Rojo github:
// This project structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
#[serde(deny_unknown_fields, rename_all = "camelCase")]
pub struct Project {
    pub name: String,

    pub tree: ProjectNode,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub serve_port: Option<u16>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub serve_address: Option<IpAddr>,
}

// Rojo project node taken from the Rojo github:
// This node structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
pub struct ProjectNode {
    #[serde(rename = "$className", skip_serializing_if = "Option::is_none")]
    pub class_name: Option<String>,

    /// Contains all of the children of the described instance.
    #[serde(flatten)]
    pub children: BTreeMap<String, ProjectNode>,

    #[serde(rename = "$ignoreUnknownInstances", skip_serializing_if = "Option::is_none")]
    pub ignore_unknown_instances: Option<bool>,

    #[serde(rename = "$path", skip_serializing_if = "Option::is_none")]
    pub path: Option<String>,
}

impl ProjectNode {
    /// Converts a Rojo ProjectNode to Verde Node
    pub fn convert_node(&self) -> Node {
        let mut child_nodes = BTreeMap::<String, Node>::new();
        for (key, child) in &self.children {
            child_nodes.insert(key.to_string(), child.convert_node());
        }

        Node {
            path: self.path.to_owned(),
            properties: None,
            contents: Some(child_nodes),
        }
    }
}

/// Converts the associated project file from Rojo to Verde
pub fn convert(project: &mut File) -> Result<VerdeProject, Box<dyn Error>> {
    let mut buffer = String::new();
    project.read_to_string(&mut buffer)?;
    let rojo_project: Project = serde_json::from_str(&buffer)?;

    Ok(VerdeProject {
        name: rojo_project.name,
        tree: rojo_project.tree.convert_node(),
    })
}
