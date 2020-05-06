
import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import SnapKit


struct ProfileSection {
    var items: [Item]
}


extension ProfileSection: SectionModelType {
    typealias Item = String


    init(original: ProfileSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class Profile_VC: UIViewController {

    private var headerView = UIView()
    private var emptyView = UIView()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileSection>?
    private let sections = BehaviorRelay<[ProfileSection]>(value: [])
    private let statusHeight = UIApplication.shared.statusBarFrame.size.height

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

        self.emptyView.backgroundColor = .yellow
        self.collectionView.addSubview(emptyView)

        self.headerView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.view.addSubview(self.headerView)
    }

    private func setupCollectionView() {
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")

        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.collectionView.delegate = self
        self.setupDataSource()

        self.collectionView.contentInset = UIEdgeInsets(top: 256.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    private func layout() {
        self.collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.emptyView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(80.0)
        }

        self.headerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(40.0)
        }
    }

    private func bind() {
        if let dataSource = self.dataSource {
            self.sections.asDriver()
                .drive(self.collectionView.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
        }

        self.view.rx.panGesture()
            .bind { recognizer in
                let location = recognizer.location(in: recognizer.view)
                switch recognizer.state {
                case .began:
                    self.y = location.y
                case .changed:
                    let move = location.y - self.y
                    self.y = location.y

                    var top = self.collectionView.contentInset.top + move
                    if top < 40.0 {
                        top = 40.0
                    } else if top > 256.0 {
                        top = 256.0
                    }
                    print("top: \(top)")
                    self.collectionView.contentInset = UIEdgeInsets(top: top, left: 0.0, bottom: 0.0, right: 0.0)
                    
                case .ended:
                    self.y = 0.0
                default: break
                }
            }
            .disposed(by: self.disposeBag)

        self.collectionView.rx.contentOffset
            .distinctUntilChanged()
            .bind {
                print("contentOffset: \($0.y)")
            }
            .disposed(by: self.disposeBag)
    }
}


extension Profile_VC {

    private func setupDataSource() {
        self.dataSource = RxCollectionViewSectionedReloadDataSource(
            configureCell: { dataSource, collectionView, indexPath, items -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                cell.backgroundColor = .blue
                return cell
            }
        )

        self.dataSource?.configureSupplementaryView = { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            }

            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            reusableView.backgroundColor = .green

            return reusableView
        }
    }
}


extension Profile_VC {

    private func loadItems() {
        self.sections.accept([ProfileSection(items: (1..<20).map { "\($0)" })])
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60.0)
    }
}
