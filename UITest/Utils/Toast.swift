
import UIKit

import RxSwift
import RxGesture
import SnapKit


final class Toast {
    static let shared = Toast()


    enum Status {
        case success
        case error
        case info

        var title: String {
            switch self {
            case .success:
                return "Success"
            case .error:
                return "Error"
            case .info:
                return "Info"
            }
        }

        var image: UIImage? {
            switch self {
            case .success:
                return UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green)
            case .error:
                return UIImage(systemName: "xmark.circle.fill")?.withTintColor(.red)
            case .info:
                return UIImage(systemName: "info.circle.fill")?.withTintColor(.blue)
            }
        }
    }


    private var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = false
        window.makeKeyAndVisible()

        return window
    }()

    private var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.radius = 16.0
        view.shadow(opacity: 0.1, radius: 10.0)

        return view
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private var contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 4.0

        return stackView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black

        return label
    }()

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0

        return label
    }()

    private var viewTopConstraint: Constraint?
    private var viewBottomConstraint: Constraint?

    private var clickDisposeBag = DisposeBag()
    private var hideDisposeBag = DisposeBag()


    init() {
        self.setup()
        self.layout()
    }
}


extension Toast {

    private func setup() {
        self.window.addSubview(self.view)

        self.view.addSubview(self.imageView)
        self.view.addSubview(self.contentsStackView)

        self.contentsStackView.addArrangedSubview(self.titleLabel)
        self.contentsStackView.addArrangedSubview(self.messageLabel)
    }

    private func layout() {
        self.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            self.viewTopConstraint = make.top.equalToSuperview().offset(UIApplication.statusBarHeight).constraint
            if let superview = self.view.superview {
                self.viewBottomConstraint = make.bottom.equalTo(superview.snp.top).constraint
            }
        }
        self.viewTopConstraint?.deactivate()
        
        self.imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.centerY.equalTo(self.contentsStackView)
            make.width.height.equalTo(30.0)
        }

        self.contentsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.leading.equalTo(self.imageView.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }

        self.window.layoutIfNeeded()
    }
}


extension Toast {

    private func show(
        _ message: String,
        status: Status = .success,
        animated: Bool = true,
        autoHidden: Bool = true,
        onClick: (() -> Void)? = nil
    ) {
        self.imageView.image = status.image
        self.titleLabel.text = status.title
        self.messageLabel.text = message

        self.hide(delay: false, animated: false)

        self.clickDisposeBag = DisposeBag()
        if let onClick = onClick {
            self.window.isUserInteractionEnabled = true
            self.view.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }

                    self.hide(delay: false, animated: true)
                    onClick()
                }
                .disposed(by: self.clickDisposeBag)
        }

        self.present(animated, autoHidden: autoHidden)
    }

    private func hide(
        delay: Bool = true,
        animated: Bool = true
    ) {
        self.hideDisposeBag = DisposeBag()

        if delay {
            Observable<Void>.just(())
                .delay(.seconds(3), scheduler: MainScheduler.instance)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.dismiss(animated)
                }
                .disposed(by: self.hideDisposeBag)
        } else {
            self.dismiss(animated)
        }
    }
}


extension Toast {

    private func present(_ animated: Bool = true, autoHidden: Bool = true) {
        self.window.isHidden = false

        let layoutWindow: () -> Void = {
            self.viewBottomConstraint?.deactivate()
            self.viewTopConstraint?.activate()
            self.window.layoutIfNeeded()
            
            var size = self.window.frame.size
            size.height = self.view.frame.size.height
            self.window.frame.size = size
        }

        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                layoutWindow()
            }, completion: { _ in
                if autoHidden {
                    self.hide()
                }
            })
        } else {
            layoutWindow()
            if autoHidden {
                self.hide()
            }
        }
    }

    private func dismiss(_ animated: Bool = true) {
        self.window.isUserInteractionEnabled = false

        let layoutWindow: () -> Void = {
            self.viewTopConstraint?.deactivate()
            self.viewBottomConstraint?.activate()
            self.window.layoutIfNeeded()
            
            self.window.frame = UIScreen.main.bounds
        }

        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                layoutWindow()
            }, completion: { _ in
                self.window.isHidden = true
            })
        } else {
            layoutWindow()
            self.window.isHidden = true
        }
    }
}


extension Toast {

    public static func showSuccess(
        _ message: String,
        animated: Bool = true,
        autoHidden: Bool = true,
        onClick: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            Toast.shared.show(
                message,
                status: .success,
                autoHidden: autoHidden,
                onClick: onClick
            )
        }
    }

    public static func showError(
        _ message: String,
        animated: Bool = true,
        autoHidden: Bool = true,
        onClick: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            Toast.shared.show(
                message,
                status: .error,
                autoHidden: autoHidden,
                onClick: onClick
            )
        }
    }

    public static func showInfo(
        _ message: String,
        animated: Bool = true,
        autoHidden: Bool = true,
        onClick: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            Toast.shared.show(
                message,
                status: .info,
                autoHidden: autoHidden,
                onClick: onClick
            )
        }
    }

    public static func hide() {
        DispatchQueue.main.async {
            Toast.shared.hide()
        }
    }
}
