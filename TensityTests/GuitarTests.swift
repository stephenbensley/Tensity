//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import XCTest
@testable import Tensity

class GuitarTests: XCTestCase {
    func testLoadAllDefaults() throws {
        let guitar = Guitar.create()
        for guitarType in guitar.validGuitarTypes {
            guitar.guitarType = guitarType
            for stringCount in guitar.validStringCounts {
                guitar.stringCount = stringCount
                for stringType in guitar.validStringTypes {
                    guitar.stringType = stringType
                }
            }
        }
    }
}
