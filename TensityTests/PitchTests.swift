//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import XCTest
@testable import Tensity

class PitchTests: XCTestCase {
    func testFrequency() throws {
        let middleC = Pitch(.C, 4)
        XCTAssertEqual(middleC.frequency, 261.63, accuracy: 0.05, "Middle C should be 261.63 Hz")

        let A440 = Pitch(.A, 4)
        XCTAssertEqual(A440.frequency, 440.0, accuracy: 0.05, "A440 should be 440.0 Hz")
    }

    func testRange() throws {
        let pianoKeyboard = Pitch(.A, 0)...Pitch(.C, 8)
        XCTAssertEqual(
            pianoKeyboard.count,
            88,
            "Using Pitch to enumerate a piano keyboard should yield 88 notes."
        )
    }
}
