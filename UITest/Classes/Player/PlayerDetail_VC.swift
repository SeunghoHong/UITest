
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

    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()

    private var player: AVPlayer?

    private var disposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(nibName: nil, bundle: nil)

        print(#function)
    }

    deinit {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.bind()

        self.prepare()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(#function)
        self.player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print(#function)
        self.player?.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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

        self.titleLabel.backgroundColor = .green
        self.view.addSubview(self.titleLabel)

        self.nicknameLabel.backgroundColor = .yellow
        self.view.addSubview(self.nicknameLabel)
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
//            .width(30%)
            .size(200.0)

        self.backgroundImageView.pin
            .all()
    }

    private func bind() {
        
    }
}


extension PlayerDetail_VC {

    func prepare() {
        self.player = AVPlayer(url: URL(string: "http://kr-cdn.spooncast.net/profiles/E/VX2O4Et3Xozb4/4857feeb-d461-479a-957f-8e0fd9a991ae.m4a")!)
        self.player?.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 33, timescale: 1000),
            queue: nil
        ) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration else { return }

            let progress = CGFloat(time.seconds / duration.seconds)
            self?.circleProgressBar.progress = progress
//            print("\(time.seconds) / \(duration.seconds)")
        }
    }
}
