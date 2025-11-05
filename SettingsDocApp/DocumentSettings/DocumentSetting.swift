///-------------------------------------------------------------------------------------------------
///  DocumentSetting.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public enum SettingType: String, Codable {
    case boolean
    case float
    case integer
    case text
}

public protocol DocumentSetting {
    typealias ID = String
    var id: ID { get }

    var settingType: SettingType { get }
}

public typealias DocumentSettingsMap = [DocumentSetting.ID: DocumentSetting]
