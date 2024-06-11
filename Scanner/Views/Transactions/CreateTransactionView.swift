//
//  CreateTransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/9/24.
//

import SwiftUI

struct CreateTransactionView: View {
    @Binding var selectedItems: [Item]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Top 2/3 colored and scrollable section with shadow
                        ZStack {
                            // Background and shadow
                            RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25)
                                .fill(Color(uiColor: UIColor(red: 173/255, green: 194/255, blue: 223/255, alpha: 1)))
                                .frame(width: geometry.size.width, height: geometry.size.height * 2/3)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            // Scrollable content
                            
                            VStack {
                                ItemsListView(selectedItems: $selectedItems,color: Color.white)
                                    .padding(.horizontal)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 2/3, alignment: .topLeading)
                            .clipShape(RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25))
                            
                            
                        }
                        
                        // Bottom 1/3 section
                        PaymentView(selectedItems: $selectedItems)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .toolbarBackground(Color(uiColor: UIColor(red: 173/255, green: 194/255, blue: 223/255, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color(uiColor: UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)))
        }
    }
}
