//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

extension DynamicTypeSize {
    var scaleFactor: Double {
        var numerator: Int = 0
        let denominator: Int = 17

        switch self {
        case .xSmall:
            numerator = 14
        case .small:
            numerator = 15
        case .medium:
            numerator = 16
        case .large:
            numerator = 17
        case .xLarge:
            numerator = 19
        case .xxLarge:
            numerator = 21
        case .xxxLarge:
            numerator = 23
        case .accessibility1:
            numerator = 28
        case .accessibility2:
            numerator = 33
        case .accessibility3:
            numerator = 40
        case .accessibility4:
            numerator = 47
        case .accessibility5:
            numerator = 53
        @unknown default:
            numerator = denominator
        }

        return Double(numerator)/Double(denominator)
    }
}

// Text widths with default system fault and .semibold
// Symbol    20
// Note      38
// G♯4       32
// Gauge     52
// 0.0095    58
// 0.088w    61
// 888.8     48
// Tension:  62

/// Defines the characteristics of each column in the ``StringTensionTable``
struct StringTensionColumn {
    static let courseWidth = 20.0
    static let noteWidth = 52.0
    static let gaugeWidth = 81.0
    static let tensionWidth = 62.0
}

/// Presents the information for a ``TunedString`` in the ``StringTensionTable``
struct StringTensionRow: View {
    enum Editing {
        case none
        case note
        case gauge
    }

    @ObservedObject var tunedString: TunedString
    var validPitches: ClosedRange<Pitch>
    var validStrings: StringChoices
    var scale: Double
    @State var editing = Editing.none

    var body: some View {
        HStack {
            Image(systemName: "\(tunedString.course).circle")
                .frame(width: StringTensionColumn.courseWidth * scale)
                .accessibility(label: Text("course \(tunedString.course)"))

            Spacer()

            Button(tunedString.pitch.description) {
                editing = (editing == .note) ? .none : .note
            }
            .buttonStyle(.borderless)
            .foregroundColor(editing == .note ? Color(UIColor.systemRed) : .primary)
            .padding(5)
            .frame(width: StringTensionColumn.noteWidth * scale)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 7.0))
            .contentShape(Rectangle())

            Spacer()

            Button(tunedString.string.description) {
                editing = (editing == .gauge) ? .none : .gauge
            }
            .buttonStyle(.borderless)
            .foregroundColor(editing == .gauge ? Color(UIColor.systemRed) : .primary)
            .padding(5)
            .frame(width: StringTensionColumn.gaugeWidth * scale)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 7.0))
            .contentShape(Rectangle())

            Spacer()

            Text(String(format: "%.1f", tunedString.tension))
                .frame(width: StringTensionColumn.tensionWidth * scale, alignment: .trailing)
        }

        switch editing {
        case .note:
            Picker("Note", selection: $tunedString.pitch) {
                ForEach(validPitches) { pitch in
                    Text(pitch.description).tag(pitch)
                }
            }
            .pickerStyle(.wheel)
            .id(UUID())

        case .gauge:
            Picker("Gauge", selection: $tunedString.string) {
                ForEach(validStrings) { string in
                    Text(string.description).tag(string)
                }
            }
            .pickerStyle(.wheel)
            .id(UUID())

        default:
            EmptyView()
        }
    }
}

/// Computes and displays the total tension of all the strings in the ``StringTensionTable``
struct TotalTensionText: View {
    @ObservedObject var tunedStrings: ObservedArray<TunedString>

    init(tunedStrings: [TunedString]) {
        self.tunedStrings = ObservedArray(tunedStrings)
    }

    var totalTension: Double {
        tunedStrings.reduce(0.0) { $0 + $1.tension }
    }

    var body: some View {
        Text(String(format: "%.1f", totalTension))
    }
}

/// Displays the table of guitar strings, consisting of a header, a row for each ``TunedString``, and summary row with
/// the ``TotalTensionText``.
struct StringTensionTable: View {
    var tunedStrings: [TunedString]
    var validPitches: ClosedRange<Pitch>
    var validStrings: StringChoices
    @Environment(\.dynamicTypeSize) var typeSize

    var scale: Double {
        min(max(typeSize.scaleFactor, 1.0), 1.4)
    }

    var body: some View {
        Group {
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: StringTensionColumn.courseWidth * scale)
                Spacer()
                Text("Note")
                    .frame(width: StringTensionColumn.noteWidth * scale)
                Spacer()
                Text("Gauge")
                    .frame(width: StringTensionColumn.gaugeWidth * scale)
                Spacer()
                Text("Tension\n(lbs.)")
                    .multilineTextAlignment(.center)
                    .frame(width: StringTensionColumn.tensionWidth * scale, alignment: .trailing)
                    .accessibility(label: Text("Tension in pounds"))
            }

            ForEach(tunedStrings) { tunedString in
                StringTensionRow(
                    tunedString: tunedString,
                    validPitches: validPitches,
                    validStrings: validStrings,
                    scale: scale
                )
            }

            HStack(spacing: 0) {
                Text("Total")
                    .accessibility(label: Text("Total Tension"))
                Spacer()
                TotalTensionText(tunedStrings: tunedStrings)
            }
        }
    }
}

struct StringTensionTable_Previews: PreviewProvider {
    static var appModel = Guitar()
    static var previews: some View {
        Form {
            StringTensionTable(
                tunedStrings: appModel.tunedStrings,
                validPitches: appModel.validPitches,
                validStrings: appModel.validStrings
            )
        }
    }
}
