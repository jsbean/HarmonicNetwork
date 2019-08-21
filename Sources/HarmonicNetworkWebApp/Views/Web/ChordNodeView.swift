//
//  ChordNodeView.swift
//  HarmonicNetworkWebApp
//
//  Created by James Bean on 8/21/19.
//

import Geometry
import Rendering

public struct ChordNodeView {
    let label: String
    let position: Point
    let radius: Double
    let textColor: Color
    let fillColor: Color
    let strokeColor: Color
}

extension ChordNodeView: Codable { }
