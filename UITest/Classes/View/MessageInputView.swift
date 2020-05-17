
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class MessageInputView: UIView {

    private let baseView = UIView()
    private let guidLabel = UILabel()
    private let textView = UITextView()
    private let sendButton = UIButton()

    private let lineCount: CGFloat = 3.0
    private lazy var lineHeight: CGFloat = {
        if let font = self.textView.font {
            return font.lineHeight
        }
        return 18.0
    }()

    private var textViewHeightConstraint: Constraint?

    private var disposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.rx.layoutSubviews
            .take(1)
            .bind { [weak self] in
                guard let self = self else { return }
                self.setup()
                self.layout()
                self.bind()
            }
            .disposed(by: self.disposeBag)
    }
}


extension MessageInputView {

    private func setup() {
        self.backgroundColor = .blue

        self.baseView.backgroundColor = .white
        self.baseView.layer.cornerRadius = 17.0
        self.baseView.layer.masksToBounds = true
        self.baseView.clipsToBounds = true
        self.addSubview(self.baseView)

        self.textView.isScrollEnabled = false
        self.textView.font = UIFont.systemFont(ofSize: 18.0)
        self.textView.textContainerInset = UIEdgeInsets.zero
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.baseView.addSubview(self.textView)

        self.guidLabel.text = "Enter you message"
        self.guidLabel.textColor = .lightGray
        self.guidLabel.font = UIFont.systemFont(ofSize: 18.0)
        self.guidLabel.textAlignment = .natural
        self.textView.addSubview(self.guidLabel)

        self.sendButton.backgroundColor = .black
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.setTitleColor(.white, for: .normal)
        self.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.baseView.addSubview(self.sendButton)
    }

    private func layout() {
        self.baseView.snp.makeConstraints { maker in
            maker.leading.top.equalTo(8.0)
            maker.trailing.bottom.equalTo(-8.0)
        }

        self.textView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10.0)
            maker.trailing.equalTo(self.sendButton.snp.leading).offset(-10.0)
            maker.top.equalToSuperview().offset(8.0)
            maker.bottom.equalToSuperview().offset(-8.0)

            self.textViewHeightConstraint = maker.height.greaterThanOrEqualTo(18.0).constraint
        }

        let inset = self.textView.textContainerInset
        self.guidLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(inset.top)
            maker.leading.equalToSuperview().offset(inset.left)
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                maker.trailing.equalToSuperview().offset(inset.right)
                maker.width.equalToSuperview()
            }
        }

        self.guidLabel.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
        }

        self.sendButton.snp.makeConstraints { maker in
            maker.trailing.top.bottom.equalToSuperview()
//            maker.width.equalTo(50.0)
        }
    }

    private func bind() {
        /*
        self.textView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .map { $0 > (self.lineHeight * self.lineCount) }
            .distinctUntilChanged()
            .bind(to: self.textView.rx.isScrollEnabled)
            .disposed(by: self.disposeBag)
         */

        self.textView.rx.text
            .map {
                guard let text = $0 else { return false }
                return !text.isEmpty
            }
            .bind(to: self.guidLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        let textHeightShare = self.textView.rx.text
            .map { text -> CGFloat in
                let size = CGSize(width: self.textView.frame.width, height: .infinity)
                return self.textView.sizeThatFits(size).height
            }
            .share()

        let isScrollEnabledShare = textHeightShare
            .distinctUntilChanged()
            .map { $0 > (self.lineHeight * (self.lineCount + 1)) }
            .share()

        isScrollEnabledShare
            .distinctUntilChanged()
            .bind(to: self.textView.rx.isScrollEnabled)
            .disposed(by: self.disposeBag)

        Observable.combineLatest(isScrollEnabledShare.asObservable(),
                                 textHeightShare.asObservable())
            { isScrollEnabled, textHeight in
                (isScrollEnabled, textHeight)
            }
            .filter { $0.0 == false }
            .map { $0.1 }
            .bind { height in
                self.textViewHeightConstraint?.update(offset: height)
            }
            .disposed(by: self.disposeBag)
    }
}
