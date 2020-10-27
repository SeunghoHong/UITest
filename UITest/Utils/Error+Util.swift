
import Foundation


extension Error {

    static func trace(function: String = #function, line: Int = #line, message: String? = nil) -> Error {
        return NSError(domain: [function, message].compactMap({ $0 }).joined(separator: " - "), code: line, userInfo: nil)
    }
}
