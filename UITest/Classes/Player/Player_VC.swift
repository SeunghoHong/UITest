
import UIKit
import AVFoundation

import RxSwift
import RxCocoa
import PinLayout
import SnapKit


final class Player_VC: UIViewController {

    private let closeButton = UIButton()

    private lazy var pageViewController: UIPageViewController = {
        return UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }()

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout()
    }
}


extension Player_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.pageViewController.dataSource = self
        self.view.addSubview(self.pageViewController.view)
        self.addChild(self.pageViewController)
        self.pageViewController.didMove(toParent: self)

        self.pageViewController.setViewControllers(
            [PlayerDetail_VC()],
            direction: .forward,
            animated: true,
            completion: nil
        )

        self.closeButton.backgroundColor = .black
        self.closeButton.setTitle("close", for: .normal)
        self.view.addSubview(self.closeButton)
    }

    private func layout() {
        self.closeButton.pin
            .top(self.view.pin.safeArea)
            .start(16.0)
            .marginTop(16.0)
            .sizeToFit()

        self.pageViewController.view.pin
            .all()
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
}


extension Player_VC: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return PlayerDetail_VC()
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return PlayerDetail_VC()
    }
}
