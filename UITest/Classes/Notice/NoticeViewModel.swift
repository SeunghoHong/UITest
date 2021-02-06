
import Foundation

import RxSwift
import RxCocoa


class NoticeViewModel {

    private var notice: Notice?
    private var disposeBag = DisposeBag()


    init(with notice: Notice?) {
        self.notice = notice
    }
}


extension NoticeViewModel {

    private func bind() {
        
    }
}
