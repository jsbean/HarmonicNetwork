//
//  Ionian.swift
//  HarmonicNetworkCore
//
//  Created by James Bean on 8/24/19.
//

import Pitch

public enum Ionian {
    public static let chordNodes: [ChordNode] = [I, IV, V]
}

extension Ionian {

    // MARK: - Tonic

    // MARK: I

    public static let I = HarmonicFunctionGroupRepresentativeNode(
        label: "I",
        descriptor: .major,
        relatives: [vi],
        inversions: [I6, I64]
    )

    public static let I6 = InversionNode(label: "I6", descriptor: .major)

    // MARK: vi

    public static let vi = RootPositionNode(label: "vi", descriptor: .minor, inversions: [vi6])

    public static let vi6 = InversionNode(
        label: "vi6",
        descriptor: ChordDescriptor.minor.inversion(1)
    )

    public static let I64 = InversionNode(
        label: "I64",
        descriptor: ChordDescriptor.major.inversion(2)
    )
}

extension Ionian {

    // MARK: - Predominant

    // MARK: IV

    public static let IV = HarmonicFunctionGroupRepresentativeNode(
        label: "IV",
        descriptor: .major,
        relatives: [ii],
        inversions: [IV6]
    )

    public static let IV6 = InversionNode(
        label: "IV6",
        descriptor: ChordDescriptor.major.inversion(1)
    )

    // MARK: ii

    public static let ii = RootPositionNode(label: "ii", descriptor: .minor, inversions: [ii6])
    public static let ii6 = InversionNode(
        label: "ii6",
        descriptor: ChordDescriptor.minor.inversion((1))
    )
}

extension Ionian {

    // MARK: - Dominant

    public static let V = HarmonicFunctionGroupRepresentativeNode(
        label: "V",
        descriptor: .major,
        relatives: [iii, viio],
        inversions: [V6]
    )

    public static let V6 = InversionNode(
        label: "V6",
        descriptor: ChordDescriptor.major.inversion(1)
    )

    // MARK: iii

    public static let iii = RootPositionNode(label: "iii", descriptor: .minor, inversions: [])

    // MARK: viio

    public static let viio = RootPositionNode(
        label: "viio",
        descriptor: .diminished,
        inversions: [viio6]
    )

    public static let viio6 = InversionNode(
        label: "viio6",
        descriptor: ChordDescriptor.diminished.inversion(1)
    )
}
