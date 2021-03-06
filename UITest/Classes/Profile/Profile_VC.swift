
import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import SnapKit


class Profile_VC: UIViewController {

    private var closeButton = UIButton()

    private var titleView = UIView()
    private var menuStackView = UIStackView()
    private var menuButton = UIButton()
    private var titleLabel = UILabel()

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

    private let alpha = BehaviorRelay<CGFloat>(value: 0.0)
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

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.collectionView.backgroundColor = .clear
        self.view.addSubview(self.collectionView)

        self.headerView.backgroundColor = .green
        self.collectionView.addSubview(self.headerView)

        self.tabView.backgroundColor = .yellow
        self.collectionView.addSubview(self.tabView)

        self.titleView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.view.addSubview(self.titleView)

        self.menuStackView.axis = .horizontal
        self.menuStackView.alignment = .center
        self.menuStackView.spacing = 8.0
        self.titleView.addSubview(self.menuStackView)

        self.menuButton.backgroundColor = .red
        self.menuStackView.addArrangedSubview(self.menuButton)

        self.titleLabel.textColor = .black
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "123123"
        self.menuStackView.addArrangedSubview(self.titleLabel)
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
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(self.closeButton.snp.bottom).offset(16.0)
            maker.bottom.leading.trailing.equalToSuperview()
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
            maker.height.equalTo(40.0)
        }

        self.titleView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.collectionView.snp.top)
            maker.height.equalTo(40.0)
        }

        self.menuStackView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16.0)
            maker.trailing.lessThanOrEqualToSuperview().offset(-16.0)
            maker.top.bottom.equalToSuperview()
        }

        self.menuButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(36.0)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)

        self.items.asDriver()
            .drive(
                self.collectionView.rx.items(
                    cellIdentifier: "UICollectionViewCell",
                    cellType: UICollectionViewCell.self
                )
            ) { index, item, cell in
                cell.backgroundColor = .blue
            }
            .disposed(by: self.disposeBag)

        self.collectionView.rx.contentOffset
            .bind {
                let offsetY = $0.y
                let maxY = self.headerView.frame.size.height
                let minY = self.statusHeight + self.tabView.frame.size.height + self.titleView.frame.size.height

                if -minY < offsetY {
                    self.alpha.accept(0.0)
                } else if offsetY < -maxY {
                    self.alpha.accept(1.0)
                } else {
                    self.alpha.accept(((abs(offsetY) - minY) / (maxY - minY)))
                }

                if offsetY < -maxY {
                    self.headerViewTopConstraint?.update(offset: offsetY)
                } else if offsetY <= -minY {
                    self.headerViewTopConstraint?.update(offset: -maxY)
                } else {
                    self.headerViewTopConstraint?.update(offset: -maxY + (offsetY + $0.y))
                }
            }
            .disposed(by: self.disposeBag)

        self.collectionView.rx.observe(CGSize.self, "contentSize")
            .distinctUntilChanged()
            .bind { size in
                guard let size = size else { return }

                let offsetY = self.statusHeight + self.tabView.frame.size.height + self.titleView.frame.size.height
                let collectionViewHeight = self.view.frame.height - offsetY
                if size.height < collectionViewHeight {
                    self.collectionView.contentInset = UIEdgeInsets(top: 256.0, left: 0.0, bottom: collectionViewHeight - size.height, right: 0.0)
                }
            }
            .disposed(by: self.disposeBag)

        self.alpha.asDriver()
            .distinctUntilChanged()
            .map { 1.0 - $0 }
            .drive(self.titleView.rx.alpha)
            .disposed(by: self.disposeBag)

        self.alpha.asDriver()
            .distinctUntilChanged()
            .drive(self.headerView.rx.alpha)
            .disposed(by: self.disposeBag)
    }
}


extension Profile_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func loadItems() {
        self.items.accept((1..<10).map { "\($0)" })
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
