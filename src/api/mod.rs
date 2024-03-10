/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
mod sync;

use crate::core::payload::Payload;
use std::sync::Arc;
use warp::Filter;

pub fn get_api(payload: Arc<Payload>) -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
  sync::filters::sync(payload)
}
