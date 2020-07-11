//
//  ContentView.swift
//  BetterRest
//
//  Created by Reysmer Williangel Valle Ramírez on 7/11/20.
//  Copyright © 2020 Reysmer Williangel Valle Ramírez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount: Double = 8
    @State private var coffeeAmount: Int = 1
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                    .lineLimit(nil)
                
                DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
                
                Text("Desired amount of sleep")
                    .font(.headline)
                    .lineLimit(nil)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }.padding(.bottom)
                
                Text("Daily coffee intake")
                    .font(.headline)
                    .lineLimit(nil)
                
                Stepper(value: $coffeeAmount, in: 1...20, step: 1) {
                    if coffeeAmount == 1 {
                        Text("\(coffeeAmount) cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
                Spacer()
            }
            .navigationBarTitle(Text("Better Rest"))
            .navigationBarItems(trailing:
                Button(action: calculateBedTime) {
                    Text("Calculate")
                }
            )
            .padding()
                .alert(isPresented: $showingAlert) { () -> Alert in
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime() -> Void {
        let model = SleepCalculator()
        
        do {
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(coffee: Double(coffeeAmount), estimatedSleep: sleepAmount, wake: Double(hour + minute))
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is.."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, There was a problem calculating your bedtime"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
