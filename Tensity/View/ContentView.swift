//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

/// The main view for the Tensity app.
struct ContentView: View {
    @StateObject private var guitarModel = Guitar.load() ?? Guitar()
    @Environment(\.scenePhase) private var scenePhase
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavPicker(
                        title: "Guitar Type",
                        selection: $guitarModel.guitarType,
                        options: GuitarType.allCases,
                        footer: """
                                Changing the guitar type will revert all other fields to the \
                                default values for the new type.
                                """
                    )
                    
                    NavPicker(
                        title: "Number of Strings",
                        selection: $guitarModel.stringCount,
                        options: guitarModel.guitarType.traits.validStringCounts,
                        footer: """
                                Changing the number of strings will revert the tuning and string \
                                gauges to the default values for the new string count.
                                """
                    )
                    
                    NavigationLink {
                        ScaleLengthView(
                            length: $guitarModel.scaleLength,
                            validLengths: guitarModel.validScaleLengths
                        )
                    } label: {
                        HStack {
                            Text("Scale Length")
                            Spacer()
                            Text(guitarModel.scaleLength.formatted() + " inches")
                                .foregroundColor(Color.secondary)
                        }
                    }
                    
                    NavPicker(
                        title: "String Type",
                        selection: $guitarModel.stringType,
                        options: guitarModel.validStringTypes,
                        footer: """
                                Changing the string type may cause some strings to change to the \
                                closest available gauge in the new type.
                                """
                    )
                }
                
                StringTensionTable(
                    tunedStrings: guitarModel.tunedStrings,
                    validPitches: guitarModel.validPitches,
                    validStrings: guitarModel.validStrings
                )
            }
            .navigationTitle("String Tension")
            .toolbar {
                Button("About") {
                    showAbout = true
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                guitarModel.save()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .dynamicTypeSize(.xSmall ..< .accessibility1)
        .frame(maxWidth: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
