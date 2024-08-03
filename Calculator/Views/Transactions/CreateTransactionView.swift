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
        VStack {
          // Top 2/3 colored and scrollable section with shadow
          ScrollView {
            VStack(alignment: .leading) {
              ItemsListView(selectedItems: $selectedItems, color: Color.white)
                .padding(.horizontal)
            }
            .clipShape(RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
          }
          .background(Color.markBG2)
          .frame(width: geometry.size.width, height: geometry.size.height * 1 / 2, alignment: .topLeading)
          .clipShape(RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 25))
          .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)

          Spacer()

          PaymentView(selectedItems: $selectedItems)
            .frame(maxWidth: .infinity)
        }
      }

      .onTapGesture {
        UIApplication.shared.sendAction(
          #selector(UIResponder.resignFirstResponder),
          to: nil,
          from: nil,
          for: nil
        )
      }
      .toolbarBackground(
        Color.markBG2,
        for: .navigationBar
      )
      .toolbarBackground(.visible, for: .navigationBar)
      .background(Color(uiColor: UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1)))
    }
  }
}
