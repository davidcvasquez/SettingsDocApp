///-------------------------------------------------------------------------------------------------
///  BoolSetting.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct BoolSetting: DocumentSetting {
    public var id: ID
    public var settingType: SettingType = .boolean

    public var valueReader: () -> Bool
    public var commit: (Bool) -> Void

    public var commitBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                self.valueReader()
            },
            set: {
                self.commit($0)
            })
    }
}

public struct BoolSettingView: View {
    @Environment(\.isEnabled) private var isEnabled

    public var textKey: LocalizedStringKey
    private var value: Binding<Bool>

    public init (textKey: LocalizedStringKey,
                 setting: BoolSetting,
                 onEditingDone: @escaping () -> Void = { }) {
        self.textKey = textKey
        self.value = setting.commitBinding
    }

    public var body: some View {
        Toggle(isOn: value) {
            Text(textKey)
        }
        .padding([.horizontal, .bottom])
    }
}
