//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

/// A picker that displays a navigation link to a list of options, which are shown in a new sheet on the navigation stack.
struct NavPicker<SelectionType>: View
where SelectionType: CustomStringConvertible & Equatable & Hashable {
    @State var isActive = false
    let title: String
    @Binding var selection: SelectionType
    let options: [SelectionType]
    var footer: String = ""
    
    var body: some View {
        NavigationLink(isActive: $isActive) {
            picker()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(selection.description)
                    .foregroundColor(Color.secondary)
            }
        }
        
    }
    
    private func picker() -> some View {
        List {
            Section {
                ForEach(options, id: \.self) { choice in
                    HStack {
                        Text(choice.description)
                        Spacer()
                        if choice == selection  {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                                .font(Font.body.weight(.semibold))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = choice
                        // Add a slight delay, so the user can see the new item checked.
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 0.25) {
                                isActive = false
                            }
                    }
                }
            } footer: {
                Text(footer)
            }
        }
    }
}


struct NavPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                NavPicker(
                    title: "Title",
                    selection: .constant(3),
                    options: [1, 2, 3, 4, 5],
                    footer: "This is the footer text"
                )
            }
        }
    }
}
