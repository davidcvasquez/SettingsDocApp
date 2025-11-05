///-------------------------------------------------------------------------------------------------
///  IconName.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

/// A system or local icon name.
public enum IconName: Codable {
    case system(name: String)
    case local(name: String)

    var name: String {
        switch self {
        case .system(let name):
            name
        case .local(let name):
            name
        }
    }
}
