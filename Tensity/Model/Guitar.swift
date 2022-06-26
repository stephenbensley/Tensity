//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

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
            stringType = stringCatalog.defaultStringType(guitarType)
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
            validStrings = StringChoices(forType: stringType, catalog: stringCatalog)
            tunedStrings.forEach { $0.string = validStrings.findClosestMatch(to: $0.string) }
        }
    }
    var validStringTypes: [StringType] {
        stringCatalog.validStringTypes(guitarType)
    }

    @Published var tunedStrings: [TunedString]
    var validPitches: ClosedRange<Pitch> {
        guitarType.traits.validPitches
    }
    var validStrings: StringChoices

    private var stringCatalog: StringCatalog

    init() {
        let stringCatalog = StringCatalog()
        
        // Try to load the UserData; otherwise, use default values.
        if let userData = UserData.load() {
            // Unpack the user data
            let guitarType = GuitarType(rawValue: userData.guitarTypeId)!
            let stringCount = userData.stringCount
            let scaleLength = userData.scaleLength
            let stringType = stringCatalog.findStringType(id: userData.stringTypeId)
            let pitches = userData.pitchIds.map { Pitch(id: $0) }
            let strings = userData.stringIds.compactMap { stringCatalog.findString(id: $0) }

            // Initialize self
            self.guitarType = guitarType
            self.stringCount = stringCount
            self.scaleLength = scaleLength
            self.stringType = stringType
            self.validStrings = StringChoices(forType: stringType, catalog: stringCatalog)
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
            let stringType = stringCatalog.defaultStringType(guitarType)

            // Initialize self.
            self.guitarType = guitarType
            self.stringCount = stringCount
            self.scaleLength = scaleLength
            self.stringType = stringType
            self.validStrings = StringChoices(forType: stringType, catalog: stringCatalog)
            self.tunedStrings = Self.buildDefaultTunedStrings(
                guitarType: guitarType,
                stringCount: stringCount,
                scaleLength: scaleLength,
                stringChoices: self.validStrings
            )
        }

        self.stringCatalog = stringCatalog
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
        strings: [GuitarString]
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
