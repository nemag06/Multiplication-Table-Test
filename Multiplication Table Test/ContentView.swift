//
//  ContentView.swift
//  Multiplication Table Test
//
//  Created by Magomet Bekov on 28.01.2023.
//

import SwiftUI

struct Question {
    var text: String
    var answer: Int
}

struct AnswersImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .scaleEffect(0.5)
            .frame(width: 80, height: 80)
    }
}

struct AnswerButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 330, height: 100, alignment: .center)
            .background(Color.green)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 2))
    }
}

extension View {
    func drawAnswerButton() -> some View {
        self.modifier(AnswerButton())
    }
}

struct GameLabel: ViewModifier  {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.black, lineWidth: 2)
        )
            .padding(.bottom, 15)
            .padding(.top, 100)
    }
}

extension View {
    func drawGameLabel() -> some View {
        self.modifier(GameLabel())
    }
}

struct StartEndButton: ViewModifier {
    var isColorRed: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(isColorRed ? Color.red : Color.green)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.white, lineWidth: 2))
            .font(.title)
            .padding(.top, 10)
            .foregroundColor(.white)
    }
}

extension View {
    
    func drawStartAndEndButton(whatColor: Bool) -> some View {
        self.modifier(StartEndButton(isColorRed: whatColor))
    }
}

struct GamePicker: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(.yellow)
            .padding(.bottom, 50)
    }
}

extension View {
    func drawGamePicker() -> some View {
        self.modifier(GamePicker())
    }
}


struct FontText: ViewModifier {
    let font = Font.system(size: 22, weight: .heavy, design: .default)
    
    func body(content: Content) -> some View {
        content
            .font(font)
    }
}

extension View {
    func setFontText() -> some View {
        self.modifier(FontText())
    }
}

struct DrawHorizontalText: View {
    var text: String
    var textResult: String
    
    var body: some View {
        HStack {
            Text(text)
                .modifier(FontText())
                .foregroundColor(Color.green)
            
            Text(textResult)
                .modifier(FontText())
                .foregroundColor(Color.red)
        }
        .padding(.top, 10)
    }
}

struct ContentView: View {
    
    @State private var imagesName = ["parrot", "duck", "dog", "horse", "rabbit", "whale", "rhino", "elephant", "zebra", "chicken", "cow", "panda", "hippo", "gorilla", "owl", "penguin", "sloth", "frog", "narwhal", "buffalo", "monkey", "giraffe", "moose", "pig", "snake", "bear", "chick", "walrus", "goat", "crocodile"]
    @State private var multiplicationTable = 1
    
    let allMultiplicationTables = Range(1...12)
    
    @State private var countOfQuestions = "5"
    
    let variantsOfQuestions = ["5", "10", "20", "All"]
    
    @State private var arrayOfQuestions = [Question]()
    @State private var answerArray = [Question]()
    
    @State private var currentQuestion = 0
    @State private var totalScore = 0
    @State private var remainingQuestions = 0
    @State private var selectedNumber = 0
    
    @State private var gameIsRunning = false
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var isShowAlert = false
    @State private var isWinGame = false
    @State private var fadeOutOpacity = false
    
    @State private var alertTitle = ""
    @State private var buttonAlertTitle = ""
    
