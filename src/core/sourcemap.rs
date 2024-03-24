/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use crate::core::project::{node::Node, VerdeProject};
use serde::Serialize;
use std::path::Path;

/// The sourcemap schema has been defined by Rojo and adopted by third parties becoming the standard.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct VerdeSourcemap<'a> {
  /// The name of the node.
  pub name: &'a str,

  /// The Roblox class name.
  pub class_name: &'a str,

  /// The file paths associated with the node.
  #[serde(skip_serializing_if = "Option::is_none")]
  pub file_paths: Option<Vec<&'a Path>>,

  /// Child nodes.
  #[serde(skip_serializing_if = "Option::is_none")]
  pub children: Option<Vec<VerdeSourcemap<'a>>>,
}

fn populate_children(tree: &Node) -> Option<Vec<VerdeSourcemap<'_>>> {
  if let Some(contents) = &tree.contents {
    let mut children = Vec::with_capacity(contents.len());
    for (key, child) in contents.iter() {
      // TODO: Use node helper to get className
      // TODO: Use node helper to get files under base path
      children.push(VerdeSourcemap {
        name: key,
        class_name: child.class_name.as_ref().unwrap_or(key),
        file_paths: None,
        children: populate_children(child),
      })
    }

    return Some(children);
  }

  None
}

impl<'a> From<&'a VerdeProject> for VerdeSourcemap<'a> {
  fn from(project: &'a VerdeProject) -> Self {
    let populated_children = populate_children(&project.tree);
    VerdeSourcemap {
      name: &project.name,
      class_name: "DataModel",
      file_paths: None,
      children: populated_children,
    }
  }
}
