/**
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
use serde::{Deserialize, Serialize};
use std::{collections::BTreeMap, fs, path::Path};

pub const DEFAULT_PROJECT: &str = "verde.yaml";

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

/// An instance node.
#[derive(Serialize, Deserialize)]
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

impl VerdeProject {
    /// Loads a VerdeProject from the specified file path.
    pub fn new(path: Option<&Path>) -> Self {
        if let Ok(val) = fs::read_to_string(path.unwrap_or(Path::new(DEFAULT_PROJECT))) {
            serde_yaml::from_str(&val).expect("")
        } else {
            VerdeProject::default()
        }
    }

    /// Saves the VerdeProject to the file system.
    pub fn save(self) {
        match serde_yaml::to_string(&self) {
            Ok(yaml) => {
                fs::write(DEFAULT_PROJECT, yaml).expect("Failed to write.");
            }

            Err(_) => println!("Failed"),
        }
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
                        contents: None,
                    },
                ),
                (
                    String::from("StarterPlayer"),
                    Node {
                        path: None,
                        properties: None,
                        contents: Some(BTreeMap::<String, Node>::from([(
                            String::from("StarterPlayerScripts"),
                            Node {
                                path: Some(String::from("src/client")),
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
