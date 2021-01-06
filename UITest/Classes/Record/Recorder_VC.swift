
import UIKit

import RxSwift
import RxCocoa
import SnapKit


protocol RecorderBindable {
    var file: BehaviorRelay<String> { get }
    var progress: BehaviorRelay<TimeInterval> { get }
    var error: PublishRelay<Error> { get }

    var recordButtonTapped: PublishRelay<Void> { get }
    var stopButtonTapped: PublishRelay<Void> { get }
    var playButtonTapped: PublishRelay<Void> { get }
}

class Recorder_VC: UIViewController {

    private var closeButton = UIButton()
    private var recordButton = UIButton()
    private var stopButton = UIButton()
    private var playButton = UIButton()

    private var fileLabel = UILabel()
    private var progressLabel = UILabel()

    private var viewModel: RecorderBindable?
    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Recorder_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.recordButton.setTitle("record", for: .normal)
        self.recordButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.recordButton)

        self.stopButton.setTitle("stop", for: .normal)
        self.stopButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.stopButton)

        self.playButton.setTitle("play", for: .normal)
        self.playButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.playButton)

        self.fileLabel.textColor = .black
        self.view.addSubview(self.fileLabel)

        self.progressLabel.textColor = .black
        self.view.addSubview(self.progressLabel)
    }

    private func layout() {
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.recordButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }

        self.stopButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.recordButton.snp.bottom).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }

        self.playButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.stopButton.snp.bottom).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }

        self.fileLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        self.progressLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.fileLabel.snp.bottom).offset(16.0)
            maker.centerX.equalToSuperview()
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Recorder_VC {

    func bind(_ viewModel: RecorderBindable) {
        self.viewModel = viewModel

        viewModel.file.asDriver()
            .drive(self.fileLabel.rx.text)
            .disposed(by: self.disposeBag)

        viewModel.progress.asDriver()
            .map { "\(Int($0))" }
            .drive(self.progressLabel.rx.text)
            .disposed(by: self.disposeBag)

        viewModel.error
            .map { $0.localizedDescription }
            .bind(to: self.fileLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.recordButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.recordButtonTapped)
            .disposed(by: self.disposeBag)

        self.stopButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.stopButtonTapped)
            .disposed(by: self.disposeBag)

        self.playButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.playButtonTapped)
            .disposed(by: self.disposeBag)
    }
}


extension Recorder_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
