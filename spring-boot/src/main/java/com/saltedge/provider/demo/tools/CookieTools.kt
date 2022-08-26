/*
* @author Constantin Chelban (constantink@saltedge.com)
* Copyright (c) 2022 Salt Edge.
*/
package com.saltedge.provider.demo.tools

import javax.servlet.http.Cookie
import javax.servlet.http.HttpServletResponse

const val COOKIE_AUTHENTICATION_ACTION = "KEY_AUTHENTICATION_ACTION"
const val COOKIE_PAYMENT_ACTION = "COOKIE_PAYMENT_ACTION"

fun clearActionCookie(key: String, response: HttpServletResponse) {
    val cookie = Cookie(key, "");
    cookie.maxAge = 0
    response.addCookie(cookie);
}

fun saveActionCookie(key: String, data: String, response: HttpServletResponse) {
    val cookie = Cookie(key, data);
    cookie.maxAge = 5 * 60
    response.addCookie(cookie);
}