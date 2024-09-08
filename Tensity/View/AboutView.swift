//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI
import QuickLook
import UtiliKit

struct TensityInfo: AboutInfo {
    var appStoreId: Int = 1631745251
    var copyright: String = "© 2024 Stephen E. Bensley"
    var description: String = ""
    var gitHubAccount: String = "stephenbensley"
    var gitHubRepo: String = "Tensity"
}

// Displays the About page.
struct AboutView: View {
    // URLs for the content we link
    let daddarioUrl = URL(string: "http://www.daddario.com")!
    let specUrl = Bundle.main.url(forResource: "String Tension Specifications", withExtension: "pdf")!
    let info: TensityInfo
    // Trigger QuickLook
    @State private var previewUrl: URL?
    
    init(info: TensityInfo) {
        self.info = info
    }

    var body: some View {
        NavigationStack {
            Form {
                HStack(alignment: .center) {
                    info.icon
                        .resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(10)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text(info.name)
                            .font(.title)
                        Text("Version \(info.version)\n\(info.copyright)")
                            .font(.footnote)
                    }
                }
                
                Section {
                    Link(destination: info.privacyPolicy) {
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
                    Link(destination: info.license) {
                        Label("Read the license", systemImage: "doc.plaintext")
                    }
                    Link(destination: info.sourceCode) {
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
                    Link(destination: info.writeReview) {
                        Label("Rate this app", systemImage: "star")
                    }
                    ShareLink(item: info.share) {
                        Label("Share this app", systemImage:  "square.and.arrow.up")
                    }
                    Link(destination: info.contact) {
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
    AboutView(info: TensityInfo())
}
