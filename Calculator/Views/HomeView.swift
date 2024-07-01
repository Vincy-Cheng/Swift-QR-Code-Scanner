//
//  HomeView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/2/24.
//

import CoreData
import SwiftUI

let primaryColor: Color = .init(uiColor: UIColor(red: 120 / 255, green: 108 / 255, blue: 255 / 255, alpha: 1))

struct HomeView: View {
  @State private var selectedItems: [Item] = []
  @State private var needsRefresh: Bool = false

  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var ownerController = OwnerController()
  @StateObject private var categoryController = CategoryController()
  @StateObject private var itemController = ItemController()

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        // Set no space between 2 view
        VStack(spacing: 0) {
          GridItemView(selectedItems: $selectedItems, needRefresh: $needsRefresh)
            .frame(
              width: geometry.size.width,
              height: geometry.size.height * 2 / 3,
              alignment: .topLeading
            )
            .clipShape(RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25))

          CalculateView(selectedItems: $selectedItems)
            .frame(
              width: geometry.size.width,
              height: geometry.size.height / 3,
              alignment: .topLeading
            ).background(Color(uiColor: UIColor(
              red: 233 / 255,
              green: 233 / 255,
              blue: 233 / 255,
              alpha: 1
            )))
        }
        .background(Color(uiColor: UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1)))
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
                Label(
                  title: { Text("Manage Owner") },
                  icon: { Image(systemName: "person") }
                )
              }
              NavigationLink {
                ListCategoryView()

              } label: {
                Label(
                  title: { Text("Manage Category") },
                  icon: { Image(systemName: "folder") }
                )
              }
              NavigationLink {
                ListItemView()

              } label: {
                Label(
                  title: { Text("Manage Item") },
                  icon: { Image(systemName: "list.bullet.clipboard") }
                )
              }
              NavigationLink {
                ListTransactionView()

              } label: {
                Label(
                  title: { Text("Records") },
                  icon: { Image(systemName: "plus.magnifyingglass") }
                )
              }
              Button(action: {
                preInsert()
              }, label: {
                Label(
                  title: { Text("Pre-insert items") },
                  icon: { Image(systemName: "cart") }
                )
              })

            } label: {
              // Icon for the Menu Button
              Image(systemName: "list.bullet")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(primaryColor)
            }
          }
        }
        .toolbarBackground(
          Color(uiColor: UIColor(red: 173 / 255, green: 194 / 255, blue: 223 / 255, alpha: 1)),
          for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .frame(
          width: geometry.size.width,
          height: geometry.size.height,
          alignment: .topLeading
        )
        .onAppear {
          needsRefresh.toggle()
        }
      }
    }
  }

  private func preInsert() {
    let inital = OwnerController().findAllOwners(context: managedObjectContext)
    if inital.isEmpty {
      for data in preInsertData {
        let owner = OwnerController().preInsertOwner(context: managedObjectContext, name: data.ownerName)

        for item in data.items {
          let category = CategoryController().preInsertCategory(
            context: managedObjectContext,
            name: item.categoryName
          )

          let itemData = ItemData(
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            status: ItemStatus.available,
            imageURL: "",
            category: category,
            owner: owner
          )
          _ = itemController.addItem(context: managedObjectContext, data: itemData)
        }
      }

      needsRefresh.toggle()
    }
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

struct PerInsertData {
  let ownerName: String
  let items: [PerInsertItemData]
}

struct PerInsertItemData {
  let name: String
  let price: Double
  let quantity: Int
  let categoryName: String
}

#Preview {
  HomeView()
}

