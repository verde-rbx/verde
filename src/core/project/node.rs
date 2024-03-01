/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, HashMap};

/// A node describing an instance in the project tree.
#[derive(Serialize, Deserialize, Clone, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Node {
  /// The classname for the instance.
  /// TODO: Fetch instance types from rbx api and auto resolve best one if not specified (ReplicatedStorage -> ReplicatedStorage)
  #[serde(rename = ".class", skip_serializing_if = "Option::is_none")]
  pub class_name: Option<String>,

  /// Path (relative to source directory)
  #[serde(rename = ".path", skip_serializing_if = "Option::is_none")]
  pub path: Option<String>,

  /// Determines if untracked descendants should be forcibly overwritten
  #[serde(rename = ".force", skip_serializing_if = "Option::is_none")]
  pub overwrite_descendants: Option<bool>,

  // Properties applied to the related Roblox instance
  // #[serde(rename = ".properties", skip_serializing_if = "Option::is_none")]
  // pub properties: Option<BTreeMap<String, String>>,
  // TODO: Implement a roblox typing based on api dump
  /// Additonal instance tree
  #[serde(flatten, skip_serializing_if = "Option::is_none")]
  pub contents: Option<BTreeMap<String, Node>>,
}

impl Node {
  /// Recursively locates the paths of child nodes and creates a flattened structure with nodes attached to their paths.
  pub fn get_paths(&self) -> HashMap<String, Node> {
    let mut map = HashMap::<String, Node>::new();
    if let Some(path) = &self.path {
      map.insert(path.clone(), self.clone());
    }

    if let Some(contents) = &self.contents {
      for node in contents.values() {
        map.extend(node.get_paths());
      }
    }

    map
  }
}
