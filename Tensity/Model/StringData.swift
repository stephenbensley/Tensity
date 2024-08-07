//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

// The type of guitar being modeled.
enum GuitarType: Int, CaseIterable, Codable, CustomStringConvertible, Identifiable {
    case electric
    case acoustic
    case bass

    var id: Self { self }

    var description: String {
        switch self {
        case .electric:
            return "Electric"
        case .acoustic:
            return "Acoustic"
        case .bass:
            return "Bass"
        }
    }
}

// One of the guitar strings a user can choose from when configuring the guitar.
//
// Conceptually, this represents an unused string, sitting on the shelf of your local
// music shop. Once it's strung on a guitar and brought up to tune, it becomes a TunedString.
final class StringChoice: Codable, Comparable, Equatable, Hashable, Identifiable {
    // Must be unique across all string types.
    let id: String
    // Pounds per linear inch
    let unitWeight: Double
    // String diameter in inches
    let gauge: Double
    // True for wound strings; false for plain strings.
    let wound: Bool

    var description: String {
        // Show at least 3 digits after the decimal, so we display 0.010 rather than 0.01.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 6

        // gauge is trusted input, so the format can't fail.
        var result = formatter.string(from: NSNumber(value: gauge))!
        result += wound ? "w" : "p"
        return result
    }

    init(id: String, unitWeight: Double, gauge: Double, wound: Bool) {
        self.id = id
        self.unitWeight = unitWeight
        self.gauge = gauge
        self.wound = wound
    }

    // Useful when we want to specify a gauge without regard to a particular string type.
    init(_ gauge: Double, wound: Bool = false) {
        self.id = UUID().uuidString
        self.unitWeight = 0.0
        self.gauge = gauge
        self.wound = wound
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    static func == (lhs: StringChoice, rhs: StringChoice) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: StringChoice, rhs: StringChoice) -> Bool {
        if (lhs.wound != rhs.wound) {
            return rhs.wound
        } else {
            return lhs.gauge < rhs.gauge
        }
    }
}

// A collection of StringChoice objects of the same type, e.g., Phosphor Bronze.
final class StringType: Codable, CustomStringConvertible, Equatable, Hashable, Identifiable {
    // Must be unique across all string types.
    let id: String
    // Friendly name of the type.
    let description: String
    // Which type of guitar is this type intended for.
    let forGuitarType: GuitarType?
    // Another string type that this type includes, typically plain steel.
    let includes: String?
    // All available guitar strings of this type.
    let strings: [StringChoice]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    static func == (lhs: StringType, rhs: StringType) -> Bool {
        lhs.id == rhs.id
    }
}

// The  guitar string tension specifications that are loaded from the bundled JSON during app
// initialization.
final class StringData: Codable {
    let stringTypes: [StringType]

    static func create(forResource: String, withExtension: String) -> StringData? {
        guard let url = Bundle.main.url(
            forResource: forResource,
            withExtension: withExtension
        ) else {
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        let decoder = JSONDecoder()
        guard let StringData = try? decoder.decode(StringData.self, from: data) else {
            return nil
        }

        return StringData
    }
}
