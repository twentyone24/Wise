//
//  PDFView.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/16/20.
//

import SwiftUI
import PDFKit
import PDFViewer
struct PDFKitView : UIViewRepresentable {
    
    var url: URL?
    
    func makeUIView(context: Context) -> UIView {
        let pdfView = PDFView()

        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}


struct PDFProvider: View, DownloadManagerDelegate {
    
    @State private var viewRemotePDF = false
    @State private var loadingPDF: Bool = false
    @State private var progressValue: Float = 0.0
    @ObservedObject var downloadManager = DownloadManager.shared()
    @Binding var openFile: Bool
    let pdfUrlString: String
    
    
    var body: some View {
        
        ZStack (alignment: .top) {
            
            ZStack {
                if viewRemotePDF {
                    PDFViewer(pdfUrlString: self.pdfUrlString) }
                ProgressView(value: self.$progressValue, visible: self.$loadingPDF)
            }
            
            HStack {
                Button(action: {
                    self.openFile.toggle()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            
        }
        
        .onAppear() {
            print(pdfUrlString)
            if self.fileExistsInDirectory() {
                self.viewRemotePDF = true
            } else {
                self.downloadPDF(pdfUrlString: self.pdfUrlString)
            }
        }
    }
    
    private func fileExistsInDirectory() -> Bool {
        if let cachesDirectoryUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first, let lastPathComponent = URL(string: self.pdfUrlString)?.lastPathComponent {
            let url = cachesDirectoryUrl.appendingPathComponent(lastPathComponent)
            if FileManager.default.fileExists(atPath: url.path) {
                return true
            }
        }
        return false
    }
    
    private func downloadPDF(pdfUrlString: String) {
        guard let url = URL(string: pdfUrlString) else { return }
        downloadManager.delegate = self
        downloadManager.downloadFile(url: url)
    }
    
    //MARK: DownloadManagerDelegate
    func downloadDidFinished(success: Bool) {
        if success {
            loadingPDF = false
            viewRemotePDF = true
        }
    }
    
    func downloadDidFailed(failure: Bool) {
        if failure {
            loadingPDF = false
            print("PDFCatalogueView: Download failure")
        }
    }
    
    func downloadInProgress(progress: Float, totalBytesWritten: Float, totalBytesExpectedToWrite: Float) {
        loadingPDF = true
        progressValue = progress
    }
}
