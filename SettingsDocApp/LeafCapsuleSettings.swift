///-------------------------------------------------------------------------------------------------
///  LeafCapsuleSettings.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public extension DocumentSetting.ID {
    static let leafCapsuleTopLeadingID = DocumentSetting.ID("LCTL.7tNH_bbH_2mmfMh2JV3VD")
    static var leafCapsuleBottomLeadingID = DocumentSetting.ID("LCBL.4rlUZzofCfTDrUSB2f9Bf")
    static var leafCapsuleBottomTrailingID = DocumentSetting.ID("LCBT.VmqifI8gHxmyfgjJNplzK")
    static var leafCapsuleTopTrailingID = DocumentSetting.ID("LCTT.EiA1PpwHYh6FURKCu1caW")
}

public struct LeafCapsuleSettings {
    @Binding var radii: UnevenRoundedRectangleCornerRadii

    public var settingsMap: DocumentSettingsMap {
        [
            .leafCapsuleTopLeadingID: leafCapsuleTopLeadingSetting,
            .leafCapsuleBottomLeadingID: leafCapsuleBottomLeadingSetting,
            .leafCapsuleBottomTrailingID: leafCapsuleBottomTrailingSetting,
            .leafCapsuleTopTrailingID: leafCapsuleTopTrailingSetting
        ]
    }

    private static var capsuleCornerRange: ClosedRange<Double> {
        0...0.5
    }

    private static var capsuleCornerStep: Double {
        0.01
    }

    public var leafCapsuleTopLeadingSetting: FloatSetting {
        FloatSetting(
            id: .leafCapsuleTopLeadingID,
            valueReader: {
                return Double(self.radii.topLeading)
            },
            tracking: { newValue in
                self.radii.topLeading = newValue
            },
            commit: { newValue in
                self.radii.topLeading = newValue
            },
            range: Self.capsuleCornerRange,
            step: Self.capsuleCornerStep,
            format: .percent
        )
    }

    public var leafCapsuleBottomLeadingSetting: FloatSetting {
        FloatSetting(
            id: .leafCapsuleBottomLeadingID,
            valueReader: {
                return Double(self.radii.bottomLeading)
            },
            tracking: { newValue in
                self.radii.bottomLeading = newValue
            },
            commit: { newValue in
                self.radii.bottomLeading = newValue
            },
            range: Self.capsuleCornerRange,
            step: Self.capsuleCornerStep,
            format: .percent
        )
    }

    public var leafCapsuleBottomTrailingSetting: FloatSetting {
        FloatSetting(
            id: .leafCapsuleBottomTrailingID,
            valueReader: {
                return Double(self.radii.bottomTrailing)
            },
            tracking: { newValue in
                self.radii.bottomTrailing = newValue
            },
            commit: { newValue in
                self.radii.bottomTrailing = newValue
            },
            range: Self.capsuleCornerRange,
            step: Self.capsuleCornerStep,
            format: .percent
        )
    }

    public var leafCapsuleTopTrailingSetting: FloatSetting {
        FloatSetting(
            id: .leafCapsuleTopTrailingID,
            valueReader: {
                return Double(self.radii.topTrailing)
            },
            tracking: { newValue in
                self.radii.topTrailing = newValue
            },
            commit: { newValue in
                self.radii.topTrailing = newValue
            },
            range: Self.capsuleCornerRange,
            step: Self.capsuleCornerStep,
            format: .percent
        )
    }
}
