//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI
import QuickLook

// Displays the About page.
struct AboutView: View {
    // Lots of URLs for all the content we link
    let contactUrl = URL(string: "https://stephenbensley.github.io/Tensity/contact.html")!
    let daddarioUrl = URL(string: "http://www.daddario.com")!
    let licenseUrl = URL(string: "https://github.com/stephenbensley/Tensity/blob/main/LICENSE")!
    let privacyUrl = URL(string: "https://stephenbensley.github.io/Tensity/privacy.html")!
    let reviewUrl = URL(string: "https://apps.apple.com/us/app/id1631745251?action=write-review")!
    let shareUrl = URL(string: "https://apps.apple.com/us/app/id1631745251")!
    let sourceUrl = URL(string: "https://github.com/stephenbensley/Tensity")!
    let specUrl = Bundle.main.url(forResource: "String Tension Specifications", withExtension: "pdf")!

    // Trigger QuickLook
    @State private var previewUrl: URL?
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Image("tensity_76x76")
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text("Tensity")
                            .font(.title)
                        Text("Version \(appVersion), build \(buildNumber)\n© 2024 Stephen E. Bensley")
                            .font(.footnote)
                    }
                }
                
                Section {
                    Link(destination: privacyUrl) {
                        Label("Read the privacy policy", systemImage: "hand.raised")
                    }
                } header: {
                    Text("This app does not collect or share any personal information.")
                }
                .textCase(nil)
                
                Section {
                    Link(destination: daddarioUrl) {
                        Label("Visit D'Addario on the web", systemImage: "globe")
                    }
                    Button("View the specificatons", systemImage: "doc") {
                        previewUrl = specUrl
                        
                    }
                } header: {
                    Text("""
                    The string tension specifications used by this app were provided by D'Addario. \
                    However, this app is neither affiliated with nor endorsed by D'Addario.
                    """)
                }
                .textCase(nil)
                
                Section {
                    Link(destination: licenseUrl) {
                        Label("Read the license", systemImage: "doc.plaintext")
                    }
                    Link(destination: sourceUrl) {
                        Label("Download the source code", systemImage: "icloud.and.arrow.down")
                    }
                } header: {
                    Text("""
                    The source code for this app has been released under the MIT License and is \
                    hosted on GitHub.
                    """)
                }
                .textCase(nil)
                
                Section {
                    Link(destination: reviewUrl) {
                        Label("Rate this app", systemImage: "star")
                    }
                    ShareLink(item: shareUrl) {
                        Label("Share this app", systemImage:  "square.and.arrow.up")
                    }
                    Link(destination: contactUrl) {
                        Label("Contact the developer", systemImage: "mail")
                    }
                 }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .quickLookPreview($previewUrl)
         }
    }
}

#Preview {
    AboutView()
}
