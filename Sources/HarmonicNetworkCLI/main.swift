import DataStructures
import HarmonicNetworkCore
import Vapor

public let bachMajor: WeightedDirectedGraph<String,Double> = {
    var network = WeightedDirectedGraph<String,Double>()
    // I
    network.insertEdge(from: "I", to: "ii", weight: 0.1)
    network.insertEdge(from: "I", to: "ii6", weight: 0.2)
    network.insertEdge(from: "I", to: "IV", weight: 0.1)
    network.insertEdge(from: "I", to: "IV6", weight: 0.2)
    network.insertEdge(from: "I", to: "V", weight: 0.3)
    network.insertEdge(from: "I", to: "V6", weight: 0.2)
    network.insertEdge(from: "I", to: "vi", weight: 0.1)
    // I6
    network.insertEdge(from: "I6", to: "I", weight: 0.17)
    network.insertEdge(from: "I6", to: "ii", weight: 0.2)
    network.insertEdge(from: "I6", to: "IV", weight: 0.17)
    network.insertEdge(from: "I6", to: "IV6", weight: 0.5)
    // ii
    network.insertEdge(from: "ii", to: "V", weight: 0.6)
    network.insertEdge(from: "ii", to: "V6", weight: 0.1)
    network.insertEdge(from: "ii", to: "vi", weight: 0.1)
    network.insertEdge(from: "ii", to: "vii", weight: 0.1)
    network.insertEdge(from: "ii", to: "vii6", weight: 0.1)
    // ii6
    network.insertEdge(from: "ii6", to: "ii", weight: 0.3)
    network.insertEdge(from: "ii6", to: "V", weight: 0.75)
    // iii
    network.insertEdge(from: "iii", to: "IV", weight: 0.17)
    network.insertEdge(from: "iii", to: "vi", weight: 0.17)
    network.insertEdge(from: "iii", to: "vi6", weight: 0.5)
    // IV
    network.insertEdge(from: "IV", to: "I", weight: 0.17)
    network.insertEdge(from: "IV", to: "IV", weight: 0.17)
    network.insertEdge(from: "IV", to: "V", weight: 0.5)
    network.insertEdge(from: "IV", to: "vii", weight: 0.17)
    // IV6
    network.insertEdge(from: "IV6", to: "I", weight: 0.17)
    network.insertEdge(from: "IV6", to: "V", weight: 0.17)
    network.insertEdge(from: "IV6", to: "V6", weight: 0.3)
    network.insertEdge(from: "IV6", to: "I64", weight: 0.25)
    network.insertEdge(from: "IV6", to: "vi", weight: 0.17)
    // V
    network.insertEdge(from: "V", to: "I", weight: 0.46)
    network.insertEdge(from: "V", to: "I6", weight: 0.22)
    network.insertEdge(from: "V", to: "IV", weight: 0.07)
    network.insertEdge(from: "V", to: "IV6", weight: 0.1)
    network.insertEdge(from: "V", to: "vi", weight: 0.07)
    // V6
    network.insertEdge(from: "V6", to: "I", weight: 0.25)
    network.insertEdge(from: "V6", to: "I64", weight: 0.25)
    network.insertEdge(from: "V6", to: "vi", weight: 0.25)
    network.insertEdge(from: "V6", to: "vii6", weight: 0.3)
    // vi
    network.insertEdge(from: "vi", to: "ii", weight: 0.1)
    network.insertEdge(from: "vi", to: "V", weight: 0.5)
    network.insertEdge(from: "vi", to: "vi6", weight: 0.1)
    network.insertEdge(from: "vi", to: "vii", weight: 0.13)
    // vi6
    network.insertEdge(from: "vi6", to: "ii", weight: 0.1)
    network.insertEdge(from: "vi6", to: "ii6", weight: 0.1)
    network.insertEdge(from: "vi6", to: "iii", weight: 0.63)
    network.insertEdge(from: "vi6", to: "IV6", weight: 0.1)
    // vii
    network.insertEdge(from: "vii", to: "I", weight: 0.17)
    network.insertEdge(from: "vii", to: "ii", weight: 0.2)
    network.insertEdge(from: "vii", to: "iii", weight: 0.25)
    network.insertEdge(from: "vii", to: "I64", weight: 0.25)
    network.insertEdge(from: "vii", to: "vi6", weight: 0.25)
    // I64
    network.insertEdge(from: "I64", to: "I", weight: 0.5)
    network.insertEdge(from: "I64", to: "V", weight: 0.5)
    // vii6
    network.insertEdge(from: "vii6", to: "I64", weight: 1)
    return network
}()


struct FindPath: Command {
    let arguments: [CommandArgument] = []

    var options: [CommandOption] {
        return [
            .flag(
                name: "one-shot",
                short: "o",
                help: ["Stop once you have reached I (Tonic) again"]
            )
        ]
    }

    var help: [String] {
        return ["Find your way through a network of harmony!"]
    }

    func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        var path: Stack<String> = []
        var redo: Stack<String> = []
        var undoRedoOptions: [String] {
            var result: [String] = []
            // Always ensure there is at least one chord in the path ("I")
            if path.count > 1 { result.append("undo") }
            if redo.count > 0 { result.append("redo") }
            return result
        }
        path.push("I")
        context.console.print("Let's start on the Tonic: \(path)")
        while true {
            // Invariant: There is always at least one element in the `path`.
            // (as guarded by the undo / redo interface)
            let current = path.top!
            let neighbors = bachMajor.neighbors(of: current).reordered(by: orderedRomanNumerals)
//            let neighbors: Set<String> = ["I","ii"]
            // Factor to multiply weights by so that percentages sum-to-one
            //let factor = 1 / neighbors.map { bachMajor.weight(from: current, to: $0)! }.sum
            let factor: Double = 1
            let options = neighbors + undoRedoOptions + ["done"]
            let optionsWidth = options.map { $0.count }.max()!
            let selection = context.console.choose("What's next?", from: options, display: { option in
                switch option {
                case "undo":
                    return option.consoleText(color: .red, isBold: true)
                case "redo":
                    return option.consoleText(color: .red, isBold: true)
                case "done":
                    return option.consoleText(color: .green, isBold: true)
                default:
                    return option.consoleText()
//                    let weight = bachMajor.weight(from: current, to: option)!
//                    let percentage = Int((weight * factor * 100).rounded())
//                    let padding = String(repeating: " ", count: optionsWidth - option.count + 2)
//                    return option.consoleText(color: .white, isBold: true)
//                        + padding.consoleText()
//                        + "\(percentage)%".consoleText(color: .white, isBold: false)
                    }
            })
            switch selection {
            case "undo":
                path.pop().map { redo.push($0) }
            case "redo":
                redo.pop().map { path.push($0) }
            case "done":
                context.console.print("All done: \(path)")
                return .done(on: context.container)
            default:
                path.push(selection)
                redo = []
                if context.options["one-shot"] != nil && selection == "I" {
                    context.console.print("We are done here: \(path)")
                    return .done(on: context.container)
                }
            }
            context.console.print("Harmonic Path: \(path)")
        }
    }
}

let container = BasicContainer(
    config: Config(),
    environment: Environment.production,
    services: Services(),
    on: EmbeddedEventLoop()
)

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var config = CommandConfig()
config.use(FindPath(), as: "find-path", isDefault: true)


do {
    let commands = try config.resolve(for: container)
        .group(help: ["\"It's all connected.\""])
    _ = console.run(commands, input: &input, on: container)
} catch {
    print("Something went horribly wrong. Forgive me. Forgive yourself. Try again? Or just move on.")
}
