///-------------------------------------------------------------------------------------------------
///  Log.swift
///  Platform
///
///  Logging of progress, diagnostics, and errors.
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import Foundation
import os
import SwiftUI

public extension Log.ModuleName {
    static let platform = Log.ModuleName("platform")
    static let application = Log.ModuleName("application")
}

public class Log {
    public enum Kind: String, Codable {
        case progress
        case diagnostic
        case error
        case fatalError
    }

    public typealias ErrorCode = String
    public typealias ModuleName = String

    struct ErrorDescription {
        let module: ModuleName
        let key: LocalizedStringKey
    }

    public class func registerPlatformErrors() {
//        registerPlatformErrorCodes()
    }

    class func registerPlatformErrorMessage(
        errorCode: ErrorCode, _ key: LocalizedStringKey
    ) {
        errorDescriptions[errorCode] = ErrorDescription(module: .platform, key: key)
    }

    public class func registerApplicationErrorMessage(
        _ errorCode: ErrorCode, _ key: LocalizedStringKey
    ) {
        errorDescriptions[errorCode] = ErrorDescription(module: .application, key: key)
    }

    public class func registerErrorMessage(
        module: ModuleName, errorCode: ErrorCode, _ key: LocalizedStringKey
    ) {
        errorDescriptions[errorCode] = ErrorDescription(module: module, key: key)
    }

    public class func logErrorMessages(module: ModuleName) {
        var errorDescriptionList = ""

        let list = errorDescriptions.sorted{ $0.key < $1.key }
        for description in list {
            guard description.value.module == module else {
                continue
            }
            errorDescriptionList = errorDescriptionList + """
            \n\(module.uppercased()) Error code: \(description.key), \(description.value.key.stringValue)
            """
        }

        log(kind: .diagnostic, errorDescriptionList)
    }

    private static var errorDescriptions: [ErrorCode: ErrorDescription] = [
        .noError: ErrorDescription(module: .platform, key: .noErrorKey),
        .unknownError: ErrorDescription(module: .platform, key: .unknownErrorKey)
    ]

    /// Convenience method to log progress.
    public static func progress(
        _ message: String = "",
        _ fields: [String : String] = [:],
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        threadDescription: String = Thread.current.description
    ) {
        log(kind: .progress,
            message, fields,
            fileID: fileID, functionName: functionName, lineNumber: lineNumber,
            threadDescription: threadDescription)
    }

    /// Convenience method to log diagnostic.
    public static func diagnostic(
        _ message: String = "",
        _ fields: [String : String] = [:],
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        threadDescription: String = Thread.current.description
    ) {
        log(kind: .diagnostic,
            message, fields,
            fileID: fileID, functionName: functionName, lineNumber: lineNumber,
            threadDescription: threadDescription)
    }

