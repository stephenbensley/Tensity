//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Foundation

// User settings that are persisted across app invocations.
struct UserData: Codable {
    var guitarTypeId: Int
    var stringCount: Int
    var scaleLength: Double
    var stringTypeId: String
    var pitchIds: [Int]
    var stringIds: [String]

    static func load() -> Self? {
        guard let data = UserDefaults.standard.data(forKey: "UserData") else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: data)
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "UserData")
        }
    }
}
