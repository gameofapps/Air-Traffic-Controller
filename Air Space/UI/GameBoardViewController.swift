//
//  GameBoardViewController.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit

class GameBoardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var planeButton: UIButton!
    @IBOutlet weak var tracePathView: TracePathView!
    @IBOutlet weak var pathsView: UIView!

    // MARK: - IBActions
    @IBAction func planeButton(_ sender: UIButton) {
        print("Button tapped")
        startTracingPath()
    }
    
    // MARK: - Private properties
    private var isTracingPath = false
    private var shapeLayer = CAShapeLayer()
}

// MARK: - UIViewController methods
extension GameBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tracePathView.delegate = self
    }
}

// MARK: - TracePathViewDelegate methods
extension GameBoardViewController: TracePathViewDelegate {
    
    func tracePathCompleted(bezierPath: UIBezierPath) {
        stopTracingPath()
        drawPlanePath(bezierPath: bezierPath, planeView: planeButton)
    }

    func shouldTrace() -> Bool {
        return isTracingPath
    }
}

// MARK: - Private methods
extension GameBoardViewController {
    
    private func startTracingPath() {
        guard !isTracingPath else { return }
        print("Start tracing")
        isTracingPath = true
        tracePathView.clear()
        tracePathView.isHidden = false
    }
    
    private func stopTracingPath() {
        guard isTracingPath else { return }
        print("Stop tracing")
        isTracingPath = false
        tracePathView.isHidden = true
    }
    
    private func drawPlanePath(bezierPath: UIBezierPath, planeView: UIView) {
        shapeLayer.removeFromSuperlayer()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        pathsView.layer.addSublayer(shapeLayer)
    }
}
