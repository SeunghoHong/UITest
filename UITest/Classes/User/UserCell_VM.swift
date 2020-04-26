
import Foundation

import RxSwift
import RxCocoa


class UserCell_VM: UserCellBindable {

    var nickname = BehaviorRelay<String>(value: "")

    var user: User?

    private var disposeBag = DisposeBag()


    init(with user: User) {
        self.user = user

        self.loadItem()
    }
}


extension UserCell_VM {

    private func loadItem() {
        guard let user = self.user else { return }

        self.nickname.accept(user.nickname)
    }
}
