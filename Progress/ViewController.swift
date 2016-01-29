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
        do {
            try manager.authorizeHealthSharingWithSuccess({
                manager.getWeightData { (results: [HKQuantitySample]) -> Void in
                    self.model = WeightModel(values: results)
                    self.loadGraph()
                }
                },
                errorHandler: {
                    print("Health request denied.")
            })
        } catch {
            print("No health data available.")
        }

    }
    
    func loadGraph() {
        
    }
}

