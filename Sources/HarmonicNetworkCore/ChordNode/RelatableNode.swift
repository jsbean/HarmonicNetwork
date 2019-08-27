//
//  RelatableNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

/// A `ChordNode` which can expose relatives.
public protocol RelatableNode: ChordNode {
    var relatives: [RootPositionNode] { get }
}
