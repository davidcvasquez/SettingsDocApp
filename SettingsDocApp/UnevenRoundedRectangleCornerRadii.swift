///-------------------------------------------------------------------------------------------------
///  LeafCapsuleSettings.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct UnevenRoundedRectangleCornerRadii: Codable, Sendable, Equatable {
    /// The radius of the top-leading corner.
    public var topLeading: CGFloat

    /// The radius of the bottom-leading corner.
    public var bottomLeading: CGFloat

    /// The radius of the bottom-trailing corner.
    public var bottomTrailing: CGFloat

    /// The radius of the top-trailing corner.
    public var topTrailing: CGFloat

    public static var defaultCapsule = UnevenRoundedRectangleCornerRadii(
        topLeading: 0.15, bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 0.15)

    public static var swatchCapsule = UnevenRoundedRectangleCornerRadii(
        topLeading: 0.12, bottomLeading: 0.12, bottomTrailing: 0.12, topTrailing: 0.12)
}
