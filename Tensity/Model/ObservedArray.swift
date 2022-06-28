//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import Combine
import Foundation

/// Wraps an array of ObservableObjects to provide a consolidated change notification when any of
/// the objects has changed.
class ObservedArray<T>: ObservableObject, RandomAccessCollection where T: ObservableObject {
    private let subject: [T]
    private var cancellables = Set<AnyCancellable>()

    init(_ subject: [T]) {
        self.subject = subject
        
        subject.forEach({
            let c = $0.objectWillChange.sink(receiveValue: { _ in
                self.objectWillChange.send()
            })

            self.cancellables.insert(c)
        })
    }

    // RandomAccessCollection
    var count: Int { subject.count }
    var startIndex: Int { 0 }
    var endIndex: Int { count }
    subscript(position: Int) -> T { subject[position] }
}
