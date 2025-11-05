///-------------------------------------------------------------------------------------------------
///  SettingViewStackView.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

/// A SwiftUI view that renders a vertical stack of setting rows using a Grid.
///
/// Use this view to declaratively compose a settings page from a set of known models with
/// automatic layout and presentation of any of the supported types.
///
/// SettingViewStackView takes a sequence of lightweight descriptors (SettingViewStackItem)
/// that define which settings to render and in what order. For each descriptor, the view
/// looks up the concrete setting model in `documentSettings` and chooses an appropriate
/// setting subview (for example, `FloatSettingView`, `AngleSettingView`, `BoolSettingView`,
/// `IntSliderSettingView`, or `IntPickerSettingView`) based on the model type and format.
///
/// - Rendering:
///   - FloatSetting → `FloatSettingView`
///   - FloatSetting with `.angle` format → `AngleSettingView`
///   - BoolSetting → `BoolSettingView`
///   - IntSetting with `.count` format → `IntSliderSettingView`
///   - IntSetting with `.enumeration` format → `IntPickerSettingView`
///
/// - Layout: Uses a `Grid` with spacing defined by `NDFloat.settingGridSpacing`. Each
///   `SettingViewStackItem` produces one `GridRow`.
///
/// - Parameters:
///   - settingViewStack: The ordered list of setting descriptors to display. Each item
///     supplies an `id` used to look up the corresponding model in `documentSettings`,
///     a localized `key` for the label, and an optional `iconName`.
///   - documentSettings: A map of all available document settings, keyed by `DocumentSetting.ID`.
///     This is queried at runtime to find the strongly typed setting model for each row.
///
public struct SettingViewStackView: View {
    /// The ordered list of setting descriptors that determines which rows are shown and in what order.
    @State var settingViewStack: SettingViewStack
    /// A lookup table containing concrete setting models, queried by each item
    /// in `settingViewStack` to choose an appropriate row view.
    let documentSettings: DocumentSettingsMap

    public var body: some View {
        Grid(alignment: .leading,
             horizontalSpacing: .settingGridSpacing.width,
             verticalSpacing: .settingGridSpacing.height) {
            ForEach(settingViewStack, id: \.id) { setting in
                GridRow {
                    if let floatSetting = documentSettings[setting.id] as? FloatSetting {
                        if floatSetting.format == .angle {
                            AngleSettingView(
                                iconName: setting.iconName, textKey: setting.key, setting: floatSetting)
                        }
                        else {
                            FloatSettingView(
                                iconName: setting.iconName, textKey: setting.key, setting: floatSetting)
                        }
                    }
                    else if let boolSetting = documentSettings[setting.id] as? BoolSetting {
                        BoolSettingView(textKey: setting.key, setting: boolSetting)
                    }
                    else if let intSetting = documentSettings[setting.id] as? IntSetting {
                        if intSetting.format == .count {
                            IntSliderSettingView(
                                iconName: setting.iconName, textKey: setting.key, setting: intSetting)
                        }
                        else if case .enumeration(_) = intSetting.format {
                            IntPickerSettingView(textKey: setting.key, setting: intSetting)
                        }
                    }
                }
            }
        }
    }
}

public extension NDFloat {
    static let settingGridSpacing = CGSize(width: 16.0, height: 20.0)
}

public struct SettingViewStackItem: Codable, Identifiable {
    public let id: DocumentSetting.ID
    public let key: LocalizedStringKey
    public var iconName: IconName
}

public typealias SettingViewStack = [SettingViewStackItem]

