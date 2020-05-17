
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Message_VC: UIViewController {

    private let closeButton = UIButton()
    private let loadButton = UIButton()

    private let stackView = UIStackView()
    private let messageView = UIView()
    private let countLabel = UILabel()
    private let messageInputView = MessageInputView()

    private var stackViewViewBottomConstraint: Constraint?

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension Message_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)

        self.stackView.axis = .vertical
        self.view.addSubview(self.stackView)

        self.messageView.backgroundColor = .yellow
        self.stackView.addArrangedSubview(self.messageView)

        self.countLabel.textColor = .black
        self.countLabel.text = "12345"
        self.messageView.addSubview(self.countLabel)

        self.stackView.addArrangedSubview(self.messageInputView)
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

        self.stackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.closeButton.snp.bottom).offset(16.0)
            self.stackViewViewBottomConstraint = maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).constraint
        }

        self.countLabel.snp.makeConstraints { maker in
            maker.trailing.bottom.equalToSuperview()
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
    }
}


extension Message_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func onLoad() {
        self.messageInputView.isHidden.toggle()
    }
}


extension Message_VC {

    @objc private func onKeyboard(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let rect = frame.cgRectValue
            if notification.name == UIResponder.keyboardWillShowNotification {
                self.changeKeyboardStatus(height: rect.height, curve: UIView.AnimationOptions(rawValue: curve), duration: duration)
            } else {
                self.changeKeyboardStatus(height: 0, curve: UIView.AnimationOptions(rawValue: curve), duration: duration)
            }
        }
    }

    func changeKeyboardStatus(height: CGFloat, curve: UIView.AnimationOptions, duration: Double) {
        guard let constraint = self.stackViewViewBottomConstraint else { return }

        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
            if height > 0 {
                constraint.update(offset: -height)
            } else {
                constraint.update(offset: 0)
            }
            self.view.layoutIfNeeded()
        })
    }
}
