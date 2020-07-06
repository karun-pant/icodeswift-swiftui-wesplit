//
//  ContentView.swift
//  WeSplit
//
//  Created by Pant, Karun on 22/03/20.
//  Copyright © 2020 Pant, Karun. All rights reserved.
//

import SwiftUI

struct Amount: ViewModifier {
    var isCorrect: Bool = true
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(Color(.white))
            .padding()
            // conditional formatting
            .background(isCorrect ? Color(.lightGray) : Color(.red))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

extension View {
    func amountStyle(isCorrect: Bool = true) -> some View {
        return self.modifier(Amount(isCorrect: isCorrect))
    }
}

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 1
    @State private var tipPercentage = 2
    
    private let tipPercentages = [15, 10, 20, 0]
    private var totalCheckAmount: Double {
        let tipPercentage = Double(self.tipPercentages[self.tipPercentage])
        let checkAmount = Double(self.checkAmount) ?? 0
        return (1 + tipPercentage/100) * checkAmount
    }
    private var totalPayable: Double {
        let numberOfPeople = Double(self.numberOfPeople + 2)
        return totalCheckAmount > 0
            ? totalCheckAmount/numberOfPeople
            : 0
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)

                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section(header: Text("How much tip you wanna leave?")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<self.tipPercentages.count) { index in  Text("\(self.tipPercentages[index])%").tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Total Amount")) {
                    // using directly
                    Text("₹\(totalCheckAmount, specifier: "%.2f")")
                        .modifier(Amount(isCorrect: tipPercentages[tipPercentage] > 0))
                }
                Section(header: Text("Everyone has to pay")) {
                    // using via extension
                    Text("₹\(totalPayable, specifier: "%.2f")")
                    .amountStyle(isCorrect: tipPercentages[tipPercentage] > 0)
                }
            }.navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
