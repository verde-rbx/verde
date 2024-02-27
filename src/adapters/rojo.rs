/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::{node::base::Node, project::VerdeProject};
use serde::{self, Deserialize};
use std::{collections::BTreeMap, net::IpAddr};

// Rojo project structure taken from the Rojo github:
// This project structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
#[serde(deny_unknown_fields, rename_all = "camelCase")]
pub struct RojoProject {
  pub name: String,

  pub tree: RojoProjectNode,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub serve_port: Option<u16>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub serve_address: Option<IpAddr>,
}

impl From<RojoProject> for VerdeProject {
  fn from(value: RojoProject) -> Self {
    Self {
      name: value.name,
      tree: value.tree.into(),
    }
  }
}

// Rojo project node taken from the Rojo github:
// This node structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
pub struct RojoProjectNode {
  #[serde(rename = "$className", skip_serializing_if = "Option::is_none")]
  pub class_name: Option<String>,

  /// Contains all of the children of the described instance.
  #[serde(flatten)]
  pub children: BTreeMap<String, RojoProjectNode>,

  #[serde(rename = "$ignoreUnknownInstances", skip_serializing_if = "Option::is_none")]
  pub ignore_unknown_instances: Option<bool>,

  #[serde(rename = "$path", skip_serializing_if = "Option::is_none")]
  pub path: Option<String>,
}

impl From<RojoProjectNode> for Node {
  /// Converts a Rojo ProjectNode to Verde Node
  fn from(node: RojoProjectNode) -> Self {
    let mut child_nodes = BTreeMap::<String, Self>::new();
    for (key, child) in node.children {
      child_nodes.insert(key.to_string(), child.into());
    }

    // Convert properties to verde format
    let overwrite_descendants = node.ignore_unknown_instances.and_then(|f| match f {
      true => None,
      _ => Some(true),
    });

    Self {
      class_name: node.class_name.to_owned(),
      path: node.path.to_owned(),
      overwrite_descendants,
      contents: Some(child_nodes),
    }
  }
}
