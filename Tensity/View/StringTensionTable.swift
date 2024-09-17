//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

// Presents the information for a TunedString in the StringTensionTable
struct StringTensionRow: View {
    @Bindable private var tunedString: TunedString
    
    init(tunedString: TunedString) {
        self.tunedString = tunedString
    }
    
    var body: some View {
        GridRow {
            Image(systemName: "\(tunedString.course).circle")
            
            Picker("Note", selection: $tunedString.pitch) {
                ForEach(tunedString.validPitches) { pitch in
                    Text(pitch.description + " ").tag(pitch)
                }
            }
            .fixedSize()
            .labelsHidden()
            
            Picker("Gauge", selection: $tunedString.string) {
                ForEach(tunedString.validStrings) { stringChoice in
                    Text(stringChoice.description).tag(stringChoice)
                }
            }
            .fixedSize()
            .labelsHidden()
            
            Text(String(format: "%.1f", tunedString.tension))
                .fixedSize()
        }
    }
}

// Displays the table of guitar strings, consisting of a header, a row for each TunedString, and
// a summary row with the total tension.
struct StringTensionTable: View {
    @Environment(Guitar.self) private var appModel
    
    var body: some View {
        Grid {
            GridRow(alignment: .bottom) {
                Color.clear
                    .gridCellUnsizedAxes([.horizontal, .vertical])
                Text("Note ")
                Text("Gauge    ")
                VStack {
                    Text("Tension")
                    Text("(lbs.)")
                }
            }
            .gridColumnAlignment(.trailing)
            
            Divider()
            
            ForEach(appModel.tunedStrings) {
                StringTensionRow(tunedString: $0)
            }
            
            Divider()
            
            GridRow {
                Text("Total")
                    .gridCellAnchor(.trailing)
                    .gridCellColumns(3)
                Text(String(format: "%.1f", appModel.tension))
            }
        }
    }
}

#Preview {
    Form {
        StringTensionTable()
    }
}
