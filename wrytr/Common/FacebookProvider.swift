import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift

class Facebook {

    class Provider {
        
        func login(withReadPermissions permissions: [String] = ["email", "public_profile", "user_friends"]) -> Observable<FBSDKLoginManagerLoginResult> {
        
            return ParseRxCallbacks.createWithCallback({ observer -> Void in
                FBSDKLoginManager().logIn(withReadPermissions: permissions, from: nil, handler: ParseRxCallbacks.rx_parseUnwrappedOptionalCallback(observer))
                return
            })
            
        }
        
    }
    
}

