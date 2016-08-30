import Foundation

import RxSwift

import Twitter
import TwitterKit

extension Twitter {

    func rx_login() -> Observable<TWTRSession> {
    
        return ParseRxCallbacks.createWithCallback({ observer in
            self.logInWithCompletion(ParseRxCallbacks.rx_parseUnwrappedOptionalCallback(observer))
        })
    
    }

}
