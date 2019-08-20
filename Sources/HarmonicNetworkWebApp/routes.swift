import Routing
import Vapor
import HarmonicNetworkCore

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
        let probability: String
    }

    router.post(SelectedChord.self, at: "neighbors") { request, value -> [WeightedChordNode] in
        let chord = value.label
        return bachMajor
            .neighbors(of: chord)
            .reordered(by: orderedRomanNumerals)
            .map { other in
                let weight = bachMajor.weight(from: chord, to: other)!
                let probabilityDisplay = "\(Int((weight * 100).rounded()))%"
                return WeightedChordNode(label: other, probability: probabilityDisplay)
            }
    }
}
