import UIKit
import ReSwift
import RxSwift
import RxCocoa
import RxLibrary
import Then

extension Feed {

    class ViewController: ContainerViewController<ChallengeNavigationController>, TabBarItemProviding {
        static let tabItem: UITabBarItem = UITabBarItem().then {
            $0.title = tr(.feedTitle)
            $0.image = UIImage(asset: .iconTabbarFeed)
        }

        init(challengeViewController: ChallengeNavigationController = ChallengeNavigationController.fromStoryboard(segmentedControlTitles: ["New", "Popular"])) {
            super.init(viewController: challengeViewController)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        private let disposeBag = DisposeBag()
        var controller: Challenge.Controller!

        override func viewDidLoad() {
            super.viewDidLoad()

            self.controller = Challenge.Controller(
                inputs: (
                    pullToRefresh: contained.tableView.refreshControl!.rx.controlEvent(.valueChanged),
                    source: Variable<Challenge.State.Source>(.everyone),
                    ordering: contained.tableView.topSegmentedControlValue
                        .ignore(-1)
                        .map { value -> Challenge.State.Ordering in
                            switch value {
                            case 0: return .new
                            case 1: return .popular
                            default: fatalError("dont know how to handle > 2 cases yet. Just new & popular")
                            }
                        },
                    challengeSelected: contained.tableView.itemSelected
                ),
                challengeSelected: { post in Routing(to: .home(.feed(.detail(post)))) }
            )

            self.controller.output.refreshControlVisible.asDriver()
                .drive(contained.tableView.refreshControl!.rx.isRefreshing)
                .disposed(by: self.disposeBag)

            self.controller.output.posts.asDriver()
                .drive(contained.tableView.posts)
                .disposed(by: self.disposeBag)
        }

    }
}

extension Feed.ViewController: StoreSubscriber {
    func newState(state: App.State) {
    }
}
