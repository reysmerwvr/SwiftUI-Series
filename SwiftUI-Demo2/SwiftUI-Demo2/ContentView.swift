//
//  ContentView.swift
//  SwiftUI-Demo2
//
//  Created by Reysmer Williangel Valle Ramírez on 7/8/20.
//  Copyright © 2020 Reysmer Williangel Valle Ramírez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["estonia", "france", "germany", "ireland",
                     "italy", "monaco", "nigeria", "poland", "russia", "spain",
        "uk", "usa"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    // Apple recommends to declare @State as private
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach((0...2), id: \.self) { index in
                    Image(self.countries[index])
                    .border(Color.black, width: 1)
                    .onTapGesture {
                        self.flagTapped(index)
                    }
                }
//                Spacer()
            }
            .navigationBarTitle(Text(countries[correctAnswer].uppercased()))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text("Your score is \(score)"),
                      dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    }
                )
            }
        }
    }
    
    func flagTapped(_ tag: Int) {
        if tag == correctAnswer {
            // they were right!
            score += 1
            alertTitle = "Correct"
        } else {
            // they were wrong!
            score -= 1
            alertTitle = "Wrong"
        }
        showingAlert = true
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
