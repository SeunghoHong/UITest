
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout


final class TestPinCell: UITableViewCell {

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


extension TestPinCell {

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


extension TestPinCell {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.pin.width(size.width)
        self.layout()

        return CGSize(width: self.contentView.frame.width, height: self.noticeLabel.frame.maxY + 12.0)
    }
}
