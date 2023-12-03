//
//  ScannerView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/28/23.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    // TODO: Create the Confirm button to make purchase log
    @Binding var isPresentingScannerView:Bool
    @State private var parsedProducts: [Product] = []
    
    private var totalValue: Double {
        parsedProducts.reduce(0) { $0 + $1.value }
    }
    
    private var formattedTotalValue: String {
        String(format: "%.2f", totalValue)
    }
    
    private func removeProduct(at index: Int) {
        parsedProducts.remove(at: index)
    }
    
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
            
            .frame(height: UIScreen.main.bounds.height / 3)
            Text("Total Value: \(formattedTotalValue)") // Displaying the formatted total value
                .font(.headline)
                .padding()
            List {
                ForEach(Array(parsedProducts.enumerated()), id: \.1.id) { index, product in
                    HStack(){
                        Text("Item \(index+1)")
                        VStack(alignment: .leading){
                            Text("Product Name: \(product.name)")
                            Text("Owner: \(product.owner)")
                            
                            Text("Price: HKD$\(String(format: "%.2f", product.value))")
                            
                        }.frame(maxWidth: .infinity)
                        Button(action: {
                            removeProduct(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                }
            }
            
            Spacer()
        }
        
    }
}
