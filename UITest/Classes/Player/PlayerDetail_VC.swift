
import UIKit
import AVFoundation

import RxSwift
import RxCocoa
import PinLayout
import SnapKit


final class PlayerDetail_VC: UIViewController {

    private let backgroundImageView = UIImageView()
    private let circleProgressBar = CircleProgressBar()
    private let profileImageView = UIImageView()

    private let infoView = UIView()
    private let nicknameLabel = UILabel()
    private let titleLabel = UILabel()

    private let followButton = UIButton()
    private let likeButton = UIButton()
    private let shareButton = UIButton()

    private var player: AVPlayer?

    private var disposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(nibName: nil, bundle: nil)

        LogD(#function)
    }

    deinit {
        LogD(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LogD(#function)

        self.setup()
        self.setupFlex()
        self.bind()

        self.prepare()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogD(#function)

        self.player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogD(#function)

        self.player?.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogD(#function)

        self.layout()
    }
}


extension PlayerDetail_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.backgroundImageView.backgroundColor = .lightGray
        self.view.addSubview(self.backgroundImageView)

        self.circleProgressBar.backgroundColor = .black
        self.circleProgressBar.progress = 0.0
        self.view.addSubview(self.circleProgressBar)

        self.profileImageView.clipsToBounds = true
        self.profileImageView.backgroundColor = .blue
        self.profileImageView.radius = 100.0
        self.view.addSubview(self.profileImageView)

        self.infoView.backgroundColor = .cyan
        self.view.addSubview(self.infoView)

        self.nicknameLabel.backgroundColor = .yellow
        self.nicknameLabel.textColor = .black
        self.nicknameLabel.text = "Apple Event"

        self.titleLabel.backgroundColor = .green
        self.titleLabel.textColor = .black
        self.titleLabel.text = "Introducing the new MacBook Air, 13‑inch MacBook Pro, and Mac mini, all with the Apple M1 chip."

        self.followButton.backgroundColor = .red
        self.likeButton.backgroundColor = .blue
        self.shareButton.backgroundColor = .yellow
    }

    private func setupFlex() {
        self.infoView.flex
            .direction(.row)
            .marginHorizontal(16.0)
            .alignItems(.baseline)
            .define { flex in
                flex.addItem()
                    .direction(.column)
                    .shrink(1)
                    .define { flex in
                        flex.addItem(self.nicknameLabel)

                        flex.addItem(self.titleLabel)
                            .marginTop(8.0)
                    }

                flex.addItem()
                    .direction(.column)
                    .backgroundColor(.green)
                    .marginLeft(28.0)
                    .define { flex in
                        flex.addItem(self.followButton)
                            .size(40)

                        flex.addItem(self.likeButton)
                            .marginTop(24.0)
                            .size(40)

                        flex.addItem(self.shareButton)
                            .marginTop(24.0)
                            .size(40)
                    }
            }
    }

    private func layout() {
        self.circleProgressBar.pin
            .top(64.0)
            .margin(12.0)
            .hCenter()
            .size(208.0)

        self.profileImageView.pin
            .top(64.0)
            .marginTop(16.0)
            .hCenter()
            .size(200.0)

        self.backgroundImageView.pin
            .all()

        self.infoView.pin
            .horizontally()

        self.infoView.flex
            .layout(mode: .adjustHeight)

        self.infoView.pin
            .bottom(self.view.pin.safeArea.bottom + 86.0)
    }

    private func bind() {
        
    }
}


extension PlayerDetail_VC {

    func prepare() {
    }
}
