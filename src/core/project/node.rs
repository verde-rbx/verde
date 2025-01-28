// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use serde::{Deserialize, Serialize};
use std::{
  collections::BTreeMap,
  path::{Path, PathBuf},
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
  #[serde(skip)]
  pub logical_roots: Option<BTreeMap<String, Node>>,

  /// Full calculated roblox path
  #[serde(skip)]
  pub roblox_path: Option<Vec<String>>,
}

impl Node {
  /// Retrieves valid node roots.
  /// A root is considered valid if it exists in the FS.
  pub fn get_roots(&self) -> Vec<PathBuf> {
    self
      .into_iter()
      .filter_map(|node| {
        let path = node.path.clone()?;
        let path_buf = PathBuf::from(path);
        if path_buf.try_exists().is_ok_and(|f| f) {
          return path_buf.canonicalize().ok();
        }

        None
      })
      .collect()
  }

  /// Logically groups root paths to the same structure as a file system.
  pub fn group_roots(&self) -> BTreeMap<String, Self> {
    if let Some(cached) = &self.logical_roots {
      return cached.clone();
    }

    let mut roots: BTreeMap<String, Self> = BTreeMap::new();
    for node in self {
      if let Some(path) = &node.path {
        let components = Path::new(path).components();

        // Add additional paths
        let mut current_root = &mut roots;
        for component in components {
          if let Some(comp) = component.as_os_str().to_str() {
            let next = current_root.entry(comp.to_owned()).or_insert_with(|| Self {
              contents: Some(BTreeMap::<String, Self>::new()),
              ..node.clone()
            });

            current_root = next.contents.as_mut().unwrap();
          }
        }
      }
    }

    roots
  }

  /// Calculates roblox paths for every node in the tree.
  fn calculate_paths(&mut self) {
    let mut node_depth = 0;
    let mut nodes_left: Vec<usize> = vec![1];
    let mut stack: Vec<(Option<String>, &mut Node)> = vec![(None, self)];
    let mut path_stack: Vec<String> = vec![];
    while let Some((name, node)) = stack.pop() {
      // Node path depth
      while let Some(0) = nodes_left.get(node_depth) {
        path_stack.pop();
        node_depth -= 1;
      }
      nodes_left[node_depth] -= 1;

      // Add child nodes
      let path = node.class_name.clone().or(name);
      if let Some(contents) = &mut node.contents {
        if !contents.is_empty() {
          node_depth += 1;
          if nodes_left.len() - 1 < node_depth {
            nodes_left.push(contents.len());
          } else {
            nodes_left[node_depth] = contents.len();
          }

          // Add child nodes.
          for child in contents.iter_mut() {
            stack.push((Some(child.0.clone()), child.1));
          }

          // Generate path for parent node.
          if let Some(path) = &path {
            path_stack.push(path.clone());
            node.roblox_path = Some(path_stack.clone());
            continue;
          }
        }
      }

      // Generate path
      if let Some(path) = path {
        let mut new_path = path_stack.clone();
        new_path.push(path);
        node.roblox_path = Some(new_path);
      }
    }
  }

  /// Precalculates values
  pub fn precalculate(&mut self) {
    self.calculate_paths();
    self.logical_roots = Some(self.group_roots());
  }
}
