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

// This is the main entry point into the app model. It represents the guitar whose string tension
// is to be calculated.
@Observable
final class Guitar {
    private let stringData: StringData
    
    var guitarType: GuitarType {
        didSet {
            // On guitar type change, we preserve nothing, so rebuild tuned strings from defaults.
            tunedStrings = Self.buildTunedStrings(
                stringData: stringData,
                guitarType: guitarType
            )
        }
    }
    var validGuitarTypes: [GuitarType] { GuitarType.allCases }
    
    var stringCount: Int {
        get { tunedStrings.count }
        set {
            // On string count change, we preserve guitar type, scale length, and string type.
            tunedStrings = Self.buildTunedStrings(
                guitarType: guitarType,
                stringCount: newValue,
                scaleLength: scaleLength,
                validStrings: validStrings
            )
        }
    }
    var validStringCounts: [Int] { guitarType.traits.validStringCounts }
    
    // Scale length of the guitar in inches. This gets propagated to all tuned strings.
    var scaleLength: Double {
        get { tunedStrings.first!.length }
        set { tunedStrings.forEach { $0.length = newValue } }
    }
    var validScaleLengths: ClosedRange<Double> { guitarType.traits.validScaleLengths }
    
    // String type gets propagated to all tuned strings.
    var stringType: StringType {
        get {
            tunedStrings.first!.validStrings.baseType
        }
        set {
            let validStrings = StringChoices(forType: newValue, data: stringData)
            tunedStrings.forEach { $0.validStrings = validStrings }
        }
    }
    var validStringTypes: [StringType] { stringData.validStringTypes(guitarType) }
    
    var validStrings: StringChoices { tunedStrings.first!.validStrings }
    
    var tunedStrings: [TunedString]
    
    var tension: Double { tunedStrings.reduce(0.0) { $0 + $1.tension } }
    
    init(
        stringData: StringData,
        guitarType: GuitarType,
        stringCount: Int,
        scaleLength: Double,
        validStrings: StringChoices,
        pitches: [Pitch],
        strings: [StringChoice]
    ) {
        self.stringData = stringData
        self.guitarType = guitarType
        self.tunedStrings = Self.buildTunedStrings(
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            validStrings: validStrings,
            pitches: pitches,
            strings: strings
        )
    }
    
    init(stringData: StringData) {
        self.stringData = stringData
        self.guitarType = .electric
        self.tunedStrings = Self.buildTunedStrings(stringData: stringData, guitarType: .electric)
    }
    
    // Each buildTunedStrings function defaults fewer parameters than its predecessor.
    
    static func buildTunedStrings(
        stringData: StringData,
        guitarType: GuitarType
    ) -> [TunedString] {
        let stringCount = guitarType.traits.defaultStringCount
        let scaleLength = guitarType.traits.defaultScaleLength
        let stringType = stringData.defaultStringType(guitarType)
        let validStrings = StringChoices(forType: stringType, data: stringData)
        
        return buildTunedStrings(
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            validStrings: validStrings
        )
    }
    
    static func buildTunedStrings(
        guitarType: GuitarType,
        stringCount: Int,
        scaleLength: Double,
        validStrings: StringChoices
    ) -> [TunedString] {
        let pitches = guitarType.traits.defaultPitches(forCount: stringCount)
        let gauges = guitarType.traits.defaultStringGauges(forCount: stringCount)
        let strings = validStrings.findClosestMatches(to: gauges)
        
        return buildTunedStrings(
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            validStrings: validStrings,
            pitches: pitches,
            strings: strings
        )
    }
    
    static func buildTunedStrings(
        guitarType: GuitarType,
        stringCount: Int,
        scaleLength: Double,
        validStrings: StringChoices,
        pitches: [Pitch],
        strings: [StringChoice]
    ) -> [TunedString] {
        let stringsPerCourse = guitarType.traits.stringsPerCourse(forCount: stringCount)
        let validPitches = guitarType.traits.validPitches
        
        return (0..<stringCount).map {
            TunedString(
                number: $0 + 1,
                course: ($0 / stringsPerCourse) + 1,
                length: scaleLength,
                pitch: pitches[$0],
                validPitches: validPitches,
                string: strings[$0],
                validStrings: validStrings
            )
        }
    }
}
