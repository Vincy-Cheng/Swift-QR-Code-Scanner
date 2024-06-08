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
    @State private var navigateToManageCategory = false
    
    @State private var selectedItems: [Item] = []
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Set no space between 2 view
                VStack(spacing: 0){
                    GridItemView(selectedItems: $selectedItems)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 2/3,
                            alignment: .topLeading
                        )
                    
                    CalculateView(selectedItems: $selectedItems)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height / 3,
                            alignment: .topLeading
                        ).background(Color.white)
                    
                    
                }
                .navigationDestination(
                    isPresented: $navigateToPurchaseLog) {
                        ListPurchaseLogView()
                    }.navigationDestination(
                        isPresented: $navigateToManageOwner) {
                            ListOwnerView()
                        }.navigationDestination(
                            isPresented: $navigateToManageCategory) {
                                ListCategoryView()
                            }
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    
                                    Text("Booths")
                                        .font(.title)
                                        .foregroundColor(.primary)
                                    
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Menu {
                                        //                                    Button("Purchase Log", action: { navigateToPurchaseLog = true
                                        //                                    })
                                        Button("Manage Owner", action: { navigateToManageOwner = true
                                        })
                                        Button("Manage Category", action: { navigateToManageCategory = true
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
                            .toolbarBackground(Color(uiColor: UIColor(red: 173/255, green: 194/255, blue: 223/255, alpha: 1)), for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
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
