//
//  ListUserView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/3/24.
//

import SwiftUI

struct ListOwnerView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var owners: FetchedResults<Owner>
    //    @State private var isShowingModal = false
    @State private var isShowingAlert = false
    @State private var inputText = ""
    
    var body: some View {
        VStack(content: {
            TextField("Enter owner name", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        })
    }
}
