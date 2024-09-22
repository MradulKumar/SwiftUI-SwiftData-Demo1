//
//  ContentView.swift
//  SwiftUI-SwiftData-Demo1
//
//  Created by Mradul Kumar on 22/09/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var isShowingItemSheet: Bool = false
    //query to run when need to apply filters
    @Query(filter: #Predicate<Expense>{ $0.value > 1000 }, sort: \Expense.date) var expenses: [Expense]
    //query fetching out all expenses
    //@Query(sort: \Expense.date) var expenses: [Expense]
    @State var expenseToEdit: Expense?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.grouped)
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $expenseToEdit, content: { expense in
                UpdateExpenseSheet(expense: expense)
            })
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    },
                                           description: {
                        Text("Start adding expenses to see your list")
                    }, actions: {
                        Button("Add Expense") {
                            isShowingItemSheet = true
                        }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

extension ContentView {
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(expenses[index])
            }
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment (\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0.0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        addExpense()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addExpense() {
        let expense = Expense(name: name, date: date, value: value)
        modelContext.insert(expense)
    }
}

struct UpdateExpenseSheet: View {
    @Environment (\.dismiss) private var dismiss
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

struct ExpenseCell: View {
    
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
            Spacer()
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}
