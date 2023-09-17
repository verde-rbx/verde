/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use serde::{self, Deserialize};
use std::{collections::BTreeMap, net::IpAddr};

// Rojo project structure taken from the Rojo github:
// This project structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
#[serde(deny_unknown_fields, rename_all = "camelCase")]
pub struct Project {
    pub name: String,

    pub tree: ProjectNode,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub serve_port: Option<u16>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub serve_address: Option<IpAddr>,
}

// Rojo project node taken from the Rojo github:
// This node structure has been modified to remove properties that are not yet supported by Verde
// https://github.com/rojo-rbx/rojo/blob/master/src/project.rs
#[derive(Deserialize)]
pub struct ProjectNode {
    #[serde(rename = "$className", skip_serializing_if = "Option::is_none")]
    pub class_name: Option<String>,

    /// Contains all of the children of the described instance.
    #[serde(flatten)]
    pub children: BTreeMap<String, ProjectNode>,

    #[serde(rename = "$ignoreUnknownInstances", skip_serializing_if = "Option::is_none")]
    pub ignore_unknown_instances: Option<bool>,

    #[serde(rename = "$path", skip_serializing_if = "Option::is_none")]
    pub path: Option<String>,
}
