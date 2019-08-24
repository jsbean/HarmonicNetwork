//
//  ChordNodeNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

import Pitch

/// A node representing a chord descriptor.
public protocol ChordNode {
    // TODO: Change to `HarmonicFunction.Descriptor`
    var label: String { get }
    var descriptor: ChordDescriptor { get }
}
