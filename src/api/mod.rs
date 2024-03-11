/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
mod sync;

use crate::core::payload::Payload;
use anyhow::bail;
use std::sync::{Arc, RwLock};
use warp::Filter;

pub fn get_routes(
  payload: Arc<RwLock<Payload>>,
) -> anyhow::Result<impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone> {
  if !payload.is_poisoned() {
    Ok(sync::filters::sync(payload))
  } else {
    bail!("Unable to use poisoned payload. Try restarting Verde.")
  }
}
