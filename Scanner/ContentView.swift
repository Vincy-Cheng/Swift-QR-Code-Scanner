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
                ScannerView(isPresentingScannerView: $isPresentingScannerView)
            }
//            Text("items:\(parsedProducts.count)")
        }
    }
}

#Preview {
    ContentView()
}
