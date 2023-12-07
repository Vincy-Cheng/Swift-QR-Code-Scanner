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
    @State var parsedProducts: [Product] = []
    
    private var totalValue: Double {
        parsedProducts.reduce(0) { $0 + $1.value }
    }
    
    private var formattedTotalValue: String {
        String(format: "%.2f", totalValue)
    }
    
    private func removeProduct(name:String) {
        if let index = parsedProducts.firstIndex(where: { $0.name == name } )
        {
            // Use the index found
            parsedProducts.remove(at: index)
        } else {
            // Handle the case where the name is not found
            print("Name not found in parsedProducts")
        }
    }
    
    private func addProduct(product:Product){
        parsedProducts.append(Product(value: product.value, name: product.name, owner: product.owner))
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
                    self.parsedProducts.append(contentsOf:parseJSON(from: code.string)!)
                    
                }
            })
            .frame(height: UIScreen.main.bounds.height / 3)
            
            AddPurchaseLogView(parsedProducts: $parsedProducts,isPresentingScannerView: $isPresentingScannerView)
            
            Text("Total Value: \(formattedTotalValue)") // Displaying the formatted total value
                .font(.headline)
                .padding()
            
            
            List {
                let groupedProduct = Dictionary(grouping: parsedProducts) { $0.name }
                
                ForEach(groupedProduct.sorted(by: { $0.key < $1.key }), id: \.key) { name, product in
                    
                    let index = groupedProduct.keys.sorted().firstIndex(of: name) ?? 0
                    
                    HStack(alignment: .center){
                        Text("\(index + 1)")
                        Spacer().frame(width: 20)
                        VStack(alignment: .leading) {
                            Text("Product Name: \(product[0].name)")
                            Text("Owner: \(product[0].owner)")
                            Text("Price: HKD$\(String(format: "%.2f", product[0].value))")
                        }
                        
                        Spacer()
                        // Weird response
                        // When user tap on any button, it will process all the action
                        // Need to use onTapGesture instead of action
                        // https://stackoverflow.com/questions/58514891/two-buttons-inside-hstack-taking-action-of-each-other
                        Button(action: {}) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                        }
                        .onTapGesture {
                            addProduct(product: product[0])
                        }
                        
                        Text("\(product.count)")
                        
                        Button(action: {}) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                        .onTapGesture {
                            removeProduct(name: name)
                        }
                        
                    }
                }
            }
            
            
            Spacer()
        }
        
    }
}


