///-------------------------------------------------------------------------------------------------
///  IntSetting.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct IntSetting: DocumentSetting {
    public var id: ID
    public var settingType: SettingType = .integer

    public var valueReader: () -> Int
    public var tracking: (Int) -> Void
    public var commit: (Int) -> Void
    public var range: ClosedRange<Int>
    public var format: IntFormat

    public enum IntFormat: Equatable {
        // Equatable conformance
        public static func == (lhs: IntSetting.IntFormat, rhs: IntSetting.IntFormat) -> Bool {
            switch (lhs, rhs) {
            case (.count, .count):
                true
            case (.enumeration(let caseNamesLHS), .enumeration(let caseNamesRHS)):
                (caseNamesLHS.count == caseNamesRHS.count)
            default:
                false
            }
        }

        case count
        case enumeration(caseNames: [(icon: IconName, key: LocalizedStringKey)])
    }

    public var trackingBinding: Binding<Int> {
        Binding<Int>(
            get: {
                self.valueReader()
            },
            set: {
                self.tracking($0)
            })
    }

    public var commitBinding: Binding<Int> {
        Binding<Int>(
            get: {
                self.valueReader()
            },
            set: {
                self.commit($0)
            })
    }
}

 public struct IntSliderSettingView: View {
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

     public var valueReader: () -> Int
     private var value: Binding<Int>
     private var commit: Binding<Int>
     private let didUndoObserver = NotificationCenter.default.publisher(
        for: .NSUndoManagerDidUndoChange)
     private let didRedoObserver = NotificationCenter.default.publisher(
        for: .NSUndoManagerDidRedoChange)
     private var range: ClosedRange<Double>
     private var step: Double

     @State private var floatProxy: Double = 0.0

     public init (iconName: IconName,
                  textKey: LocalizedStringKey,
                  setting: IntSetting,
                  onEditingDone: @escaping () -> Void = { }) {
         self.iconName = iconName
         self.textKey = textKey
         self.valueReader = setting.valueReader
         self.onEditingDone = onEditingDone
         self.value = setting.trackingBinding
         self.commit = setting.commitBinding
         self.range = NDFloat(setting.range.lowerBound)...NDFloat(setting.range.upperBound)
         self.step = 1.0
     }

     var decimalFormatter: NumberFormatter {
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = 0
         formatter.maximumFractionDigits = 0
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

             ZStack {
                 Text(textKey)
                     .padding(EdgeInsets(top: -16, leading: 0, bottom: 0, trailing: 0))
                     .font(.caption2)
                     .opacity(captionOpacity)

                 Slider(value: $floatProxy, in: self.range, step: 1.0) { editing in
                     if !editing {
                         self.value.wrappedValue = Int($floatProxy.wrappedValue)
                         self.commit.wrappedValue = self.value.wrappedValue
                         self.onEditingDone()
                     }
                 }
                 .onAppear() {
                     $floatProxy.wrappedValue = NDFloat(self.valueReader())
                 }
                 .onChange(of: floatProxy) {
                     self.value.wrappedValue = Int($floatProxy.wrappedValue)
                 }
                 .help(textKey)
                 .tint(Color(.systemBlue))
                 .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                 .frame(
                    maxWidth: .infinity,
                    alignment: .leading)
             }

             TextField("", value: $floatProxy, formatter: self.decimalFormatter)
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
                     self.value.wrappedValue = Int($floatProxy.wrappedValue)
                     self.commit.wrappedValue = self.value.wrappedValue
                     self.onEditingDone()
                 }
                 .textFieldStyle(.roundedBorder)
                 .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                 .frame(
                    width: 80
                 )

#if os(macOS)
             Stepper(" ", value: $floatProxy, in: self.range, step: self.step) { editing in
                 if !editing {
                     self.value.wrappedValue = Int($floatProxy.wrappedValue)
                     self.commit.wrappedValue = self.value.wrappedValue
                     self.onEditingDone()
                 }
             }
             .help(textKey)
             .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
             .fixedSize(horizontal: true, vertical: true)
#endif
         }
         .onChange(of: commit.wrappedValue) {
             if commit.wrappedValue != Int($floatProxy.wrappedValue) {
                 $floatProxy.wrappedValue = NDFloat(self.valueReader())
             }
         }
     }
 }

public struct IntPickerSettingView: View {
    @Environment(\.isEnabled) private var isEnabled

    public var textKey: LocalizedStringKey

    private var commit: Binding<Int>
    private var caseNames: [(icon: IconName, key: LocalizedStringKey)]

    public var onEditingDone: () -> Void

    public init (textKey: LocalizedStringKey,
                 setting: IntSetting,
                 onEditingDone: @escaping () -> Void = { }) {
        self.textKey = textKey

        self.commit = setting.commitBinding
        if case let .enumeration(caseNames) = setting.format {
            self.caseNames = caseNames
        }
        else {
            self.caseNames = []
        }

        self.pickerValue = setting.valueReader()
        self.onEditingDone = onEditingDone
    }

    let pickerImageOpacity = 0.80

    @State private var pickerValue: Int = 0

    public var body: some View {
        Picker(selection: $pickerValue, label: Text(textKey)) {
            ForEach(0 ..< self.caseNames.count, id: \.self) {
                switch self.caseNames[$0].icon {
                case .system(let name):
                    Image(systemName: name)
                        .renderingMode(.template)
                        .opacity(pickerImageOpacity)
                        .tag($0)
                        .help(self.caseNames[$0].key)

                case .local(let name):
                    Image(name)
                        .renderingMode(.template)
                        .opacity(pickerImageOpacity)
                        .tag($0)
                        .help(self.caseNames[$0].key)
                }
            }
        }
        .onChange(of: $pickerValue.wrappedValue) {
            Log.diagnostic("pickerValue: \($pickerValue.wrappedValue)")

            self.commit.wrappedValue = $pickerValue.wrappedValue
            self.onEditingDone()
        }
        .onChange(of: commit.wrappedValue) {
            Log.diagnostic("commit: \(commit.wrappedValue)")

            if commit.wrappedValue != $pickerValue.wrappedValue {
                $pickerValue.wrappedValue = commit.wrappedValue
            }
        }
        .pickerStyle(.segmented)
        .controlSize(.extraLarge)
        .fixedSize()
        .opacity(self.isEnabled ? 1.0 : 0.2)
    }
}
