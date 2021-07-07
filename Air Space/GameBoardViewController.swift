//
//  GameBoardViewController.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit

class GameBoardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var tracePathView: TracePathView!

    // MARK: - IBActions
    @IBAction func buttonLongPressed(_ sender: UILongPressGestureRecognizer) {
        print("Button long pressed")
        if (!isTracingPath) {
            startTracingPath()
        }
    }
    
    // MARK: - Private properties
    private var isTracingPath = false
}

// MARK: - UIViewController methods
extension GameBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        longPressGestureRecognizer.delegate = self
        tracePathView.backgroundColor = UIColor.clear
        tracePathView.delegate = self
        longPressGestureRecognizer.cancelsTouchesInView = false
//        longPressGestureRecognizer.delegate = self
//
//        view.addSubview(tracePathView)
//        tracePathView.translatesAutoresizingMaskIntoConstraints = false
//        tracePathView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        tracePathView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        tracePathView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        tracePathView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        tracePathView.delegate = self
//        tracePathView.isUserInteractionEnabled = true
    }
}

//// MARK: - UIGestureRecognizerDelegate
//extension GameBoardViewController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
////        print("shouldReceiveTouch: \(!isTracingPath)")
////        return !isTracingPath
//        return false
//    }
//}

// MARK: - TracePathViewDelegate methods
extension GameBoardViewController: TracePathViewDelegate {
    
    func tracePathCompleted(lineArray: [CGPoint]) {
        stopTracingPath()
    }
    
    func shouldTrace() -> Bool {
        print("isTracingPath: \(isTracingPath)")
        return isTracingPath
    }
}

// MARK: - Private methods
extension GameBoardViewController {
    
    private func startTracingPath() {
        print("Start tracing")
        isTracingPath = true
//        longPressGestureRecognizer.isEnabled = false
//        view.addSubview(tracePathView)
//        tracePathView.translatesAutoresizingMaskIntoConstraints = false
//        tracePathView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        tracePathView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        tracePathView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        tracePathView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        tracePathView.delegate = self
//        tracePathView.isUserInteractionEnabled = true
    }
    
    private func stopTracingPath() {
        print("Stop tracing")
        isTracingPath = false
//        longPressGestureRecognizer.isEnabled = true
//        tracePathView.delegate = nil
//        tracePathView.removeFromSuperview()
//        tracePathView.clear()
    }
}
