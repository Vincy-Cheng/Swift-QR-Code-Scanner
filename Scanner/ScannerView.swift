//
//  ScannerView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/28/23.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    // TODO: Display the added item
    // TODO: Able to delete the item
    // TODO: Display the total
    // TODO: Create the Confirm button to make purchase log
    @Binding var isPresentingScannerView:Bool
    @State private var parsedProducts: [Product] = []

    
    var body: some View{
        VStack{
            HStack {
                Spacer() // Pushes the button to the right end of the HStack
                Button("Exit"){
                    self.isPresentingScannerView = false
                }
                            .padding()
                        }
            
            CodeScannerView(codeTypes: [.qr],scanMode: ScanMode.continuous, completion: { result in
                if case let .success(code) = result {
                    self.parsedProducts.append(parseJSON(from: code.string)!)
                    
                }
                })
                
            .frame(height: UIScreen.main.bounds.height / 2)
            Text("items:\(parsedProducts.count)")
            
            Spacer()
        }
        
    }
}
