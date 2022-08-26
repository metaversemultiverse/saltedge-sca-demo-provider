/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.callback

import com.fasterxml.jackson.annotation.JsonProperty

data class AccessTokenWrapper(
    @JsonProperty("access_token") var access_token: String,
)
