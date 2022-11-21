//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by David on 10/6/22.
//

import SwiftUI

struct Question {
    var question: String
    var answer: Int
}

struct ContentView: View {
    // Settings
    @State private var difficulty = 2
    @State private var numberOfQuestion = 5
    @State private var gameOn = false
    @State private var gameFinished = false
    let numberOfQuestions = [5, 10, 20]
    
    // Store Questions
    @State private var questions = [String]()
    @State private var answers = [Int]()
    @State private var questionNumber = 0
    
    // User
    @State private var answer = 0
    @State private var correct = 0
    @State private var wrong = 0
    
    // Display
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var score = 0
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.red, .black]), center: .center, startRadius: 2, endRadius: 650)
                .ignoresSafeArea()
            
            VStack {
                Text("Multiplication")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack {
                    Text("Settings")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Stepper("\(difficulty) times table", value: $difficulty, in: 2...12, step: 1)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: 250, maxHeight: 100)
                        .padding(.vertical, 10)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                       
                    Picker("Questions", selection: $numberOfQuestion) {
                        ForEach(numberOfQuestions, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer()
                    Spacer()
                    Button(action: newGame) {
                        Text("Start New Game")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .frame(maxWidth: 350, maxHeight: 160)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Spacer()
               
                VStack(spacing: 15) {
                    VStack {
                        Text(gameOn && questionNumber < questions.count ? questions[questionNumber] : "Start a new game when ready!")
                            .foregroundStyle(.primary)
                            .font(.headline.weight(.heavy))
                        
                        Spacer()
                        
                        TextField("Answer here", value: $answer, formatter: NumberFormatter())
                            .font(.headline.weight(.heavy))
                            .frame(maxWidth: 250, maxHeight: 150)
                            .background(.thinMaterial)
                            .keyboardType(.decimalPad)
                            .submitLabel(.join)
                        
                        // submit answer button
                        Button(action: submitAnswer) {
                            Text("Submit")
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                    }
                }
                .frame(maxWidth: 350, maxHeight: 70)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Correct: \(correct)" + "\n Wrong: \(wrong)")
                    .foregroundColor(.white)
                    .font(.title.bold())
            }
        }
        .alert("Game Complete!", isPresented: $gameFinished) {
            Button("Reset", action: resetScore)
        } message: {
            Text("Your final score is \(score)%")
        }
    }
    
    // Create math questions
    func newGame() {
        questions.removeAll()
        answers.removeAll()
        gameOn = true
        gameFinished = false
        correct = 0
        wrong = 0
        score = 0
        questionNumber = 0
        var num1 = 0
        var num2 = 0
        var answer = 0
        var questionCount = 0
        while questionCount < numberOfQuestion {
            num1 = Int.random(in:1...difficulty)
            num2 = Int.random(in:1...difficulty)
            answer = num1 * num2
            let question = Question(question: "\(num1) x \(num2)", answer: answer)
            questions.append(question.question)
            answers.append(question.answer)
            questionCount += 1
        }
        print(questions)
        print(answers)
        gameOn = true
    }
    
    func submitAnswer() {
        if questionNumber < numberOfQuestion && !questions.isEmpty{
            if answers[questionNumber] == answer {
                scoreTitle = "Correct!"
                correct += 1
            }
            else {
                scoreTitle = "Incorrect, the answer is \(answers[questionNumber])"
                wrong += 1
            }
            questionNumber += 1
            
            if questionNumber == numberOfQuestion {
                scoreTitle = "Please tap Start New Game when ready!"
                score = (correct * 100) / numberOfQuestion
                gameFinished = true
                gameOn = false
            }
            answer = 0
        }
        else {
            gameOn = false
            gameFinished = true
            scoreTitle = "Please tap Start New Game when ready!"
            score = (correct * 100) / numberOfQuestion
        }
    }
    
    func resetScore() {
        answer = 0
        correct = 0
        wrong = 0
        questionNumber = -1
        score = 0
        gameOn = false
        gameFinished = true
        questions.removeAll()
        answers.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
