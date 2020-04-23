
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class BannerView: UIView {

    private var contentView = UIView()
    private var pageViewController: UIPageViewController!

    private var disposeBag = DisposeBag()
    private var scrollDisposeBag = DisposeBag()

    private var currentIndex = 0
    private var viewControllers = BehaviorRelay<[UIViewController]>(value: [])

    var scrollInterval = 3
    var items = BehaviorRelay<[UIView]>(value: [])

    var pageIndicatorTintColor: UIColor = .gray
    var currentPageIndicatorTintColor: UIColor = .orange


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.setupPageViewController()
        self.layout()
        self.bind()
    }
}


extension BannerView {

    private func setup() {
        self.backgroundColor = .clear

        self.contentView.backgroundColor = .clear
        self.addSubview(self.contentView)
    }

    private func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self

        self.pageViewController.view.subviews.forEach { view in
            if let pageControl = view as? UIPageControl {
                pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
                pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
            }
        }

        self.contentView.layoutIfNeeded()
        self.contentView.addSubview(self.pageViewController.view)
    }

    private func layout () {
        self.contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.pageViewController.view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func bind() {
        self.items.asObservable()
            .filter { $0.isEmpty == false }
            .map { views -> [UIViewController] in
                views.map { view -> UIViewController in
                    let viewController = UIViewController()
                    viewController.view.addSubview(view)
                    view.snp.makeConstraints { maker in
                        maker.edges.equalToSuperview()
                    }
                    return viewController
                }
            }
            .bind(to: self.viewControllers)
            .disposed(by: self.disposeBag)
        
        self.viewControllers.asDriver()
            .filter { $0.isEmpty == false }
            .drive(onNext: { viewControllers in
                guard let viewController = viewControllers[safe: 0] else { return }

                self.pageViewController?.setViewControllers([viewController], direction: .forward, animated: false) { _ in
                    self.startScrolling()
                }
            })
            .disposed(by: self.disposeBag)
    }
}


extension BannerView {

    func startScrolling() {
        self.scrollDisposeBag = DisposeBag()

        Observable<Int>.interval(.seconds(self.scrollInterval), scheduler: MainScheduler.instance)
            .bind(onNext: { _ in
                var afterIndex = self.currentIndex + 1
                if afterIndex > (self.viewControllers.value.count - 1) {
                    afterIndex = 0
                }

                guard let item = self.viewControllers.value[safe: afterIndex] else {
                    return
                }

                self.currentIndex = afterIndex
                self.pageViewController?.setViewControllers([item], direction: .forward, animated: true, completion: nil)
            })
            .disposed(by: self.scrollDisposeBag)
    }

    func stopScrolling() {
        self.scrollDisposeBag = DisposeBag()
    }
}


extension BannerView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var beforeIndex = self.currentIndex - 1
        if beforeIndex < 0 {
            beforeIndex = self.viewControllers.value.count - 1
        }

        return self.viewControllers.value[safe: beforeIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var afterIndex = self.currentIndex + 1
        if afterIndex > (self.viewControllers.value.count - 1) {
            afterIndex = 0
        }

        return self.viewControllers.value[safe: afterIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.viewControllers.value.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}


extension BannerView: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.stopScrolling()
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        defer {
            self.startScrolling()
        }
        guard let viewController = pageViewController.viewControllers?[0], finished, completed else { return }

        for i in 0 ..< self.viewControllers.value.count {
            if viewController == self.viewControllers.value[safe: i] {
                self.currentIndex = i
            }
        }
    }
}
