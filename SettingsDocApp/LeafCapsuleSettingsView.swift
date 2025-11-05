///-------------------------------------------------------------------------------------------------
///  LeafCapsuleSettingsView.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct LeafCapsuleSettingsView: View {
    let leafCapsuleSettings: LeafCapsuleSettings

    public static let settingViewStack: SettingViewStack = [
        SettingViewStackItem(id: .leafCapsuleScaleToFitID,
                             key: .leafCapsuleScaleToFitKey,
                             iconName: .system(name: "rectangle")),

        // Capsule Radii Corners
        SettingViewStackItem(id: .leafCapsuleTopLeadingID,
                             key: .leafCapsuleTopLeadingKey,
                             iconName: .system(name: "rectangle")),
        SettingViewStackItem(id: .leafCapsuleBottomLeadingID,
                             key: .leafCapsuleBottomLeadingKey,
                             iconName: .system(name: "rectangle")),
        SettingViewStackItem(id: .leafCapsuleBottomTrailingID,
                             key: .leafCapsuleBottomTrailingKey,
                             iconName: .system(name: "rectangle")),
        SettingViewStackItem(id: .leafCapsuleTopTrailingID,
                             key: .leafCapsuleTopTrailingKey,
                             iconName: .system(name: "rectangle")),

        // Angle
        SettingViewStackItem(id: .leafCapsuleAngleID,
                             key: .leafCapsuleAngleKey,
                             iconName: .system(name: "rectangle"))
   ]

    public var body: some View {
        SettingViewStackView(settingViewStack: Self.settingViewStack,
                             documentSettings: self.leafCapsuleSettings.settingsMap)
    }
}
