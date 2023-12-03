//
//  ListPurchaseLogView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/3/23.
//

import SwiftUI
import CoreData

struct ListPurchaseLogView:View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var purchaseLogs: FetchedResults<PurchaseLog>
    
    @State private var showAlert = false
    
    // TODO: Complete the display view format
    //     - Group by date
    //     - Navigation to view detail
    //     - Delete option
    
    // Only need to view and delete (or may be update)
    var body: some View{
        VStack(alignment: .leading)
        {
            Text("\(purchaseLogs.count)")
            List{
                ForEach(purchaseLogs) {
                    log in VStack(alignment:.leading){
                        Text("Test")
                        Button(action: {
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Confirm Deletion"),
                                message: Text("Confirm to delete this record"),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Call the deletion function here
                                    managedObjectContext.delete(log)
                                    DataController().save(context: managedObjectContext)
                                },
                                secondaryButton: .cancel()
                                
                            )
                        }
                    }
                }
            }
        }    }
}

struct ListPurchaseLogView_Previews:PreviewProvider{
    static var previews: some View{
        ListPurchaseLogView()
    }
}
