
import Foundation

import Alamofire
import RxSwift
import RxCocoa


class S4RESTClient {

    static func json<T: Codable>(
        type: T.Type,
        url: String,
        method: Alamofire.HTTPMethod,
        queries: [String : Any]? = nil,
        body: String? = nil,
        headers: [String : String]? = [:]
    ) -> Observable<Result<T, Error>> {
        return Observable<Result<T, Error>>.create { observer -> Disposable in
            guard let url = URL(string: url), let fullURL = url.appendQueries(queries) else {
                observer.onError(NSError.trace())
                return Disposables.create()
            }

            var customHeaders: [String : String] = [
//                "User-Agent" : Device.userAgentString(),
                "Accept" : "application/json",
//                "Accept-Language" : Device.languageCode() ?? "en-US"
            ]

            headers?.forEach { customHeaders[$0.0] = $0.1 }

            var parameters: [String : Any]?
            if let body = body?.data(using: .utf8) {
                do {
                    parameters = try JSONSerialization.jsonObject(with: body, options: .mutableContainers) as? [String : Any]
                } catch let e {
                    observer.onError(e)
                }
            }

            let request = AF.request(
                    fullURL,
                    method: method,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: HTTPHeaders(customHeaders)
                )
                .validate()
                .responseData { response in
//                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        observer.onError(error)
                    case .success(let data):
                        do {
                            observer.onNext(try JSONDecoder().decode(type, from: data))
                        } catch let e {
                            observer.onError(e)
                        }
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
