//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

// Models a guitar string that has been strung and tuned.
@Observable
class TunedString: Equatable, Hashable, Identifiable {
    // None of the other fields is unique across instances
    let id = UUID()
    // 1-based string number
    let number: Int
    // 1-based course number
    let course: Int
    // Length of the string in inches
    var length: Double
    // Pitch to which the string is tuned
    var pitch: Pitch
    // Allowed pitch range for the string
    let validPitches: ClosedRange<Pitch>
    // Type of string being used
    var string: StringChoice
    // Set of strings the player can choose from.
    var validStrings: StringChoices {
        didSet {
            string = validStrings.findClosestMatch(to: string)
        }
    }
    
    // Returns the tension in pounds.
    var tension: Double {

        // Formula for string tension:
        //     T = (f * 2 * L)² * μ / g
        //
        // where
        //     T: Guitar string tension
        //     f: Frequency the string vibrates at
        //     L: Scale length
        //     μ: Linear density or unit weight of the string
        //     g: Gravitational acceleration

        // Gravitational acceleration in inches per second
        let g = 386.08858
        return pow(pitch.frequency * 2.0 * length, 2.0) * string.unitWeight / g
    }

    init(
        number: Int,
        course: Int,
        length: Double,
        pitch: Pitch,
        validPitches: ClosedRange<Pitch>,
        string: StringChoice,
        validStrings: StringChoices
    ) {
        self.number = number
        self.course = course
        self.length = length
        self.pitch = pitch
        self.validPitches = validPitches
        self.string = string
        self.validStrings = validStrings
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(course)
        hasher.combine(length)
        hasher.combine(pitch)
        hasher.combine(string)
    }

    // Equatable
    static func == (lhs: TunedString, rhs: TunedString) -> Bool {
        (lhs.number == rhs.number) &&
        (lhs.course == rhs.course) &&
        (lhs.length == rhs.length) &&
        (lhs.pitch  == rhs.pitch ) &&
        (lhs.string == rhs.string)
    }
}
