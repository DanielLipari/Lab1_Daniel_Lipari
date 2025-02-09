import SwiftUI

struct ContentView: View {
    @State private var currentNumber = Int.random(in: 1...100)
    @State private var isCorrect: Bool? = nil
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var showDialog = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(currentNumber)")
                .font(.system(size: 80, weight: .bold))
                .padding()
            
            HStack {
                Button("Prime") {
                    checkAnswer(isPrime: true)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Not Prime") {
                    checkAnswer(isPrime: false)
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if let isCorrect = isCorrect {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isCorrect ? .green : .red)
            }
        }
        .padding()
        .onAppear(perform: startTimer)
        .alert(isPresented: $showDialog) {
            Alert(
                title: Text("Game Over"),
                message: Text("Correct: \(correctCount)\nWrong: \(wrongCount)"),
                dismissButton: .default(Text("OK")) {
                    resetGame()
                }
            )
        }
    }
    
    func checkAnswer(isPrime: Bool) {
        timer?.invalidate()
        let actualPrimeStatus = isPrimeNumber(currentNumber)
        
        if isPrime == actualPrimeStatus {
            correctCount += 1
            isCorrect = true
        } else {
            wrongCount += 1
            isCorrect = false
        }
        
        attempts += 1
        
        if attempts >= 10 {
            showDialog = true
        } else {
            generateNewNumber()
            startTimer()
        }
    }
    
    func generateNewNumber() {
        currentNumber = Int.random(in: 1...100)
        isCorrect = nil
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            wrongCount += 1
            attempts += 1
            
            if attempts >= 10 {
                showDialog = true
            } else {
                generateNewNumber()
                startTimer()
            }
        }
    }
    
    func resetGame() {
        correctCount = 0
        wrongCount = 0
        attempts = 0
        generateNewNumber()
        startTimer()
    }
    
    func isPrimeNumber(_ number: Int) -> Bool {
        if number < 2 { return false }
        for i in 2..<number {
            if number % i == 0 { return false }
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}