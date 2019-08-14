import DataStructures
import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)

var path: Stack<String> = []
var redo: Stack<String> = []

var chord = "I"
path.push(chord)
console.print("Let's start on the Tonic: \(path)")
while true {
    let options = Array(bachMajor.neighbors(of: chord)) + ["undo", "redo"]
    let selection = console.choose("What's next?",
        from: options, display: { option in
            switch option {
            case "undo", "redo":
                return option.consoleText()
            default:
                return ConsoleText(
                    stringLiteral: "\(option): \(bachMajor.weight(from: chord, to: option)!)"
                )
            }
        }
    )
    switch selection {
    case "undo":
        path.pop().map { redo.push($0) }
    case "redo":
        redo.pop().map { path.push($0) }
    default:
        chord = selection
        path.push(chord)
    }
    console.print("Harmonic Path: \(path)")
}
