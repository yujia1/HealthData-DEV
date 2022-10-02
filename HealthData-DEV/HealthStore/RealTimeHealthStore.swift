//
//  RealTimeHealthStore.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/20/22.
//

import Foundation
import HealthKit
import Firebase
import WatchConnectivity


class RealTimeHealthStore {
    var healthStore: HKHealthStore?
    
   
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
                //self.fetchHealthData()
            }
        }
    }
    func fetchHealthData() {
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day], from: Date())
        let startDate : Date = calender.date(from: components)!
        let endDate : Date = calender.date(byAdding: Calendar.Component.day, value: 1, to: startDate as Date)!

        let sampleType : HKSampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let predicate : NSPredicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
       
      
       

        //self.healthStore.execute(anchoredQuery)
    }
    
    private func setUpBackgroundDeliveryForDataTypes(types: Set<HKObjectType>) {
            for type in types {
                guard let sampleType = type as? HKSampleType else { print("ERROR: \(type) is not an HKSampleType"); continue }
                
                let query1 = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: <#T##(HKObserverQuery, @escaping HKObserverQueryCompletionHandler, Error?) -> Void#>)
                let query2 = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: (HKObserverQuery!,
                                                                                                    HKObserverQueryCompletionHandler!,
                                                                                                     HKObserverQueryCompletionHandler
                                                                                                     ){
                    
                })
                            let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] (query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: NSError?) in
                                debugPrint("observer query update handler called for type \(type), error: \(error)")
                                guard let strongSelf = self else { return }
                                strongSelf.queryForUpdates(type)
                                completionHandler()
                            }
                            
                healthStore?.execute(query)
                healthStore?.enableBackgroundDelivery(for: type, frequency: .immediate, withCompletion: (success: Bool, error: NSError?), {
                    debugPrint("enable Background Delivery for type handler called for ")
                })
                
            }
        }
    private func queryForUpdate(){
        
    }
    private func dataTypesToRead() -> Set<HKObjectType> {
            return Set(arrayLiteral:
                        HKObjectType.quantityType(forIdentifier: .heartRate)!
        )
    }

    /// Types of data that this app wishes to write to HealthKit.
    ///
    /// - returns: A set of HKSampleType.
    private func dataTypesToWrite() -> Set<HKSampleType> {
            return Set(arrayLiteral:
                        HKObjectType.quantityType(forIdentifier: .heartRate)!
            )
    }
}


