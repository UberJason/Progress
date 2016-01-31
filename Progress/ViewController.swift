//
//  ViewController.swift
//  Progress
//
//  Created by Jason Ji on 1/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import HealthKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var chartView: LineChartView!
    
    var model: WeightModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = HealthManager()
        
        guard HKHealthStore.isHealthDataAvailable() else { print("No health data available."); return }
        
        manager.authorizeHealthSharingWithSuccess({
            manager.getWeightData { (results: [HKQuantitySample]) -> Void in
                self.model = WeightModel(values: results)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadGraph()
                })
            }
            },
            errorHandler: {
                print("Health request denied.")
        })
        
        
    }
    
    func loadGraph() {
        chartView.descriptionText = "View your weight progress over time."
        chartView.noDataText = "No data available - did you allow Health access?"
        chartView.dragEnabled = true
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.drawGridBackgroundEnabled = false

        chartView.legend.enabled = false
        
        chartView.leftAxis.customAxisMax = 220.0
        chartView.leftAxis.customAxisMin = 100.0
        chartView.leftAxis.startAtZeroEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .Bottom
        
        chartView.viewPortHandler.setMaximumScaleY(2.0)
        chartView.viewPortHandler.setMaximumScaleX(2.0)
        
        let xVals = ["1", "2", "3", "4"]
        let yVals = [ChartDataEntry(value: 150, xIndex: 0), ChartDataEntry(value: 175, xIndex: 1), ChartDataEntry(value: 200, xIndex: 3)]
        
        let set = LineChartDataSet(yVals: yVals)
        let data = LineChartData(xVals: xVals, dataSet: set)
        chartView.data = data
        
        chartView.animate(xAxisDuration: 1)
    }
}

