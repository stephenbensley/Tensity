import XCTest
@testable import Tensity

class StringDataTests: XCTestCase {
    static var stringData: StringData? = nil

    override class func setUp() {
        stringData = StringData.load()
    }

    override class func tearDown() {
        stringData = nil
    }

    func testAllGuitarTypesPresent() throws {
        guard let stringTypes = Self.stringData?.stringTypes else {
            return
        }

        for type in GuitarType.allCases {
            let typeCount = stringTypes.filter { $0.forGuitarType == type }.count
            XCTAssertGreaterThan(
                typeCount,
                0,
                "There are no string types defined for \(type.description) guitar."
            )
        }
    }

    func testNoTypeEmpty() throws {
        guard let stringTypes = Self.stringData?.stringTypes else {
            return
        }

        for type in stringTypes {
            XCTAssertGreaterThan(type.strings.count, 0, "String type \(type.id) has no strings.")
        }
    }

    func testNoDanglingIncludes() throws {
        guard let stringTypes = Self.stringData?.stringTypes else {
            return
        }

        for type in stringTypes {
            if let includes = type.includes {
                XCTAssert(
                    stringTypes.contains { $0.id == includes },
                    "String type \(type.id) includes unknown type \(includes)"
                )
            }
        }
    }

    func testNoDuplicateStringTypes() throws {
        guard let stringTypes = Self.stringData?.stringTypes else {
            return
        }

        var seen = Set<String>()
        for type in stringTypes {
            XCTAssert(!seen.contains(type.id), "Duplicate string type \(type.id)")
            seen.insert(type.id)
        }
    }

    func testNoDuplicateStringIds() throws {
        guard let stringTypes = Self.stringData?.stringTypes else {
            return
        }

        var seen = Set<String>()
        for type in stringTypes {
            for string in type.strings {
                XCTAssert(!seen.contains(string.id), "Duplicate string ID \(string.id)")
                seen.insert(string.id)
            }
        }
    }
}
