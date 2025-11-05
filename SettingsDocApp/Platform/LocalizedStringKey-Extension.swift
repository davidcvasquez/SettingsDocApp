///-------------------------------------------------------------------------------------------------
///  LocalizedStringKey-Extension.swift
///  Platform
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

extension LocalizedStringKey: @retroactive Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        self.init(key)
    }

    public enum CodingKeys: String, CodingKey {
        case key
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self, forKey: .key)
    }
}

public extension LocalizedStringKey {
    var stringKey: String {
        // 'LocalizedStringKey(key: "THE_KEY", hasFormatting: false, arguments: [])'
        let description = "\(self)"

        // Compact way to get "THE KEY" from in-between the argument name and the trailing comma.
        let components = description.components(separatedBy: "key: \"").map { $0.components(separatedBy: "\",") }

        guard !components.isEmpty else {
            return "key.not.found"
        }

        return components[1][0]
    }

    var stringValue: String {
        String(localized: String.LocalizationValue(self.stringKey))
    }
}
