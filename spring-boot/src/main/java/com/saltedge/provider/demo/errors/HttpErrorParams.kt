/*
 * @author Constantin Chelban (constantink@saltedge.com)
 * Copyright (c) 2022 Salt Edge.
 */
package com.saltedge.provider.demo.errors

import org.springframework.http.HttpStatus

interface HttpErrorParams {
    val errorStatus: HttpStatus
    val errorClass: String
    val errorMessage: String
}
