//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

struct ContentView: View {
    // Used to trigger saving state when app goes inactive.
    @Environment(\.scenePhase) private var scenePhase
    
    // Persistent app model.
    @State private var appModel = Guitar.create()
    
    // The string tension table gets hard to read if we let it get too wide.
    @ScaledMetric private var maxWidth = 500
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Guitar Type", selection: $appModel.guitarType) {
                        ForEach(appModel.validGuitarTypes) { guitarType in
                            Text(guitarType.description)
                        }
                    }
                    Picker("Number of Strings", selection: $appModel.stringCount) {
                        ForEach(appModel.validStringCounts, id: \.self) { stringCount in
                            Text(stringCount.description)
                        }
                    }
                    Picker("String Type", selection: $appModel.stringType) {
                        ForEach(appModel.validStringTypes) { stringType in
                            Text(stringType.description).tag(stringType)
                        }
                    }
                    VStack {
                        LabeledContent("Scale Length") {
                            Text(appModel.scaleLength.formatted() + " inches")
                        }
                        Slider(
                            value: $appModel.scaleLength,
                            in: appModel.validScaleLengths,
                            step: 0.125
                        ) {
                            Text("Scale Length")
                        } minimumValueLabel: {
                            Text(appModel.validScaleLengths.lowerBound.formatted())
                        } maximumValueLabel: {
                            Text(appModel.validScaleLengths.upperBound.formatted())
                        }
                    }
                }
                
                StringTensionTable()
            }
            .navigationTitle("String Tension")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    AboutView()
                        .frame(maxWidth: maxWidth)
                } label: {
                    Label("About", systemImage: "ellipsis.circle")
                }
            }
            .frame(maxWidth: maxWidth)
            .onChange(of: scenePhase) { _, phase in
                if phase == .inactive { appModel.save() }
            }
            .environment(appModel)
        }
    }
}

#Preview {
    ContentView()
}
