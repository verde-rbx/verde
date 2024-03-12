/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

pub mod filters {
  use crate::{api::sync::handlers, core::payload::Payload};
  use std::{
    convert::Infallible,
    sync::{Arc, RwLock},
  };
  use warp::{path, Filter};

  /// Entry point for the sync api.
  pub fn sync(
    payload: Arc<RwLock<Payload>>,
  ) -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
    sync_heartbeat(payload)
  }

  /// Api for requesting heartbeat status of the sync session.
  pub fn sync_heartbeat(
    payload: Arc<RwLock<Payload>>,
  ) -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
    path!("heartbeat")
      .and(warp::get())
      .and(with_payload(payload))
      .and_then(handlers::sync_heartbeat)
  }

  /// Helper for warp.
  fn with_payload(
    payload: Arc<RwLock<Payload>>,
  ) -> impl Filter<Extract = (Arc<RwLock<Payload>>,), Error = Infallible> + Clone {
    warp::any().map(move || Arc::clone(&payload))
  }
}

mod handlers {
  use crate::core::payload::Payload;
  use std::{
    convert::Infallible,
    sync::{Arc, RwLock},
  };

  pub async fn sync_heartbeat(_payload: Arc<RwLock<Payload>>) -> Result<impl warp::Reply, Infallible> {
    let r = _payload.read().unwrap().clone();
    Ok(warp::reply::json(&r))
  }
}
