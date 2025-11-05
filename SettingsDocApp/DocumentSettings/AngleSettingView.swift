///-------------------------------------------------------------------------------------------------
///  AngleSettingView.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct AngleSettingView: View {
    @Environment(\.isEnabled) private var isEnabled

    public var iconName: IconName
    public var textKey: LocalizedStringKey

    public var onEditingDone: () -> Void

    private var iconOpacity: NDFloat {
        self.isEnabled ? 0.85 : 0.2
    }

    var captionOpacity: NDFloat {
        self.isEnabled ? 0.67 : 0.2
    }

    @Namespace var mainNameSpace

    private var value: Binding<Double>
    private var commit: Binding<Double>
    private let didUndoObserver = NotificationCenter.default.publisher(
        for: .NSUndoManagerDidUndoChange)
    private let didRedoObserver = NotificationCenter.default.publisher(
        for: .NSUndoManagerDidRedoChange)
    private var range: ClosedRange<Double>
    private var step: Double

    public init (iconName: IconName,
                 textKey: LocalizedStringKey,
                 setting: FloatSetting,
                 onEditingDone: @escaping () -> Void = { }) {
        self.iconName = iconName
        self.textKey = textKey
        self.value = setting.trackingBinding
        self.commit = setting.commitBinding
        if setting.format == .percent {
            self.range = setting.range.lowerBound * 100.0...setting.range.upperBound * 100.0
            self.step = setting.step * 100.0
        }
        else {
            self.range = setting.range
            self.step = setting.step
        }
        self.onEditingDone = onEditingDone
    }

    var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.maximum = (self.range.upperBound) as NSNumber
        return formatter
    }

    public var body: some View {
        HStack {
            switch iconName {
            case .system(let name):
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
                    .opacity(self.iconOpacity)
                    .frame(width: 32, height: 32)
                    .help(textKey)

            case .local(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .opacity(self.iconOpacity)
                    .frame(width: 32, height: 32)
                    .help(textKey)
            }

//            Spacer()

            AngleControlView(title: textKey, value: value) { editing in
                if !editing {
                    self.commit.wrappedValue = self.value.wrappedValue
                    self.onEditingDone()
                }
            }
            .help(textKey)

//            Spacer()

            TextField("", value: value, formatter: self.decimalFormatter)
                .help(textKey)
#if os(iOS)
                .keyboardType(.numberPad)
#endif
#if os(macOS)
                .prefersDefaultFocus(false, in: mainNameSpace)
#endif
                .onSubmit {
#if os(macOS)
                    // https://developer.apple.com/forums/thread/678388
                    DispatchQueue.main.async {
                        NSApplication.shared.keyWindow?.makeFirstResponder(nil)
                    }
#endif
                    self.commit.wrappedValue = self.value.wrappedValue
                    self.onEditingDone()
                }
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .frame(
                    width: 80
                )

#if os(macOS)
            Stepper(" ", value: value, in: self.range, step: self.step,
                    onEditingChanged: { editing in
                if !editing {
                    self.commit.wrappedValue = self.value.wrappedValue
                    self.onEditingDone()
                }
            })
            .help(textKey)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            .fixedSize(horizontal: true, vertical: true)
#endif
        }
        .inspectorColumnWidth(min: 380, ideal: 380, max: 420)
    }
}
