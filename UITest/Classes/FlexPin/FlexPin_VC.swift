
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout


final class FlexPin_VC: UIViewController {

    private let closeButton = UIButton()
    private let titleLabel = UILabel()

    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

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
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout()
    }
}


extension FlexPin_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.backgroundColor = .black
        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        self.view.addSubview(self.closeButton)

        self.titleLabel.textColor = .black
        self.titleLabel.text = "title label"
        self.titleLabel.textAlignment = .center
        self.view.addSubview(self.titleLabel)

        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = .blue
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        self.tableView.register(TestCell.self, forCellReuseIdentifier: "TestCell")
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 38.0
        self.view.addSubview(self.tableView)
    }

    private func layout() {
        self.closeButton.pin
            .top(self.view.pin.safeArea).left(16.0)
            .marginTop(16.0)
            .sizeToFit()

        self.titleLabel.pin
            .after(of: self.closeButton, aligned: .center)
            .end(16.0)
            .height(32.0)
            .marginLeft(16.0)

        self.tableView.pin
            .below(of: self.closeButton)
            .bottom().left().right()
            .marginTop(12.0)
    }

    private func bind() {
        self.closeButton.rx.tap.asDriver()
            .throttle(.milliseconds(500))
            .drive { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
}


extension FlexPin_VC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.texts.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)

        if let cell = cell as? TestCell {
            cell.notice = self.texts[indexPath.row]
        }

        return cell
    }
}


final class TestCell: UITableViewCell {

    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let infoView = UIView()
    private let badgeView = UIView()
    private let profileButton = UIButton()
    private let nicknameLabel = UILabel()
    private let noticeLabel = UILabel()

    public var notice: String {
        get { self.noticeLabel.text ?? "" }
        set { self.noticeLabel.text = newValue }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }
}


extension TestCell {

    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .white

        self.timeLabel.textColor = .red
        self.timeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.contentView.addSubview(self.timeLabel)

        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel.lineBreakMode = .byCharWrapping
        self.titleLabel.numberOfLines = 2
        self.contentView.addSubview(self.titleLabel)

        self.profileImageView.backgroundColor = .yellow
        self.profileImageView.radius = 20.0
        self.contentView.addSubview(self.profileImageView)

        self.infoView.backgroundColor = .blue
        self.contentView.addSubview(self.infoView)

        self.badgeView.backgroundColor = .red
        self.badgeView.radius = 8.0
        self.infoView.addSubview(self.badgeView)

        self.nicknameLabel.textColor = .black
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.nicknameLabel.numberOfLines = 1
        self.infoView.addSubview(self.nicknameLabel)

        self.noticeLabel.textColor = .darkGray
        self.noticeLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.noticeLabel.numberOfLines = 4
        self.titleLabel.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(self.noticeLabel)

        self.profileButton.backgroundColor = .clear
        self.contentView.addSubview(self.profileButton)

        self.timeLabel.text = "2:30 PM"
        self.titleLabel.text = "라이브 타이틀은 여기에 표시됩니다. 최대 2줄까지 표시됩니다."
        self.nicknameLabel.text = "UserNickname"
    }

    private func layout() {
        self.timeLabel.pin
            .top(16.0)
            .horizontally(12.0)
            .sizeToFit(.width)

        self.titleLabel.pin
            .below(of: self.timeLabel, aligned: .left)
            .right(12.0)
            .marginTop(12.0)
            .sizeToFit(.width)

        self.profileImageView.pin
            .below(of: self.titleLabel, aligned: .left)
            .size(40.0)
            .marginTop(12.0)

        self.infoView.pin
            .after(of: self.profileImageView, aligned: .center)
            .right(12.0)
            .marginLeft(10.0)
            .wrapContent(.vertically)

        self.badgeView.pin
            .top().left()
            .width(42.0).height(16.0)

        self.nicknameLabel.pin
            .below(of: self.badgeView, aligned: .left)
            .right().bottom()
            .marginTop(4.0)
            .sizeToFit(.width)
        
        self.noticeLabel.pin
            .below(of: self.profileImageView)
            .bottom(12.0)
            .marginTop(12.0).horizontally(12.0)
            .sizeToFit(.width)

        self.profileButton.pin
            .topLeft(to: self.profileImageView.anchor.topLeft)
            .right(12.0)
            .height(40.0)
    }
}


extension TestCell {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.pin.width(size.width)
        self.layout()

        return CGSize(width: self.contentView.frame.width, height: self.noticeLabel.frame.maxY + 12.0)
    }
}
