//
//  ButtonListView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/2/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToPurchaseLog = false
    @State private var navigateToManageUser = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // Your main content goes here
                Text("Hello, World!")
                    .padding()
                    .hidden()
                
            }
            .navigationDestination(
                isPresented: $navigateToPurchaseLog) {
                    ListPurchaseLogView()
                }.navigationDestination(
                    isPresented: $navigateToManageUser) {
                        ListOwnerView()
                    }
            
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Custom Title")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Purchase Log", action: { navigateToPurchaseLog = true
                                })
                                
                                Button("Manage User", action: { navigateToManageUser = true
                                })
                                
                            } label: {
                                // Icon for the Menu Button
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            
            
        }
    }
}

#Preview {
    HomeView()
}
