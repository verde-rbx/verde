// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

use std::path::Path;

use notify::EventKind;

use super::{PayloadAction, PayloadInstance};

/// Transforms a file into a PayloadInstance.
pub fn transform_file(file_path: &Path, kind: &EventKind) -> PayloadAction {
  // Create the payload instance
  let payload_instance = PayloadInstance {
    instance: file_path.to_string_lossy().into_owned(),
    value: None,
  };

  // Wrap the payload in an action based on file event.
  match kind {
    notify::EventKind::Remove(_) => PayloadAction::Delete(payload_instance),
    _ => PayloadAction::Change(payload_instance),
  }
}