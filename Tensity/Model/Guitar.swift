//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

extension StringData {
    func defaultStringType(_ guitarType: GuitarType) -> StringType {
        findStringType(id: guitarType.traits.defaultStringType)
    }

    func findStringType(id: String) -> StringType {
        stringTypes.first(where: { $0.id == id })!
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

/// This is the main entry point into the app model. It represents the guitar whose string tension is to be calculated.
class Guitar: ObservableObject {
    @Published var guitarType: GuitarType {
        didSet {
            // Must update stringType first; otherwise default gauges will be mapped with wrong
            // string type with can lead to information loss.
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

    @Published var tunedStrings: [TunedString]
    var validPitches: ClosedRange<Pitch> {
        guitarType.traits.validPitches
    }
    var validStrings: StringChoices

    private var stringData: StringData

    init() {
        let stringData = StringData.load()
        
        // Try to load the UserData; otherwise, use default values.
        if let userData = UserData.load() {
            // Unpack the user data
            let guitarType = GuitarType(rawValue: userData.guitarTypeId)!
            let stringCount = userData.stringCount
            let scaleLength = userData.scaleLength
            let stringType = stringData.findStringType(id: userData.stringTypeId)
            let validStrings = StringChoices(forType: stringType, data: stringData)
            let pitches = userData.pitchIds.map { Pitch(id: $0) }
            let strings = userData.stringIds.map { validStrings.find($0)! }

            // Initialize self
            self.guitarType = guitarType
            self.stringCount = stringCount
            self.scaleLength = scaleLength
            self.stringType = stringType
            self.validStrings = validStrings
            self.tunedStrings = Self.buildTunedStrings(
                guitarType: guitarType,
                scaleLength: scaleLength,
                pitches: pitches,
                strings: strings
            )
        } else {
            // Create defaults
            let guitarType = GuitarType.electric
            let stringCount = guitarType.traits.defaultStringCount
            let scaleLength = guitarType.traits.defaultScaleLength
            let stringType = stringData.defaultStringType(guitarType)

            // Initialize self.
            self.guitarType = guitarType
            self.stringCount = stringCount
            self.scaleLength = scaleLength
            self.stringType = stringType
            self.validStrings = StringChoices(forType: stringType, data: stringData)
            self.tunedStrings = Self.buildDefaultTunedStrings(
                guitarType: guitarType,
                stringCount: stringCount,
                scaleLength: scaleLength,
                stringChoices: self.validStrings
            )
        }

        self.stringData = stringData
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
    ) -> [TunedString]
    {
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
    ) -> [TunedString]
    {
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
