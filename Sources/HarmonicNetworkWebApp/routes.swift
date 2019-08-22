import DataStructures
import Geometry
import Rendering
import Routing
import Vapor
import HarmonicNetworkCore

// FIXME: Put things in the right place
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { request in
        return try request.view().render("home")
    }

    struct SelectedChord: Content {
        let label: String
    }

    struct WeightedChordNode: Content {
        let label: String
        let weight: Double
    }

    // Neighbor View request
    router.post(SelectedChord.self, at: "neighbors") { request, value -> [WeightedChordNode] in
        let selected = value.label
        let neighbors = bachMajor.neighbors(of: selected)
        let factor = 1 / neighbors.map { bachMajor.weight(from: selected, to: $0)! }.sum
        return neighbors
            .reordered(by: orderedRomanNumerals)
            .map { neighbor in
                let weight = bachMajor.weight(from: selected, to: neighbor)! * factor
                return WeightedChordNode(label: neighbor, weight: weight)
            }
    }

    // Web View request
    router.post([SelectedChord].self, at: "webview") { request, path -> WebViewModel in

        // TODO: Make path a Stack

        let path = path.map { $0.label }
        let selected = path.last!
        let neighborsOfSelected = bachMajor.neighbors(of: selected)

        // Layout the nodes by how they are organized hierarchically
        // TODO: Add style(inout node: ChordNodeView) closure
        let positionedNodes = ExampleGraph.full
            .layout(at: Point(x: 200, y: 200), angle: Angle(degrees: -90), spread: 125)
            .leaves

        let styledNodes = positionedNodes.map { node -> ChordNodeView in
            var node = node
            // Nodes on the path
            if path.contains(node.label) {
                if node.label == selected {
                    // Path Head
                    node.style.fillColor = .salmon
                    node.style.strokeColor = .salmon
                } else {
                    // Path Tail
                    node.style.fillColor = .dimGray
                    node.style.strokeColor = .black
                }
            }
            // Neighbor nodes
            if neighborsOfSelected.contains(node.label) {
                node.style.strokeColor = .salmon
                node.isSelectable = true
            }

            if !path.contains(node.label) && !neighborsOfSelected.contains(node.label) {
                let color = node.style.fillColor
                // TODO: Make Color properties vars
                // Or, add Color.withOpacity(...) -> Color
                node.style.fillColor = Color(
                    red: color.red,
                    green: color.green,
                    blue: color.blue,
                    alpha: 0.25
                )
            }

            // Otherwise, leave alone

            return node
        }

        // FIXME: Encapsulate
        // Create edges
        var edges: [EdgeView] = []
        for node in positionedNodes {
            let localNeighbors = bachMajor.neighbors(of: node.label)
            let maxWeight = localNeighbors.map { bachMajor.weight(from: node.label, to: $0)! }.max()!
            for neighborLabel in localNeighbors {
                // FIXME: Form intersection upstream
                let allowed = positionedNodes.map { $0.label }
                guard allowed.contains(neighborLabel) else { continue }
                let neighbor = positionedNodes.first { $0.label == neighborLabel }!
                // Connected edge to boundary of neighbor node
                // FIXME: Move to dn-m/Geometry
                let dx = neighbor.position.x - node.position.x
                let dy = neighbor.position.y - node.position.y
                let angle = Angle(radians: atan2(dy, dx))
                let lineEnd = neighbor.position.point(at: -neighbor.radius, angle: angle)
                let weight = bachMajor
                    .weight(from: node.label, to: neighborLabel)!
                    .scaled(from: 0...maxWeight, to: 0...1)
                // If edge is not emanating from head of the path, dim it out (you can't go there!)
                let opacity = node.label == selected ? 1 : 0.05
                var color = Color(white: 1 - weight, alpha: opacity)
                var lineWidth = 1.0
                // FIXME: Encapsulate
                var pathContainsEdge = false
                for (a,b) in path.pairs {
                    if a == node.label && b == neighborLabel {
                        pathContainsEdge = true
                        break
                    }
                }
                if pathContainsEdge {
                    color = .springGreen
                    lineWidth = 2
                }
                // FIXME: Engineer out magic number for strokeWidth
                let edgeView = EdgeView(
                    source: node.position,
                    destination: lineEnd,
                    style: EdgeView.Style(strokeWidth: lineWidth, color: color)
                )
                edges.append(edgeView)
            }
        }

        let viewModel = WebViewModel(nodes: styledNodes, edges: edges)
        return viewModel
    }
}

extension ChordNodeView: Content { }
extension EdgeView: Content { }
extension WebViewModel: Content { }

enum ExampleGraph {
    static var tonicDominant: ChordClusterNode = .branch((), [
        .leaf("I"),
        .leaf("V"),
    ])

    static var tonicPredominantDominant: ChordClusterNode = .branch((), [
        .leaf("I"),
        .leaf("IV"),
        .leaf("V"),
    ])

    static var firstInversions: ChordClusterNode = .branch((), [
        .branch((), [
            .branch((), [
                .leaf("iii"),
            ]),
            .branch((), [
                .leaf("vi"),
            ]),
            .leaf("I"),
        ]),
        .branch((), [
            .branch((), [
                .leaf("ii"),
            ]),
            .branch((), [
                .leaf("IV"),
            ]),
        ]),
        .branch((), [
            .branch((), [
                .leaf("V"),
            ]),
            .branch((), [
                .leaf("vii"),
            ]),
        ]),
    ])

    static var full: ChordClusterNode = .branch((), [
        .branch((), [
            .branch((), [
                .leaf("iii"),
            ]),
            .branch((), [
                .leaf("vi"),
                .leaf("vi6"),
            ]),
            .branch((), [
                .leaf("I"),
                .leaf("I6"),
                .leaf("I64"),
            ]),
        ]),
        .branch((), [
            .branch((), [
                .leaf("ii"),
                .leaf("ii6"),
            ]),
            .branch((), [
                .leaf("IV6"),
                .leaf("IV"),
            ]),
        ]),
        .branch((), [
            .branch((), [
                .leaf("V"),
                .leaf("V6"),
            ]),
            .branch((), [
                .leaf("vii"),
                .leaf("vii6"),
            ]),
        ]),
    ])
}
