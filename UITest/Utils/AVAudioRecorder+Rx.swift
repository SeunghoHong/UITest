
import AVFoundation

import RxCocoa
import RxSwift


extension Reactive where Base: AVAudioRecorder {

    var isRecording: Observable<Bool> {
        return self
            .observe(Bool.self, #keyPath(AVAudioRecorder.isRecording))
            .map { $0 ?? false }
    }

    var position: Observable<TimeInterval> {
        return Observable.create { observer in
            var disposeBag = DisposeBag()
            Observable<Int>.interval(
                    .milliseconds(33),
                    scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
                )
                .bind { _ in
                    observer.onNext(base.currentTime)
                }
                .disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = DisposeBag()
            }
        }
    }
}
