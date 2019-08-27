//
//  HarmonicFunctionGroupRepresentativeNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

import Pitch
import Algebra

/// A `ChordNode` which can expose relatives and inversions.
public struct HarmonicFunctionGroupRepresentativeNode: RelatableNode, InvertibleNode {
    public var label: String
    public let descriptor: ChordDescriptor
    public let relatives: [RootPositionNode]
    public let inversions: [InversionNode]
}