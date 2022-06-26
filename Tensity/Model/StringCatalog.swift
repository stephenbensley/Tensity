//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

/// Wraps ``StringData`` to provide useful and efficient query functions.
class StringCatalog {
    private let staticData = StringData.load()
    // Index the individual strings, so we can look them up quickly.
    private var stringsById: [String: GuitarString] = [:]

    init() {
        for type in staticData.stringTypes {
            for string in type.strings {
                stringsById[string.id] = string
            }
        }
    }

    func findString(id: String) -> GuitarString {
        stringsById[id]!
    }

    func defaultStringType(_ guitarType: GuitarType) -> StringType {
        findStringType(id: guitarType.traits.defaultStringType)
    }

    func findStringType(id: String) -> StringType {
        staticData.stringTypes.first(where: { $0.id == id })!
    }

    func validStringTypes(_ guitarType: GuitarType) -> [StringType] {
        staticData.stringTypes.filter { $0.forGuitarType == guitarType }
    }
}
