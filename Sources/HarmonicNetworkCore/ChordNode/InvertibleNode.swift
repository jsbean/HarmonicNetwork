//
//  InvertibleNode.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

/// A `ChordNode` which can expose inversions.
public protocol InvertibleNode: ChordNode {
    var inversions: [InversionNode] { get }
}
