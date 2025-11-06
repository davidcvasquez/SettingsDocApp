///-------------------------------------------------------------------------------------------------
///  LeafCapsuleSettings.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public extension DocumentSetting.ID {
    static let leafCapsuleScaleToFitID = DocumentSetting.ID("LLStF.IhEbgwxWAnYy8dnKvyZBY")
    static let leafCapsuleTopLeadingID = DocumentSetting.ID("LCTL.7tNH_bbH_2mmfMh2JV3VD")
    static var leafCapsuleBottomLeadingID = DocumentSetting.ID("LCBL.4rlUZzofCfTDrUSB2f9Bf")
    static var leafCapsuleBottomTrailingID = DocumentSetting.ID("LCBT.VmqifI8gHxmyfgjJNplzK")
    static var leafCapsuleTopTrailingID = DocumentSetting.ID("LCTT.EiA1PpwHYh6FURKCu1caW")
    static let leafCapsuleAngleID = DocumentSetting.ID("LLA.gg_hzaHOy5zIlGNC_yZI8")
}

public struct LeafCapsuleSettings {
    @Binding var scaleToFit: Bool
    @Binding var radii: UnevenRoundedRectangleCornerRadii
    @Binding var rotation: Double

    public var settingsMap: DocumentSettingsMap {
        [
            .leafCapsuleScaleToFitID: leafCapsuleScaleToFitSetting,
            .leafCapsuleTopLeadingID: leafCapsuleTopLeadingSetting,
            .leafCapsuleBottomLeadingID: leafCapsuleBottomLeadingSetting,
            .leafCapsuleBottomTrailingID: leafCapsuleBottomTrailingSetting,
            .leafCapsuleTopTrailingID: leafCapsuleTopTrailingSetting,
            .leafCapsuleAngleID: leafCapsuleAngleSetting
        ]
    }

    public var leafCapsuleScaleToFitSetting: BoolSetting {
        BoolSetting(
            id: .leafCapsuleScaleToFitID,
            valueReader: {
                return self.scaleToFit
            },
            commit: { newValue in
                self.scaleToFit = newValue
            }
        )
    }

    private static var capsuleCornerRange: ClosedRange<Double> {
        0...0.5
    }

    private static var capsuleCornerStep: Double {
        0.1
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

    public var leafCapsuleAngleSetting: FloatSetting {
        FloatSetting(
            id: .leafCapsuleAngleID,
            valueReader: {
                return Double(self.rotation)
            },
            tracking: { newValue in
                self.rotation = newValue
            },
            commit: { newValue in
                self.rotation = newValue
            },
            range: Self.angleRange,
            step: Self.angleStep,
            format: .angle
        )
    }

    private static var angleRange: ClosedRange<Double> {
        -360.0...360.0
    }

    private static var angleStep: Double {
        1.0
    }
}
