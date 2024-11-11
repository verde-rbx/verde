// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
use crate::core::payload::{PayloadAction, PayloadInstance};
use crate::core::project::VerdeProject;
use notify::EventKind;
use std::{fs, path::Path, sync::Arc};

/// Transforms a file into a PayloadInstance.
pub fn transform_file(
  file_path: &Path,
  kind: &EventKind,
  project: &Arc<VerdeProject>,
) -> anyhow::Result<PayloadAction> {
  // Create the payload instance
  let payload_instance = transform_script(file_path, project)?;

  // Wrap the payload in an action based on file event.
  let action = match kind {
    notify::EventKind::Remove(_) => PayloadAction::Delete(payload_instance),
    _ => PayloadAction::Change(payload_instance),
  };

  Ok(action)
}

/// Transform a file into a Roblox script.
fn transform_script(file_path: &Path, project: &Arc<VerdeProject>) -> anyhow::Result<PayloadInstance> {
  // Get file path
  let instance_path = file_path.to_string_lossy().into_owned();
  // TODO: Replace temporary instance path with calculation using project structure.
  //       Chop off the 'project root' from the file_path then match to node path.

  // Get file contents
  let contents = fs::read_to_string(file_path)?;
  Ok(PayloadInstance {
    instance: instance_path,
    value: Some(contents),
  })
}
