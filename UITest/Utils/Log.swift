
import Foundation
import os


enum LogLevel: Int {
    case debug, info, warning, error, silent
}


extension LogLevel: CustomStringConvertible {
    var description: String {
        switch self {
        case .debug:    return "🔍"
        case .info:     return "📝"
        case .warning:  return "⚠️"
        case .error:    return "❗️"
        case .silent:   return "🤫"
        }
    }
}


extension LogLevel {
    var osLogType: OSLogType {
        switch self {
        case .debug:    return .debug
        case .info:     return .info
        case .warning:  return .default
        case .error:    return .error
        case .silent:   return .debug
        }
    }
}


#if DEBUG
var g_logLevel: LogLevel = .debug
#else
var g_logLevel: LogLevel = .silent
#endif


func LogD(_ message: String, function: String = #function, file: String = #file, line: Int = #line, tags: Set<String> = []) {
    Log(.debug, message: message, function: function, file: file, line: line, tags: tags)
}

func LogI(_ message: String, function: String = #function, file: String = #file, line: Int = #line, tags: Set<String> = []) {
    Log(.info, message: message, function: function, file: file, line: line, tags: tags)
}

func LogW(_ message: String, function: String = #function, file: String = #file, line: Int = #line, tags: Set<String> = []) {
    Log(.warning, message: message, function: function, file: file, line: line, tags: tags)
}

func LogE(_ message: String, function: String = #function, file: String = #file, line: Int = #line, tags: Set<String> = []) {
    Log(.error, message: message, function: function, file: file, line: line, tags: tags)
}


fileprivate func Log(_ level: LogLevel, message: String, function: String, file: String, line: Int, tags: Set<String>) {
    guard g_logLevel.rawValue <= level.rawValue else { return }

    let className = file.components(separatedBy: "/").last ?? "unknown"
    let tagsLog = tags.count == 0 ? "" : "[\(tags.sorted().map { "#\($0)" }.joined(separator: "|"))] "

    let message = "[\(level)] [\(className)|\(function)|\(line)] \(tagsLog)\(message)"

    os_log("%@", type: level.osLogType, message)
}
