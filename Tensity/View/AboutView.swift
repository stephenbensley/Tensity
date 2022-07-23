//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import SwiftUI

// Displays an action item on the About page.
struct ActionItem: View {
   var leftSymbol: String
   var text: String
   var rightSymbol: String
   var action: () -> Void

   var body: some View {
      HStack {
         Label(text, systemImage: leftSymbol)
         Spacer()
         Image(systemName: rightSymbol)
            .font(.subheadline.bold())
            .foregroundColor(Color(UIColor.tertiaryLabel))
      }
      .onTapGesture {
         action()
      }
   }
}

/// Displays the About page.
struct AboutView: View {
   /// Used to dismiss the view when the Done button is tapped.
   @Environment(\.dismiss) private var dismiss
   /// Used to follow various web links.
   @Environment(\.openURL) private var openURL
   /// Signals that the tension specifications pdf should be displayed.
   @State private var showSpec: Bool = false
   /// Signals that the sheet to share the app should be displayed.
   @State private var showShareApp: Bool = false
   /// Base URL for this app on the App Store
   private let appUrl = "https://apps.apple.com/us/app/tensity/id1631745251"

   private var appVersion: String {
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
   }

   private var buildNumber: String {
      Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
   }

   private var specUrl: URL? {
      Bundle.main.url(forResource: "String Tension Specifications", withExtension: "pdf")
   }

   var body: some View {
      NavigationView {
         Form {
            HStack {
               Image("tensity_76x76")
                  .padding(.trailing, 5)
               VStack(alignment: .leading) {
                  Text("Tensity")
                     .font(.title)
                  Text("© 2022 Stephen E. Bensley\nVersion \(appVersion), build \(buildNumber)")
                     .font(.footnote)
               }
            }

            Section {
               ActionItem(
                  leftSymbol: "hand.raised",
                  text: "Read the privacy policy",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: "https://www.stephenbensley.com/privacy_tensity") {
                     openURL(url)
                  }
               }
            } header: {
               Text("This app does not collect or share any personal information.")
            }
            .textCase(nil)

            Section {
               ActionItem(
                  leftSymbol: "globe",
                  text: "Visit D'Addario on the web",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: "http://www.daddario.com") {
                     openURL(url)
                  }
               }
               ActionItem(
                  leftSymbol: "doc",
                  text: "View the specifications",
                  rightSymbol: "chevron.right"
               ) {
                  showSpec = true
               }
            } header: {
               Text("""
                    The string tension specifications used by this app were provided by D'Addario. \
                    However, this app is neither affiliated with nor endorsed by D'Addario.
                    """)
            }
            .textCase(nil)

            Section {
               ActionItem(
                  leftSymbol: "doc.plaintext",
                  text: "Read the license",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: "https://github.com/stephenbensley/Tensity/blob/main/LICENSE") {
                     openURL(url)
                  }
               }
               ActionItem(
                  leftSymbol: "icloud.and.arrow.down",
                  text: "Download the source code",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: "https://github.com/stephenbensley/Tensity") {
                     openURL(url)
                  }
               }
            } header: {
               Text("""
                    The source code for this app has been released under the MIT License and is \
                    hosted on GitHub.
                    """)
            }
            .textCase(nil)

            Section {
               ActionItem(
                  leftSymbol: "star",
                  text: "Rate this app",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: appUrl + "?action=write-review") {
                     openURL(url)
                  }
               }
               ActionItem(
                  leftSymbol: "square.and.arrow.up",
                  text: "Share this app",
                  rightSymbol: "chevron.right"
               ) {
                  showShareApp = true
               }
               ActionItem(
                  leftSymbol: "mail",
                  text: "Contact the developer",
                  rightSymbol: "link"
               ) {
                  if let url = URL(string: "https://www.stephenbensley.com/contact") {
                     openURL(url)
                  }
               }
            }
         }
         .navigationBarTitleDisplayMode(.inline)
         .fullScreenCover(isPresented: $showSpec) {
            if let url = specUrl {
               PdfReader(url: url)
            }
         }
         .sheet(isPresented: $showShareApp) {
            if let url = URL(string: appUrl) {
               ShareSheetView(url: url)
            }
         }
         .toolbar {
            Button("Done") { dismiss() }
         }
      }
   }
}

struct AboutView_Previews: PreviewProvider {
   static var previews: some View {
      AboutView()
   }
}
