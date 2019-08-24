//
//  Ionian.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

public enum Ionian {
    public static let chordNodes: [ChordNode] = [I, IV, V]
}

extension Ionian {

    // MARK: - Tonic

    // MARK: I

    public static let I = HarmonicFunctionGroupRepresentativeNode(
        label: "I",
        relatives: [vi],
        inversions: [I6]
    )

    public static let I6 = InversionNode(label: "I6")

    // MARK: vi

    public static let vi = RootPositionNode(label: "vi", inversions: [vi6])
    public static let vi6 = InversionNode(label: "vi6")
}

extension Ionian {

    // MARK: - Predominant

    // MARK: IV

    public static let IV = HarmonicFunctionGroupRepresentativeNode(
        label: "IV",
        relatives: [ii],
        inversions: [IV6]
    )

    public static let IV6 = InversionNode(label: "IV6")

    // MARK: ii

    public static let ii = RootPositionNode(label: "ii", inversions: [ii6])
    public static let ii6 = InversionNode(label: "ii6")
}

extension Ionian {

    // MARK: - Dominant

    public static let V = HarmonicFunctionGroupRepresentativeNode(
        label: "V",
        relatives: [iii, viio],
        inversions: [V6]
    )

    public static let V6 = InversionNode(label: "V6")
    public static let V64 = InversionNode(label: "V64")

    // MARK: iii

    public static let iii = RootPositionNode(label: "iii", inversions: [])

    // MARK: viio

    public static let viio = RootPositionNode(label: "viio", inversions: [viio6])
    public static let viio6 = InversionNode(label: "viio6")
}
