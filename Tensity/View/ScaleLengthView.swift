//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

/// Allows the user to edit the guitar's scale length.
struct ScaleLengthView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var length: Double
    var validLengths: ClosedRange<Double>
    @State var newLength: Double = 0.0
    @State var enableDone = false
    @FocusState var lengthInFocus: Bool

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Length (inches)")
                    Spacer()
                    TextField("Scale Length", value: $newLength, format: .number)
                        .focused($lengthInFocus)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.lengthInFocus = true
                            }
                        }
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onChange(of: newLength)  { newValue in
                            enableDone = lengthChanged && lengthValid
                        }
                }
            } footer: {
                Text("""
                     Scale length must be between \(validLengths.lowerBound, specifier: "%.0f") \
                     and \(validLengths.upperBound, specifier: "%.0f") inches.
                     """)
            }
        }
        .navigationTitle("Scale Length")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Color(UIColor.systemRed))
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Done") {
                    length = newLength
                    dismiss()
                }
                .disabled(!enableDone)
            }
        }
        .onAppear() { newLength = length }
    }

    private var lengthChanged: Bool {
        newLength != length
    }
    private var lengthValid: Bool {
        validLengths.contains(newLength)
    }
}

struct ScaleLengthView_Previews: PreviewProvider {
    static var length = 25.5
    static var validScaleLengths = 20.0...30.0
    static var previews: some View {
        NavigationView {
            ScaleLengthView(length: .constant(length), validLengths: validScaleLengths)
        }
    }
}
