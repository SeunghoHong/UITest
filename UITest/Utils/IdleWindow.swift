
import UIKit

import RxCocoa
import RxSwift


class IdleWindow: UIWindow {

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

        Observable.just(()).delay(.seconds(5), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self,
                      let visibleViewController = self.visibleViewController
                else { return }

                print("\(String(describing: visibleViewController.classForCoder))")
            }
            .disposed(by: self.disposeBag)
            
    }
}


extension IdleWindow {

    var visibleViewController: UIViewController? {
        guard let rootViewController = self.rootViewController else { return nil }

        return visibleViewController(rootViewController)
    }

    private func visibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return visibleViewController(presentedViewController)
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
