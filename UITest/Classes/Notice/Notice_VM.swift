
import Foundation

import RxSwift
import RxCocoa


class Notice_VM {

    struct Response: Codable {
        var status_code: String
        var detail: String
        var next: String
        var previous: String
        var results: [Notice]
    }


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
                type: Response.self,
                url: "https://us-api.spooncast.net/commons/notices/",
                method: .get,
                queries: ["is_popup":"true"]
            )
            .debug()
            .retryWhen { e in
                e.enumerated().flatMap { (retry, error) -> Observable<Int> in
                    guard retry < 3 else { return Observable.never() }

                    return Observable<Int>.timer(
                        .milliseconds(300),
                        scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
                    )
                }
            }
            .subscribe(onNext: { response in
                print("onNext")
            }, onError: { error in
                print("onError \(error)")
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: self.disposeBag)
        
    }
}
