//
//  loginFunctions.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/1/24.
//

import Foundation
import SwiftUI
import Firebase

/*
 Assume that input is already checked in the caller function callLogIn()
 Takes email or phone number and password, and makes necessary requests to verify if the user exists

func logIn(username: String, password: String)  -> Bool {
    print("username value:  \(username)")
    print("password value:  \(password)")
    var returnVal = false
    
    return returnVal
}

/*
 Assume that input is already validated in the caller function callRegister()
 Takes contact (phone/email), name, and password and sends a new account request
 */
func register(email: String, phone: String, name: String, password: String, confirm: String){
    print("email value:   \(email)")
    print("phone value:   \(phone)")
    print("name value:      \(name)")
    print("password value:  \(password)")
    print("confirm value:   \(confirm)")
}

/*
 Takes an email and sends a request firebase auth to get a sign-in link
 */
func forgotPassword(username: String){
    print("email value:  \(username)")
}
*/
