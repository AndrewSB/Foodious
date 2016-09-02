import UIKit
import RxSwift

extension Landing {
    
    class Handler: HandlerType {
        let store: Store
        
        init(store: Store) {
            self.store = store
        }
        
        func twitterTap() {
//            store.dispatch()
        }
        
        func facebookTap() {
        
        }
        
        func actionTap() {
            
        }
        
        func changeAuthOptionTap(option: ViewModel.Option) {
            store.dispatch(Landing.Action.updateOption(option))
        }
        
    }
    
}
