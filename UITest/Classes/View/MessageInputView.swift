
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

    var onText: ((String) -> Void)?


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

        self.textView.delegate = self
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

        self.textView.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        self.sendButton.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        self.textView.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        self.sendButton.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
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

        self.sendButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onSend()
            }
            .disposed(by: self.disposeBag)

    }
}


extension MessageInputView {

    private func onSend() {
        guard let text = self.textView.text, let onText = self.onText else { return }
        onText(text)
    }
}


extension MessageInputView: UITextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            if textView.text.count > 0 {
                if let attributedString = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
                    var mentionRange: NSRange?

                    attributedString.enumerateAttribute(
                        .link,
                        in: NSRange(location: 0, length: textView.attributedText.length)
                    ) { value, linkRange, stop in
                        if linkRange.contains(range.location) && value != nil {
                            mentionRange = linkRange
                            stop.pointee = true
                        }
                    }

                    if let mentionRange = mentionRange {
                        attributedString.removeAttribute(.link, range: mentionRange)
                        attributedString.deleteCharacters(in: mentionRange)
                        textView.attributedText = attributedString
                        textView.selectedRange = NSRange(location: mentionRange.location, length: 0)
                        textView.scrollRangeToVisible(NSRange(location: mentionRange.location, length: 0))
                        return false
                    }
                }
            }

            return true
        }

        if text == "@" {
            let mention = "@raymond"
            var string = textView.text ?? ""
            string.insert(contentsOf: "\(mention) ", at: string.index(string.startIndex, offsetBy: range.location))
            let mentionRange = NSRange(location: range.location, length: mention.count)

            let attributedString = NSMutableAttributedString(string: string as String, attributes: [.font : UIFont.systemFont(ofSize: 18.0)])
            attributedString.addAttribute(.link, value: "test://userID/raymond", range: mentionRange)
            textView.attributedText = attributedString
            textView.selectedRange = NSRange(location: mentionRange.location + mention.count + 1 /* space */, length: 0)
            return false
        }

        return true
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        print("\(characterRange) \(URL)")
        return false
    }
}
