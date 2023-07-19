/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use std::{
    collections::BTreeMap,
    fs,
    path::{Path, PathBuf},
};
use verde::core::project::{self, VerdeProject};

/// Saves a mock project
fn save_mock_project() -> PathBuf {
    let path = Path::new("test.verde.yaml");
    let project_contents = r#"
      name: Verde Test Project
      tree:
        ReplicatedStorage:
          .path: src/shared
        ServerScriptService:
          .path: src/server
        StarterPlayer:
          StarterPlayerScripts:
            .path: src/client
    "#;

    fs::write(path, project_contents).expect("Failed to create temp project");
    path.to_path_buf()
}

/// Creates a mock project
fn create_mock_project() -> VerdeProject {
    VerdeProject {
        name: String::from("Verde Test Project"),
        tree: BTreeMap::new(),
    }
}

#[test]
/// Test to ensure a project can be deserialised correctly
fn new_project_from_path() {
    let project_path = save_mock_project();
    let project = project::VerdeProject::new(Some(Path::new(&project_path)));

    // Checking to ensure the project name is deserialised correctly
    assert_eq!(project.name, "Verde Test Project");

    // Checking to ensure the tree serialised a node correctly
    assert!(project.tree.contains_key("ReplicatedStorage"));

    // Checking to ensure a node contains the correct serialised values
    let replicated_storage_node = project.tree.get("ReplicatedStorage");
    assert!(replicated_storage_node.is_some());
    assert!(replicated_storage_node.unwrap().path.is_some());
}

#[test]
fn save_project() {
    let project = create_mock_project();

    assert!(!Path::new("verde.yaml").exists());
    project.save();
    assert!(Path::new("verde.yaml").exists());
}
