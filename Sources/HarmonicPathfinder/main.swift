import DataStructures
import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)

var stack: Stack<String> = []

var chord = "I"
console.print("Let's start with \(chord)")
stack.push(chord)
while true {
    chord = console.choose("Where to, next?",
        from: Array(bachMajor.neighbors(of: chord)),
        display: { next in
            ConsoleText(stringLiteral: "\(next): \(bachMajor.weight(from: chord, to: next)!)")
        }
    )
    stack.push(chord)
    console.print("Harmonic Path: \(stack)")
}
