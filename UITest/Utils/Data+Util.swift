
import Foundation

import RxSwift
import Alamofire


extension Data {

    static internal func request(with url: URL) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            let request = AF.request(url, method: .get)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
