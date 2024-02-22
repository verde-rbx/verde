use std::collections::{BTreeMap, HashMap};

use serde::{Deserialize, Serialize};

/// An instance node.
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
  #[serde(rename = ".properties", skip_serializing_if = "Option::is_none")]
  pub properties: Option<BTreeMap<String, String>>,

  /// Additonal instance tree
  #[serde(flatten, skip_serializing_if = "Option::is_none")]
  pub contents: Option<BTreeMap<String, Node>>,
}

impl Node {
  /// Recursively locates the paths of child nodes and creates a flattened structure with nodes attached to their paths.
  pub fn get_paths(&self, map: &mut HashMap<String, Node>) {
    if let Some(path) = &self.path {
      map.insert(path.clone(), self.clone());
    }

    if let Some(contents) = self.contents.as_ref() {
      for node in contents.values() {
        node.get_paths(map);
      }
    }
  }
}
