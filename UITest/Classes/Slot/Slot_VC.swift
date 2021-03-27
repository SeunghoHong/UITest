
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Slot_VC: UIViewController {

    private var closeButton = UIButton()
    private var loadButton = UIButton()

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.clipsToBounds = false
        return collectionView
    }()

    private var items = BehaviorRelay<[String]>(value: [])

    private var collectionViewHeight: Constraint?

    private var viewModel: Slot_VM?
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


extension Slot_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)

        self.setupCollectionView()
    }

    private func setupCollectionView() {
        self.collectionView.register(SlotCell.self, forCellWithReuseIdentifier: "SlotCell")

        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.collectionView.delegate = self

        self.collectionView.backgroundColor = .clear
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
            maker.top.equalTo(self.closeButton.snp.bottom).offset(16.0)
            maker.leading.trailing.equalToSuperview()
            self.collectionViewHeight = maker.height.equalTo(80.0).constraint
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

        self.items.asDriver()
            .drive(self.collectionView.rx.items(
                cellIdentifier: "SlotCell",
                cellType: SlotCell.self
            )) { index, items, cell in

            }
            .disposed(by: self.disposeBag)
    }
}


extension Slot_VC {

    func bind(_ viewModel: Slot_VM) {
        self.viewModel = viewModel
    }
}


extension Slot_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func onLoad() {
        self.items.accept(["1", "2", "", ""])
    }
}


extension Slot_VC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var width = self.collectionView.bounds.size.width
        width -= (16.0 * 2.0)
        width -= (56.0 * 4.0)
        let spacing = width / 3.0
        
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56.0, height: 80.0)
    }
}
