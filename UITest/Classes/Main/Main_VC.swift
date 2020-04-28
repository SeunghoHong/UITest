
import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxAppState
import SnapKit


struct MainSection {
    enum SectionType {
        case topUser
        case newUser

        var identifier: String {
            switch self {
            case .topUser:   return "MainCell_TopUser"
            case .newUser:   return "MainCell_NewUser"
            }
        }
    }

    var type: SectionType
    var items: [Item]
}


extension MainSection: SectionModelType {
    typealias Item = [Any]


    init(original: MainSection, items: [Item]) {
        self = original
        self.items = items
    }
}


protocol MainBindable {
    var sections: BehaviorRelay<[MainSection]> { get }
}


class Main_VC: UIViewController {

    private var closeButton = UIButton()
    private var loadButton = UIButton()
    private var bannerView = UIView()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private var viewModel = Main_VM()
    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()

        self.viewModel.loadSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Main_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)

        self.collectionView.backgroundColor = .gray
        self.view.addSubview(self.collectionView)

        self.bannerView.backgroundColor = .yellow
        self.bannerView.clipsToBounds = true
        self.collectionView.addSubview(self.bannerView)

        self.setupCollection()
    }

    private func layout() {
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.loadButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }

        self.collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(self.closeButton.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }

        self.bannerView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.height.equalTo(320.0)
            maker.top.equalToSuperview().offset(-320.0)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)

        self.loadButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onLoad()
            }
            .disposed(by: self.disposeBag)

        self.viewModel.sections.asDriver()
            .drive(self.collectionView.rx.items(dataSource: self.dataSource()))
            .disposed(by: self.disposeBag)
    }
}


extension Main_VC {

    private func setupCollection() {
        self.collectionView.register(MainCell_TopUser.self, forCellWithReuseIdentifier: MainSection.SectionType.topUser.identifier)
        self.collectionView.register(MainCell_NewUser.self, forCellWithReuseIdentifier: MainSection.SectionType.newUser.identifier)

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        self.collectionView.contentInset = UIEdgeInsets(top: 320.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.collectionView.delegate = self
    }

    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<MainSection> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { dataSource, collectionView, indexPath, items -> UICollectionViewCell in
                guard let sectionModel = dataSource.sectionModels[safe: indexPath.section] else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                }

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                cell.backgroundColor = .black

                return cell
            }
        )
    }
}


extension Main_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func onLoad() {
    }
}


extension Main_VC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60.0)
    }
}
