import DataStructures

typealias HarmonicNetwork = WeightedDirectedGraph<String,Double>
var network = HarmonicNetwork()
// Hookup tonic
network.insertEdge(from: "I", to: "IV", weight: 0.5)
network.insertEdge(from: "I", to: "V", weight: 0.25)
// Hookup predominant
network.insertEdge(from: "IV", to: "I", weight: 0.25)
network.insertEdge(from: "IV", to: "V", weight: 0.75)
// Hookup dominant
network.insertEdge(from: "V", to: "I", weight: 1)

func traverse(_ network: HarmonicNetwork, startingAt initial: String, visited: inout Set<String>) {
    print(initial, visited)
    let neighbors = network.neighbors(of: initial)
    let unvisited = neighbors.subtracting(visited)
    guard let firstNeighbor = unvisited.first else { return }
    visited.insert(firstNeighbor)
    traverse(network, startingAt: firstNeighbor, visited: &visited)
}

func main() {
    var visited: Set<String> = []
    traverse(network, startingAt: "I", visited: &visited)
}

main()
