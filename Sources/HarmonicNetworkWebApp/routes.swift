import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
//    router.get { req -> Future<View> in
//        return Chord.query(on: req).all().flatMap(to: View.self) { chords in
//            let nodes = chords.map { chord in
//                NodeView(
//                    id: chord.id,
//                    label: chord.label,
//                    function: chord.function,
//                    x: Double.random(in: 100..<700),
//                    y: Double.random(in: 100..<700)
//                )
//            }
//            return try req.view().render("home", ["nodes": nodes])
//        }
//    }
//
//    router.post(Chord.self, at: "add") { req, chord -> Future<Response> in
//        return chord.save(on: req).map(to: Response.self) { chord in
//            dump(chord)
//
//            return req.redirect(to: "/")
//        }
//    }
}

