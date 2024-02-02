//
//  loginFunctions.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/1/24.
//

import Foundation
import SwiftUI

/*
 Assume that input is already checked in the caller function callLogIn()
 Takes username and password, and makes necessary requests to verify if the user exists
 */
func logIn(username: String, password: String){
    print("username value:  \(username)")
    print("password value:  \(password)")
}

/*
 Assume that input is already validated in the caller function callRegister()
 Takes contact (phone/email), name, username, and password and sends a new account request
 */
func register(contact: String, name: String, username: String, password: String, confirm: String){
    print("contact value:   \(contact)")
    print("name value:      \(name)")
    print("username value:  \(username)")
    print("password value:  \(password)")
    print("confirm value:   \(confirm)")
}

/*
 Takes a username, email or phone number and sends a request to change password
 */
func forgotPassword(username: String){
    print("username value:  \(username)")
}
