//
//  ChordNodeView.swift
//  HarmonicNetworkWebApp
//
//  Created by James Bean on 8/21/19.
//

import Geometry
import Rendering

public struct ChordNodeView {
    var label: String
    var position: Point
    var radius: Double
    var textColor: Color
    var fillColor: Color
    var strokeColor: Color
}

extension ChordNodeView: Codable { }
