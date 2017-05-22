import UIKit

class RootNavigator: MainNavigation {
    var child: ChildNavigation?

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func add(child: ChildNavigation) {
        self.child = child
        self.child!.presentationContext = { [weak self] childView in
            self!.window.rootViewController!.present(childView, animated: false)
        }
    }

    func activate(routable: Routable) {
        guard let leafChild = self.recursiveLastChild as? ChildNavigation else {
            fatalError("what's a root navigator to do without child 👵🏼😭")
        }

        leafChild.activate(routable: routable)
    }
}
