///-------------------------------------------------------------------------------------------------
///  SettingsDocAppApp.swift
///  SettingsDocApp
///
///  Created by David Vasquez on 04-Nov-2025.
///  Copyright © 2025 David C. Vasquez. All rights reserved.
///-------------------------------------------------------------------------------------------------

import SwiftUI

@main
struct SettingsDocApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: SettingsDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
