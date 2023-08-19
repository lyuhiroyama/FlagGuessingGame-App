//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lyu Hiroyama on 2023/08/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
                        "Poland", "Russia", "Spain", "UK", "US"]
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var questionNum = 0
    @State private var eightQuestions = false
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.65), location: 0.3),
                .init(color: Color(red: 0.86, green: 0.45, blue: 0.26), location: 0.3)],
                    center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag!")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        // .largeTitle is the largest built-in iOS font-size offered.
                    }
                    
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)/8")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Tries remaining: \(8-questionNum)")
                    .font(.title.weight(.light))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                askQuestion()
                if questionNum == 8 {
                    eightQuestions = true
                }
            }
        } message: {
            Text("Your score is \(score)/8")
        }
        
        .alert("That's it!", isPresented: $eightQuestions) {
            Button("Play again", action: reset)
        } message: {
            Text("Your final score: \(score)/8")
        }
        
    }
    
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = """
                        Wrong!
                        That's the flag of \(countries[number])
                        """
        }
        showingScore = true
        questionNum += 1
        print(questionNum)
    }
    
    func askQuestion () {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        countries = ContentView.allCountries //Could also be "Self.allCountries"
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNum = 0
        score = 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
