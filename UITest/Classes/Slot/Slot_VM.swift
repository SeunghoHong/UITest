
import Foundation

import RxSwift
import RxCocoa


class Slot_VM {

    let items = BehaviorRelay<[User]>(value: [])
    let loadButtonTapped = PublishRelay<Void>()

    private let disposeBag = DisposeBag()


    init() {
        self.bind()
    }
}


extension Slot_VM {

    private func bind() {
        self.loadButtonTapped
            .flatMap { self.load() }
            .bind(to: self.items)
            .disposed(by: self.disposeBag)
    }
}


extension Slot_VM {

    private func load() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            observer.onNext([
                User(id: 0, nickname: "abc", image: nil),
                User(id: 1, nickname: "def", image: nil),
                User(id: 2, nickname: "ghi", image: nil),
                User(id: 3, nickname: "jkl", image: nil),
            ])
            return Disposables.create()
        }
    }
}
