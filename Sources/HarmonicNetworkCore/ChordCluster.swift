//
//  ChordCluster.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/16/19.
//

import DataStructures
import Pitch
import SpelledPitch

typealias ChordClusterNode = Tree<String,String>

extension ChordClusterNode {
    func printAll() {
        switch self {
        case let .leaf(value):
            print(value)
        case let .branch(value, branches):
            print("\(value):")
            branches.forEach { $0.printAll() }
        }
    }
}
