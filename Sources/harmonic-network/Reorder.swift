//
//  Reorder.swift
//  harmonic-network
//
//  Created by James Bean on 8/14/19.
//

extension Collection where Element: Equatable {
    /// - Returns: The contents of `self` reordered by the given `preferredOrder`.
    /// - Warning: This is accidentally quadratic. If for some reason performance ever becomes an
    ///         issue here (if we have like a million chords all of a sudden), consider implementing
    ///         this in a more performant manner using a dictionary to store indices.
    func reordered(by preferredOrder: [Element]) -> [Element] {
        return sorted { (a, b) -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else { return false }
            guard let second = preferredOrder.firstIndex(of: b) else { return true }
            return first < second
        }
    }
}

/// The preferred ordering of roman numeral chord names.
///
/// - Note: This must be updated when more chords are added.
let orderedRomanNumerals = [
    "I",
    "I6",
    "ii",
    "ii6",
    "iii",
    "IV",
    "IV6",
    "V",
    "V6",
    "I64",
    "vi",
    "vi6",
    "vii",
    "vii6"
]
