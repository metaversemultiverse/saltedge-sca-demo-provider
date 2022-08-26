/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.callback

import com.fasterxml.jackson.annotation.JsonProperty

data class RevokeConnectionRequest(
    @JsonProperty("data") var data: Any = Any(),
    @JsonProperty("exp") var exp: Int
)
