/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.controllers.api.sca.v1.model

import com.fasterxml.jackson.annotation.JsonProperty

data class CreateAuthorizationInfoRequest(
    @JsonProperty("data") var data: CreateAuthorizationInfoRequestData,
    @JsonProperty("exp") var exp: Integer
)

data class CreateAuthorizationInfoRequestData(
    @JsonProperty("connection_id") var connectionId: String,
    @JsonProperty("access_token") var accessToken: String
)
