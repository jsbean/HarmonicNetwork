import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)

var chord = harmonicNetwork.nodes.randomElement()!
console.print("Let's start with \(chord)")
while true {
    chord = console.choose("Where to next?", from: Array(harmonicNetwork.neighbors(of: chord)))
    console.print(chord)
}
