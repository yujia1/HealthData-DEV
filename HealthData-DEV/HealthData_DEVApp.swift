//
//  HealthData_DEVApp.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import SwiftUI
import Firebase

@main
struct HealthData_DEVApp: App {
    
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            AuthView()
        }
    }
}
