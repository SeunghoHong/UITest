
import UIKit

import RxCocoa
import RxSwift


class IdleWindow: UIWindow {

    private let IDLE_TIME = 5
    private var disposeBag = DisposeBag()


    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)

        event.allTouches?.forEach { touch in
            if touch.phase == .began {
                self.setIdleTimer()
            }
        }
    }

    func setIdleTimer() {
        self.disposeBag = DisposeBag()

        Observable.just(()).delay(.seconds(IDLE_TIME), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self,
                      let rootViewController = self.rootViewController,
                      let visibleViewController = self.visibleViewController(rootViewController)
                else { return }

                print("\(String(describing: visibleViewController.classForCoder))")
            }
            .disposed(by: self.disposeBag)
            
    }
}


extension IdleWindow {

    private func visibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return visibleViewController(presentedViewController)
        }

        if let child = rootViewController.children.last {
            return visibleViewController(child)
        }

        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return rootViewController
    }
}
