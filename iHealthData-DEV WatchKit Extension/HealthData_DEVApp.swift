//
//  HealthData_DEVApp.swift
//  iHealthData-DEV WatchKit Extension
//
//  Created by Yu Jia on 9/22/22.
//

import SwiftUI

@main
struct HealthData_DEVApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
