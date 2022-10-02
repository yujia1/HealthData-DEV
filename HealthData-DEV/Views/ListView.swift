//
//  ListView.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import SwiftUI
import HealthKit

struct ListView: View {
    private var healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
    }
    var body: some View {
        Text("health work!")
            .onAppear {
                if let healthStore = healthStore {
                    healthStore.requestAuth {
                        success in
                    }
                }
        }
    }
}



