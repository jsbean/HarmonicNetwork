//
//  ChordClusterView.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/16/19.
//

// FIXME: Conditional import < Swift 5.0
import Darwin

import DataStructures
import Math
import Pitch
import SpelledPitch
import Geometry

struct ChordClusterView {
    var position: Point
    var label: String
}

struct ChordView {
    var position: Point
    var chord: String
}

typealias ChordClusterViewNode = Tree<ChordClusterView,ChordView>

extension ChordClusterNode {
    func layout(at position: Point = .zero, angle: Angle = .zero, spread: Double)
        -> ChordClusterViewNode
    {
        func traverseToLayout(
            _ node: ChordClusterNode,
            at point: Point,
            angle: Angle,
            spread: Double
        ) -> ChordClusterViewNode {
            switch node {
            case let .leaf(value):
                return .leaf(ChordView(position: point, chord: value))
            case let .branch(label, nodes):
                let clusterView = ChordClusterView(position: point, label: label)
                let pa = pointsAndAngles(
                    count: nodes.count,
                    distance: spread,
                    from: point,
                    at: angle
                )
                let branches = zip(nodes, pa).map { nodePointAndAngle -> ChordClusterViewNode in
                    let (node,(point,angle)) = nodePointAndAngle
                    return traverseToLayout(node, at: point, angle: angle, spread: spread * 0.5)
                }
                return .branch(
                    clusterView,
                    branches
                )
            }
        }
        return traverseToLayout(self, at: position, angle: angle, spread: spread)
    }
}

/// - Returns: An array of points spread equidistantly around the given `centroid`.
func pointsAndAngles(
    count: Int,
    distance: Double,
    from centroid: Point,
    at angle: Angle
) -> [(point: Point, angle: Angle)] {
    precondition(count > 0)
    if count == 1 { return [(point: centroid, angle: angle)] }
    // Clusters with event amounts of nodes start offset by `-1/nodes * .pi`
    // so that baseline is perpendicular to `centroid`
    let angleOffset = count.isMultiple(of: 2) ? Angle(radians: (1 / Double(count)) * .pi) : .zero
    return (0..<count).map { i in
        let position = Double(i) / Double(count)
        let localAngle = Angle(radians: position * 2 * .pi)
        let angle = angle + localAngle + angleOffset
        let localPoint = Point(x: distance * cos(angle.radians), y: distance * sin(angle.radians))
        let point = centroid + localPoint
        return (point: point, angle: angle)
    }
}

// FIXME: Move to dn-m/Graphics/Geometry
extension Angle {
    static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians + rhs.radians)
    }
    static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians - rhs.radians)
    }
}

extension Angle {
    var perpendicular: Angle {
        return Angle(radians: radians + 0.5 * .pi)
    }
}

extension ChordView: Equatable { }
extension ChordClusterView: Equatable { }
