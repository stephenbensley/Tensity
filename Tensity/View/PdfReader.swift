//
// Copyright 2022 Stephen E. Bensley
//
// This file is licensed under the MIT License. You may obtain a copy of the
// license at https://github.com/stephenbensley/Tensity/blob/main/LICENSE.
//

import PDFKit
import SwiftUI

/// Wraps UIKit's UIActivityViewController to display a share sheet.
struct ShareSheetView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let items = [url]
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) { }

    typealias UIViewControllerType = UIActivityViewController
}

/// Wrapper around UIKit's PDFView
struct PdfView: UIViewRepresentable {
    let url: URL

    func makeUIView(
        context: UIViewRepresentableContext<PdfView>
    ) -> PdfView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(
        _ uiView: UIView,
        context: UIViewRepresentableContext<PdfView>
    ) { }
}

/// Allows the user to read and share a PDF.
struct PdfReader: View {
    @Environment(\.dismiss) var dismiss
    let url: URL
    @State var showShareSheet = false

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Spacer()

                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                Button("Done") { dismiss() }
            }
            .padding()

            PdfView(url: url)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView(url: url)
        }
    }
}

struct PdfReader_Previews: PreviewProvider {
    static var url = Bundle.main.url(
        forResource: "String Tension Specifications",
        withExtension: "pdf"
    )
    static var previews: some View {
        PdfReader(url: url!)
    }
}
