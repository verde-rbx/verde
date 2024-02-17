/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

pub mod filters {
  use super::handlers;
  use crate::core::project::VerdeProject;
  use std::{convert::Infallible, sync::Arc};
  use warp::{path, Filter};

  /// Entry point for the sync api
  pub fn sync(
    project: Arc<VerdeProject>,
  ) -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
    sync_heartbeat(project)
  }

  /// Api for requesting heartbeat status of the sync session
  pub fn sync_heartbeat(
    project: Arc<VerdeProject>,
  ) -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
    path!("heartbeat")
      .and(warp::get())
      .and(with_project(project))
      .and_then(handlers::sync_heartbeat)
  }

  /// Helper for warp
  fn with_project(
    project: Arc<VerdeProject>,
  ) -> impl Filter<Extract = (Arc<VerdeProject>,), Error = Infallible> + Clone {
    warp::any().map(move || Arc::clone(&project))
  }
}

mod handlers {
  use crate::core::project::VerdeProject;
  use std::{convert::Infallible, sync::Arc};
  use warp::http::StatusCode;

  pub async fn sync_heartbeat(project: Arc<VerdeProject>) -> Result<impl warp::Reply, Infallible> {
    Ok(StatusCode::OK)
  }
}
