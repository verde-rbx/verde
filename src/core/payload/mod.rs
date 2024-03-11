/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use globset::{Glob, GlobSet, GlobSetBuilder};

struct PayloadInstance {}

/// Payload for a response
#[derive(Default)]
pub struct Payload {
  /// The instance paths to destroy.
  destroying: Vec<String>,

  /// The instances to add/change
  changing: Vec<PayloadInstance>,
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
