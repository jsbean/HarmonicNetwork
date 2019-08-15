import DataStructures
import Console
import Command

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
            // Factor to multiply weights by so that percentages sum-to-one
            let factor = 1 / neighbors.map { bachMajor.weight(from: current, to: $0)! }.sum
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
                    let weight = bachMajor.weight(from: current, to: option)!
                    let percentage = Int((weight * factor * 100).rounded())
                    let padding = String(repeating: " ", count: optionsWidth - option.count + 2)
                    return option.consoleText(color: .white, isBold: true)
                        + padding.consoleText()
                        + "\(percentage)%".consoleText(color: .white, isBold: false)
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
