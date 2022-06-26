//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

/// Displays the About page.
struct AboutView: View {
    // Used to dismiss the view when the Done button is tapped.
    @Environment(\.dismiss) var dismiss
    // Signals that the tension specifications pdf should be displayed.
    @State var showSpec: Bool = false
    // Left and right margin size.
    let margin = 25.0

    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "0.0.0"
        }
    }

    var buildNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return version
        } else {
            return "0"
        }
    }

    var specUrl: URL? {
        Bundle.main.url(forResource: "String Tension Specifications", withExtension: "pdf")
    }

    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                    .frame(width: margin)

                VStack(alignment: .leading, spacing: 25.0) {
                    HStack {
                        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                            .padding(.trailing, 5)
                        Text("Tensity")
                            .font(.largeTitle)
                    }

                    Text("© 2022 Stephen E. Bensley\nVersion \(appVersion), build \(buildNumber)")

                    Text("""
                         The string tension specifications used by this app come from [D'Addario]\
                         (https://www.daddario.com). This app is neither affiliated with nor \
                         endorsed by D'Addario. I used their data because it was readily available \
                         and because I use D'Addario strings on my own instruments.
                         """)

                    Button("View the specifications.") {
                        showSpec = true
                    }

                    Text("""
                         This app does not collect or share any personal information. See my \
                         [Privacy Policy](https://www.stephenbensley.com/privacy_tensity) for more \
                         details.
                         """)

                   Text("""
                        The source code for this app has been released under the [MIT License]\
                        (https://github.com/stephenbensley/Tensity/blob/main/LICENSE) and is \
                        hosted on [GitHub](https://github.com/stephenbensley/Tensity).
                        """)

                    Text("""
                         Please [contact me](https://www.stephenbensley.com/contact) with any bug \
                         reports, feature requests, or other feedback.
                         """)

                    Spacer()
                }
                .navigationTitle(Text("About"))
                .navigationBarTitleDisplayMode(.inline)
                .multilineTextAlignment(.leading)
                .fullScreenCover(isPresented: $showSpec) {
                    if let url = specUrl {
                        PdfReader(url: url)
                    }
                }
                .toolbar {
                    Button("Done") { dismiss() }
                }

                Spacer()
                    .frame(width: margin)
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
