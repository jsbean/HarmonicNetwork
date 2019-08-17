import Routing
import Vapor
import HarmonicNetworkCore

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    // Home page: redirect immediately to a path of ["I"]
    router.get { req -> Response in
        return req.redirect(to: "I")
    }

    // Parse the url parameters which should be something like: ["I-ii-V-I"]
    router.get(String.parameter) { req -> Future<View> in
        let pathString = try req.parameters.next(String.self)
        let path = pathString.components(separatedBy: "-")
        struct NeighborInfo: Codable {
            let node: String
            let probability: Double
        }
        struct Info: Codable {
            let path: String
            let current: String
            let neighbors: [NeighborInfo]
        }
        guard let current = path.last else { fatalError() }
        let neighbors = bachMajor.neighbors(of: current).compactMap { neighbor -> NeighborInfo? in
            guard let weight = bachMajor.weight(from: current, to: neighbor) else { return nil }
            return NeighborInfo(node: neighbor, probability: weight)
        }
        let pathDisplay = path.joined(separator: "-")
        let info = Info(path: pathDisplay, current: current, neighbors: neighbors)
        return try req.view().render("home", info)
    }

    router.post("add") { req -> Future<Response> in
        return try req.content.decode([String: String].self).map(to: Response.self) { messageRequest in
            guard let path = messageRequest.keys.first else { fatalError() }
            let pathString = path.components(separatedBy: " ").joined(separator: "-")
            return req.redirect(to: pathString)
        }
    }
}
