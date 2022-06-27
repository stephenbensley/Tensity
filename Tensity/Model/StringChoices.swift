//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

/// The set of strings from which the user can choose.
///
/// Wrapped in a class, so it can be shared across views.
class StringChoices:  RandomAccessCollection {
    private var choices: [StringChoice] = []

    init(forType: StringType, data: StringData) {
        if let includes = forType.includes {
            if let includedType = data.findStringType(id: includes) {
                choices += includedType.strings
            }
        }
        choices += forType.strings

        choices.sort()
    }

    func find(_ stringId: String) -> StringChoice? {
        choices.first { $0.id == stringId }
    }

    func findClosestMatch(to gauge: StringChoice) -> StringChoice {
        assert(!choices.isEmpty)
        // min is guaranteed to exist since the array isn't empty.
        return choices.min(by: { $0.isBetterMatch(than: $1, comparedTo: gauge) })!
    }

    func findClosestMatches(to gauges: [StringChoice]) -> [StringChoice] {
        gauges.map{ findClosestMatch(to: $0) }
    }

    // RandomAccessCollection
    var count: Int { choices.count }
    var startIndex: Int { 0 }
    var endIndex: Int { count }
    subscript(position: Int) -> StringChoice { choices[position] }
}
