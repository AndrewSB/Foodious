//
//  AuthenticationState.swift
//  wrytr
//
//  Created by Andrew Breckenridge on 3/18/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import Foundation

import Firebase

import ReSwift
import ReSwiftRouter

import Twitter
import TwitterKit

struct AuthenticationState {
    var landingState: LandingFormViewController.State
    var loggedInState: LoggedInState
}

enum LoggedInState {
    case notLoggedIn
    case errorLoggingIn(NSError)
    case loggedIn(Social)
    
    case logout
}

enum Social {
    case facebook(FAuthData)
    case twitter(FAuthData)
    case firebase(FAuthData)
}

extension Social {

    init?(authData: FAuthData) {
        switch authData.provider {
        case "facebook":
            self = .facebook(authData)
        case "twitter":
            self = .twitter(authData)
        default:
            self = self.firebase(authData)
        }
    }

}
