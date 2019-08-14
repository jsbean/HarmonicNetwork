import DataStructures
import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)

var path: Stack<String> = []

var chord = "I"
path.push(chord)
console.print("Let's start on the Tonic: \(path)")
while true {
    let options = Array(bachMajor.neighbors(of: chord)) + ["undo"]
    let selection = console.choose("What's next?",
        from: options, display: { option in
            if option == "undo" { return option.consoleText() }
            return ConsoleText(
                stringLiteral: "\(option): \(bachMajor.weight(from: chord, to: option)!)"
            )
        }
    )
    if selection == "undo" {
        _ = path.pop()
        console.print("Harmonic Path: \(path)")
    } else {
        chord = selection
        path.push(chord)
        console.print("Harmonic Path: \(path)")
    }
}
