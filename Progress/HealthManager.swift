//
//  HealthManager.swift
//  Progress
//
//  Created by Jason Ji on 1/28/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager: NSObject {
    let store = HKHealthStore()
    
    func authorizeHealthSharingWithSuccess(successHandler: () -> Void, errorHandler: () -> Void) {
        // Request authorization
        
        guard let weightType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass) else { return }
        let authorizationStatus = store.authorizationStatusForType(weightType)
        
        switch authorizationStatus {
        case .NotDetermined:
            let types: Set<HKQuantityType> = [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!]
            store.requestAuthorizationToShareTypes(types, readTypes: types) { (success, error) -> Void in
                guard success else { print("Authorization request unprocessed"); return }
                successHandler()
            }
        case .SharingAuthorized:
            successHandler()
        case .SharingDenied:
            errorHandler()
        }
    }
    
    func getWeightData(successHandler: (results: [HKQuantitySample]) -> Void ) {
        
        // Read weight data
        //        let formatter = NSMassFormatter() // useful for localized output of mass
        
        let past = NSDate.distantPast()
        let now = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: now, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!, predicate: mostRecentPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (query: HKSampleQuery, results: [HKSample]?, error: NSError?) -> Void in
            if let results = results as? [HKQuantitySample] {
                successHandler(results: results)
            }
        }
        
        store.executeQuery(sampleQuery)
    }
}

