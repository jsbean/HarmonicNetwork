//
//  harmonicNetwork.swift
//  Algebra
//
//  Created by James Bean on 8/12/19.
//

import DataStructures

typealias HarmonicNetwork = WeightedDirectedGraph<String,Double>

let harmonicNetwork: HarmonicNetwork = {
    var network = HarmonicNetwork()
    // Hookup tonic
    network.insertEdge(from: "I", to: "IV", weight: 0.5)
    network.insertEdge(from: "I", to: "V", weight: 0.25)
    // Hookup predominant
    network.insertEdge(from: "IV", to: "I", weight: 0.25)
    network.insertEdge(from: "IV", to: "V", weight: 0.75)
    // Hookup dominant
    network.insertEdge(from: "V", to: "I", weight: 1)
    return network
}()
