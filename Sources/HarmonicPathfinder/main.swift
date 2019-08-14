import DataStructures
import ConsoleKit

final class MakePath: Command {
    struct Signature: CommandSignature {
        @Option(short: "o", help: "One shot: Stop once you have reached I (Tonic) again")
        var oneShot: Bool
        init() { }
    }

    var help: String {
        "Find your way through a network of harmony!"
    }

    func run(using context: CommandContext, signature: Signature) throws {
        var path: Stack<String> = []
        var redo: Stack<String> = []
        var undoRedoOptions: [String] {
            var result: [String] = []
            if path.count > 1 { result.append("undo") }
            if redo.count > 0 { result.append("redo") }
            return result
        }
        path.push("I")
        console.print("Let's start on the Tonic: \(path)")
        while true {
            // Invariant: There is always at least one element in the `path`.
            // (as guarded by the undo / redo interface)
            let current = path.top!
            let neighbors = bachMajor.neighbors(of: current)
            let options = Array(neighbors) + undoRedoOptions
            let selection = console.choose("What's next?", from: options, display: { option in
                switch option {
                case "undo", "redo":
                    return option.consoleText()
                default:
                    return ConsoleText(
                        stringLiteral: "\(option): \(bachMajor.weight(from: current, to: option)!)"
                    )
                }
            })
            switch selection {
            case "undo":
                path.pop().map { redo.push($0) }
            case "redo":
                redo.pop().map { path.push($0) }
            default:
                path.push(selection)
                redo = []
                if signature.oneShot == true && selection == "I" {
                    console.print("We are done here: \(path)")
                    return
                }
            }
            console.print("Harmonic Path: \(path)")
        }
    }
}

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var config = CommandConfiguration()
config.use(MakePath(), as: "makepath", isDefault: true)

do {
    let commands = try config.resolve()
        .group(help: "Find your way through a network of harmony!")
    try console.run(commands, input: input)
} catch {
    print("Something went horribly wrong. Forgive me and forgive yourself. It will be ok.")
}
