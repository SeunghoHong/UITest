
import Foundation

import RxSwift
import RxCocoa


class Recorder_VM: RecorderBindable {
    let file = BehaviorRelay<String>(value: "")
    let progress = BehaviorRelay<TimeInterval>(value: 0.0)
    let error = PublishRelay<Error>()

    let recordButtonTapped = PublishRelay<Void>()
    let stopButtonTapped = PublishRelay<Void>()
    let playButtonTapped = PublishRelay<Void>()

    private let recorder = AudioRecorder()
    private var disposeBag = DisposeBag()

    init() {
        self.bind()
    }
}


extension Recorder_VM {

    private func bind() {
        self.recordButtonTapped
            .bind { [weak self] _ in
                self?.recorder.record(for: 10.0)
            }
            .disposed(by: self.disposeBag)

        self.stopButtonTapped
            .bind { [weak self] _ in
                self?.recorder.stop()
            }
            .disposed(by: self.disposeBag)

        self.playButtonTapped
            .bind { [weak self] _ in
                self?.recorder.review()
            }
            .disposed(by: self.disposeBag)

        self.recorder.isRecording
            .bind { isRecording in
                print("isRecording \(isRecording)")
            }
            .disposed(by: self.disposeBag)

        self.recorder.currentTime
            .bind(to: self.progress)
            .disposed(by: self.disposeBag)

        self.recorder.error
            .compactMap { $0 }
            .bind { error in
                print("\(error.localizedDescription)")
            }
            .disposed(by: self.disposeBag)
    }
}
