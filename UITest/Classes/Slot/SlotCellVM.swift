
import UIKit

import RxSwift
import RxCocoa


class SlotCellVM {

    let nickname = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<UIImage?>(value: nil)
    let mute = BehaviorRelay<Bool>(value: true)

    let muteButtonTapped = PublishRelay<Void>()

    private var user: User?

    private let disposeBag = DisposeBag()


    init(with user: User?) {
        self.user = user

        self.bind()
        self.loadItem()
    }
}


extension SlotCellVM {

    private func bind() {
        self.muteButtonTapped
            .map { !self.mute.value }
            .bind(to: self.mute)
            .disposed(by: self.disposeBag)
    }
}


extension SlotCellVM {

    private func loadItem() {
        guard let user = self.user else { return }

        self.nickname.accept(user.nickname)
        self.image.accept(user.image ?? UIImage(named: "img_round"))
    }
}
