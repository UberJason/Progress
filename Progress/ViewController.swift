//
//  ViewController.swift
//  Progress
//
//  Created by Jason Ji on 1/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request authorization
        let store = HKHealthStore()
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("No health data available, quitting now.")
        }
        guard let weightType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass) else { return }
        let authorizationStatus = store.authorizationStatusForType(weightType)
        
        if authorizationStatus == .NotDetermined {
            store.requestAuthorizationToShareTypes(nil, readTypes: [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!]) { (success, error) -> Void in
                if success {
                    print("Authorization request processed (unsure if actually allowed).")
                }
                else {
                    print("Failed to process authorization request.")
                }
            }
        }
        
        // Read weight data
        //        let formatter = NSMassFormatter() // useful for localized output of mass
        
        let past = NSDate.distantPast()
        let now = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: now, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!, predicate: mostRecentPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (query: HKSampleQuery, results: [HKSample]?, error: NSError?) -> Void in
            if let results = results as? [HKQuantitySample] {
                for sample: HKQuantitySample in results {
                    let lbs = sample.quantity.doubleValueForUnit(HKUnit.poundUnit())
                    let start = sample.startDate, end = sample.endDate
                    print("\(lbs) - \(start), \(end)")
                }
            }
        }
        
        store.executeQuery(sampleQuery)
    }
}

