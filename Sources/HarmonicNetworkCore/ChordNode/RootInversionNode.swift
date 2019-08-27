//
//  RootInversionNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

import Pitch

/// A `ChordNode` which can expose inversions.
public struct RootPositionNode: InvertibleNode {
    public let label: String
    public let descriptor: ChordDescriptor
    public let inversions: [InversionNode]
}
