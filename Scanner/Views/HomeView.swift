//
//  ButtonListView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/2/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var selectedItems: [Item] = []
    @State private var needsRefresh: Bool = false
    
    @Environment (\.managedObjectContext) var managedObjectContext
    @StateObject private var ownerController = OwnerController()
    @StateObject private var categoryController = CategoryController()
    @StateObject private var itemController = ItemController()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Set no space between 2 view
                VStack(spacing: 0){
                    GridItemView(selectedItems: $selectedItems, needRefresh: $needsRefresh)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 2/3,
                            alignment: .topLeading
                        ).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .clipShape(RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25))
                    
                    CalculateView(selectedItems: $selectedItems)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height / 3,
                            alignment: .topLeading
                        ).background(Color(uiColor: UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)))
                    
                    
                }
                .background(Color(uiColor: UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        
                        Text("Booths")
                            .font(.title)
                            .foregroundColor(.primary)
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            NavigationLink {
                                ListOwnerView()
                                
                            } label: {
                                Text("Manage Owner")
                            }
                            NavigationLink {
                                ListCategoryView()
                                
                            } label: {
                                Text("Manage Category")
                            }
                            NavigationLink {
                                ListItemView()
                                
                            } label: {
                                Text("Manage Item")
                            }
                            NavigationLink {
                                ListTransactionView()
                                
                            } label: {
                                Text("Records")
                            }
                            Button(action: {
                                // Minus action
//                                let index = selectedItems.firstIndex(of: item)
//                                if(index != nil){
//                                    selectedItems.remove(at: index!)
//                                }
                                
                            }) {
                                Text("Pre-insert items")
//                                Image(systemName: "minus.circle.fill")
//                                    .foregroundColor(Color(uiColor: UIColor(red: 120/255, green: 108/255, blue: 255/255, alpha: 1)))
//                                    .font(.system(size: 28))
                            }
                            
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
                .onAppear{
                    needsRefresh.toggle()
                }
            }
            
            
        }
    }
    
    private func preInsert(){
//        let items:[ItemData] = [ItemData(name: "", price: 0, quantity: 0, status: ItemStatus.available, imageURL: "", category: Category, owner: Owner)]
    }
}

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
}
