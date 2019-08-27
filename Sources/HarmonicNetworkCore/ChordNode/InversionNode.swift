//
//  InversionNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

import Pitch

/// A `ChordNode` which is an inverted instance of a `RootPositionNode`.
public struct InversionNode: ChordNode {
    public let label: String
    public let descriptor: ChordDescriptor
}
