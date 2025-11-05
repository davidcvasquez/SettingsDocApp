///-------------------------------------------------------------------------------------------------
///  LocalizedStringKeys.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public extension LocalizedStringKey {
    static var noErrorKey = LocalizedStringKey(.noError)
    static var unknownErrorKey = LocalizedStringKey(.unknownError)
    static var appNameKey = LocalizedStringKey("AppName")

    static var leafCapsuleTopLeadingKey = LocalizedStringKey("LeafCapsuleTopLeading")
    static var leafCapsuleBottomLeadingKey = LocalizedStringKey("LeafCapsuleBottomLeading")
    static var leafCapsuleBottomTrailingKey = LocalizedStringKey("LeafCapsuleBottomTrailing")
    static var leafCapsuleTopTrailingKey = LocalizedStringKey("LeafCapsuleTopTrailing")
}
