//
//  PaymentView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/9/24.
//

import SwiftUI

let paymentBgColor = Color(uiColor: UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1))
let paymentFontColor = Color(uiColor: UIColor(red: 203 / 255, green: 203 / 255, blue: 203 / 255, alpha: 1))

struct PaymentMethod: Identifiable {
  var id = UUID()
  let name: String
  let color: Color

  init(id: UUID = UUID(), name: String, color: Color) {
    self.id = id
    self.name = name
    self.color = color
  }
}

struct PaymentView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode
  @Binding var selectedItems: [Item]
  @State var options: [PaymentMethod] = [
    PaymentMethod(name: "Cash", color: Color.yellow),
    PaymentMethod(name: "Payme", color: Color.red),
    PaymentMethod(name: "支付寶", color: Color.blue),
    PaymentMethod(name: "FPS", color: Color.green)
  ]
  @State private var selectedMethod: PaymentMethod?
  @State private var inputValue: Int = 0
  @State private var isConfirm = false

  var body: some View {
    VStack {
      HStack {
        paymentMethod
        Spacer()
        countingView
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isConfirm = true
          }) {
            HStack(alignment: .center) {
              Text("Save to record")
              Image(systemName: "square.and.arrow.down")
                .foregroundColor(
                  inputValue -
                    sumUp(groupedItems: groupItems(selectedItems: selectedItems)) < 0 ? Color.gray : Color
                    .blue
                )
            }
          }
          .disabled(inputValue - sumUp(groupedItems: groupItems(selectedItems: selectedItems)) < 0)
        }
      }
      .onAppear {
        selectedMethod = options[0]
      }
    }.alert(isPresented: $isConfirm) {
      Alert(
        title: Text("Warning"),
        message: Text("Confirm the items?"),
        primaryButton: .destructive(Text("Confirm")) {
          if TransactionController().addTransaction(
            context: managedObjectContext,
            payment: selectedMethod!.name,
            paid: Double(inputValue),
            items: selectedItems
          ) {
            for item in selectedItems {
              ItemController().updateTransactionItemQuantity(
                context: managedObjectContext,
                item: item,
                quantity: 1
              )
            }
          }
          selectedItems = []
          presentationMode.wrappedValue.dismiss()
        },
        secondaryButton: .cancel()
      )
    }
  }

  private var paymentMethod: some View {
    // Calculate the maximum width of the text items
    let maxWidth: CGFloat = options.map { option in
      (option.name as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
        .width
    }.max() ?? 0

    return VStack(alignment: .leading) {
      ForEach(options) { option in
        HStack(spacing: 0) {
          Button(action: {
            if selectedMethod?.id != option.id {
              selectedMethod = option // Select this method
            }
          }) {
            Text(option.name)
              .foregroundStyle(option.color)
              .padding(.vertical)
              .padding(.leading) // Add padding only to the left side
              .frame(width: maxWidth + 64, alignment: .leading) // Added padding to max width
          }
          .background(
            RoundedCornersShape(corners: [.topRight, .bottomRight], radius: 25)
              .fill(Color.white)
              .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
          )
          .clipShape(RoundedCornersShape(corners: [.topRight, .bottomRight], radius: 25))

          // Text field hidden by default, only shown when selectedMethod == option
          if selectedMethod?.id == option.id {
            TextField("Enter value", value: $inputValue, formatter: formatter())
              .keyboardType(.numberPad)
              .foregroundColor(.gray)
              .background(paymentFontColor)
              .clipShape(RoundedCornersShape(corners: [.topRight, .bottomRight], radius: 25))
              .frame(width: 32, alignment: .leading)
              .transition(.opacity)
              .padding()
          }
        }.background(selectedMethod?.id == option.id ? paymentFontColor : paymentBgColor)
          .clipShape(RoundedCornersShape(corners: [.topRight, .bottomRight], radius: 25))
      }
      Spacer()
    }.padding(.vertical)
  }

  private var countingView: some View {
    return VStack(alignment: .leading) {
      HStack {
        Text("Total").foregroundStyle(.black).font(.title)
        Spacer()
        Text("$\(sumUp(groupedItems: groupItems(selectedItems: selectedItems)))").foregroundStyle(.gray)
          .font(.title)
      }
      Divider()
      HStack {
        Text("Payment").foregroundStyle(.gray)
        Spacer()
        Text("\(selectedMethod?.name ?? "Unknown payment")")
          .foregroundStyle(selectedMethod?.color ?? Color.gray)
      }
      Divider()
      HStack {
        Text("Paid").foregroundStyle(.gray)
        Spacer()
        Text("$\(inputValue)").foregroundStyle(.gray)
      }
      Divider()
      HStack {
        Text("Payback").foregroundStyle(.gray)
        Spacer()
        Text("$\(inputValue - sumUp(groupedItems: groupItems(selectedItems: selectedItems)))")
          .foregroundStyle(.gray)
      }
      Spacer()
    }.padding()
  }
}
