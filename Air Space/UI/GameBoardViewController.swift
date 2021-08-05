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
    private var planes = [PlaneViewModel]()
    private var beacons = [Beacon]()
    
    // MARK: - Private properties
    private var isTracingPath = false
    private var gameScene: GameScene? = nil
}

// MARK: - UIViewController methods
extension GameBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tracePathView.delegate = self
        isTracingPath = false
        tracePathView.isHidden = true

        gameScene = GameScene()
        gameScene?.isUserInteractionEnabled = true
        gameScene?.gameSceneDelegate = self
        spriteKitView.presentScene(gameScene)
        spriteKitView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameScene?.spawnBeacons()
    }
}

// MARK: - TracePathViewDelegate methods
extension GameBoardViewController: TracePathViewDelegate {
    
    func tracePathCompleted(bezierPath: UIBezierPath, planeViewModel: PlaneViewModel) {
        stopTracingPath(planeViewModel: planeViewModel)
        resetPlanePath(bezierPath: bezierPath, planeViewModel: planeViewModel)
        drawPlanePath(planeViewModel: planeViewModel)
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
    }
    
    private func stopTracingPath(planeViewModel: PlaneViewModel) {
        guard isTracingPath else { return }
        print("Stop tracing")
        planeViewModel.isSelected = false
        isTracingPath = false
        tracePathView.isHidden = true
    }

    private func resetPlanePath(bezierPath: UIBezierPath, planeViewModel: PlaneViewModel) {
        let currentPosition = planeViewModel.planeNode.cartesianCoordinates
        let path = UIBezierPath()
        path.move(to: currentPosition)
        path.append(bezierPath)
        planeViewModel.plane.path = path
        planeViewModel.planeNode.setMotion(on: path)
    }
    
    private func drawPlanePath(planeViewModel: PlaneViewModel) {
        guard let path = planeViewModel.plane.path else { return }
        planeViewModel.pathShape.removeFromSuperlayer()
        planeViewModel.pathShape = CAShapeLayer()
        planeViewModel.pathShape.path = path.cgPath
        planeViewModel.pathShape.strokeColor = UIColor.darkGray.cgColor
        planeViewModel.pathShape.fillColor = UIColor.clear.cgColor
        planeViewModel.pathShape.lineWidth = 5.0
        planeViewModel.pathShape.opacity = 1.0
        pathsView.layer.addSublayer(planeViewModel.pathShape)
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.0
        fadeOut.duration = 2.0
        fadeOut.autoreverses = false
        fadeOut.beginTime = CACurrentMediaTime() + 1.0
        fadeOut.fillMode = .forwards
        fadeOut.isRemovedOnCompletion = false
        planeViewModel.pathShape.add(fadeOut, forKey: "fadeOutAnimation")
    }
}

// MARK: - Game mechanics methods
extension GameBoardViewController {

    private func spawnNewPlane() {
        guard let gameScene = gameScene else { return }
        let planeViewModel = gameScene.spawnNewPlane()
        planeViewModel.delegate = self
        planeViewModel.planeNode.defaultSpeed = planeViewModel.plane.velocity.rawValue
        planes.append(planeViewModel)
    }
    
    private func viewModel(for planeNode: PlaneNode) -> PlaneViewModel? {
        for planeViewModel in planes {
            if planeViewModel.planeNode == planeNode {
                return planeViewModel
            }
        }
        return nil
    }
}

// MARK: - PlaneNodeDelegate methods
extension GameBoardViewController : PlaneViewModelDelegate {
    
    func didSelect(planeViewModel: PlaneViewModel) {
        startTracingPath(planeViewModel: planeViewModel)
    }
}

// MARK: - GameSceneDelegate methods
extension GameBoardViewController : GameSceneDelegate {
    
    func didCollide(gameScene: GameScene, planeA: PlaneNode, planeB: PlaneNode) {
        gameScene.view?.isPaused = true
        if let firstPlaneViewModel = viewModel(for: planeA) {
            firstPlaneViewModel.isCollided = true
        }
        if let secondPlaneViewModel = viewModel(for: planeB) {
            secondPlaneViewModel.isCollided = true
        }
    }
}
