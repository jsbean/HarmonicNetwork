//
//  ChordClusterViewTests.swift
//  HarmonicNetworkCoreTests
//
//  Created by James Bean on 8/16/19.
//

import Darwin
import XCTest
import DataStructures
import Pitch
import SpelledPitch
import Geometry
@testable import HarmonicNetworkCore

class ChordClusterViewTests: XCTestCase {

    func testPerpendicularAngle() {
        let angle = Angle(degrees: 90)
        let result = angle.perpendicular
        let expected = Angle(degrees: 180)
        XCTAssertEqual(result, expected)
    }

    func testPointsFromCentroidSinglePoint() {
        let centroid = Point(x: 100, y: 100)
        let result = pointsAndAngles(count: 1, distance: 100, from: centroid, at: Angle(degrees: 30))
        XCTAssertEqual(result.map { $0.point }, [centroid])
    }

    ///        (0,0)
    ///    • ----x---- •
    /// (-100,0)    (100,0)
    func testTwoPointsFromCentroidAtZeroAngle() {
        let distance: Double = 100
        let result = pointsAndAngles(count: 2, distance: distance, from: .zero, at: .zero)
        let expected = [Point(x: 100, y: 0), Point(x: -100, y: 0)]
        zip(result.map { $0.point },expected).forEach { result, expected in
            XCTAssertEqual(result.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(result.y, expected.y, accuracy: 0.000001)
        }
    }

    ///   • (0,100)
    ///   |
    ///   x (0,0)
    ///   |
    ///   • (0,-100)
    func testTwoPointsFromCentroidAt90DegreeAngle() {
        let distance: Double = 100
        let result = pointsAndAngles(count: 2, distance: distance, from: .zero, at: Angle(degrees: 90))
        let expected = [Point(x: 0, y: 100), Point(x: 0, y: -100)]
        zip(result.map { $0.point },expected).forEach { result, expected in
            XCTAssertEqual(result.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(result.y, expected.y, accuracy: 0.000001)
        }
    }

    /// A single node should be layed out at exactly Point.zero
    func testLayoutSingle() {
        let chordCluster: ChordClusterNode = .leaf("I")
        let result = chordCluster.layout(spread: 100)
        let expected: ChordClusterViewNode = .leaf(ChordView(position: .zero, chord: "I"))
        XCTAssertEqual(result, expected)
    }

    func testLayoutTonicDominant() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .leaf("I"),
            .leaf("V"),
        ])
        let result = chordCluster.layout(spread: 100)
        let expected = [
            ChordView(position: Point(x: 100, y: 0), chord: "I"),
            ChordView(position: Point(x: -100, y: 0), chord: "V")
        ]
        zip(result.leaves, expected).forEach { result, expected in
            XCTAssertEqual(result.position.x, expected.position.x, accuracy: 0.000001)
            XCTAssertEqual(result.position.y, expected.position.y, accuracy: 0.000001)
        }
    }

    func testLayoutTonicDominantVertical() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .leaf("I"),
            .leaf("V"),
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        let expected = [
            ChordView(position: Point(x: 0, y: 100), chord: "I"),
            ChordView(position: Point(x: 0, y: -100), chord: "V")
        ]
        zip(result.leaves, expected).forEach { result, expected in
            XCTAssertEqual(result.position.x, expected.position.x, accuracy: 0.000001)
            XCTAssertEqual(result.position.y, expected.position.y, accuracy: 0.000001)
        }
    }

    func testLayoutTonicPredominantDominantVertical() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .leaf("I"),
            .leaf("IV"),
            .leaf("V"),
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0)}
    }

    func testLayoutTonicTwoPredominantDominantVertical() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .leaf("I"),
            .leaf("ii"),
            .leaf("IV"),
            .leaf("V"),
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0)}
    }

    func testLayoutTwoPairs() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .leaf("I"),
                .leaf("I6")
            ]),
            .branch("Dominant", [
                .leaf("V"),
                .leaf("V6"),
            ])
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0)}
    }

    func testLayoutThreePairs() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .leaf("I"),
                .leaf("I6")
            ]),
            .branch("Tonic", [
                .leaf("ii"),
                .leaf("IV")
            ]),
            .branch("Dominant", [
                .leaf("V"),
                .leaf("V6"),
            ])
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0)}
    }

    func testLayoutThreeTrios() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .leaf("I"),
                .leaf("I6"),
                .leaf("I64"),
            ]),
            .branch("Tonic", [
                .leaf("ii"),
                .leaf("ii6"),
                .leaf("IV")
            ]),
            .branch("Dominant", [
                .leaf("V"),
                .leaf("V7"),
                .leaf("V6"),
            ])
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0)}
    }

    func testLayoutMoreComplicated() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .leaf("I"),
                .leaf("I6")
            ]),
            .branch("Predominant", [
                .leaf("IV"),
                .leaf("IV6"),
                .leaf("ii"),
                .leaf("ii6"),
            ]),
            .branch("Dominant", [
                 .leaf("V"),
                 .leaf("V6"),
                 .leaf("viio")
            ])
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 100)
        result.leaves.map { $0.position }.forEach { print($0) }
    }

    func testLayoutMultiNested() {
        let chordCluster: ChordClusterNode = .branch("Root", [
            .branch("Tonic", [
                .leaf("I"),
                .leaf("I6"),
                .leaf("vi"),
                .leaf("vi6"),
                .leaf("vi7")
            ]),
            .branch("Predominant", [
                .branch("IV", [
                    .leaf("IV"),
                    .leaf("IV6"),
                ]),
                .branch("ii", [
                    .leaf("ii"),
                    .leaf("ii6"),
                ])
            ]),
            .branch("Dominant", [
                .branch("V", [
                    .leaf("V"),
                    .leaf("V6"),
                ]),
                .branch("vii", [
                    .leaf("viio"),
                    .leaf("viio7"),
                    .leaf("viio43"),
                ])
            ])
        ])
        let result = chordCluster.layout(angle: Angle(degrees: 90), spread: 50)
        result.leaves.forEach { print($0) }
    }
}
