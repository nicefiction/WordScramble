//  ContentView.swift

import SwiftUI



struct ContentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State private var rootWord: String = ""
    @State private var newWord: String = ""
    @State private var usedWords = Array<String>()
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Write your word here ..." ,
                          text : $newWord ,
                          /**
                          Because the closure’s signature
                          – the parameters it needs to accept and its return type –
                          exactly matches the `addNewWord()` method we just wrote ,
                          we can pass that in directly :
                          */
                          onCommit : addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                /**
                 `NOTE` : By giving `usedWords` to `List` directly ,
                 we are asking it to make one row for every word in the array ,
                 uniquely identified by the word itself .
                 This would cause problems if there were lots of duplicates in `usedWords` ,
                 but soon enough
                 we’ll be disallowing that
                 so it is not a problem .
                 */
                List(usedWords , id : \.self) { (usedWord: String) in
                    /**
                     `NOTE` : If we use a second view inside a List row ,
                     SwiftUI will automatically create an implicit horizontal stack for us
                     so that everything in the row sits neatly side by side :
                     */
                    Image(systemName: "\(usedWord.count).circle")
                        .font(.title)
                    Text(usedWord)
                }
            }
            // .navigationBarTitle(Text(rootWord))
            .navigationBarTitle(rootWord)
            .font(.title)
            .onAppear(perform : startGame)
        }
    }
    
    
     // ////////////////////
    // MARK: HELPER METHODS
    
    func addNewWord() {
        // Lowercase newWord and remove any whitespace :
        let answer = newWord.lowercased().trimmingCharacters(in : .whitespaces)
        
        // Check that it has at least 1 character otherwise exit :
        guard answer.count > 0
        else { return }
        
        // Insert that word at position 0 in the usedWords array :
        usedWords.insert(answer , at : 0)
        
        // Set newWord back to be an empty string :
        newWord = ""
    }
    
    
    func startGame() {
        // STEP 1 • Find the URL for start.txt in our app bundle :
        if
            let _startURLFile = Bundle.main.url(forResource : "start" ,
                                                withExtension : "txt") {
            // STEP 2 • Load start.txt into a string :
            if
                let _startFileContents = try? String(contentsOf : _startURLFile) {
                
                // STEP 3 • Split the string up into an array of strings , splitting on line breaks :
                let startWordsArray: [String] = _startFileContents.components(separatedBy: "\n")
                
                // STEP 4 • Pick one random word , or use "silkworm" as a sensible default :
                rootWord = startWordsArray.randomElement() ?? "silkworm"
                
                // STEP 5A • If we are here everything has worked , so we can exit :
                return
            }
        }
        // STEP 5B • If were are *here* then there was a problem – trigger a crash and report the error :
        fatalError("The words file of the game could not be loaded .")
    }
    /**
     Now that we have a method to load everything for the game ,
     we need to actually call that thing when our view is shown .
     SwiftUI gives us a dedicated view modifier for running a closure when a view is shown — `onAppear()`.
     */
}





struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView().previewDevice("iPhone 12 Pro")
    }
}
