//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

/// The type of guitar being modeled.
enum GuitarType: Int, CaseIterable, Codable, CustomStringConvertible, Identifiable {
    case electric
    case acoustic
    case bass

    var id: Int {
        rawValue
    }

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

/// A guitar string being modeled.
class StringChoice: Codable, Comparable, Equatable, Hashable, Identifiable {
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

    func isBetterMatch(than other: StringChoice, comparedTo gauge: StringChoice) -> Bool {
        if (wound == other.wound) {
            // If they're both wound or plain, choose the closest in size
            return abs(self.gauge - gauge.gauge) < abs(other.gauge - gauge.gauge)
        } else {
            // Otherwise, prefer wound-to-wound and plain-to-plain
            return self.wound == gauge.wound
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: StringChoice, rhs: StringChoice) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: StringChoice, rhs: StringChoice) -> Bool {
        if (lhs.wound == rhs.wound) {
            return rhs.wound
        } else {
            return lhs.gauge < rhs.gauge
        }
    }
}

/// A collection of ``GuitarString`` objects of the same type, e.g., Phosphor Bronze.
class StringType: Codable, CustomStringConvertible, Equatable, Hashable, Identifiable {
    let id: String
    // Friendly name of the type.
    let description: String
    // Which type of guitar is this type intended for.
    let forGuitarType: GuitarType?
    // Another string type that this type includes, typically plain steel.
    let includes: String?
    // All available guitar strings of this type.
    let strings: [StringChoice]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: StringType, rhs: StringType) -> Bool {
        lhs.id == rhs.id
    }
}

/// The  guitar string tension specifications that are loaded from the bundled JSON during app initialization.
class StringData: Codable {
    let stringTypes: [StringType]

    init(stringTypes: [StringType]) {
        self.stringTypes = stringTypes
    }

    static func load() -> StringData {
        guard let url = Bundle.main.url(forResource: "StringData", withExtension: "json") else {
            fatalError("Failed to locate StringData.json in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load StringData.json from bundle.")
        }

        let decoder = JSONDecoder()
        guard let StringData = try? decoder.decode(StringData.self, from: data) else {
            fatalError("Failed to decode StringData.json from bundle.")
        }

        return StringData
    }
}
