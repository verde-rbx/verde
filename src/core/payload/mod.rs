/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
// use globset::{Glob, GlobSet, GlobSetBuilder};
use serde::Serialize;
use std::{
  collections::HashMap,
  time::{SystemTime, UNIX_EPOCH},
};

#[derive(Serialize, Clone)]
pub struct PayloadInstance {}

#[derive(Serialize, Clone)]
pub enum PayloadAction {
  /// Delete payload action.
  /// The value is the time the action was requested.
  Delete(SystemTime),

  /// Change/Add payload action.
  /// The value is the payload instance.
  Change(PayloadInstance),
}

/// Payload for a response
#[derive(Default, Serialize, Clone)]
pub struct Payload {
  /// The instance paths to destroy.
  pub destroying: HashMap<String, PayloadAction>,

  /// The instances to add/change
  pub changing: HashMap<String, PayloadAction>,

  /// The alst time the payload was edited.
  last_update: Option<u128>,

  /// The last time the payload was read + cleared.
  last_read: Option<u128>,
}

impl Payload {
  /// Clears all the values in the payload.
  pub fn clear(&mut self) {
    self.destroying.clear();
    self.changing.clear();
    self.last_read = Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis());
  }

  /// Adds a new roblox instance path to destroy.
  pub fn add_destroying(&mut self, instance: String, payload: SystemTime) {
    if self.changing.contains_key(&instance) {
      self.changing.remove(&instance);
    }

    self.destroying.insert(instance, PayloadAction::Delete(payload));
    self.last_update = Some(payload.duration_since(UNIX_EPOCH).unwrap().as_millis());
  }

  /// Adds a new roblox instance to update/create.
  pub fn add_instance(&mut self, instance: String, payload: PayloadInstance) {
    if self.destroying.contains_key(&instance) {
      self.destroying.remove(&instance);
    }

    self.changing.insert(instance, PayloadAction::Change(payload));

    // Set time
    let time = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis();
    self.last_update = Some(time);
  }

  /// Adds a new roblox instance to update/create.
  pub fn add_payload(&mut self, instance: String, payload: PayloadAction) {
    match payload {
      PayloadAction::Delete(p) => self.add_destroying(instance, p),
      PayloadAction::Change(p) => self.add_instance(instance, p),
    };
  }
}

// /// Valid transformers
// #[allow(dead_code)]
// enum NodeTransformers {
//   Csv,
//   Script,
//   Yaml,
// }

// #[allow(dead_code)]
// struct NodeRule {
//   glob: &'static str,
//   transform: NodeTransformers,
// }

// #[allow(dead_code)]
// const RULES: [NodeRule; 3] = [
//   NodeRule {
//     glob: "**/*.csv",
//     transform: NodeTransformers::Csv,
//   },
//   NodeRule {
//     glob: "**/*.{lua,luau}",
//     transform: NodeTransformers::Script,
//   },
//   NodeRule {
//     glob: "**/*.{yaml,yml}",
//     transform: NodeTransformers::Yaml,
//   },
// ];

// /// Creates the globset for the rules.
// #[allow(dead_code)]
// fn create_ruleset() -> GlobSet {
//   let mut builder = GlobSetBuilder::new();
//   for x in RULES {
//     if let Ok(glob) = Glob::new(x.glob) {
//       builder.add(glob);
//     }
//   }

//   builder.build().unwrap_or(GlobSet::empty())
// }
