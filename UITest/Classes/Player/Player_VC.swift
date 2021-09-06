
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import SnapKit


final class CircleProgressBar: UIView {

    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()

    var progress: CGFloat = 0.0 {
        didSet { self.setNeedsDisplay() }
    }


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: .zero)

        self.setup()
    }
    
    private func setup() {
        self.backgroundMask.lineWidth = 4.0
        self.backgroundMask.fillColor = nil
        self.backgroundMask.strokeColor = UIColor.black.cgColor
        self.layer.mask = self.backgroundMask

        self.progressLayer.lineWidth = 4.0
        self.progressLayer.fillColor = nil
        self.layer.addSublayer(self.progressLayer)
        self.layer.transform = CATransform3DMakeRotation(CGFloat(90.0 * .pi / 180.0), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 4.0 / 2, dy: 4.0 / 2))
        self.backgroundMask.path = circlePath.cgPath

        self.progressLayer.path = circlePath.cgPath
        self.progressLayer.lineCap = .round
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = self.progress
        self.progressLayer.strokeColor = UIColor.red.cgColor
        self.progressLayer.backgroundColor = UIColor.black.cgColor
    }
}



final class Player_VC: UIViewController {

    private let closeButton = UIButton()

    private let backgroundImageView = UIImageView()
    private let circleProgressBar = CircleProgressBar()
    private let profileImageView = UIImageView()

    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()

    private var disposeBag = DisposeBag()


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


extension Player_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.backgroundImageView.backgroundColor = .lightGray
        self.view.addSubview(self.backgroundImageView)

        self.circleProgressBar.backgroundColor = .black
        self.circleProgressBar.progress = 0.5
        self.view.addSubview(self.circleProgressBar)

        self.profileImageView.clipsToBounds = true
        self.profileImageView.backgroundColor = .blue
        self.profileImageView.radius = 100.0
        self.view.addSubview(self.profileImageView)

        self.titleLabel.backgroundColor = .green
        self.view.addSubview(self.titleLabel)

        self.nicknameLabel.backgroundColor = .yellow
        self.view.addSubview(self.nicknameLabel)

        self.closeButton.backgroundColor = .black
        self.closeButton.setTitle("close", for: .normal)
        self.view.addSubview(self.closeButton)
    }

    private func layout() {
        self.closeButton.pin
            .top(self.view.pin.safeArea)
            .start(16.0)
            .marginTop(16.0)
            .sizeToFit()

        self.circleProgressBar.pin
            .below(of: self.closeButton)
            .margin(10.0)
            .hCenter()
            .size(212.0)

        self.profileImageView.pin
            .below(of: self.closeButton)
            .marginTop(16.0)
            .hCenter()
//            .width(30%)
            .size(200.0)

        self.backgroundImageView.pin
            .all()
    }

    private func bind() {

    }
}
