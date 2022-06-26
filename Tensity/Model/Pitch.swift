//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

/// Represents the twelve notes in an octave.
///
/// In scientific pitch notation, the octave starts with C, so it's convenient for C to have a rawValue of zero.
enum PitchClass: Int {
    case C
    case Csharp
    case D
    case Dsharp
    case E
    case F
    case Fsharp
    case G
    case Gsharp
    case A
    case Asharp
    case B

    static let names = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]

    var description: String {
        PitchClass.names[rawValue]
    }
}

/// Represents a musical pitch, which consists of a ``PitchClass`` and an octave.
struct Pitch: Codable, Hashable, Identifiable, Strideable {
    // Pitches are numbered starting from C0
    let id: Int

    static let notesPerOctave = 12
    // In standard pitch, A4 corresponds to 440 Hz
    static let a4 = Pitch(PitchClass.A, 4)
    static let a4Freq = 440.0
    // Amount pitch changes with each semitone.
    static let semitoneMultiplier = pow(2.0, 1.0/12.0)

    init(id: Int) {
        self.id = id
    }
    init(_ pitchClass: PitchClass, _ octave: Int) {
        self.init(id: pitchClass.rawValue + (Pitch.notesPerOctave * octave))
    }

    var pitchClass: PitchClass {
        PitchClass(rawValue: id % Pitch.notesPerOctave)!
    }
    var octave: Int {
        id / Pitch.notesPerOctave
    }
    var description: String {
        assert((0...9).contains(octave))
        // Scalar for Unicode subscript zero (₀)
        let subscriptZero = 0x2080
        return pitchClass.description + String(Character(UnicodeScalar(subscriptZero + octave)!))
    }
    var frequency: Double {
        // Multiply A440 based on the number of semitones between self and A4.
        Pitch.a4Freq * pow(Pitch.semitoneMultiplier, Double(-distance(to: Pitch.a4)))
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func advanced(by n: Int) -> Self {
        return Pitch(id: id + n)
    }
    func distance(to other: Pitch) -> Int {
        return other.id - id
    }
}
