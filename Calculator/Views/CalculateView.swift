//
//  CalculateView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import SwiftUI

struct ItemCount {
    var itemDetail: Item
    var items: [Item]
}

struct CalculateView: View {
    @Binding var selectedItems: [Item]
    @State private var isValid = false
    @State private var navigateToCreateTransaction = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack{
                    
                    ItemsListView(selectedItems: $selectedItems,color: Color.black)
                        .onChange(of: selectedItems) { newItems in
                                                validateSelectedItems(newItems)
                                            }
                    
                    DashedLineView()
                    
                    VStack(){
                        HStack{
                            Text("Total").foregroundStyle(.black).padding(.horizontal,10)
                            Text("$\(sumUp(groupedItems: groupItems(selectedItems: selectedItems)))").foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    Spacer()
                    
                    NavigationLink {
                        CreateTransactionView(selectedItems: $selectedItems)
                        
                    } label: {
                        HStack{
                           
                            if isValid{
                                Text("Next").font(.title).foregroundStyle(primaryColor)
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(primaryColor)
                            }else{
                                Text("Next").font(.title).foregroundStyle(.gray)
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    .padding(.vertical)
                    .disabled(!isValid)
                    
                    
                }.padding()
            } .onAppear {
                validateSelectedItems(selectedItems) // Validate initial state
            }
            
        }
    }
    // Function to validate selected items
        private func validateSelectedItems(_ items: [Item]) {
            // Update isValid based on your criteria
            isValid = !items.isEmpty
        }
    
}

func groupItems(selectedItems:[Item]) -> [ItemCount] {
    var groups:[ItemCount] = []
    
    for item in selectedItems {
        if let groupIndex = groups.firstIndex(where: {$0.itemDetail.name == item.name!}){
            groups[groupIndex].items.append(item)
        }else{
            groups.append(ItemCount(itemDetail: item, items: [item]))
        }
    }
    
    return groups
}

func sumUp(groupedItems:[ItemCount]) -> Int {
    var total = 0
    
    for group in groupedItems {
        total += Int(group.itemDetail.price) * group.items.count
    }
    
    return total
    
}

struct ItemsListView:View {
    @Binding var selectedItems: [Item]
    @State var color: Color
    
    var body: some View {
        Text("Item List").font(.title).foregroundStyle(color).frame(maxWidth: .infinity, alignment: .leading)
        let groupedItems = groupItems(selectedItems: selectedItems)
        
        ForEach(groupedItems, id: \.itemDetail) { group in
            HStack{
                Text("\(group.items.count)x   \(group.itemDetail.name!)").foregroundStyle(color)
                Spacer()
                Text("$\(group.items.count * Int(group.itemDetail.price))").foregroundStyle(color)
            }
        }
    }
}

struct DashedLineView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 1))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 1))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
            .foregroundColor(.gray)
            .frame(height: 2)
            .padding(.trailing) // Adjust the horizontal padding as needed
        }
    }
}