let preInsertData = [
  PerInsertData(
    ownerName: "Wmc",
    items: [
      PerInsertItemData(
        name: "透明魷魚掛件",
        price: 25,
        quantity: 180,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Random 透明魷魚掛件",
        price: 20,
        quantity: 180,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "透明魷魚掛件(Set)",
        price: 200,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "打工磁石貼",
        price: 30,
        quantity: 25,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "偶像串串",
        price: 25,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "糖果包",
        price: 35,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "打工鐳射掛件",
        price: 25,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "大集合包(Random透明魷魚掛件x1+打工磁石貼+打工鐳射掛件)",
        price: 100,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "打工袋",
        price: 65,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "迷宮飯磁石貼",
        price: 85,
        quantity: 50,
        categoryName: "迷宮飯"
      ),
    ]
  ),
  PerInsertData(
    ownerName: "y",
    items: [
      PerInsertItemData(
        name: "KDA 貼紙（新同舊同價）",
        price: 25,
        quantity: 34,
        categoryName: "lol"
      ),
      PerInsertItemData(
        name: "Yummi 掛件 + 貼紙",
        price: 20,
        quantity: 15,
        categoryName: "lol"
      ),
      PerInsertItemData(
        name: "Zelda 掛件",
        price: 70,
        quantity: 50,
        categoryName: "Zelda"
      ),
      PerInsertItemData(
        name: "Splat 小袋",
        price: 40,
        quantity: 20,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Splat 3 Poster",
        price: 20,
        quantity: 100,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Splat 3 明信片組 (冇貼紙）",
        price: 20,
        quantity: 100,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Splat 3 B6 貼紙",
        price: 10,
        quantity: 100,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Splat Octo  掛件 White + Black",
        price: 50,
        quantity: 100,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Splat Octo  掛件 Black",
        price: 30,
        quantity: 50,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(
        name: "Chili 辛俐立牌",
        price: 70,
        quantity: 19,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "御三家小卡",
        price: 10,
        quantity: 30,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "草貓貼紙+ 小相框",
        price: 10,
        quantity: 24,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "烏波組合  （3 隻）",
        price: 60,
        quantity: 100,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "烏波單隻",
        price: 25,
        quantity: 20,
        categoryName: "Pokemon"
      ),
    ]
  ),
  PerInsertData(
    ownerName: "Ge",
    items: [
      PerInsertItemData(
        name: "古魯夏立牌",
        price: 70,
        quantity: 12,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "奇樹立牌",
        price: 70,
        quantity: 12,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "瑪力露麗",
        price: 25,
        quantity: 16,
        categoryName: "Pokemon"
      ),
      PerInsertItemData(
        name: "Koharu 立牌",
        price: 70,
        quantity: 30,
        categoryName: "BA"
      ),
    ]
  ),
  PerInsertData(
    ownerName: "Chow",
    items: [
      PerInsertItemData(
        name: "Holo 飯友立牌",
        price: 15,
        quantity: 10,
        categoryName: "Hololive"
      ),
      PerInsertItemData(
        name: "Holo 立牌",
        price: 45,
        quantity: 2,
        categoryName: "Hololive"
      ),
      PerInsertItemData(
        name: "Splatoon 掛件扣針",
        price: 35,
        quantity: 10,
        categoryName: "Splatoon"
      ),
      PerInsertItemData(name: "水藝大師飯友立牌", price: 45, quantity: 3, categoryName: "MH"),
      PerInsertItemData(
        name: "Ina post card",
        price: 10,
        quantity: 10,
        categoryName: "Hololive"
      ),
      PerInsertItemData(
        name: "Holo 鎖匙扣",
        price: 35,
        quantity: 6,
        categoryName: "Hololive"
      ),
      PerInsertItemData(name: "迷宮飯立牌", price: 80, quantity: 50, categoryName: "迷宮飯"),
      PerInsertItemData(name: "迷宮飯小卡", price: 15, quantity: 80, categoryName: "迷宮飯"),
      PerInsertItemData(name: "迷宮飯貼紙", price: 10, quantity: 50, categoryName: "迷宮飯"),
      PerInsertItemData(name: "迷宮飯雀扣", price: 10, quantity: 50, categoryName: "迷宮飯"),
      PerInsertItemData(
        name: "迷宮飯大禮包(迷宮飯立牌+迷宮飯小卡+迷宮飯貼紙+迷宮飯雀扣)",
        price: 100,
        quantity: 100,
        categoryName: "迷宮飯"
      ),
    ]
  )
]
