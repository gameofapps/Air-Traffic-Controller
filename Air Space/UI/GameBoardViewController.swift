//
//  GameBoardViewController.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit
import SpriteKit

class GameBoardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tracePathView: TracePathView!
    @IBOutlet weak var spriteKitView: SKView!
    @IBOutlet weak var pathsView: UIView!

    // MARK: - IBActions
    @IBAction func spawnButtonTapped(_ sender: UIBarButtonItem) {
        spawnNewPlane()
    }

    // MARK: - Data model
    private var viewModel = [PlaneViewModel]()
    
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
    private var gameScene: GameScene? = nil
    private var gameLoopTimer: Timer? = nil
    private var gameLoopInterval = 0.3
}

// MARK: - UIViewController methods
extension GameBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tracePathView.delegate = self
        isTracingPath = false
        tracePathView.isHidden = true
        isGameLoopRunning = false

        gameScene = GameScene()
        gameScene?.isUserInteractionEnabled = true
        spriteKitView.presentScene(gameScene)
        spriteKitView.isUserInteractionEnabled = true
    }
}

// MARK: - TracePathViewDelegate methods
extension GameBoardViewController: TracePathViewDelegate {
    
    func tracePathCompleted(bezierPath: UIBezierPath, planeViewModel: PlaneViewModel) {
        stopTracingPath(planeViewModel: planeViewModel)
        resetPlanePath(bezierPath: bezierPath, planeViewModel: planeViewModel)
        drawPlanePath(bezierPath: bezierPath, planeViewModel: planeViewModel)
//        orientToPath(bezierPath: bezierPath, planeView: planeView)
    }

    func shouldTrace() -> Bool {
        return isTracingPath
    }
}

// MARK: - Tracing and path methods
extension GameBoardViewController {
    
    private func startTracingPath(planeViewModel: PlaneViewModel) {
        guard !isTracingPath else { return }
        print("Start tracing")
        planeViewModel.isSelected = true
        isTracingPath = true
        tracePathView.start(planeViewModel: planeViewModel)
        tracePathView.isHidden = false
        isGameLoopRunning = false
    }
    
    private func stopTracingPath(planeViewModel: PlaneViewModel) {
        guard isTracingPath else { return }
        print("Stop tracing")
        planeViewModel.isSelected = false
        isTracingPath = false
        tracePathView.isHidden = true
        isGameLoopRunning = true
    }

    private func resetPlanePath(bezierPath: UIBezierPath, planeViewModel: PlaneViewModel) {
        planeViewModel.planeNode.setMotion(on: bezierPath)
    }
    
    private func drawPlanePath(bezierPath: UIBezierPath, planeViewModel: PlaneViewModel) {
        planeViewModel.pathShape.removeFromSuperlayer()
        planeViewModel.pathShape = CAShapeLayer()
        planeViewModel.pathShape.path = bezierPath.cgPath
        planeViewModel.pathShape.strokeColor = UIColor.darkGray.cgColor
        planeViewModel.pathShape.fillColor = UIColor.clear.cgColor
        planeViewModel.pathShape.lineWidth = 5.0
        planeViewModel.pathShape.opacity = 1.0
        pathsView.layer.addSublayer(planeViewModel.pathShape)
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.0
        fadeOut.duration = 1.0
        fadeOut.autoreverses = false
//                fadeOut.beginTime = 1.0
//                fadeOut.repeatCount = 1.0
        fadeOut.fillMode = .forwards
        fadeOut.isRemovedOnCompletion = false
        planeViewModel.pathShape.add(fadeOut, forKey: "fadeOutAnimation")
    }
}

// MARK: - Game loop methods
extension GameBoardViewController {
    
    private func startGameLoop() {
        stopGameLoop()
        gameLoopTimer = Timer.scheduledTimer(timeInterval: gameLoopInterval, target: self, selector: #selector(gameLoopTimerFired), userInfo: nil, repeats: true)
    }
    
    private func stopGameLoop() {
        gameLoopTimer?.invalidate()
    }
    
    @objc func gameLoopTimerFired() {
//        print("Timer fired!")
        for (index, _) in viewModel.enumerated() {
//            viewModel[index].plane.move()
            guard let path = viewModel[index].plane.path else { return }
            drawPlanePath(bezierPath: path, planeViewModel: viewModel[index])
//            orientToPath(bezierPath: path, planeView: planeView)
//            movePlaneOnPath(bezierPath: path, planeView: planeView)
        }
//
//        checkForCollision()
    }
}

// MARK: - Game mechanics methods
extension GameBoardViewController {

    private func spawnNewPlane() {
        guard let gameScene = gameScene else { return }
        let planeViewModel = gameScene.spawnNewPlane()
        planeViewModel.delegate = self
        viewModel.append(planeViewModel)
    }
}

// MARK: - PlaneNodeDelegate methods
extension GameBoardViewController : PlaneViewModelDelegate {
    
    func didSelect(planeViewModel: PlaneViewModel) {
        startTracingPath(planeViewModel: planeViewModel)
    }
}
