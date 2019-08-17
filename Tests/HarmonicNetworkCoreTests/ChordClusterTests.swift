//
//  ChordClusterTests.swift
//  HarmonicNetworkCoreTests
//
//  Created by James Bean on 8/16/19.
//

import Foundation
import XCTest
import DataStructures
import Pitch
import SpelledPitch
@testable import HarmonicNetworkCore

class ChordClusterTests: XCTestCase {

    func testCodable() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try encoder.encode(bachMajor)
        let string = String(data: json, encoding: .utf8)!
        print(string)
    }

    func testTonicDominant() {
        let cluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [.branch("I", [.leaf("I")])]),
            .branch("Dominant", [.branch("V", [.leaf("V")])])
        ])
        cluster.printAll()
    }

    func testChordCluster() {
        let cluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .branch("I", [
                    .leaf("I"),
                    .leaf("I6"),
                    .leaf("I64"),
                ]),
                // relative
                .branch("iii",  [
                    .leaf("iii"),
                    .leaf("iii6"),
                    .leaf("iii7"),
                ]),
                // counter-relative
                .branch("vi", [
                    .leaf("vi"),
                    .leaf("vi6"),
                    .leaf("vi7"),
                ])
            ]),
            .branch("Dominant", [
                .branch("V", [
                    .leaf("V"),
                    .leaf("V7"),
                    .leaf("V6"),
                    .leaf("V65"),
                    .leaf("V43"),
                    .leaf("V42"),
                ]),
                .branch("vii", [
                    .leaf("viio"),
                    .leaf("vii06"),
                    .leaf("vii065"),
                    .leaf("vii043"),
                ])
            ]),
        ])
        cluster.printAll()
    }
}
