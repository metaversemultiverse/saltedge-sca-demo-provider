/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.controllers.api.sca.v1.model

data class CreateConnectionResponse(val data: CreateConnectionResponseData)

data class CreateConnectionResponseData(val authentication_url: String)
