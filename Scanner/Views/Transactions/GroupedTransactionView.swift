//
//  GroupedTransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/11/24.
//

import SwiftUI

struct GroupedTransactionView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @StateObject private var transactionController = TransactionController()
    @StateObject private var itemController = ItemController()
    @State private var transactions: [Transaction] = []
    @State private var groupingMethod: String = ""
    let options = ["date","all"]
    
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    Text("Records")
                        .font(.title)
                        .foregroundStyle(Color(uiColor: UIColor(red: 120/255, green: 108/255, blue: 255/255, alpha: 1)))
                        .padding()
                    
                    
                    
                    Picker("Select the grouping method", selection: $groupingMethod) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing)
                    
                    
                }
                if groupingMethod == "date" {
                    datePicker
                        .padding(.horizontal)
                }
                VStack{
                    
                }.frame(width: 120,height: 120)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                if groupingMethod.isEmpty {
                    groupingMethod = options[0]
                }
            }
        
    }
    
    private var datePicker: some View {
        return DatePicker(
            "Select a date",
            selection: $selectedDate,
            in: ...Date.now,
            displayedComponents: .date
        )
        .datePickerStyle(CompactDatePickerStyle()) // Adjust style as needed
        .labelsHidden() // Hide labels if you only want the picker
        
    }
    
    private func fetchTransactions() {
        let transaction = transactionController.findAllTransaction(context: managedObjectContext)
        transactions = transaction
        print(transaction)
    }
}

func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy - HH:mm:ss"
    return dateFormatter.string(from: date)
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dashes: [CGFloat] = [5, 5] // Dash pattern: 5 points on, 5 points off
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path.strokedPath(.init(lineWidth: 1, dash: dashes, dashPhase: 0))
    }
}

//struct ReceiptBackground: View {
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<20) { _ in // Adjust the number of lines as needed
//                HStack {
//                    Spacer()
//                }
//                .frame(height: 20)
//                .overlay(DashedLine().stroke(Color.gray, lineWidth: 1))
//            }
//        }
//    }
//}

struct TornEdgeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.maxX * 0.8, y: rect.midY))
        path.closeSubpath()
        return path
    }
}
