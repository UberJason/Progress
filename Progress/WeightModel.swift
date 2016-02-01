//
//  WeightModel.swift
//  Progress
//
//  Created by Jason Ji on 1/28/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import HealthKit
import Charts


class WeightModel: NSObject {
    var rawValues: [HKQuantitySample]?
    var chartValues: [ChartDataEntry] = []
    var chartXValues: [String] = []
    init(rawValues: [HKQuantitySample]) {
        self.rawValues = rawValues
        super.init()
        
        guard let earliestDate = earliestDateFromValues() else { return }
        
        for sample in rawValues {
            let rawDate = sample.startDate
            let modifiedDate = NSDate(year: rawDate.year(), month: rawDate.month(), day: rawDate.day())
            
            let offset = modifiedDate.daysLaterThan(earliestDate)
            let lbs = sample.quantity.doubleValueForUnit(HKUnit.poundUnit())
            
            chartValues.append(ChartDataEntry(value: lbs, xIndex: offset))
        }
        let totalDays = NSDate().daysLaterThan(earliestDate)+1
        
        for i in 0..<totalDays {
            let currentDate = earliestDate.dateByAddingDays(i)
            chartXValues.append(currentDate.formattedDateWithFormat("MM/d"))
        }
    }
    
    private func earliestDateFromValues() -> NSDate? {
        guard let rawValues = rawValues else { return nil }
        let array = (rawValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "startDate", ascending: true)])
        guard let rawDate = (array.first as? HKQuantitySample)?.startDate else { return nil }
        return NSDate(year: rawDate.year(), month: rawDate.month(), day: rawDate.day())
    }
    
    func highestWeightValue() -> Double? {
        let weightSorted = rawValues?.sort { $0.quantity.doubleValueForUnit(HKUnit.poundUnit()) > $1.quantity.doubleValueForUnit(HKUnit.poundUnit()) }
        return weightSorted?.first?.quantity.doubleValueForUnit(HKUnit.poundUnit())
    }
    
    func lowestWeightValue() -> Double? {
        let weightSorted = rawValues?.sort { $0.quantity.doubleValueForUnit(HKUnit.poundUnit()) < $1.quantity.doubleValueForUnit(HKUnit.poundUnit()) }
        return weightSorted?.first?.quantity.doubleValueForUnit(HKUnit.poundUnit())
    }
}