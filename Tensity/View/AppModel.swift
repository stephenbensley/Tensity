//
// Copyright 2024 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

// The Guitar class is our app model. This file provides some additional functionality making it
// easier to use as the app model.

extension StringData {
    static func create() -> StringData {
        guard let stringData = create(forResource: "StringData", withExtension: "json") else {
            fatalError("Unable to load StringData.json from app bundle.")
        }
        return stringData
    }
}

extension Guitar {
    // Subset of the object's state that needs to be persisted.
    struct CodableState: Codable {
        let guitarTypeId: Int
        let stringCount: Int
        let scaleLength: Double
        let stringTypeId: String
        let pitchIds: [Int]
        let stringIds: [String]
    }

    convenience init?(stringData: StringData, state: CodableState) {
        guard let guitarType = GuitarType(rawValue: state.guitarTypeId) else {
            return nil
        }
        
        let stringCount = state.stringCount
        guard guitarType.traits.validStringCounts.contains(stringCount) else {
            return nil
        }
        
        let scaleLength = state.scaleLength
        guard guitarType.traits.validScaleLengths.contains(scaleLength) else {
            return nil
        }
        
        guard let stringType = stringData.findStringType(state.stringTypeId) else {
            return nil
        }
        let validStrings = StringChoices(forType: stringType, data: stringData)
        
        guard state.pitchIds.count == stringCount else {
            return nil
        }
        let pitches = state.pitchIds.map { Pitch(id: $0) }
        guard !pitches.contains(where: { !guitarType.traits.validPitches.contains($0) }) else {
            return nil
        }
        
        guard state.stringIds.count == stringCount else {
            return nil
        }
        let strings = state.stringIds.compactMap { validStrings.find($0) }
        guard strings.count == stringCount else {
            return nil
        }
        
        self.init(
            stringData: stringData,
            guitarType: guitarType,
            stringCount: stringCount,
            scaleLength: scaleLength,
            validStrings: validStrings,
            pitches: pitches,
            strings: strings
        )
    }
    
    static func create() -> Guitar {
        let stringData = StringData.create()
        if let data = UserDefaults.standard.data(forKey: "AppModel"),
           let state = try? JSONDecoder().decode(CodableState.self, from: data),
           let guitar = Guitar(stringData: stringData, state: state) {
            return guitar
        }
        // We couldn't restore from persistent state, so create a default instance.
        return Guitar(stringData: stringData)
    }
    
    func save() {
        let state = CodableState(
            guitarTypeId: guitarType.rawValue,
            stringCount: stringCount,
            scaleLength: scaleLength,
            stringTypeId: stringType.id,
            pitchIds: tunedStrings.map({ $0.pitch.id }),
            stringIds: tunedStrings.map({ $0.string.id })
        )
        let data = try! JSONEncoder().encode(state)
        UserDefaults.standard.set(data, forKey: "AppModel")
    }
}

// Allow app model to be passed through the environment

private struct AppModelKey: EnvironmentKey {
    static let defaultValue = Guitar.create()
}

extension EnvironmentValues {
    var appModel: Guitar {
        get { self[AppModelKey.self] }
        set { self[AppModelKey.self] = newValue }
    }
}

extension View {
    func appModel(_ value: Guitar) -> some View {
        environment(\.appModel, value)
    }
}
