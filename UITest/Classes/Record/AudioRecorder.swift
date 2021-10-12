
import UIKit
import AVFoundation

import RxCocoa
import RxSwift


class AudioRecorder: NSObject {

    private var audioRecorder: AVAudioRecorder?
    private var avPlayer: AVPlayer?
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

    var url: URL? {
        get { return self.fileURL }
    }

    override init() {
        super.init()
        self.prepare()
    }

    deinit {
        self.audioRecorder = nil
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
    }
}


extension AudioRecorder {

    func record(for duration: TimeInterval) {
        self.progressDisposeBag = DisposeBag()
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

        self.isRecording.accept(true)
        
        // MARK: 슬립모드 진입 방지
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }

        audioRecorder.rx.position
            .bind(to: self.currentTime)
            .disposed(by: self.progressDisposeBag)
    }

    func stop() {
        self.progressDisposeBag = DisposeBag()

        // MARK: 슬립모드 진입 방지 제거
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }

        if self.isRecording.value == true {
            self.isRecording.accept(false)

            guard let audioRecorder = self.audioRecorder else { return }

            audioRecorder.stop()
//            self.audioRecorder = nil
        } else {
            guard let avPlayer = self.avPlayer else { return }

            avPlayer.pause()
            self.avPlayer = nil
        }
    }

    func review(_ url: URL? = nil) {
        guard self.isRecording.value == false else { return }

        // MARK: default fileURL
        let url = url ?? self.fileURL

        guard let fileURL = url else {
            self.error.accept(NSError.trace())
            return
        }

        self.avPlayer = AVPlayer(url: fileURL)
        self.avPlayer?.play()

        Observable<Int>.interval(.milliseconds(33 /* 30fps */), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      let avPlayer = self.avPlayer
                else { return }

                self.currentTime.accept(avPlayer.currentTime().seconds)
            })
            .disposed(by: self.progressDisposeBag)
    }
}


extension AudioRecorder: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stop()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.error.accept(error)
        self.stop()
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
