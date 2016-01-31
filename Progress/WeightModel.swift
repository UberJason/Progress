//
//  WeightModel.swift
//  Progress
//
//  Created by Jason Ji on 1/28/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import HealthKit

class WeightModel: NSObject {
    var values: [HKQuantitySample]?
    
    init(values: [HKQuantitySample]) {
        self.values = values
        super.init()
    }
}