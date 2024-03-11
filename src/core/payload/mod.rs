/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use globset::{Glob, GlobSet, GlobSetBuilder};
use std::{collections::HashMap, time::SystemTime};

pub struct PayloadInstance {}

/// Payload for a response
#[derive(Default)]
pub struct Payload {
  /// The instance paths to destroy.
  pub destroying: Vec<String>,

  /// The instances to add/change
  pub changing: HashMap<String, PayloadInstance>,

  /// The alst time the payload was edited.
  last_update: Option<SystemTime>,

  /// The last time the payload was read + cleared.
  last_read: Option<SystemTime>,
}

impl Payload {
  /// Clears all the values in the payload.
  pub fn clear(&mut self) {
    self.destroying.clear();
    self.changing.clear();
    self.last_read = Some(SystemTime::now());
  }

  /// Adds a new roblox instance path to destroy.
  pub fn add_destroying(&mut self, instance: String) {
    if self.changing.contains_key(&instance) {
      self.changing.remove(&instance);
    }

    self.destroying.push(instance);
    self.last_update = Some(SystemTime::now())
  }

  /// Adds a new roblox instance to update/create.
  pub fn add_changing(&mut self) {
    todo!("Add changing. Add to changing dict, check destroying, check timestamps")
  }
}

/// Valid transformers
#[allow(dead_code)]
enum NodeTransformers {
  Csv,
  Script,
  Yaml,
}

#[allow(dead_code)]
struct NodeRule {
  glob: &'static str,
  transform: NodeTransformers,
}

#[allow(dead_code)]
const RULES: [NodeRule; 3] = [
  NodeRule {
    glob: "**/*.csv",
    transform: NodeTransformers::Csv,
  },
  NodeRule {
    glob: "**/*.{lua,luau}",
    transform: NodeTransformers::Script,
  },
  NodeRule {
    glob: "**/*.{yaml,yml}",
    transform: NodeTransformers::Yaml,
  },
];

/// Creates the globset for the rules.
#[allow(dead_code)]
fn create_ruleset() -> GlobSet {
  let mut builder = GlobSetBuilder::new();
  for x in RULES {
    if let Ok(glob) = Glob::new(x.glob) {
      builder.add(glob);
    }
  }

  builder.build().unwrap_or(GlobSet::empty())
}
