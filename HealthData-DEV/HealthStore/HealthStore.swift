//
//  HKHealthStore.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import Foundation
import HealthKit
import Firebase

class HealthStore {
    
    var healthStore: HKHealthStore?
    
    @Published var quantityData: [QuantityModel] = []
    @Published var HKQuantities: [HKQuantity] = []
   
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    let readDataTypes : Set = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
    let writeDataTypes : Set = [HKObjectType.quantityType(forIdentifier: .heartRate)!]

    func requestAuth(completion: @escaping (Bool) -> Void) {
        guard let healthStore = self.healthStore else {return completion(false)}
        healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) {
            (success, error) in
            if !success {
                // handle the error situation
            } else {
                self.fetchHealthData()
            }
        }
    }

    func fetchHealthData() {
        // Simple Step count query with no predicate and no sort descriptors
        // map <HKSampleType, string>
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let sampleUnit: HKUnit = HKUnit(from: "count/min")

        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: nil,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { [self] (query, results, error) in

            for result in results! {


                guard let currData:HKQuantitySample = result as? HKQuantitySample else { return }
                
                let test = QuantityModel(uuid: currData.uuid, value: currData.quantity.doubleValue(for: sampleUnit), unit: "count/min", startDate: currData.startDate, endDate: currData.endDate, metaData: currData.metadata?.description ?? "no access", systemVersion: currData.sourceRevision.description)
                self.quantityData.append(test)
                UploadHealthData(quantityData: test)
                
                let data = HKQuantity(uuid: currData.uuid, quantityType: currData.quantityType.description, value: currData.quantity.description, startDate: currData.startDate, endDate: currData.endDate, metaData:  currData.metadata?.description ?? "no access", systemVersion:currData.sourceRevision.description)
                UploadHkQuantityDate(quantityData: data)

            }
        }
        healthStore?.execute(query)
    }

    func UploadHealthData(quantityData: QuantityModel) {
        let db = Firestore.firestore()
        let ref = db.collection("QuantityData").document()


        ref.setData(["id": (quantityData.uuid).uuidString, "unit" : quantityData.unit, "value": quantityData.value, "startDate": quantityData.startDate, "endDate": quantityData.endDate, "metaData": quantityData.metaData, "systemVersion": quantityData.systemVersion]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func UploadHkQuantityDate(quantityData: HKQuantity) {
        let db = Firestore.firestore()
        let ref = db.collection("HKQuantity").document()
        ref.setData(["id":(quantityData.uuid).uuidString, "quantityType": quantityData.quantityType, "value": quantityData.value, "startDate": quantityData.startDate, "endDate": quantityData.endDate, "metaData": quantityData.metaData, "systemVersion": quantityData.systemVersion]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


