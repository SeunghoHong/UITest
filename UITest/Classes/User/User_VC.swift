
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class User_VC: UIViewController {

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        // MARK: Self-Sizing Cell
        flowLayout.estimatedItemSize = CGSize(width: 96.0, height: 40.0)

        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0.0, height: 0.0), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        return collectionView
    }()
    private var closeButton = UIButton()
    private var loadButton = UIButton()

    private var disposeBag = DisposeBag()

    private var users = BehaviorRelay<[User]>(value:[
        User(id: 1, nickname: "11111", image: nil),
        User(id: 2, nickname: "22222", image: nil),
        User(id: 3, nickname: "33333", image: nil),
        User(id: 4, nickname: "44444", image: nil),
        User(id: 5, nickname: "55555", image: nil),
        User(id: 1, nickname: "11111", image: nil),
        User(id: 2, nickname: "22222", image: nil),
        User(id: 3, nickname: "33333", image: nil),
        User(id: 4, nickname: "44444", image: nil),
        User(id: 5, nickname: "55555", image: nil)
    ])


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


extension User_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)

        self.collectionView.backgroundColor = .yellow
//        self.collectionView.delegate = self
        self.collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        self.view.addSubview(self.collectionView)
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
            maker.leading.trailing.equalToSuperview()
//            maker.height.equalTo(140.0)
            maker.centerY.equalToSuperview()
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

        self.users.asDriver()
            .drive(self.collectionView.rx.items(cellIdentifier: "UserCell",
                                                cellType: UserCell.self)) { index, user, cell in
                cell.bind(UserCell_VM(with: user))
            }
            .disposed(by: self.disposeBag)
    }
}


extension User_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func onLoad() {
        self.users.accept([
            User(id: 1, nickname: "11111", image: nil),
            User(id: 2, nickname: "22222", image: nil),
            User(id: 3, nickname: "33333", image: nil),
            User(id: 4, nickname: "44444", image: nil),
            User(id: 5, nickname: "55555", image: nil)
        ])
    }
}


//extension User_VC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width: CGFloat = self.view.frame.size.width * 0.16
//        let height: CGFloat = width + 10.0 + 12.0
//        return CGSize(width: width, height: height)
//    }
//}
