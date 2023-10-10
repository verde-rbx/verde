use anyhow::Context;
/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, HashMap},
    fs::{self, File},
    io::Read,
    path::Path,
    result::Result::Ok,
};

pub const DEFAULT_PROJECT: &str = "verde.yaml";

/// An instance node.
#[derive(Serialize, Deserialize, Clone)]
pub struct Node {
    /// Path (relative to source directory)
    #[serde(rename = ".path", skip_serializing_if = "Option::is_none")]
    pub path: Option<String>,

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
    pub tree: Node,
}

// Verde project implementation
impl VerdeProject {
    /// Creates a VerdeProject using defaults.
    pub fn new() -> Self {
        Self {
            name: String::from("A Verde Project"),
            tree: Node {
                path: None,
                properties: None,
                contents: Some(BTreeMap::<String, Node>::from([
                    (
                        String::from("ServerScriptService"),
                        Node {
                            path: Some(String::from("src/server")),
                            properties: None,
                            contents: None,
                        },
                    ),
                    (
                        String::from("ReplicatedStorage"),
                        Node {
                            path: Some(String::from("src/shared")),
                            properties: None,
                            contents: Some(BTreeMap::<String, Node>::from([(
                                String::from("client"),
                                Node {
                                    path: Some(String::from("src/client")),
                                    properties: None,
                                    contents: None,
                                },
                            )])),
                        },
                    ),
                ])),
            },
        }
    }

    /// Creates a new VerdeProject from the specified file.
    pub fn from(project: &mut File) -> anyhow::Result<Self> {
        let mut buffer = String::new();
        project
            .read_to_string(&mut buffer)
            .with_context(|| format!("Failed to read file {:#?}", project))?;

        serde_yaml::from_str(&buffer).context("Failed to deserialise yaml to VerdeProject.")
    }

    /// Saves the VerdeProject to the file system.
    pub fn save(&self) -> anyhow::Result<()> {
        let dest = Path::new(DEFAULT_PROJECT);
        self.save_to(dest)?;
        Ok(())
    }

    /// Saves the VerdeProject to the specified file location.
    pub fn save_to(&self, destination: &Path) -> anyhow::Result<()> {
        let content = serde_yaml::to_string(self)?;
        fs::write(destination, content)
            .with_context(|| format!("Failed to write project to {}", destination.display()))?;

        Ok(())
    }

    /// Creates watchers for defined paths
    pub fn create_watcher(&self) -> HashMap<String, Node> {
        let mut map = HashMap::<String, Node>::new();
        self.tree.get_paths(&mut map);
        map
    }
}

impl Default for VerdeProject {
    fn default() -> Self {
        Self::new()
    }
}
