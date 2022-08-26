/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.controllers.api.sca.v1.model

import com.fasterxml.jackson.annotation.JsonProperty

data class EmptyRequest(
    @JsonProperty("data") var data: Any?,
    @JsonProperty("exp") var exp: Integer
)
