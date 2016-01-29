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
        let graphHostingView = CPTGraphHostingView(frame: hostingView.bounds)
        hostingView.addSubview(graphHostingView)
        graphHostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[graphHostingView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["graphHostingView":graphHostingView]))
        hostingView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[graphHostingView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["graphHostingView":graphHostingView]))
        graphHostingView.layoutIfNeeded()
        
        let graph = CPTXYGraph(frame: hostingView.frame)
        graphHostingView.hostedGraph = graph
        
        // Set up scatter plot space
        let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace
        plotSpace?.allowsUserInteraction = true
        plotSpace?.allowsMomentum = true
//        plotSpace?.momentumAnimationCurve = .BackOut
        plotSpace?.xRange = CPTPlotRange(location: 0, length: 10.0)
        plotSpace?.yRange = CPTPlotRange(location: 0.0, length: 10.0)
        
        // Axes
        let axisSet = graph.axisSet as? CPTXYAxisSet
        axisSet?.xAxis?.axisConstraints = CPTConstraints.constraintWithLowerOffset(20)
        axisSet?.xAxis?.majorIntervalLength = 1.0
        axisSet?.xAxis?.minorTicksPerInterval = 0
        
        axisSet?.yAxis?.axisConstraints = CPTConstraints.constraintWithLowerOffset(20)
        axisSet?.yAxis?.majorIntervalLength = 1.0
        axisSet?.yAxis?.minorTicksPerInterval = 0
        let scatterPlot = CPTScatterPlot()
        scatterPlot.identifier = "Test Plot"
        
        // Line style & plot symbols
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1.0
        lineStyle.lineColor = CPTColor.greenColor()
        scatterPlot.dataLineStyle = lineStyle

        let plotSymbol = CPTPlotSymbol.ellipsePlotSymbol()
        plotSymbol.fill = CPTFill(color: CPTColor.blueColor().colorWithAlphaComponent(0.5))
        plotSymbol.lineStyle = lineStyle
        plotSymbol.size = CGSize(width: 5.0, height: 5.0)
        scatterPlot.plotSymbol = plotSymbol
        
        scatterPlot.dataSource = model
        graph.addPlot(scatterPlot)
    }
}

