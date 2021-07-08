//
//  TracePathView.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit

protocol TracePathViewDelegate {

    func tracePathCompleted(lineArray: [CGPoint])
    func shouldTrace() -> Bool
}

class TracePathView: UIView {

    // MARK: - Public properties
    var delegate: TracePathViewDelegate? = nil

    // MARK: - Public methods
    func clear() {
        lineArray = [CGPoint]()
    }

    // MARK: - Private properties
    private var lineArray: [CGPoint] = [CGPoint]()
}

// MARK: - UIView methods
extension TracePathView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard delegate?.shouldTrace() == true else { return }
        guard let touch = touches.first else { return }
        let firstPoint = touch.location(in: self)

        clear()
        addPoint(point: firstPoint)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard delegate?.shouldTrace() == true else { return }
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        addPoint(point: currentPoint)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard delegate?.shouldTrace() == true else { return }
        print("Touches ended")
        delegate?.tracePathCompleted(lineArray: lineArray)
        clear()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(inContext: context)
    }
}

// MARK: - Private methods
extension TracePathView {
    
    private func addPoint(point: CGPoint) {
        lineArray.append(point)
    }

    private func draw(inContext context: CGContext) {
        
        context.setLineWidth(5)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineCap(.round)

        guard let firstPoint = lineArray.first else { return }
        context.beginPath()
        context.move(to: firstPoint)

        for point in lineArray.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}
