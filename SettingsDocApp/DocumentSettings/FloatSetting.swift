///-------------------------------------------------------------------------------------------------
///  FloatSetting.swift
///  DocumentSettings
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

public struct FloatSetting: DocumentSetting {
    public var id: ID
    public var settingType: SettingType = .float

    public var valueReader: () -> Double
    public var tracking: (Double) -> Void
    public var commit: (Double) -> Void
    public var range: ClosedRange<Double>
    public var step: Double
    public var format: FloatFormat

    public enum FloatFormat {
        case decimal
        case percent
        case angle
    }

    public var trackingBinding: Binding<Double> {
        Binding<Double>(
            get: {
                scaledValue
            },
            set: {
                self.tracking(scaleValue($0))
            })
    }

    public var commitBinding: Binding<Double> {
        Binding<Double>(
            get: {
                scaledValue
            },
            set: {
                self.commit(scaleValue($0))
            })
    }

    public var scaledValue: Double {
        self.valueReader() * scale
    }

    public func scaleValue(_ value: Double) -> Double {
        value / scale
    }

    var scale: NDFloat {
        switch format {
        case .decimal:
            1.0

        case .percent:
            100.0

        case .angle:
            1.0
        }
    }
}
