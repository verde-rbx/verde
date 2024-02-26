/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use std::{
  collections::{BTreeMap, HashMap},
  fs::{self, File},
  io::{Seek, Write},
  path::Path,
  str,
};
use tempfile::tempfile;
use verde::core::node::Node;
use verde::core::project::{self, VerdeProject};

/// Saves a mock project
fn save_mock_project() -> File {
  let mut temp_file = tempfile().unwrap();
  let project_contents = r#"
      name: Verde Test Project
      tree:
        .class: DataModel
        ReplicatedStorage:
          .class: ReplicatedStorage
          .path: src/shared
        ServerScriptService:
          .class: ServerScriptService
          .path: src/server
        StarterPlayer:
          .class: StarterPlayer
          StarterPlayerScripts:
            .path: src/client
    "#;

  temp_file.write_all(project_contents.as_bytes()).unwrap();
  temp_file.seek(std::io::SeekFrom::Start(0)).unwrap();
  temp_file
}

/// Creates a mock project
fn create_mock_project() -> VerdeProject {
  VerdeProject {
    name: String::from("Verde Test Project"),
    tree: Node {
      class_name: Some(String::from("DataModel")),
      path: None,
      overwrite_descendants: None,
      contents: Some(BTreeMap::<String, Node>::from([(
        String::from("ServerScriptService"),
        Node {
          class_name: Some(String::from("ServerScriptService")),
          path: Some(String::from("src/server")),
          overwrite_descendants: None,
          contents: None,
        },
      )])),
    },
  }
}

#[test]
/// Test to ensure a project can be deserialised correctly
fn new_project_from_path() {
  let mut project_file = save_mock_project();
  let project = project::VerdeProject::from(&mut project_file).unwrap();

  // Checking to ensure the project name is deserialised correctly
  assert_eq!(project.name, "Verde Test Project");

  // Checking to ensure the tree serialised a node correctly
  if let Some(contents) = project.tree.contents {
    assert!(contents.contains_key("ReplicatedStorage"));

    // Checking to ensure a node contains the correct serialised values
    let replicated_storage_node = contents.get("ReplicatedStorage");
    assert!(replicated_storage_node.is_some());
  } else {
    panic!("Missing project root node.")
  }
}

#[test]
/// Test to ensure a project can be serialised and saved to the filesystem correctly
fn save_project() {
  let project_path = Path::new("verde.yaml");
  let project = create_mock_project();

  // Checking to ensure the file is created
  assert!(!project_path.exists(), "project file already exists");
  project.save().unwrap();
  assert!(project_path.exists());

  // Checking file content to ensure it is as expected
  let file_content = fs::read(project_path).unwrap();
  assert_eq!(
        str::from_utf8(&file_content).unwrap(),
        "name: Verde Test Project\ntree:\n  .class: DataModel\n  ServerScriptService:\n    .class: ServerScriptService\n    .path: src/server\n"
    );

  // Cleanup and delete file
  fs::remove_file(project_path).unwrap();
}

#[test]
/// Test to make sure node paths are properly retrieved
fn get_node_paths() {
  let project = create_mock_project();

  // Get node paths (similar to create_watchers())
  let mut node_map = HashMap::<String, Node>::new();
  project.tree.get_paths(&mut node_map);

  // Confirm path
  assert!(node_map.contains_key("src/server"));
  assert_eq!(
    node_map.get("src/server").unwrap().path,
    Some(String::from("src/server"))
  );
}
