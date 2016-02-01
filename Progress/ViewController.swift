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
    
    @IBOutlet weak var hostingView: UIView!
    @IBOutlet weak var chartView: LineChartView!
    
    var model: WeightModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = HealthManager()
        
        guard HKHealthStore.isHealthDataAvailable() else { print("No health data available."); return }
        
        manager.authorizeHealthSharingWithSuccess({
            manager.getWeightData { (results: [HKQuantitySample]) -> Void in
                self.model = WeightModel(rawValues: results)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadGraph()
                })
            }
            },
            errorHandler: {
                print("Health request denied.")
        })
        
        hostingView.layer.cornerRadius = 4.0
        hostingView.clipsToBounds = true
        
        hostingView.backgroundColor = UIColor(red: 63/255.0, green: 195/255.0, blue: 128/255.0, alpha: 1.0)
        chartView.backgroundColor = UIColor(red: 63/255.0, green: 195/255.0, blue: 128/255.0, alpha: 1.0)
        
    }
    
    func loadGraph() {
        chartView.descriptionText = ""
        chartView.noDataText = "No data available - did you allow Health access?"
        chartView.dragEnabled = true
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false

        chartView.legend.enabled = false
        
//        chartView.leftAxis.customAxisMax = 10
//        chartView.leftAxis.customAxisMin = 0
        
        chartView.leftAxis.startAtZeroEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.labelTextColor = UIColor.whiteColor()
        chartView.leftAxis.axisLineColor = UIColor.whiteColor()
        chartView.rightAxis.enabled = false

        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = UIColor.whiteColor()
        chartView.xAxis.axisLineColor = UIColor.whiteColor()
        chartView.xAxis.labelPosition = .Bottom
        
        chartView.viewPortHandler.setMaximumScaleY(8.0)
        chartView.viewPortHandler.setMaximumScaleX(8.0)
        
        let xVals = model?.chartXValues
        let yVals = model?.chartValues

//        let yVals = [
//            ChartDataEntry(value: 0, xIndex: 0),
//            ChartDataEntry(value: 1, xIndex: 1),
//            ChartDataEntry(value: 2, xIndex: 2),
//            ChartDataEntry(value: 4, xIndex: 4),
//            ChartDataEntry(value: 5, xIndex: 5),
//            ChartDataEntry(value: 7, xIndex: 7),
//            ChartDataEntry(value: 8, xIndex: 8),
//            ChartDataEntry(value: 9, xIndex: 9),
//        ]
//        let xVals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        let set = LineChartDataSet(yVals: yVals)
        set.lineWidth = 1.0
        set.circleRadius = 2.0
        set.setColor(UIColor.whiteColor())
        set.setCircleColor(UIColor.whiteColor())
        let data = LineChartData(xVals: xVals, dataSet: set)
        chartView.data = data
        
        chartView.animate(xAxisDuration: 1)
    }
}

