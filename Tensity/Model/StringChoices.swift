//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

extension StringChoice {
    func isBetterMatch(than other: StringChoice, comparedTo gauge: StringChoice) -> Bool {
        if (wound == other.wound) {
            // If they're both wound or plain, choose the closest in size
            abs(self.gauge - gauge.gauge) < abs(other.gauge - gauge.gauge)
        } else {
            // Otherwise, prefer wound-to-wound and plain-to-plain
            self.wound == gauge.wound
        }
    }
}

// The set of strings from which the user can choose.
//
// This is different from StringType because a user may be able to choose from multiple types.
// For example, wound strings are typically paired with plain steel strings for the higher-pitched
// notes.
final class StringChoices:  RandomAccessCollection {
    let baseType: StringType
    private var choices: [StringChoice]

    init(forType type: StringType, data: StringData) {
        self.baseType = type
        self.choices = type.strings
        
        if let includes = type.includes {
            if let includedType = data.findStringType(includes) {
                choices += includedType.strings
            }
        }

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
