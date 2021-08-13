
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout


final class TestFlexCell: UITableViewCell {

    private let baseView = UIView()
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
        set {
            self.noticeLabel.text = newValue
            self.noticeLabel.flex.markDirty()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        self.setupFlex()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }
}


extension TestFlexCell {

    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .lightGray

        self.baseView.backgroundColor = .white
        self.baseView.radius = 6.0
        self.contentView.addSubview(self.baseView)
        
        self.timeLabel.textColor = .red
        self.timeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)

        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel.lineBreakMode = .byCharWrapping
        self.titleLabel.numberOfLines = 2

        self.profileImageView.backgroundColor = .yellow
        self.profileImageView.radius = 20.0

        self.infoView.backgroundColor = .blue

        self.badgeView.backgroundColor = .red
        self.badgeView.radius = 8.0

        self.nicknameLabel.textColor = .black
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.nicknameLabel.numberOfLines = 1

        self.noticeLabel.textColor = .darkGray
        self.noticeLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.noticeLabel.numberOfLines = 4
        self.titleLabel.lineBreakMode = .byCharWrapping

        self.profileButton.backgroundColor = .clear

        self.timeLabel.text = "2:30 PM"
        self.titleLabel.text = "라이브 타이틀은 여기에 표시됩니다. 최대 2줄까지 표시됩니다."
        self.nicknameLabel.text = "UserNickname"
    }

    private func setupFlex() {
        self.baseView.flex.direction(.column)
            .marginHorizontal(16.0).marginVertical(8.0)
            .padding(12.0)
            .define { flex in
                flex.addItem(self.timeLabel)

                flex.addItem(self.titleLabel)
                    .marginTop(12.0)

                flex.addItem().direction(.row)
                    .marginTop(12.0)
                    .alignItems(.center)
                    .define { flex in
                        flex.addItem(self.profileImageView)
                            .size(40)

                        flex.addItem().direction(.column)
                            .marginLeft(12.0)
                            .define { flex in
                                flex.addItem(self.badgeView)
                                    .width(42.0).height(16.0)

                                flex.addItem(self.nicknameLabel)
                                    .marginTop(4.0)
                            }
                    }

                flex.addItem(self.noticeLabel)
                    .marginTop(12.0)
            }
    }

    private func layout() {
        self.contentView.flex.layout(mode: .adjustHeight)
    }
}


extension TestFlexCell {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.pin.width(size.width)
        self.layout()

        return self.contentView.frame.size
    }
}

