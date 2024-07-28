//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import XCTest
@testable import Tensity

class StringChoicesTests: XCTestCase {
    static var stringData: StringData? = nil

    override class func setUp() {
        stringData = StringData.create()
    }

    override class func tearDown() {
        stringData = nil
    }

    func testNoDuplicateStringDescriptions() throws {
        guard let stringData = Self.stringData else {
            return
        }

        for guitarType in GuitarType.allCases {
            for stringType in stringData.validStringTypes(guitarType) {
                let choices = StringChoices(forType: stringType, data: stringData)
                var seen = Set<String>()
                for choice in choices {
                    XCTAssert(!seen.contains(choice.description), "Duplicate string description for \(stringType.id): \(choice.description)")
                    seen.insert(choice.id)
                }
            }
        }
    }

    func testFindClosestMatch() throws {
        guard let stringData = Self.stringData else {
            return
        }
        let type = stringData.findStringType("NW")!
        let choices = StringChoices(forType: type, data: stringData)

        var match = choices.findClosestMatch(to: StringChoice(0.020, wound: true))
        XCTAssertEqual(match.id, "NW020", "Didn't find exact match.")

        match = choices.findClosestMatch(to: StringChoice(0.058, wound: true))
        XCTAssertEqual(match.id, "NW059", "Didn't find bounded match.")

        match = choices.findClosestMatch(to: StringChoice(0.009, wound: true))
        XCTAssertEqual(match.id, "NW017", "Didn't find lowest match.")

        match = choices.findClosestMatch(to: StringChoice(0.100, wound: true))
        XCTAssertEqual(match.id, "NW080", "Didn't find highest match.")
    }
}
