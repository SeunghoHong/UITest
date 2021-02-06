
import Foundation

import RxSwift
import RxCocoa


class Notice_VM {

    private let notices = BehaviorRelay<[Notice]>(value: [])
    private let disposeBag = DisposeBag()


    init() {
        self.bind()
        self.load()
    }
}


extension Notice_VM {

    private func bind() {
        
    }
}


extension Notice_VM {

    private func load() {
        S4RESTClient.json(
                type: Notice.self,
                url: "https://us-api.spooncast.net/commons/notices/",
                method: .get,
                queries: ["is_popup":"true"]
            )
            .bind { [weak self] result in
                if case .success(let obj) = result {
                    print("\(obj)")
                    self?.notices.accept(obj.results)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