    var body: some View {
        Group {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                if gameIsRunning {
                VStack {
                    Text("\(arrayOfQuestions[currentQuestion].text) ")
                        .drawGameLabel()
                        .font(.largeTitle)
                    
                    VStack {
                        ForEach (0 ..< 4, id: \.self) { number in
                            HStack {
                                Button(action: {
                                    withAnimation {
                                    self.checkAnswer(number)
                                    }
                                }) {
                                    AnswersImage(image: self.imagesName[number])
                                        .padding()
                                    
                                    Text("\(self.answerArray[number].answer)")
                                        .foregroundColor(Color.black)
                                        .font(.title)
                                }
                            .drawAnswerButton()
                                .rotation3DEffect(.degrees(self.isCorrect && self.selectedNumber == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(self.fadeOutOpacity && !(self.selectedNumber == number) ? 0.25 : 1)
                                .rotation3DEffect(.degrees(self.isWrong && self.selectedNumber == number ? 180 : 0), axis: (x: 0, y: 0, z: 0.5))
                            }
                        }
                    }
                    Button(action: {
                        self.gameIsRunning = false
                    }) {
                        Text("End Game")
                        .drawStartAndEndButton(whatColor: gameIsRunning)
                    }
                    VStack {
                        DrawHorizontalText(text: "Total score: ", textResult: "\(totalScore)")
                        DrawHorizontalText(text: "Questions remained: ", textResult: "\(remainingQuestions)")
                    }
                    
                   Spacer()
                }
                } else {
                    VStack {
                        Text("Which multiplication table ?")
                            .drawGameLabel()
                        
                        Picker("Which multiplication table ?", selection: $multiplicationTable) {
                            ForEach(allMultiplicationTables, id: \.self) {
                                Text("\($0)")
                            }
                        }.drawGamePicker()
                        
                        Text("How many questions ?")
                            .drawGameLabel()
                        
                        Picker("How many questions ?", selection: $countOfQuestions) {
                            ForEach(variantsOfQuestions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .drawGamePicker()
                        
                        Button(action: {
                            self.newGame()
                        }) {
                            Text("Start Game")
                            .drawStartAndEndButton(whatColor: gameIsRunning)
                        }
                        
                        Spacer()
                    }
                }
            }
           
        }.alert(isPresented: $isShowAlert) { () -> Alert in
            Alert(title: Text("\(alertTitle)"), message: Text(" Your score is: \(totalScore)"), dismissButton: .default(Text("\(buttonAlertTitle)")){
                if self.isWinGame {
                    self.newGame()
                    self.isWinGame = false
                    self.isCorrect = false
                } else if self.isCorrect  {
                    self.isCorrect = false
                    self.newQuestion()
                } else {
                    self.isWrong = false
                }
                })
        }
    }
    
    func createArrayOfQuestions() {
        for i in 1 ... multiplicationTable {
            for j in 1...4 {
                let newQuestion = Question(text: "How much is: \(i) x \(j) = ?", answer: i * j)
                arrayOfQuestions.append(newQuestion)
            }
        }
        self.arrayOfQuestions.shuffle()
        self.currentQuestion = 0
        self.answerArray = []
    }
    
    func setCountOfQuestions() {
        guard let count = Int(self.countOfQuestions) else {
            remainingQuestions  = arrayOfQuestions.count
            return
        }
        remainingQuestions = count
    }
    
    func createAnswersArray() {
        if currentQuestion + 4 < arrayOfQuestions.count {
            for i in currentQuestion ... currentQuestion + 3 {
                answerArray.append(arrayOfQuestions[i])
            }
        } else {
            for i in arrayOfQuestions.count - 4 ..< arrayOfQuestions.count {
                answerArray.append(arrayOfQuestions[i])
            }
        }
        self.answerArray.shuffle()
    }
    
    func newGame() {
        self.gameIsRunning = true
        self.arrayOfQuestions = []
        self.createArrayOfQuestions()
        self.currentQuestion = 0
        self.setCountOfQuestions()
        self.answerArray = []
        self.createAnswersArray()
        self.imagesName.shuffle()
        self.totalScore = 0
    }
    
    func newQuestion() {
        self.imagesName.shuffle()
        self.currentQuestion += 1
        self.answerArray = []
        self.createAnswersArray()
    }
    
    func checkAnswer(_ number: Int) {
        self.selectedNumber = number
        if answerArray[number].answer == arrayOfQuestions[currentQuestion].answer {
            self.isCorrect = true
            self.remainingQuestions -= 1
            fadeOutOpacity = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.remainingQuestions == 0 {
                    self.alertTitle = "You win"
                    self.buttonAlertTitle = "Start new game"
                    self.totalScore += 1
                    self.isWinGame = true
                    self.isShowAlert = true
                                
                } else {
                    self.totalScore += 1
                    self.alertTitle = "Correct!"
                    self.buttonAlertTitle = "New Question"
                    self.isShowAlert = true
                    fadeOutOpacity = false
                }
            }
        } else {
            isWrong = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.alertTitle = "Wrong!"
                self.buttonAlertTitle = "Try again"
                self.isShowAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
