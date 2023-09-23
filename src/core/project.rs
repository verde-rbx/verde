/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, HashMap},
    error::Error,
    fs::{self, File},
    io::Read,
    result::Result::{Err, Ok},
};

pub const DEFAULT_PROJECT: &str = "verde.yaml";

/// An instance node.
#[derive(Serialize, Deserialize, Clone)]
pub struct Node {
    /// Path (relative to source directory)
    #[serde(rename = ".path")]
    pub path: String,

    // Properties applied to the related Roblox instance
    #[serde(rename = ".properties", skip_serializing_if = "Option::is_none")]
    pub properties: Option<BTreeMap<String, String>>,

    /// Additonal instance tree
    #[serde(flatten, skip_serializing_if = "Option::is_none")]
    pub contents: Option<BTreeMap<String, Node>>,
}

impl Node {
    /// Recursively locates the paths of child nodes.
    pub fn get_paths(&self, map: &mut HashMap<String, Node>) {
        map.insert(self.path.clone(), self.clone());
        if self.contents.as_ref().is_some_and(|x| !x.is_empty()) {
            for (_key, node) in self.contents.as_ref().unwrap() {
                node.get_paths(map);
            }
        }
    }
}

/// Project Structure
///
/// ```yaml
/// name: "A Verde Project"
///
/// tree:
///  ReplicatedStorage:
///    .path: src/shared
///
///  ServerScriptService:
///    .path: src/server
/// ````
#[derive(Serialize, Deserialize)]
pub struct VerdeProject {
    /// Name of project
    pub name: String,

    /// The instance tree
    pub tree: BTreeMap<String, Node>,
}

// Verde project implementation
impl VerdeProject {
    /// Creates a VerdeProject using defaults.
    pub fn new() -> Self {
        VerdeProject::default()
    }

    /// Creates a new VerdeProject from the specified file.
    pub fn from(project: &mut File) -> Result<Self, Box<dyn Error>> {
        let mut buffer = String::new();
        project.read_to_string(&mut buffer)?;
        Ok(serde_yaml::from_str(&buffer)?)
    }

    /// Saves the VerdeProject to the file system.
    pub fn save(&self) {
        match serde_yaml::to_string(self) {
            Ok(yaml) => {
                fs::write(DEFAULT_PROJECT, yaml).expect("Failed to write.");
            }

            Err(_) => println!("Failed"),
        }
    }

    /// Creates watchers for defined paths
    pub fn create_watcher(&self) -> HashMap<String, Node> {
        let mut map = HashMap::<String, Node>::new();
        for (_key, node) in &self.tree {
            node.get_paths(&mut map);
        }

        map
    }
}

impl Default for VerdeProject {
    fn default() -> Self {
        Self {
            name: String::from("A Verde Project"),
            tree: BTreeMap::<String, Node>::from([
                (
                    String::from("ServerScriptService"),
                    Node {
                        path: String::from("src/server"),
                        properties: None,
                        contents: None,
                    },
                ),
                (
                    String::from("ReplicatedStorage"),
                    Node {
                        path: String::from("src/shared"),
                        properties: None,
                        contents: Some(BTreeMap::<String, Node>::from([(
                            String::from("client"),
                            Node {
                                path: String::from("src/client"),
                                properties: None,
                                contents: None,
                            },
                        )])),
                    },
                ),
            ]),
        }
    }
}
