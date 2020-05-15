
import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit


class Page_VC: UIViewController {

    private var titleView = UIView()
    private var headerView = UIView()
    private var pageControl = PageControl()
    private var pageView = UIView()

    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    private var headerViewTopConstraint: Constraint?

    private let statusHeight = UIApplication.shared.statusBarFrame.size.height
    private let titleViewHeight: CGFloat = 80.0
    private let pageControlHeight: CGFloat = 60.0
    private let headerViewHeight: CGFloat = 400.0

    private var offsetY = BehaviorRelay<CGFloat>(value: 0.0)
    private var beginY: CGFloat = 0.0

    private var isOnTop = BehaviorRelay<Bool>(value: false)
    private var contentOffset = BehaviorRelay<CGPoint>(value: CGPoint.zero)

    private var currentIndex = BehaviorRelay<Int>(value: 0)
    private lazy var viewControllers: [UIViewController] = {
//        return [
//            Test_VC().bind((0..<10).map { "\($0)" }, color: .blue, isOnTop: self.isOnTop),
//            Test_VC().bind((0..<20).map { "\($0)" }, color: .yellow, isOnTop: self.isOnTop),
//            Test_VC().bind((0..<2).map { "\($0)" }, color: .gray, isOnTop: self.isOnTop)
//        ]
        return [
            Test_VC().bind((0..<10).map { "\($0)" }, color: .blue, isOnTop: self.isOnTop, contentOffset: self.contentOffset)
        ]
    }()

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Page_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.headerView.backgroundColor = .brown
        self.view.addSubview(self.headerView)

        self.pageControl.backgroundColor = .red
        self.view.addSubview(self.pageControl)

        self.pageView.backgroundColor = .yellow
        self.view.addSubview(self.pageView)

        self.titleView.backgroundColor = .green
        self.view.addSubview(self.titleView)

        self.pageViewController.view.backgroundColor = .clear
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self

        self.addChild(self.pageViewController)
        self.pageView.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)

        self.pageViewController.setViewControllers([self.viewControllers[0]], direction: .forward, animated: true, completion: nil)
    }

    private func layout() {
        self.headerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.headerViewHeight)

            self.headerViewTopConstraint = maker.top.equalToSuperview().constraint
        }

        self.pageControl.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.headerView.snp.bottom)
            maker.height.equalTo(self.pageControlHeight)
        }

        self.pageView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.pageControl.snp.bottom)
            maker.height.equalTo(self.view.frame.height - self.statusHeight - self.pageControlHeight - self.titleViewHeight)
        }

        self.pageViewController.view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.titleView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(self.titleViewHeight)
        }
    }

    private func bind() {
        self.offsetY.asDriver()
            .drive(onNext: { [weak self] offsetY in
                self?.headerViewTopConstraint?.update(offset: offsetY)
            })
            .disposed(by: self.disposeBag)

        self.offsetY.asDriver()
            .map { $0 == -(self.headerViewHeight - self.statusHeight - self.titleViewHeight) }
            .drive(self.isOnTop)
            .disposed(by: self.disposeBag)

        Observable.combineLatest(self.contentOffset.asObservable(),
                                 self.view.rx.panGesture().asObservable()) { contentOffset, recognizer in
                (contentOffset, recognizer)
            }
            .filter { ($0.0.y <= 0.0) }
            .map { $0.1 }
            .bind { recognizer in
                let location = recognizer.location(in: recognizer.view)
                switch recognizer.state {
                case .began:
                    self.beginScroll(location.y)
                case .changed:
                    self.doScroll(location.y)
                case .ended:
                    let maxY: CGFloat = 0.0
                    let minY: CGFloat = -(self.headerViewHeight - self.statusHeight - self.titleViewHeight)

                    let velocity = recognizer.velocity(in: recognizer.view)
                    UIView.animate(withDuration: 0.3) {
                        self.offsetY.accept((velocity.y > 0.0) ? maxY : minY)
                        self.view.layoutIfNeeded()
                    }
                default: break
                }
            }
            .disposed(by: self.disposeBag)
    }
}


extension Page_VC {

    private func beginScroll(_ y: CGFloat) {
        self.beginY = y
    }

    private func doScroll(_ y: CGFloat) {
        let moveY = self.beginY - y
        self.beginY = y

        let maxY: CGFloat = 0.0
        let minY: CGFloat = -(self.headerViewHeight - self.statusHeight - self.titleViewHeight)

        let offsetY = self.offsetY.value - moveY

        if offsetY < minY {
            self.offsetY.accept(minY)
        } else if maxY < offsetY {
            self.offsetY.accept(maxY)
        } else {
            self.offsetY.accept(offsetY)
        }
    }
}


extension Page_VC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.currentIndex.value - 1

        guard let viewController = self.viewControllers[safe: index] else { return nil }
        self.currentIndex.accept(index)

        return viewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.currentIndex.value + 1

        guard let viewController = self.viewControllers[safe: index] else { return nil }
        self.currentIndex.accept(index)

        return viewController
    }
}


extension Page_VC: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[safe: 0], finished, completed else { return }

        for i in 0 ..< self.viewControllers.count {
            if viewController == viewControllers[i] {
                self.currentIndex.accept(i)
            }
        }
    }
}




class Test_VC: UIViewController {

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private var items = BehaviorRelay<[String]>(value: [])
    private var color: UIColor?

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func setup() {
        self.view.backgroundColor = .cyan

        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }

    private func layout() {
        self.collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func bind() {
        self.items.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: "UICollectionViewCell",
                                                   cellType: UICollectionViewCell.self)) { index, item, cell in
                cell.backgroundColor = self.color
            }
            .disposed(by: self.disposeBag)
    }
}


extension Test_VC {

    func bind(_ items: [String], color: UIColor, isOnTop: BehaviorRelay<Bool>, contentOffset: BehaviorRelay<CGPoint>) -> UIViewController {
        self.color = color
        self.items.accept(items)

        isOnTop.asDriver()
            .drive(self.collectionView.rx.isUserInteractionEnabled)
            .disposed(by: self.disposeBag)

        self.collectionView.rx.contentOffset
            .bind(to: contentOffset)
            .disposed(by: self.disposeBag)

        return self
    }
}


extension Test_VC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
}
