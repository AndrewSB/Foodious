//
//  RootRoutable.swift
//  wrytr
//
//  Created by Andrew Breckenridge on 3/18/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import UIKit

import ReSwift
import ReSwiftRouter

let landingRoute: RouteElementIdentifier = StoryboardScene.Login.LandingScene.rawValue
let mainRoute: RouteElementIdentifier = StoryboardScene.Main.HomeScene.rawValue

class RootRoutable: Routable {
    
    let loginStoryboard = StoryboardScene.Login.storyboard()
    let mainStoryboard = StoryboardScene.Main.storyboard()
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setToLandingViewController() -> Routable {
        self.window.rootViewController = loginStoryboard.instantiateViewControllerWithIdentifier(landingRoute)
        
        return LoginViewRoutable(self.window.rootViewController!)
    }
    
    func setToMainViewController() -> Routable {
        self.window.rootViewController = mainStoryboard.instantiateViewControllerWithIdentifier(mainRoute)
        
        return MainViewRoutable(self.window.rootViewController!)
    }
    
    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: RoutingCompletionHandler) -> Routable {
        
        if routeElementIdentifier == landingRoute {
            completionHandler()
            return self.setToLandingViewController()
        } else if routeElementIdentifier == mainRoute {
            completionHandler()
            return self.setToMainViewController()
        } else {
            fatalError("Route not supported!")
        }
    }
}