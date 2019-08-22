//
//  EdgeView.swift
//  HarmonicNetworkWebApp
//
//  Created by James Bean on 8/21/19.
//

import Geometry
import Rendering

public struct EdgeView {
    // TODO: Bézier
    var source: Point
    var destination: Point
    var style: Style
}

extension EdgeView {
    struct Style {
        var strokeWidth: Double
        var color: Color
    }
}

extension EdgeView.Style {
    static var `default`: EdgeView.Style {
        return EdgeView.Style(
            strokeWidth: 1,
            color: .lightGray
        )
    }
}

extension EdgeView.Style: Codable { }
extension EdgeView: Codable { }
