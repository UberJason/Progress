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
    
    @IBOutlet weak var hostingView: UIView!
    var model: WeightModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = HealthManager()
        
        guard HKHealthStore.isHealthDataAvailable() else { print("No health data available."); return }
        
        manager.authorizeHealthSharingWithSuccess({
            manager.getWeightData { (results: [HKQuantitySample]) -> Void in
                self.model = WeightModel(values: results)
                self.loadGraph()
            }
            },
            errorHandler: {
                print("Health request denied.")
        })
        
        
    }
    
    func loadGraph() {
        
    }
}

