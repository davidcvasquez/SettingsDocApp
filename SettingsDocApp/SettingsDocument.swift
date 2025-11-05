///-------------------------------------------------------------------------------------------------
///  SettingsDocument.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI
import UniformTypeIdentifiers

struct SettingsDocument: FileDocument, Codable {
    static var readableContentTypes: [UTType] { [.json] }

    // Manual set up values.
    var intValue: Int = 50
    var doubleValue: Double = 25.0   // 0...100 in steps of 0.5 via UI

    // DocumentSettings-based values.
    var scaleToFit: Bool = true
    var radii: UnevenRoundedRectangleCornerRadii = .defaultCapsule
    var rotation: Double = 0.0

    init() {}

    // Decode the whole document from JSON
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self = try JSONDecoder().decode(Self.self, from: data)
        } else {
            self = .init()
        }
    }

    // Encode the whole document to JSON
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}
