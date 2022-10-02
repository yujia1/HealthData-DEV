//
//  HealthModels.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import Foundation
import HealthKit

struct QuantityModel: Codable {
    var uuid: UUID
    var value: Double
    var unit: String
    var startDate: Date
    var endDate: Date
    var metaData: String
    var systemVersion: String
}

struct HKQuantity{
    var uuid: UUID
    var quantityType: String 
    var value: String
    var startDate: Date
    var endDate: Date
    var metaData: String
    var systemVersion: String
}
