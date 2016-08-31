import UIKit

import RxSwift

import ReSwift
import ReSwiftRouter

import PINRemoteImage

class CreateViewController: RxViewController, Identifiable {
    
    static let identifier = "CreateViewController"
    var composer: ComposeViewController! {
        didSet {
            composer.delegate = self
        }
    }
    
}

extension CreateViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "Create"
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(asset: .Icon_Tabbar_Create), tag: 2)
        
        self.navigationItem.title = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissKeyboardTap = UITapGestureRecognizer()
        dismissKeyboardTap.rx.event.subscribe(onNext: { _ in self.view.endEditing(true) }).addDisposableTo(disposeBag)
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let des = segue.destination as? ComposeViewController {
            self.composer = des
        }
        
    }

}

extension CreateViewController: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    func newState(state: State) {
    
        if let result = state.createPostState.didUpload {
            switch result {
            case .success(let post):
                print("post created \(post)")
            case .failure(let error):
                print("error \(error)")
            }
        }
        
        if let _ = state.createPostState.toBeUploaded { stopLoading() }

    }
    
}

extension CreateViewController: ComposeViewControllerDelegate {
    func shouldPost(_ post: Post) {
        store.dispatch(LocalPostReady(post: post))
        store.dispatch(CreatePostProvider.uploadPost)
    }
}

extension CreateViewController: Routable {}