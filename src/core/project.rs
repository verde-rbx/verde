/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

#[derive(Serialize, Deserialize)]
pub struct VerdeProject {
    /// Name of project
    pub name: String,

    /// The instance tree
    pub tree: BTreeMap<String, Node>,
}

impl Default for VerdeProject {
    fn default() -> Self {
        Self {
            name: "A Verde Project".to_string(),
            tree: BTreeMap::<String, Node>::new(),
        }
    }
}

#[derive(Serialize, Deserialize)]
pub struct Node {
    /// Path (relative to source directory)
    #[serde(rename = ".path", skip_serializing_if = "Option::is_none")]
    pub path: Option<String>,

    #[serde(rename = ".properties", skip_serializing_if = "Option::is_none")]
    pub properties: Option<BTreeMap<String, String>>,

    /// Additional Contents
    #[serde(flatten)]
    pub contents: BTreeMap<String, Node>,
}

impl Default for Node {
    fn default() -> Self {
        Self {
            path: Some("".to_string()),
            properties: None,
            contents: BTreeMap::new(),
        }
    }
}
