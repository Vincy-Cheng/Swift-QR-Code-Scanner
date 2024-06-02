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
    
    var body: some View {
        ButtonListView()
//        NavigationView{
//            VStack(spacing: 20){
//                NavigationLink {
//                    // destination view to navigation to
//                    ListPurchaseLogView()
//                } label: {
//                    Text("View Purchase History")
//                }
//                NavigationLink {
//                    // destination view to navigation to
//                    ButtonListView()
//                } label: {
//                    Text("Button List")
//                }
//                Button("Scan QR Code with Camera"){
//                    self.isPresentingScannerView = true
//                }
//                .sheet(isPresented: $isPresentingScannerView){
//                    ScannerView(isPresentingScannerView: $isPresentingScannerView)
//                }
//                
//            }
//        }
        
    }
}
#Preview {
    ContentView()
}
