//
//  ContentView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/25/23.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @State var isPresentingScannerView = false
//    @State var scannedQRCode: String = "Scan QR Code"
    
    @State private var parsedProducts: [Product] = []
    
    var scanner: some View {
        VStack{
            
            CodeScannerView(codeTypes: [.qr], completion: { result in
                if case let .success(code) = result {
//                    self.scannedQRCode = code.string
                    self.parsedProducts.append(parseJSON(from: code.string)!)
                    self.isPresentingScannerView = false
                }})
            Button("Exit"){
                self.isPresentingScannerView = false
            }
        }
    }
    
    // TODO: Move CodeScanner part to ScannerView
    // TODO: Create a purchase log (store in local)
    //       Able to be deleted
    // TODO: Create purchase log view
    
    var body: some View {
        VStack {
            
//            Text(scannedQRCode)
            Button("Scan QR Code with Camera"){
                self.isPresentingScannerView = true
            }
            .sheet(isPresented: $isPresentingScannerView){
                self.scanner
            }
//            Text("items:\(parsedProducts.count)")
        }
    }
}

#Preview {
    ContentView()
}
