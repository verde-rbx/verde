// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use serde::{Deserialize, Serialize};
use std::{
  collections::{BTreeMap, HashMap},
  path::Path,
  rc::Rc,
};

/// A node describing an instance in the project tree.
#[derive(Serialize, Deserialize, Default, Clone, Debug)]
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

  /// Additonal instance tree
  #[serde(flatten, skip_serializing_if = "Option::is_none")]
  pub contents: Option<BTreeMap<String, Node>>,

  /// Cached logical grouping
  #[serde(skip_serializing)]
  pub logical_roots: Option<Rc<BTreeMap<String, Node>>>,

  /// Full calculated roblox path
  #[serde(skip_serializing)]
  pub roblox_path: Option<String>,
}

impl Node {
  /// Identifies each path root.
  pub fn get_roots(&self) -> HashMap<String, Node> {
    let mut roots: HashMap<String, Node> = HashMap::new();

    let mut stack = vec![self];
    while let Some(node) = stack.pop() {
      if let Some(path) = &node.path {
        roots.insert(path.clone(), self.clone());
      }

      // Add children to stack
      if let Some(children) = &node.contents {
        for child in children.values() {
          stack.push(child);
        }
      }
    }

    roots
  }

  /// Logically groups root paths to the same structure as a file system.
  pub fn group_roots(&self) -> Rc<BTreeMap<String, Node>> {
    if let Some(cached) = &self.logical_roots {
      return cached.clone();
    }

    let mut roots: BTreeMap<String, Node> = BTreeMap::new();
    let mut stack = vec![self];
    while let Some(node) = stack.pop() {
      if let Some(path) = &node.path {
        let components = Path::new(path).components();

        // Add additional paths
        let mut current_root = &mut roots;
        for component in components {
          if let Some(comp) = component.as_os_str().to_str() {
            let next = current_root.entry(comp.to_owned()).or_insert_with(|| Node {
              contents: Some(BTreeMap::<String, Node>::new()),
              ..node.clone()
            });

            current_root = next.contents.as_mut().unwrap();
          }
        }
      }

      // Add children to stack
      if let Some(children) = &node.contents {
        for child in children.values() {
          stack.push(child);
        }
      }
    }

    Rc::new(roots)
  }

  /// Precalculates values
  pub fn precalculate(&mut self) {
    self.logical_roots = Some(self.group_roots());
  }
}
