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
    
    // MARK: - Data model
    private var viewModel = GameBoardViewModel()

    // MARK: - Private properties
    private var isTracingPath = false
    private var isGameLoopRunning = false {
        didSet {
            if isGameLoopRunning {
                startGameLoop()
            }
            else {
                stopGameLoop()
            }
        }
    }
    private var gameLoopTimer: Timer? = nil
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
        resetPlanePath(bezierPath: bezierPath, planeView: planeButton)
        drawPlanePath(bezierPath: bezierPath, planeView: planeButton)
        orientToPath(bezierPath: bezierPath, planeView: planeButton)
    }

    func shouldTrace() -> Bool {
        return isTracingPath
    }
}

// MARK: - Tracing and path methods
extension GameBoardViewController {
    
    private func startTracingPath() {
        guard !isTracingPath else { return }
        print("Start tracing")
        isTracingPath = true
        tracePathView.clear()
        tracePathView.isHidden = false
        isGameLoopRunning = false
    }
    
    private func stopTracingPath() {
        guard isTracingPath else { return }
        print("Stop tracing")
        isTracingPath = false
        tracePathView.isHidden = true
        isGameLoopRunning = true
    }

    private func resetPlanePath(bezierPath: UIBezierPath, planeView: UIView) {
        viewModel.plane.resetPath()
    }
    
    private func drawPlanePath(bezierPath: UIBezierPath, planeView: UIView) {
        viewModel.planeView = planeView
        viewModel.pathShape.removeFromSuperlayer()
        viewModel.pathShape = CAShapeLayer()
        viewModel.pathShape.path = bezierPath.cgPath
        viewModel.pathShape.strokeColor = UIColor.darkGray.cgColor
        viewModel.pathShape.fillColor = UIColor.clear.cgColor
        viewModel.pathShape.lineWidth = 5.0
        viewModel.pathShape.strokeStart = viewModel.plane.percentageComplete
        viewModel.pathShape.strokeEnd = 1.0
        pathsView.layer.addSublayer(viewModel.pathShape)
    }
    
    private func orientToPath(bezierPath: UIBezierPath, planeView: UIView) {
        viewModel.plane.path = bezierPath
        let rotation = viewModel.plane.headingInRadians()
        planeView.transform = CGAffineTransform(rotationAngle: rotation)
        print("Rotating to \(rotation) radians")
    }
    
    private func movePlaneOnPath(bezierPath: UIBezierPath, planeView: UIView) {
        planeView.center = viewModel.plane.centrePosition
    }
}

// MARK: - Game loop methods
extension GameBoardViewController {
    
    private func startGameLoop() {
        stopGameLoop()
        gameLoopTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameLoopTimerFired), userInfo: nil, repeats: true)
    }
    
    private func stopGameLoop() {
        gameLoopTimer?.invalidate()
    }
    
    @objc func gameLoopTimerFired() {
        print("Timer fired!")
        viewModel.plane.move()
        guard let path = viewModel.plane.path else { return }
        drawPlanePath(bezierPath: path, planeView: planeButton)
        orientToPath(bezierPath: path, planeView: planeButton)
        movePlaneOnPath(bezierPath: path, planeView: planeButton)
    }
}
