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

    struct ChordNode: Content {
        let label: String
    }

    router.post(ChordNode.self, at: "neighbors") { request, value -> [String] in
        let chord = value.label
        dump("incoming: \(chord)")
        return Array(bachMajor.neighbors(of: chord))
    }

//    router.post(Value.self, at: "add") { request, value -> String in
//        dump(value)
//        return value.neighbor
//    }
}
