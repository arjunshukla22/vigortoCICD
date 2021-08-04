//
//  CloseButton.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 23/02/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit

internal class CloseButton: UIButton {

    var iconSize: CGFloat = 10
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.red.withAlphaComponent(1)

    weak var tagView: TagView?

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.lineWidth = lineWidth
        path.lineCapStyle = .round

        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )

        path.move(to: iconFrame.origin)
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.maxY))
        path.move(to: CGPoint(x: iconFrame.maxX, y: iconFrame.minY))
        path.addLine(to: CGPoint(x: iconFrame.minX, y: iconFrame.maxY))

        lineColor.setStroke()

        path.stroke()
    }

}
