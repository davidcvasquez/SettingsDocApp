///-------------------------------------------------------------------------------------------------
///  ContentView.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

private func snapToHalf(_ x: Double) -> Double { (x * 2).rounded() / 2 }

struct ContentView: View {
    @Binding var document: SettingsDocument

    @FocusState private var focusedField: Field?
    private enum Field { case int, dbl }

    private var intAsDouble: Binding<Double> {
        .init(get: { Double(document.intValue) },
              set: { document.intValue = Int($0.rounded()) })
    }

    var leafCapsuleSettings: LeafCapsuleSettings {
        LeafCapsuleSettings(radii: .init(get: { self.document.radii },
                                         set: { self.document.radii = $0 }))
    }

    var body: some View {
        Form {
            // Integer controls
            HStack { Text("Integer"); Spacer(); Text("\(document.intValue)").monospacedDigit() }
            Slider(value: intAsDouble, in: 0...100, step: 1,
                   onEditingChanged: { isEditing in
                       if isEditing { focusedField = nil }  // dismiss keyboard/focus when drag starts
                   })

            TextField("Integer", value: $document.intValue, format: .number)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .int)
            #if os(iOS)
                .keyboardType(.numberPad)
                .submitLabel(.done)
            #endif

            Divider().padding(.vertical, 8)

            // Double controls (0...100, step 0.5)
            HStack {
                Text("Double"); Spacer()
                Text(String(format: "%.1f", document.doubleValue)).monospacedDigit()
            }
            Slider(value: $document.doubleValue, in: 0...100, step: 0.5,
                   onEditingChanged: { isEditing in
                       if isEditing { focusedField = nil }  // dismiss keyboard/focus when drag starts
                   })

            TextField("Double",
                      value: $document.doubleValue,
                      format: .number.precision(.fractionLength(0...1)))
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .dbl)
            #if os(iOS)
                .keyboardType(.decimalPad)
                .submitLabel(.done)
            #endif
                // Keep text edits clamped & snapped like the slider
                .onChange(of: document.doubleValue) { _, v in
                    let clamped = min(max(v, 0), 100)
                    let snapped = snapToHalf(clamped)
                    if snapped != document.doubleValue { document.doubleValue = snapped }
                }

            LeafCapsuleSettingsView(leafCapsuleSettings: leafCapsuleSettings)
        }
        .padding()
        .frame(minWidth: 320, minHeight: 240)
    #if os(iOS)
        // A small toolbar above the keyboard with a Done button
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    #endif
    }
}
