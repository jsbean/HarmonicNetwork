import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)

var chord = bachMajor.nodes.randomElement()!
console.print("Let's start with \(chord)")
while true {
    chord = console.choose("Where to, next?",
        from: Array(bachMajor.neighbors(of: chord)),
        display: { next in
            ConsoleText(stringLiteral: "\(next): \(bachMajor.weight(from: chord, to: next)!)")
        }
    )
    console.print(chord)
}
