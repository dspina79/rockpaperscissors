import SwiftUI
struct BigMessage: View {
    var message: String = ""
    var color: Color = .white
    var body: some View {
        Text(message)
            .font(.title)
            .foregroundColor(self.color)
            
    }
}

struct SpecialButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .clipShape(Capsule())
    }
}

extension View {
    func specialButton() -> some View {
        self.modifier(SpecialButton())
    }
}

struct ContentView: View {
    let items = ["Rock", "Paper", "Scissors"]
    @State private var currentScore: Int = 0
    @State private var currentUserSelection: Int = 0
    @State private var currentComputerSelection: Int = Int.random(in: 0...2)
    
    @State private var numGames: Int = 0
    @State private var currentMessage: String = "Rock... Paper... Scissors..."
    @State private var readyNext = false
    @State private var endGame: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 10) {
                BigMessage(message: self.currentMessage, color: .white)
                ForEach(0..<items.count) { index in
                    Button(self.items[index]) {
                        let computerSelection: String = items[currentComputerSelection]
                        checkMatch(selection: self.items[index], beat: computerSelection)
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.gray)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 5)
                }
                Button("Next") {
                    nextMatch()
                }
                .specialButton()
                .disabled(!readyNext)
                
            }
            Spacer()
        }.alert(isPresented: $endGame) {
            Alert(title: Text("Game Over"), message: Text("Your final score is \(self.currentScore)"), dismissButton: .default(Text("Ok")){
                    resetGame()
            })
        }
    }
    
    func nextMatch() {
        self.readyNext = false
        self.numGames += 1
        self.currentComputerSelection = Int.random(in: 0...2)
        currentMessage = "Rock... Paper... Scissors..."
        endGame = self.numGames > 10
    }
    
    func resetGame() {
        self.numGames = 0
        self.currentScore = 0
        self.currentComputerSelection = Int.random(in: 0...2)
    }
    
    func checkMatch(selection: String, beat: String) {
        if let selectionIndex: Int = items.firstIndex(of: selection) {
            if let beatIndex: Int = items.firstIndex(of: beat) {
                let result: Bool = (selectionIndex > beatIndex ||
                        (selectionIndex == 0 && beatIndex == 3))
                if result {
                    self.currentMessage = "You win. \(selection) beats \(beat)"
                    self.currentScore += 1
                } else {
                    self.currentMessage = "\(beat) does not beat \(selection)"
                }
            }
        }
        self.readyNext = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
