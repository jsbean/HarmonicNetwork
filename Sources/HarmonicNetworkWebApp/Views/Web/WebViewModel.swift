//
//  WebViewModel.swift
//  HarmonicNetworkWebApp
//
//  Created by James Bean on 8/21/19.
//

// FIXME: Handle with stdlib for 5.1
#if os(Linux)
import Glibc
#else
import Darwin
#endif

import DataStructures
import Geometry

public struct WebViewModel {
    public let nodes: [ChordNodeView]
    public let edges: [EdgeView]
}

typealias ChordClusterNode = Tree<(),String>

extension WebViewModel: Codable { }

// TODO: Color nodes based on:
// - in path
// - neighbor of path.top
extension ChordClusterNode {
    public func layout(at position: Point = .zero, angle: Angle = .zero, spread: Double)
        -> Tree<(),ChordNodeView>
    {
        func traverseToLayout(
            _ node: ChordClusterNode,
            at position: Point,
            angle: Angle,
            spread: Double
        ) -> Tree<(),ChordNodeView> {
            switch node {
            case let .leaf(value):
                return .leaf(
                    ChordNodeView(
                        label: value,
                        position: position,
                        radius: 15,
                        style: .default
                    )
                )
            case let .branch(_, nodes):
                let pa = pointsAndAngles(
                    count: nodes.count,
                    distance: spread,
                    from: position,
                    at: angle
                )
                let branches = zip(nodes, pa).map { nodePointAndAngle -> Tree<(),ChordNodeView> in
                    let (node,pointAndAngle) = nodePointAndAngle
                    let (point,angle) = pointAndAngle
                    return traverseToLayout(node, at: point, angle: angle, spread: spread * 0.5)
                }
                return .branch((), branches)
            }
        }
        return traverseToLayout(self, at: position, angle: angle, spread: spread)
    }
}

/// - Returns: An array of points spread equidistantly around the given `centroid`.
public func pointsAndAngles(
    count: Int,
    distance: Double,
    from centroid: Point,
    at angle: Angle
) -> [(point: Point, angle: Angle)] {
    precondition(count > 0)
    if count == 1 { return [(point: centroid, angle: angle)] }
    // Clusters with even amounts of nodes are offset by `-1/nodes * .pi`
    // so that baseline is perpendicular to `centroid`
    let angleOffset = count.isMultiple(of: 2) ? Angle(radians: (1 / Double(count)) * .pi) : .zero
    return (0..<count).map { i in
        let position = Double(i) / Double(count)
        let localAngle = Angle(radians: position * 2 * .pi)
        let angle = angle + localAngle - angleOffset
        let point = centroid.point(at: distance, angle: angle)
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

    static prefix func - (_ angle: Angle) -> Angle {
        return Angle(radians: -angle.radians)
    }
}

extension Point {
    func point(at distance: Double, angle: Angle) -> Point {
        let result = Point(
            x: self.x + distance * cos(angle.radians),
            y: self.y + distance * sin(angle.radians)
        )
        return result
    }
}
