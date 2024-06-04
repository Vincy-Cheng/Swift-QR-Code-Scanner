//
//  AddPurchaseLogView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/3/23.
//

import SwiftUI

struct AddPurchaseLogView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    
    @Binding var parsedProducts: [Product]
    @Binding var isPresentingScannerView:Bool
    
    @State private var showAlert = false
    
    var body: some View {
        Button("Complete"){
            // Add purchase log only if the length of the product list > 0 and able to encode the product list
            if parsedProducts.count > 0 , let content = stringifyObject(products: parsedProducts){
                PurchaseLogController().addLog(content:content  , context: managedObjectContext)
                isPresentingScannerView = false
                print(content)
                
            }else{
                showAlert = true
            }
        }.alert(isPresented: $showAlert) {
            // Alert user if there is no item is added
            Alert(
                title: Text("Warning"),
                message: Text("There is no item"),
                dismissButton: .default(Text("OK")) {
                    showAlert = false // Dismiss the alert when OK is tapped
                }
            )
        }
    }
}
