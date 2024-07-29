//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

// A  protocol that exposes the static characteristics of a GuitarType.
protocol GuitarTraits {
    var defaultStringCount: Int { get }
    var validStringCounts: [Int] { get }
    var defaultScaleLength: Double { get }
    var validScaleLengths: ClosedRange<Double> { get }
    var defaultStringType: String { get }
    var validPitches: ClosedRange<Pitch> { get }

    func stringsPerCourse(forCount stringCount: Int) -> Int

    func defaultPitches(forCount stringCount: Int) -> [Pitch]
    func defaultStringGauges(forCount stringCount: Int) -> [StringChoice]
}

// The GuitarTraits for an electric guitar.
final class ElectricGuitarTraits: GuitarTraits {
    let defaultStringCount: Int = 6
    let validStringCounts: [Int] = [4, 6, 7, 12]
    let defaultScaleLength: Double = 25.5
    let validScaleLengths: ClosedRange<Double> = 20.0...30.0
    let defaultStringType: String = "NW"
    let validPitches: ClosedRange<Pitch> = Pitch(.A, 1)...Pitch(.A, 4)

    func stringsPerCourse(forCount stringCount: Int) -> Int { (stringCount == 12) ? 2 : 1 }
    
    func defaultPitches(forCount stringCount: Int) -> [Pitch] {
        switch stringCount {
        case 4:
            return [
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.D, 3)]
        case 6:
            return [
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.D, 3),
                Pitch(.A, 2),
                Pitch(.E, 2)]
        case 7:
            return [
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.D, 3),
                Pitch(.A, 2),
                Pitch(.E, 2),
                Pitch(.B, 1)]
       case 12:
            return [
                Pitch(.E, 4),
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.G, 4),
                Pitch(.D, 3),
                Pitch(.D, 4),
                Pitch(.A, 2),
                Pitch(.A, 3),
                Pitch(.E, 2),
                Pitch(.E, 3)]
        default:
            assertionFailure("Invalid string count for electric guitar.")
            // Middle C seems as good a default as any.
            return Array(repeating: Pitch(.C, 4), count: stringCount)
        }
    }

    func defaultStringGauges(forCount stringCount: Int) -> [StringChoice] {
        switch stringCount {
        case 4:
            return [
                StringChoice(0.011),
                StringChoice(0.015),
                StringChoice(0.019),
                StringChoice(0.028, wound: true)
            ]
        case 6:
            return [
                StringChoice(0.010),
                StringChoice(0.013),
                StringChoice(0.017),
                StringChoice(0.026, wound: true),
                StringChoice(0.036, wound: true),
                StringChoice(0.046, wound: true)
            ]
        case 7:
            return [
                StringChoice(0.010),
                StringChoice(0.013),
                StringChoice(0.017),
                StringChoice(0.026, wound: true),
                StringChoice(0.036, wound: true),
                StringChoice(0.046, wound: true),
                StringChoice(0.059, wound: true)
            ]
        case 12:
            return [
                StringChoice(0.010),
                StringChoice(0.010),
                StringChoice(0.013),
                StringChoice(0.013),
                StringChoice(0.017),
                StringChoice(0.008),
                StringChoice(0.026, wound: true),
                StringChoice(0.012),
                StringChoice(0.036, wound: true),
                StringChoice(0.018),
                StringChoice(0.046, wound: true),
                StringChoice(0.026, wound: true)
            ]
        default:
            assertionFailure("Invalid string count for electric guitar.")
            return Array(repeating: StringChoice(0.010), count: stringCount)
        }
    }
}

// The GuitarTraits for an acoustic guitar.
final class AcousticGuitarTraits: GuitarTraits {
    let defaultStringCount: Int = 6
    let validStringCounts: [Int] = [4, 6, 12]
    let defaultScaleLength: Double = 25.5
    let validScaleLengths: ClosedRange<Double> = 20.0...30.0
    let defaultStringType: String = "PB"
    let validPitches: ClosedRange<Pitch> = Pitch(.A, 1)...Pitch(.A, 4)
    
    func stringsPerCourse(forCount stringCount: Int) -> Int { (stringCount == 12) ? 2 : 1 }

