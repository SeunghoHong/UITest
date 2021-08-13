
import UIKit

import RxSwift
import RxCocoa
import SnapKit


final class Schedule_VC: UIViewController {

    private let closeButton = UIButton()

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
//        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 38.0)
        flowLayout.sectionInset = .zero

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )

        return collectionView
    }()

    private var disposeBag = DisposeBag()

    private let texts = [
        "The JSON Formatter was created to help folks with debugging.",
        "JSON data is often output without line breaks to save space, it can be extremely difficult to actually read and make sense of it.",
        "This tool hoped to solve the problem by formatting and beautifying the JSON data so that it is easy to read and debug by human beings.",
        "To further expand the debugging capabilities, advanced JSON validation was soon added following the description set out by Douglas Crockford of json.org in RFC 4627.",
        "It has since been updated to allow validation of multiple JSON standards, including both current specifications RFC 8259 and ECMA-404.",
        "Most recently, the capability to fix common JSON errors was added.",
        "If enabled, it will replace incorrect quotes, add missing quotes, correct numeric keys, lowercase literals, escape unescaped characters, and remove comments and trailing commas."
    ]


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


extension Schedule_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "UICollectionViewCell"
        )
        self.collectionView.register(
            ScheduleCell.self,
            forCellWithReuseIdentifier: "ScheduleCell"
        )
        self.collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "UICollectionReusableView"
        )
        self.collectionView.backgroundColor = .blue
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
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
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Schedule_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension Schedule_VC: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.texts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "UICollectionReusableView", for: indexPath
        )
        headerView.backgroundColor = .red

        return headerView
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ScheduleCell",
            for: indexPath
        )

        if let cell = cell as? ScheduleCell {
            cell.notice = self.texts[indexPath.row]
        }

        return cell
    }
}


final class ScheduleCell: UICollectionViewCell {

    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
//    private let stackView = UIStackView()
//    private let badgeView = UIView()
//    private let nicknameLabel = UILabel()
    private let noticeLabel = UILabel()

    public var notice: String {
        get { self.noticeLabel.text ?? "" }
        set { self.noticeLabel.text = newValue }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = CGFloat(ceilf(Float(size.height)))
        layoutAttributes.frame = frame

        return layoutAttributes
    }

    private func setup() {
        self.backgroundColor = .gray

        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.timeLabel.textColor = .red
        self.timeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.contentView.addSubview(self.timeLabel)

        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.preferredMaxLayoutWidth = (UIScreen.main.bounds.width - 24.0)
        self.contentView.addSubview(self.titleLabel)

        self.profileImageView.backgroundColor = .yellow
        self.profileImageView.radius = 20.0
        self.contentView.addSubview(self.profileImageView)

        self.noticeLabel.backgroundColor = .darkGray
        self.noticeLabel.textColor = .white
        self.noticeLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.noticeLabel.numberOfLines = 4
        self.noticeLabel.preferredMaxLayoutWidth = (UIScreen.main.bounds.width - 24.0)
        self.contentView.addSubview(self.noticeLabel)

        self.timeLabel.text = "2:30 PM"
        self.titleLabel.text = "라이브 타이틀은 여기에 표시됩니다. 최대 2줄까지 표시됩니다."
//        self.nicknameLabel.text = "UserNickname"
    }

    private func layout() {
        self.contentView.snp.makeConstraints { maker in
            maker.width.equalTo(UIScreen.main.bounds.width)
        }

        self.timeLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(16.0)
            maker.leading.equalToSuperview().offset(12.0)
            maker.trailing.equalToSuperview().offset(-12.0)
        }

        self.titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.timeLabel.snp.bottom).offset(12.0)
            maker.leading.equalToSuperview().offset(12.0)
            maker.trailing.equalToSuperview().offset(-12.0)
        }

        self.profileImageView.snp.makeConstraints { maker in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(12.0)
            maker.leading.equalToSuperview().offset(12.0)
            maker.width.height.equalTo(40.0)
        }

        self.noticeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.profileImageView.snp.bottom).offset(12.0)
            maker.bottom.equalToSuperview().offset(-16.0)
            maker.leading.equalToSuperview().offset(12.0)
            maker.trailing.equalToSuperview().offset(-12.0)
        }
    }
}