    /// Convenience method to log an error via an error code.
    public static func error(
        _ code: ErrorCode,
        _ fields: [String : String] = [:],
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        threadDescription: String = Thread.current.description
    ) {
        log(kind: .error, errorCode: code,
            "", fields,
            fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }

    public enum Environment: Codable {
        case development
        case production
    }

    public enum Platform: Codable {
        case macOS
        case iOS
        case iPadOS
        case visionOS
        case windows
    }

    public struct Manifest: Codable, Identifiable {
        public var id: String = UUID().uuidString

        public let environment: Environment
        public let platform: Platform
        public let startTime: Date
        public let appName: String
        public let appVersion: String
    }

    public struct SessionLog: Codable {
        public let manifest: Manifest
        public var logEntries: [LogEntry]
    }

    public static var sessionLog = SessionLog(
        manifest: Manifest(environment: .development, platform: .macOS, startTime: Date(), appName: "Too Many Suits • Creator", appVersion: "1.0.0"),
        logEntries: []
        )

    public struct LogEntry: Codable, Identifiable, CustomDebugStringConvertible {
        public var id: String = UUID().uuidString

        public var timeStamp: String {
            "\(timeStampDateFormatter.string(from: self.date))"
        }

        public var location: String {
            "Module: \(self.module) | File: \(self.file) • func \(functionName) @ ln#\(lineNumber)"
        }
        public var messageHeader: String {
            "\(prefix)\(self.timeStamp) • \(self.location)"
        }

        public var debugDescription: String {
            let messageHeader: String = "\(prefix)  \(self.timeStamp) • \(location)"
            let messageBody = message.isEmpty ? "" : " • \(message)"
            var kvps: String = ""
            if !self.fields.isEmpty {
                kvps = "\n"
                for field in self.fields {
                    kvps += "[\(field.0) : \(field.1)]\n"
                }
            }

            let fullMessage: String = messageHeader + messageBody + kvps

            return fullMessage
        }

        let kind: Kind
        let errorCode: ErrorCode
        let date: Date
        let timeMS: Int
        let message: String
        let fields: [String : String]
        let module: String
        let file: String
        let functionName: String
        let lineNumber: Int
        let threadDescription: String

        var prefix: String {
            switch kind {
            case .progress:
                "⏱️ Progress"

            case .diagnostic:
                "ℹ️ Diagnostic"

            case .error:
                if errorCode == .noError {
                    "⚠️ ERROR"
                }
                else {
                    if let errorDescription = Log.errorDescriptions[errorCode] {
                        """
                        ⚠️ \(errorDescription.module.uppercased())
                         ERROR CODE: \(errorCode),
                         \(errorDescription.key.stringValue) ⚠️
                        """
                    }
                    else {
                        "*** ERROR CODE: \(errorCode) *** "
                    }
                }

            case .fatalError:
                "🔥 FATAL ERROR"
            }
        }
    }

    private static func components(_ fileID: String) -> (module: String, file: String) {
        let components = fileID.components(separatedBy: "/")
        let moduleName: String = components.first ?? "Unknown module"
        let leafName: String = components.last ?? "Unknown file"

        return (module: moduleName, file: leafName)
    }

    static var isConsoleOutputEnabled = true

    /// Log progress, diagnostics, or errors.
    fileprivate static func log(
        kind: Kind = .progress,
        errorCode: ErrorCode = .noError,
        _ message: String = "",
        _ fields: [String : String] = [:],
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        threadDescription: String = Thread.current.description
    ) {
        let components = components(fileID)

        let logEntry = LogEntry(
            kind: kind, errorCode: errorCode, date: Date(), timeMS: Self.currentMS,
            message: message, fields: fields,
            module: components.module, file: components.file,
            functionName: functionName, lineNumber: lineNumber,
            threadDescription: threadDescription)

        Self.sessionLog.logEntries.append(logEntry)

        if isConsoleOutputEnabled {
            Swift.print(logEntry.debugDescription)
        }
    }

    /// Log a fatal entry that stops execution.
    public class func fatalEntry(
        _ code: ErrorCode = .noError,
        _ message: String = "",
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line
    ) -> Never {
        Log.log(
            kind: .fatalError,
            errorCode: code == .noError ? .unknownError : code,
            message,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber)

        // Unconditionally prints End of Line and stops execution.
        fatalError("🔥 End of line. 🔥")
    }

    public typealias TimingCategory = String

    public typealias Millisecond = Int
    public typealias TimeStamps = [TimingCategory: Millisecond]
    public static var startTimes: TimeStamps = [:]
    public static var elapsedTimes: TimeStamps = [:]

    public typealias FPS = [TimingCategory: Int]
    public static var timingsPerSecondCompleted: FPS = [:]
    public static var timingsPerSecondInProgress: FPS = [:]

    static var currentMS: Int {
        Int(Date().timeIntervalSinceReferenceDate * 1000)
    }

    public static func recordStartTime(category: TimingCategory) {
        Self.startTimes[category] = Int(Date().timeIntervalSinceReferenceDate * 1000)
    }

    public static func recordElapsedTime(category: TimingCategory) {
        if let startTime = Self.startTimes[category] {
            Self.elapsedTimes[category] =
                Int(Date().timeIntervalSinceReferenceDate * 1000) - startTime
        }
    }

    public static func recordFPS(category: TimingCategory) {
        if let startTime = Self.startTimes[category],
           let timingPerSecond = Self.timingsPerSecondInProgress[category] {
            if Int(Date().timeIntervalSinceReferenceDate * 1000) - startTime > 1000 {
                Self.recordStartTime(category: category)
                Self.timingsPerSecondCompleted[category] = timingPerSecond
                Self.timingsPerSecondInProgress[category] = 0
            }
            else {
                Self.timingsPerSecondInProgress[category] = timingPerSecond + 1
            }
        }
        else {
            Self.recordStartTime(category: category)
            Self.timingsPerSecondInProgress[category] = 0
        }
    }

    private class var timeStampDateFormatter: DateFormatter {
        let timeStampDateFormatter = DateFormatter()
        timeStampDateFormatter.timeStyle = .short
        timeStampDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeStampDateFormatter.dateFormat = "dd-MMM-YYYY HH:mm:ss.SSS"
        return timeStampDateFormatter
    }
}

public extension Log.ErrorCode {
    static let noError = Log.ErrorCode("0")
    static let unknownError = Log.ErrorCode("EC.unknown")
}

///-------------------------------------------------------------------------------------------------
/// EOF
///-------------------------------------------------------------------------------------------------
