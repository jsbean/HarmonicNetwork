//
//  ChordCluster.swift
//  harmonic-network
//
//  Created by James Bean on 8/16/19.
//

import DataStructures
import Pitch
import SpelledPitch

typealias ChordClusterNode = Tree<(),Chord>

extension ChordClusterNode {
    func printAll() {
        switch self {
        case let .leaf(value):
            print(value)
        case let .branch(_, branches):
            branches.forEach { $0.printAll() }
        }
    }
}

typealias Point = (x: Double, y: Double)

struct ChordClusterView {
    var position: Point
    var radius: Double
}

struct ChordView {
    var chord: SpelledChord
    var position: Point
}

typealias ChordClusterViewNode = Tree<ChordClusterView,ChordView>

extension ChordClusterViewNode {
    func printAll() {
        switch self {
        case let .leaf(chordView):
            dump(chordView)
        case let .branch(clusterView, branches):
            dump(clusterView)
            branches.forEach { $0.printAll() }
        }
    }
}
