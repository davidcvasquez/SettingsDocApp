///-------------------------------------------------------------------------------------------------
///  AngleControlView.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct AngleControlView: View {
    public var title: LocalizedStringKey
    public var rotation: Binding<Double>

    @State private var isDragging = false
    @State private var initialDragValue = 0.0

    @Environment(\.isEnabled) private var isEnabled

    var captionOpacity: NDFloat {
        self.isEnabled ? 0.67 : 0.2
    }

    var dialOpacity: NDFloat {
        self.isEnabled ? 0.9 : 0.25
    }

    static let knobWidth: CGFloat = 36
    static let grabberWidth: CGFloat = knobWidth/5
    static let selectorXOffset: CGFloat = 9
    static let selectorYOffset: CGFloat = 5

    public var onEditingChanged: (Bool) -> Void

    public init(title: LocalizedStringKey, value: Binding<Double>, in bounds: ClosedRange<Double> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.title = title
        self.rotation = value
        self.onEditingChanged = onEditingChanged
    }

    let knob: some View = {
        Circle()
            .fill(Color.init(.displayP3, red: 195/255, green: 195/255, blue: 195/255, opacity: 1.0))
            .frame(width: knobWidth, height: knobWidth, alignment: .center)
    }()

    let grabber: some View = {
        Circle()
            .fill(Color.black.opacity(0.5))
            .frame(
                width: grabberWidth,
                height: grabberWidth,
                alignment: .center
            )
            .offset(x: knobWidth * 0.4, y: selectorYOffset)

    }()

    public var body: some View {
        HStack {
            Text(title)
                .font(.caption2)
                .opacity(captionOpacity)

            ZStack {
                knob
                    .opacity(self.dialOpacity)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                if !self.isDragging {
                                    self.isDragging = true
                                    self.initialDragValue = self.rotation.wrappedValue
                                    self.onEditingChanged(true)
                                }
                                self.rotation.wrappedValue = self.initialDragValue + drag.location.y - drag.startLocation.y
                            }
                            .onEnded { _ in
                                self.isDragging = false
                                self.onEditingChanged(false)
                            }
                    )

                // Note: Example of secondary rotation gesture.
                //                .gesture(RotationGesture()
                //                            .onChanged { value in
                //                                self.rotation = value.degrees
                //                            }
                //                        )

                grabber
                    .rotationEffect(
                        .degrees(self.rotation.wrappedValue),
                        anchor: .center
                    )
            }
        }

    }
}
