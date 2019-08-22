//
//  BachMajor.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/17/19.
//

import DataStructures

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

