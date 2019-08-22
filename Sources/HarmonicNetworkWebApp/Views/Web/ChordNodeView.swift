//
//  ChordNodeView.swift
//  HarmonicNetworkWebApp
//
//  Created by James Bean on 8/21/19.
//

import Geometry
import Rendering

public struct ChordNodeView {

    // MARK: Model

    var label: String

    // MARK: Position and Size

    var position: Point
    var radius: Double

    // MARK: Style

    var style: Style

    // MARK: UI

    var isSelectable: Bool = false
}

extension ChordNodeView {
    struct Style {
        var textColor: Color
        var fillColor: Color
        var strokeColor: Color
    }
}

extension ChordNodeView.Style {
    static var `default`: ChordNodeView.Style {
        return ChordNodeView.Style(
            textColor: .white,
            fillColor: .lightGray,
            strokeColor: .darkGray
        )
    }
}

extension ChordNodeView.Style: Codable { }
extension ChordNodeView: Codable { }
