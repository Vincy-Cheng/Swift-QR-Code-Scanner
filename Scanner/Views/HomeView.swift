//
//  ButtonListView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/2/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToPurchaseLog = false
    @State private var navigateToManageOwner = false
   
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(){
                    ListItemView()
                        .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.height * 2/3,
                                        alignment: .topLeading
                                    )
       
                    CalculateView().padding(.bottom)
                    
                    
                }
                .navigationTitle("Products")
                .navigationDestination(
                    isPresented: $navigateToPurchaseLog) {
                        ListPurchaseLogView()
                    }.navigationDestination(
                        isPresented: $navigateToManageOwner) {
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
//                                    Button("Purchase Log", action: { navigateToPurchaseLog = true
//                                    })
                                    
                                    Button("Manage Owner", action: { navigateToManageOwner = true
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
                
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .topLeading
                        )
                 
                
            }
            
            
        }
    }
}

#Preview {
    HomeView()
}
