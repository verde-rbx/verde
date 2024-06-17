// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
pub mod transform;

use serde::Serialize;
use std::{
  collections::HashSet,
  hash::{Hash, Hasher},
  time::{SystemTime, UNIX_EPOCH},
};

/// Metadata for a Roblox instance payload.
#[derive(Clone, Serialize, Eq, PartialEq)]
pub struct PayloadInstance {
  /// The Roblox instance path.
  pub instance: String,

  /// The value of the instance.
  /// In this case only the Script source is supported.
  pub value: Option<String>,
}

impl Hash for PayloadInstance {
  fn hash<H: Hasher>(&self, state: &mut H) {
    self.instance.hash(state);
  }
}

/// Payload action.
#[derive(Clone, Serialize, Eq, Hash, PartialEq)]
pub enum PayloadAction {
  /// Delete payload action.
  /// The value is the time the action was requested.
  Delete(PayloadInstance),

  /// Change/Add payload action.
  /// The value is the payload instance.
  Change(PayloadInstance),
}

/// Payload for a response.
#[derive(Clone, Default, Serialize)]
pub struct Payload {
  /// The instances to add/change
  pub events: HashSet<PayloadAction>,

  /// The alst time the payload was edited.
  last_update: Option<u128>,

  /// The last time the payload was read + cleared.
  last_read: Option<u128>,
}

impl Payload {
  /// Clears all the values in the payload.
  pub fn clear(&mut self) {
    self.events.clear();
    self.last_read = Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis());
  }

  /// Adds a new Roblox instance to update/create/delete.
  pub fn add_payload(&mut self, payload: PayloadAction) {
    self.events.replace(payload);
    self.last_update = Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis());
  }
}
