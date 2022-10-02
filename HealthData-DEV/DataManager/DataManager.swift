//
//  DataManager.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import Foundation
import Firebase

class DataManager: ObservableObject {
    @Published var quantityData: [QuantityModel] = []
    
    init() {
       FetchData()
    }
    
    func FetchData() {
        quantityData.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("QuantityData")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let uuid = data["id"] as? UUID ?? UUID.init()
                    let unit = data["unit"] as? String ?? ""
                    let value = data["unit"] as? Double ?? 0.00
                    let startDate = data["startDate"] as? Date ?? Date.now
                    let endDate = data["endDate"] as? Date ?? Date.now
                    let metaData = data["metaData"] as? String ?? ""
                    let systemVersion = data["systemVersion"] as? String ?? ""
                    
                    let quantityData = QuantityModel(uuid: uuid, value: value, unit: unit, startDate: startDate, endDate: endDate, metaData: metaData, systemVersion: systemVersion)
                    self.quantityData.append(quantityData)
                }
            }
        }
    }
    
    func UploadData(quantityData: QuantityModel) {
        let db = Firestore.firestore()
        let ref = db.collection("QuantityData").document()
        
        
        ref.setData(["id": quantityData.uuid, "unit" : quantityData.unit, "value": quantityData.value, "startDate": quantityData.startDate, "endDate": quantityData.endDate, "metaData": quantityData.metaData, "systemVersion": quantityData.systemVersion]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
