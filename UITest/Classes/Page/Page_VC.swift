
import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit


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

    func bind(_ items: [String], color: UIColor) -> UIViewController {
        self.color = color
        self.items.accept(items)
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




class Page_VC: UIViewController {

    private var titleView = UIView()
    private var headerView = UIView()
    private var pageControl = PageControl()
    private var pageView = UIView()

    private var emptyView = UIView()

    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    private var headerViewTopConstraint: Constraint?

    private var isOnScrolling = false
    private let statusHeight = UIApplication.shared.statusBarFrame.size.height
    private let titleViewHeight: CGFloat = 50.0
    private let pageControlHeight: CGFloat = 40.0
    private let headerViewHeight: CGFloat = 200.0
    private var offsetY: CGFloat = 0.0
    private var beginY: CGFloat = 0.0

    private var currentIndex = BehaviorRelay<Int>(value: 0)
    private var viewControllers = [
        Test_VC().bind((0..<10).map { "\($0)" }, color: .blue),
        Test_VC().bind((0..<20).map { "\($0)" }, color: .yellow),
        Test_VC().bind((0..<2).map { "\($0)" }, color: .gray)
    ]
    
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

        self.emptyView.backgroundColor = .black
        self.pageView.addSubview(self.emptyView)

        self.titleView.backgroundColor = .green
        self.view.addSubview(self.titleView)

        self.pageViewController.view.backgroundColor = .clear
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self

        self.addChild(self.pageViewController)
        self.pageView.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)

        self.pageViewController.setViewControllers([Test_VC().bind((0..<10).map { "\($0)" }, color: .blue)], direction: .forward, animated: true, completion: nil)
    }

    private func layout() {
        self.headerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(200.0)

            self.headerViewTopConstraint = maker.top.equalToSuperview().constraint
        }

        self.pageControl.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.headerView.snp.bottom)
            maker.height.equalTo(40.0)
        }

        self.pageView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.pageControl.snp.bottom)
            maker.bottom.equalToSuperview()
        }

        self.pageViewController.view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.emptyView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(80.0)
        }

        self.titleView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(50.0)
        }
    }

    private func bind() {
        self.view.rx.panGesture()
            .bind { recognizer in
                let location = recognizer.location(in: recognizer.view)
                switch recognizer.state {
                case .began:
                    self.beginScroll(location.y)
                case .changed:
                    self.doScroll(location.y)
                case .ended:
                    self.endScroll(location.y)
                default: break
                }
            }
            .disposed(by: self.disposeBag)
    }
}


extension Page_VC {

    private func beginScroll(_ y: CGFloat) {
        self.isOnScrolling = true
        self.beginY = y
    }

    private func doScroll(_ y: CGFloat) {
        guard self.isOnScrolling else { return }

        let moveY = self.beginY - y
        self.beginY = y

        let maxY: CGFloat = 0.0
        let minY: CGFloat = -(self.headerViewHeight - self.statusHeight - self.titleViewHeight)

        let offsetY = self.offsetY - moveY

        if offsetY < minY {
            self.offsetY = minY
        } else if maxY < offsetY {
            self.offsetY = maxY
        } else {
            self.offsetY = offsetY
        }

        self.headerViewTopConstraint?.update(offset: self.offsetY)
    }

    private func endScroll(_ y: CGFloat) {
        guard self.isOnScrolling else { return }
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
