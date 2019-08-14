import DataStructures
import ConsoleKit

struct MakePath: Command {

    struct Signature: CommandSignature {
        @Flag(short: "o", help: "Stop once you have reached I (Tonic) again")
        var oneshot: Bool
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
            // Always ensure there is at least one chord in the path ("I")
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
            let neighbors = bachMajor.neighbors(of: current).reordered(by: orderedRomanNumerals)
            let options = neighbors + undoRedoOptions + ["done"]
            let optionsWidth = options.map { $0.count }.max()!
            let selection = console.choose("What's next?", from: options, display: { option in
                switch option {
                case "undo":
                    return option.consoleText(color: .red, isBold: true)
                case "redo":
                    return option.consoleText(color: .red, isBold: true)
                case "done":
                    return option.consoleText(color: .green, isBold: true)
                default:
                    let weight = bachMajor.weight(from: current, to: option)!
                    let percentage = Int(weight * 100)
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
                console.print("All done: \(path)")
                return
            default:
                path.push(selection)
                redo = []
                if signature.oneshot == true && selection == "I" {
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
config.use(MakePath(), as: "find-path", isDefault: false)

do {
    let commands = try config.resolve()
        .group(help: "\"It's all connected.\"")
    try console.run(commands, input: input)
} catch {
    print("Something went horribly wrong. Forgive me. Forgive yourself. Try again? Or just move on.")
}
