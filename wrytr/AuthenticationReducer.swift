//
//  AuthenticationReducer.swift
//  wrytr
//
//  Created by Andrew Breckenridge on 3/18/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import Foundation

import ReSwift
import ReSwiftRouter

func authenticationReducer(state: AuthenticationState?, action: Action) -> AuthenticationState {
    var state = state ?? initialAuthenticationState()
    
    switch action {
    case _ as ReSwiftInit:
        break
    default:
        break
    }
    
    return state
}

func initialAuthenticationState() -> AuthenticationState {
    return AuthenticationState(loggedInState: .NotLoggedIn)
}
