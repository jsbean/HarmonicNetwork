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

    router.post([SelectedChord].self, at: "webview") { request, path -> WebViewModel in

        // TODO: Make path a Stack

        let path = path.map { $0.label }
        let current = path.last!

        // Layout the nodes by how they are organized hierarchically
        // TODO: Add style(inout node: ChordNodeView) closure
        let laidOut = ExampleGraph.firstInversions
            .layout(at: Point(x: 200, y: 200), angle: Angle(degrees: -90), spread: 100)
            .leaves
            .map { chordNodeView -> ChordNodeView in
                // Apply default styling
                var chordNodeView = ChordNodeView(
                    label: chordNodeView.label,
                    position: chordNodeView.position,
                    radius: chordNodeView.radius,
                    textColor: .white,
                    fillColor: .lightGray,
                    strokeColor: .black
                )
                if bachMajor.neighbors(of: current).contains(chordNodeView.label) {
                    chordNodeView.strokeColor = .red
                }
                if path.contains(chordNodeView.label) {
                    chordNodeView.fillColor = .black
                }
                if path.last == chordNodeView.label {
                    chordNodeView.fillColor = .red
                }
                return chordNodeView
            }

        var edges: [EdgeView] = []
        for node in laidOut {
            for neighborLabel in bachMajor.neighbors(of: node.label) {
                // FIXME: Form intersection upstream
                let allowed = laidOut.map { $0.label }
                guard allowed.contains(neighborLabel) else { continue }
                let neighbor = laidOut.first { $0.label == neighborLabel }!
                // FIXME: Move to dn-m/Geometry
                let dx = neighbor.position.x - node.position.x
                let dy = neighbor.position.y - node.position.y
                let angle = Angle(radians: atan2(dy, dx))
                let lineEnd = neighbor.position.point(at: -neighbor.radius, angle: angle)
                let edgeView = EdgeView(
                    source: node.position,
                    destination: lineEnd,
                    strokeWidth: 3,
                    color: .lightGray
                )
                edges.append(edgeView)
            }
        }
        let viewModel = WebViewModel(nodes: laidOut, edges: edges)
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
            .branch((), [
                .leaf("I"),
            ]),
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
                .leaf("IV"),
                .leaf("IV6"),
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
