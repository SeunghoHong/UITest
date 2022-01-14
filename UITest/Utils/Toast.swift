
import UIKit

import RxSwift
import RxGesture
import PinLayout
import FlexLayout


final class ToastView: UIView {

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

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12.0)

        return label
    }()

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0

        return label
    }()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.setupFlex()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }

    private func setup() {
        self.addSubview(self.view)
    }

    private func setupFlex() {
        self.view.flex.direction(.row)
            .margin(16.0)
            .padding(16.0)
            .alignItems(.center)
            .define { flex in
                flex.addItem(self.imageView)
                    .size(CGSize(width: 30.0, height: 30.0))

                flex.addItem().direction(.column)
                    .marginLeft(16.0)
                    .shrink(1.0)
                    .define { flex in
                        flex.addItem(self.titleLabel)

                        flex.addItem(self.messageLabel)
                            .marginTop(4.0)
                    }
            }
    }

    private func layout() {
        self.view.pin
            .horizontally()

        self.view.flex
            .layout(mode: .adjustHeight)

        self.view.pin
            .top()

        self.pin.height(self.view.height)
    }

    func setData(image: UIImage?, title: String, message: String) {
        self.imageView.image = image
        
        self.titleLabel.text = title
        self.titleLabel.flex.markDirty()
        
        self.messageLabel.text = message
        self.messageLabel.flex.markDirty()

        self.layoutIfNeeded()
    }
}



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


    private var toastWindow: UIWindow = {
        var window: UIWindow?

        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first

        if let windowScene = windowScene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window?.isUserInteractionEnabled = false
        window?.makeKeyAndVisible()

        return window ?? UIWindow(frame: UIScreen.main.bounds)
    }()

    private let topView = UIView()
    private let toastView = ToastView()

    private var clickDisposeBag = DisposeBag()
    private var hideDisposeBag = DisposeBag()


    init() {
        self.setup()
    }
}


extension Toast {

    private func setup() {
        self.toastWindow.addSubview(self.topView)
        self.toastWindow.addSubview(self.toastView)
    }

    private func layout(_ isShow: Bool) {
        self.topView.pin
            .horizontally()
            .top()

        self.toastView.pin
            .horizontally()

        if isShow {
            self.toastView.pin
                .top(self.toastWindow.pin.safeArea)
        } else {
            self.toastView.pin
                .above(of: self.topView)
        }
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
        self.toastView.setData(image: status.image, title: status.title, message: message)

        self.hide(delay: false, animated: false)

        self.clickDisposeBag = DisposeBag()
        if let onClick = onClick {
            self.toastWindow.isUserInteractionEnabled = true
            self.toastView.rx.tapGesture()
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
        self.toastWindow.isHidden = false

        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.layout(true)
            }, completion: { _ in
                if autoHidden {
                    self.hide()
                }
            })
        } else {
            self.layout(true)
            if autoHidden {
                self.hide()
            }
        }
    }

    private func dismiss(_ animated: Bool = true) {
        self.toastWindow.isUserInteractionEnabled = false

        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.layout(false)
            }, completion: { _ in
                self.toastWindow.isHidden = true
            })
        } else {
            self.layout(false)
            self.toastWindow.isHidden = true
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
