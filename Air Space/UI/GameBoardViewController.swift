//
//  GameBoardViewController.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit

class GameBoardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tracePathView: TracePathView!
    @IBOutlet weak var planesView: UIView!
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
    private var gameLoopTimer: Timer? = nil
    private var gameLoopInterval = 0.3
}

// MARK: - UIViewController methods
extension GameBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tracePathView.delegate = self
    }
}

// MARK: - TracePathViewDelegate methods
extension GameBoardViewController: TracePathViewDelegate {
    
    func tracePathCompleted(bezierPath: UIBezierPath, planeView: UIButton) {
        stopTracingPath(planeView: planeView)
        resetPlanePath(bezierPath: bezierPath, planeView: planeView)
        drawPlanePath(bezierPath: bezierPath, planeView: planeView)
        orientToPath(bezierPath: bezierPath, planeView: planeView)
    }

    func shouldTrace() -> Bool {
        return isTracingPath
    }
}

// MARK: - UICollisionDelegate methods
extension GameBoardViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print("Collision detected")
    }
}

// MARK: - Tracing and path methods
extension GameBoardViewController {
    
    private func startTracingPath(planeView: UIButton) {
        guard !isTracingPath else { return }
        print("Start tracing")
        planeView.isSelected = true
        isTracingPath = true
        tracePathView.start(planeView: planeView)
        tracePathView.isHidden = false
        isGameLoopRunning = false
    }
    
    private func stopTracingPath(planeView: UIButton) {
        guard isTracingPath else { return }
        print("Stop tracing")
        planeView.isSelected = false
        isTracingPath = false
        tracePathView.isHidden = true
        isGameLoopRunning = true
    }

    private func resetPlanePath(bezierPath: UIBezierPath, planeView: UIButton) {
        for (index, planeViewModel) in viewModel.enumerated() {
            if planeViewModel.planeButton == planeView {
                viewModel[index].plane.resetPath()
                break
            }
        }
    }
    
    private func drawPlanePath(bezierPath: UIBezierPath, planeView: UIButton) {
        for (index, planeViewModel) in viewModel.enumerated() {
            if planeViewModel.planeButton == planeView {
                viewModel[index].planeButton = planeView
                viewModel[index].pathShape.removeFromSuperlayer()
                viewModel[index].pathShape = CAShapeLayer()
                viewModel[index].pathShape.path = bezierPath.cgPath
                viewModel[index].pathShape.strokeColor = UIColor.darkGray.cgColor
                viewModel[index].pathShape.fillColor = UIColor.clear.cgColor
                viewModel[index].pathShape.lineWidth = 5.0
                viewModel[index].pathShape.strokeStart = viewModel[index].plane.percentageComplete
                viewModel[index].pathShape.strokeEnd = 1.0
                pathsView.layer.addSublayer(viewModel[index].pathShape)
                break
            }
        }
    }
    
    private func orientToPath(bezierPath: UIBezierPath, planeView: UIButton) {
        for (index, planeViewModel) in viewModel.enumerated() {
            if planeViewModel.planeButton == planeView {
                viewModel[index].plane.path = bezierPath
                let rotation = viewModel[index].plane.headingInRadians()
                UIView.animate(withDuration: gameLoopInterval, delay: 0, options: [.allowUserInteraction, .curveLinear]) {
                    planeView.transform = CGAffineTransform(rotationAngle: rotation)
                }
//                print("Rotating to \(rotation) radians")
                break
            }
        }
    }
    
    private func movePlaneOnPath(bezierPath: UIBezierPath, planeView: UIButton) {
        for (index, planeViewModel) in viewModel.enumerated() {
            if planeViewModel.planeButton == planeView {
                let centrePosition = viewModel[index].plane.centrePosition
                UIView.animate(withDuration: gameLoopInterval, delay: 0, options: [.allowUserInteraction, .curveLinear]) {
                    planeView.center = centrePosition
                }
                break
            }
        }
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
        for (index, planeViewModel) in viewModel.enumerated() {
            viewModel[index].plane.move()
            guard let path = viewModel[index].plane.path, let planeView = planeViewModel.planeButton else { return }
            drawPlanePath(bezierPath: path, planeView: planeView)
            orientToPath(bezierPath: path, planeView: planeView)
            movePlaneOnPath(bezierPath: path, planeView: planeView)
        }
        
        checkForCollision()
    }
    
    private func checkForCollision() {
        guard viewModel.count > 1 else { return }
        for firstIndex in 0 ..< viewModel.count - 1 {
            for secondIndex in 1 ..< viewModel.count {
                if let firstPlaneFrame = viewModel[firstIndex].planeButton?.frame, let secondPlaneFrame = viewModel[secondIndex].planeButton?.frame {
                    if firstPlaneFrame.intersects(secondPlaneFrame) {
                        print("Collision detected")
                        viewModel[firstIndex].collided = true
                        viewModel[secondIndex].collided = true
                        stopGameLoop()
                    }
                }
            }
        }
    }
}

// MARK: - Game mechanics methods
extension GameBoardViewController {
    
    private func spawnNewPlane() {
        let planeButton = UIButton()
        planeButton.addTarget(self, action: #selector(planeTapped(sender:)), for: .touchUpInside)

        var planeViewModel = PlaneViewModel()
        planeViewModel.planeButton = planeButton
        planeViewModel.collided = false

        let plane = Plane(initialPosition: getRandomPlaneStartPosition())
        planeViewModel.plane = plane

        planesView.addSubview(planeButton)
        planeButton.center = plane.centrePosition
        planeButton.frame.size = CGSize(width: PlaneViewModel.width, height: PlaneViewModel.height)
        
        viewModel.append(planeViewModel)
    }

    @objc func planeTapped(sender: UIButton) {
        print("Button tapped")
        startTracingPath(planeView: sender)
    }

    private func getRandomPlaneStartPosition() -> CGPoint {
        let topSafeArea = view.frame.origin.y + view.safeAreaInsets.top
        let bottomSafeArea = view.frame.origin.y + view.frame.size.height - view.safeAreaInsets.bottom
        let leftSafeArea = view.frame.origin.x + view.safeAreaInsets.left
        let rightSafeArea = view.frame.origin.x + view.frame.size.width - view.safeAreaInsets.right
        let minimumX = leftSafeArea + PlaneViewModel.width / 2.0
        let maximumX = rightSafeArea - PlaneViewModel.width / 2.0
//        print("minimumX: \(minimumX), maximumX: \(maximumX)")
        let xCoord = CGFloat.random(in: minimumX ... maximumX)
        let minimumY = topSafeArea + PlaneViewModel.height / 2.0
        let maximumY = bottomSafeArea - PlaneViewModel.height / 2.0
//        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
//        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }
}
