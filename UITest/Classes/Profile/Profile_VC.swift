
import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import SnapKit


class Profile_VC: UIViewController {

    private var titleView = UIView()
    private var headerView = UIView()
    private var tabView = UIView()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private let items = BehaviorRelay<[String]>(value: [])
    private let statusHeight = UIApplication.shared.statusBarFrame.size.height

    private var headerViewTopConstraint: Constraint?
    
    private var disposeBag = DisposeBag()

    private var y: CGFloat = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.setupCollectionView()
        self.layout()
        self.bind()

        self.loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Profile_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.collectionView.backgroundColor = .lightGray
        self.view.addSubview(self.collectionView)

        self.headerView.backgroundColor = .green
        self.collectionView.addSubview(self.headerView)

        self.tabView.backgroundColor = .yellow
        self.headerView.addSubview(self.tabView)

        self.titleView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.view.addSubview(self.titleView)
    }

    private func setupCollectionView() {
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")

        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.collectionView.contentInset = UIEdgeInsets(top: 256.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.collectionView.delegate = self
    }

    private func layout() {
        self.collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.headerView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(256.0)
            self.headerViewTopConstraint = maker.top.equalToSuperview().offset(-256.0).constraint
        }

        self.tabView.snp.makeConstraints { maker in
            maker.leading.bottom.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(44.0)
        }
        

        self.titleView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(40.0)
        }
    }

    private func bind() {
        self.items.asDriver()
            .drive(self.collectionView.rx.items(cellIdentifier: "UICollectionViewCell",
                                                cellType: UICollectionViewCell.self)) { index, item, cell in
                cell.backgroundColor = .blue
            }
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.contentOffset
            .distinctUntilChanged()
            .bind {
                if $0.y < -256.0 {
                    self.headerViewTopConstraint?.update(offset: $0.y)
                } else if $0.y <= -100.0 {
                    self.headerViewTopConstraint?.update(offset: -256.0)
                } else {
                    self.headerViewTopConstraint?.update(offset: -256.0 + (100.0 + $0.y))
                }
            }
            .disposed(by: self.disposeBag)
    }
}


extension Profile_VC {

    private func loadItems() {
        self.items.accept((1..<20).map { "\($0)" })
    }
}


extension Profile_VC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
}
