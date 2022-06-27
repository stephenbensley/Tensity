//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

/// Models a guitar string that has been strung and tuned.
class TunedString: Equatable, Hashable, Identifiable, ObservableObject {
    // 1-based string number
    let number: Int
    // 1-based course number
    let course: Int
    // Length of the string in inches
    @Published var length: Double
    // Pitch to which the string is tuned
    @Published var pitch: Pitch
    // Type of string being used
    @Published var string: StringChoice

    var id: Int {
        return number
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
        string: StringChoice
    ) {
        self.number = number
        self.course = course
        self.length = length
        self.pitch = pitch
        self.string = string
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Equatable
    static func == (lhs: TunedString, rhs: TunedString) -> Bool {
        lhs.id == rhs.id
    }
}
