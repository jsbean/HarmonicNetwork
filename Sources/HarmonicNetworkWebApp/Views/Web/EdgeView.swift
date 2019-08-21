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
    let source: Point
    let destination: Point
    let strokeWidth: Double
    let color: Color
}

extension EdgeView: Codable { }