    func defaultPitches(forCount stringCount: Int) -> [Pitch] {
        switch stringCount {
        case 4:
            return [
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.D, 3)]
        case 6:
            return [
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.D, 3),
                Pitch(.A, 2),
                Pitch(.E, 2)]
        case 12:
            return [
                Pitch(.E, 4),
                Pitch(.E, 4),
                Pitch(.B, 3),
                Pitch(.B, 3),
                Pitch(.G, 3),
                Pitch(.G, 4),
                Pitch(.D, 3),
                Pitch(.D, 4),
                Pitch(.A, 2),
                Pitch(.A, 3),
                Pitch(.E, 2),
                Pitch(.E, 3)]
        default:
            assertionFailure("Invalid string count for acoustic guitar.")
            // Middle C seems as good a default as any.
            return Array(repeating: Pitch(.C, 4), count: stringCount)
        }
    }

    func defaultStringGauges(forCount stringCount: Int) -> [StringChoice] {
        switch stringCount {
        case 4:
            return [
                StringChoice(0.013),
                StringChoice(0.017),
                StringChoice(0.024, wound: true),
                StringChoice(0.032, wound: true)
            ]
        case 6:
            return [
                StringChoice(0.012),
                StringChoice(0.016),
                StringChoice(0.024, wound: true),
                StringChoice(0.032, wound: true),
                StringChoice(0.042, wound: true),
                StringChoice(0.053, wound: true)
            ]
        case 12:
            return [
                StringChoice(0.010),
                StringChoice(0.010),
                StringChoice(0.014),
                StringChoice(0.014),
                StringChoice(0.023),
                StringChoice(0.008),
                StringChoice(0.030, wound: true),
                StringChoice(0.012),
                StringChoice(0.039, wound: true),
                StringChoice(0.018),
                StringChoice(0.047, wound: true),
                StringChoice(0.027, wound: true)
            ]
        default:
            assertionFailure("Invalid string count for acoustic guitar.")
            return Array(repeating: StringChoice(0.012), count: stringCount)
        }
    }
}

// The GuitarTraits for a bass guitar.
final class BassGuitarTraits: GuitarTraits {
    let defaultStringCount: Int = 4
    let validStringCounts: [Int] = [4, 5]
    let defaultScaleLength: Double = 34.0
    let validScaleLengths: ClosedRange<Double> = 30.0...40.0
    let defaultStringType: String = "XLB"
    let validPitches: ClosedRange<Pitch> = Pitch(.A, 0)...Pitch(.A, 3)

    func stringsPerCourse(forCount stringCount: Int) -> Int { 1 }

    func defaultPitches(forCount stringCount: Int) -> [Pitch] {
        switch stringCount {
        case 4:
            return [
                Pitch(.G, 2),
                Pitch(.D, 2),
                Pitch(.A, 1),
                Pitch(.E, 1)]
        case 5:
            return [
                Pitch(.G, 2),
                Pitch(.D, 2),
                Pitch(.A, 1),
                Pitch(.E, 1),
                Pitch(.B, 0)]
        default:
            assertionFailure("Invalid string count for bass guitar.")
            // Middle C seems as good a default as any.
            return Array(repeating: Pitch(.C, 4), count: stringCount)
        }
    }

    func defaultStringGauges(forCount stringCount: Int) -> [StringChoice] {
        switch stringCount {
        case 4:
            return [
                StringChoice(0.045, wound: true),
                StringChoice(0.065, wound: true),
                StringChoice(0.085, wound: true),
                StringChoice(0.105, wound: true)
            ]
        case 5:
            return [
                StringChoice(0.045, wound: true),
                StringChoice(0.065, wound: true),
                StringChoice(0.085, wound: true),
                StringChoice(0.105, wound: true),
                StringChoice(0.135, wound: true)
            ]
        default:
            assertionFailure("Invalid string count for bass guitar.")
            return Array(repeating: StringChoice(0.045, wound: true), count: stringCount)
        }
    }
}

extension GuitarType {
    var traits: GuitarTraits {
        switch self {
        case .electric:
            return ElectricGuitarTraits()
        case .acoustic:
            return AcousticGuitarTraits()
        case .bass:
            return BassGuitarTraits()
        }
    }
}
