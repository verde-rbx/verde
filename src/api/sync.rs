/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
use warp::Filter;

/// The main sync endpoint filter.
pub fn sync() -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
    filters::sync_handshake()
}

mod filters {
    use super::handlers;
    use warp::Filter;

    /// POST /sync/handshake
    /// Initiates a connection with the sync server.
    pub fn sync_handshake() -> impl Filter<Extract = (impl warp::Reply,), Error = warp::Rejection> + Clone {
        warp::path!("sync" / "handshake").and_then(handlers::handshake)
    }
}

mod handlers {
    use std::convert::Infallible;
    use warp::http::StatusCode;

    #[allow(dead_code)]
    struct SyncApi {}

    pub async fn handshake() -> Result<impl warp::Reply, Infallible> {
        Ok(StatusCode::OK)
    }
}
