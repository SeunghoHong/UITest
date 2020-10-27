
import UIKit
import AVFoundation

import RxCocoa
import RxSwift


class AudioRecorder: NSObject {

    private var audioRecorder: AVAudioRecorder?
    private lazy var fileURL: URL? = {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsURL.appendingPathComponent("record.m4a")
    }()

    private var progress: ((TimeInterval) -> Void)?
    private var completion: ((Error?) -> Void)?

    private var progressDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()

    let isRecording = BehaviorRelay<Bool>(value: false)
    let currentTime = BehaviorRelay<TimeInterval>(value: 0.0)

    let error = BehaviorRelay<Error?>(value: nil)


    override init() {
        super.init()
        self.prepare()
    }
}


extension AudioRecorder {

    private func prepare() {
        guard let fileURL = self.fileURL else {
            self.error.accept(NSError.trace())
            return
        }

        do {
            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: [
                AVFormatIDKey : kAudioFormatMPEG4AAC,
                AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue,
                AVNumberOfChannelsKey : 2,
                AVSampleRateKey : 44100.0,
            ])
            self.audioRecorder?.delegate = self
        } catch let error {
            self.error.accept(error)
        }
 
        // MARK: 슬립모드 진입 방지
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}


extension AudioRecorder {

    func record(for duration: TimeInterval) {
        guard let audioRecorder = self.audioRecorder else {
            self.error.accept(NSError.trace())
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.allowBluetooth, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            self.error.accept(error)
            return
        }

        guard audioRecorder.prepareToRecord() == true else {
            self.error.accept(NSError.trace())
            return
        }

        guard audioRecorder.record(forDuration: duration) == true else {
            self.error.accept(NSError.trace())
            return
        }

        // MARK: 슬립모드 진입 방지
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }

        Observable<Int>.interval(.milliseconds(33 /* 30fps */), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let audioRecorder = self.audioRecorder else { return }
                guard audioRecorder.isRecording == true else { return }

                self.currentTime.accept(audioRecorder.currentTime)
            })
            .disposed(by: self.progressDisposeBag)
    }

    func stop() {
        self.progressDisposeBag = DisposeBag()

        guard let audioRecorder = self.audioRecorder, audioRecorder.isRecording == true else { return }

        audioRecorder.stop()
        self.audioRecorder = nil

        // MARK: 슬립모드 진입 방지 제거
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    func review(_ url: URL? = nil) {
        
    }
}


extension AudioRecorder: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.isRecording.accept(recorder.isRecording)
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.error.accept(error)
    }
}


extension AudioRecorder {

    static func requestPermission(_ completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission(completion)
        @unknown default:
            completion(false)
        }
    }
}
