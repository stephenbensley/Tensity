//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

// Add some useful lookup functions to StringData
extension StringData {
    func defaultStringType(_ guitarType: GuitarType) -> StringType {
        // Unit tests validate that every GuitarType has a default StringType.
        findStringType(guitarType.traits.defaultStringType)!
    }

    func findStringType(_ id: String) -> StringType? {
        stringTypes.first(where: { $0.id == id })
    }

    func validStringTypes(_ guitarType: GuitarType) -> [StringType] {
        stringTypes.filter { $0.forGuitarType == guitarType }
    }
}

//
// There is a complex dependency graph amongst the model's published properties:
//
//                 guitarType
//                     |
//               --------------
//              /      |       \
//    stringType   scaleLength  stringCount
//              \      |       /
//      validStrings   |    defaultGauges
//                \    |     /
//                tunedStrings

// This is the main entry point into the app model. It represents the guitar whose string tension is to be calculated.
class Guitar: ObservableObject {
    private var stringData: StringData

    @Published var guitarType: GuitarType {
        didSet {
            // Must update stringType first; otherwise default gauges will be mapped with wrong
            // string type which can lead to information loss.
            stringType = stringData.defaultStringType(guitarType)
            stringCount = guitarType.traits.defaultStringCount
            scaleLength = guitarType.traits.defaultScaleLength
        }
    }
    var validGuitarTypes: [GuitarType] {
        GuitarType.allCases
    }

    @Published var stringCount: Int {
        didSet {
            tunedStrings = Self.buildDefaultTunedStrings(
                guitarType: guitarType,
                stringCount: stringCount,
                scaleLength: scaleLength,
                stringChoices: validStrings
            )
        }
    }
    var validStringCounts: [Int] {
        guitarType.traits.validStringCounts
    }

    // Scale length of the guitar in inches.
    @Published var scaleLength: Double {
        didSet {
            tunedStrings.forEach { $0.length = scaleLength }
        }
    }
    var validScaleLengths: ClosedRange<Double> {
        guitarType.traits.validScaleLengths
    }

    @Published var stringType: StringType {
        didSet {
            validStrings = StringChoices(forType: stringType, data: stringData)
            tunedStrings.forEach { $0.string = validStrings.findClosestMatch(to: $0.string) }
        }
    }
    var validStringTypes: [StringType] {
        stringData.validStringTypes(guitarType)
    }

    var validPitches: ClosedRange<Pitch> {
        guitarType.traits.validPitches
    }
    var validStrings: StringChoices

    @Published var tunedStrings: [TunedString]

    private init(
        stringData: StringData,
        guitarType: GuitarType,
        stringCount: Int,
        scaleLength: Double,
        stringType: StringType,
        validStrings: StringChoices,
        tunedStrings: [TunedString]
    ) {
        self.stringData = stringData
        self.guitarType = guitarType
        self.stringCount = stringCount
        self.scaleLength = scaleLength
        self.stringType = stringType
        self.validStrings = validStrings
        self.tunedStrings = tunedStrings
    }

    convenience init() {
        // Load all the defaults.
        let stringData = StringData.load()
        let guitarType = GuitarType.electric
        let stringCount = guitarType.traits.defaultStringCount
        let scaleLength = guitarType.traits.defaultScaleLength
        let stringType = stringData.defaultStringType(guitarType)
        let validStrings = StringChoices(forType: stringType, data: stringData)
        let tunedStrings = Self.buildDefaultTunedStrings(
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            stringChoices: validStrings
        )
        self.init(
            stringData: stringData,
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            stringType: stringType,
            validStrings: validStrings,
            tunedStrings: tunedStrings
        )
    }

    static func load() -> Guitar? {
        guard let userData = UserData.load() else {
            return nil
        }

        let stringData = StringData.load()

        guard let guitarType = GuitarType(rawValue: userData.guitarTypeId) else {
            return nil
        }

        let stringCount = userData.stringCount
        guard guitarType.traits.validStringCounts.contains(stringCount) else {
            return nil
        }

        let scaleLength = userData.scaleLength
        guard guitarType.traits.validScaleLengths.contains(scaleLength) else {
            return nil
        }

        guard let stringType = stringData.findStringType(userData.stringTypeId) else {
            return nil
        }

        guard userData.pitchIds.count == stringCount else {
            return nil
        }
        let pitches = userData.pitchIds.map { Pitch(id: $0) }
        guard !pitches.contains(where: { !guitarType.traits.validPitches.contains($0) }) else {
            return nil
        }

        let validStrings = StringChoices(forType: stringType, data: stringData)

        guard userData.stringIds.count == stringCount else {
            return nil
        }
        let strings = userData.stringIds.compactMap { validStrings.find($0) }
        guard strings.count == stringCount else {
            return nil
        }

        let tunedStrings = buildTunedStrings(
            guitarType: guitarType,
            scaleLength: scaleLength,
            pitches: pitches,
            strings: strings
        )

        return Guitar(
            stringData: stringData,
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            stringType: stringType,
            validStrings: validStrings,
            tunedStrings: tunedStrings
        )
    }

    func save() {
        UserData(
            guitarTypeId: guitarType.rawValue,
            stringCount: stringCount,
            scaleLength: scaleLength,
            stringTypeId: stringType.id,
            pitchIds: tunedStrings.map({ $0.pitch.id }),
            stringIds: tunedStrings.map({ $0.string.id })
        ).save()
    }

    private static func buildTunedStrings(
        guitarType: GuitarType,
        scaleLength: Double,
        pitches: [Pitch],
        strings: [StringChoice]
    ) -> [TunedString] {
        let stringCount = pitches.count
        assert(strings.count == stringCount)
        let stringsPerCourse = guitarType.traits.stringsPerCourse(forCount: stringCount)

        var result: [TunedString] = []
        for i in 0 ..< stringCount {
            let newModel = TunedString(
                number: i + 1,
                course: (i / stringsPerCourse) + 1,
                length: scaleLength,
                pitch: pitches[i],
                string: strings[i])
            result.append(newModel)
        }
        return result
    }

    private static func buildDefaultTunedStrings(
        guitarType: GuitarType,
        stringCount: Int,
        scaleLength: Double,
        stringChoices: StringChoices
    ) -> [TunedString] {
        let pitches = guitarType.traits.defaultPitches(forCount: stringCount)
        let gauges = guitarType.traits.defaultStringGauges(forCount: stringCount)
        let strings = stringChoices.findClosestMatches(to: gauges)

        return buildTunedStrings(
            guitarType: guitarType,
            scaleLength: scaleLength,
            pitches: pitches,
            strings: strings
        )
    }
}
