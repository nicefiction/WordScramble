//  ContentView.swift

import SwiftUI



struct ContentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State private var rootWord: String = ""
    @State private var newWord: String = ""
    @State private var usedWords = Array<String>()
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    
    
    
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
            .alert(isPresented : $isShowingAlert) {
                Alert(title : Text(alertTitle) ,
                      message : Text(alertMessage) ,
                      dismissButton : .default(Text("OK")))
            }
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
        
        guard checkIsReal(word : answer)
        else { return createAlertWith(title : answer == rootWord ? "Nice try ." : "I am sorry ." ,
                                      message : determineRealWordErrorMessage(with : answer)) }
        
        guard checkIsOriginal(word : answer)
        else { return createAlertWith(title : "I am sorry ." ,
                                      message : "You have already added this word to the list .")}
        
        guard checkIsPossible(word : answer)
        else { return createAlertWith(title : "I am sorry ." ,
                                      message : "It is not possible to create this word from the available letters .")}
        
        
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
        /**
         Now that we have a method to load everything for the game ,
         we need to actually call that thing when our view is shown .
         SwiftUI gives us a dedicated view modifier for running a closure when a view is shown — `onAppear()`.
         */
    }
    
    
    func checkIsOriginal(word: String)
    -> Bool {
        
        return !usedWords.contains(word)
    }
    
    
    func checkIsPossible(word: String)
    -> Bool {
        
        // STEP 1 • Create a variable copy of the root word :
        var rootWordCopy: String = rootWord
        
        for letter in word {
            // STEP 2 • Loop over each letter of the user’s input word to see if that letter exists in our copy :
            if let _letter = rootWordCopy.firstIndex(of : letter) {
                // STEP 3 • If it does , we remove it from the copy ( so it can’t be used twice ) , then continue :
                rootWordCopy.remove(at : _letter)
            } else {
                return false
            }
        }
        // STEP 4 • If we make it to the end of the user’s word successfully then the word is good , otherwise there is a mistake and we return false :
        return true
    }
    
    
    func checkIsReal(word: String)
    -> Bool {
        
        // STEP 1 • Create an instance of UITextChecker :
        let wordChecker = UITextChecker()
        
        // STEP 2 • Tell the checker how much of our string we want to check :
        let range = NSRange(location : 0 ,
                            length : word.utf16.count)
        
        // STEP 3 • Ask our text checker to report where it found any misspellings in our word :
        let misspelledRange = wordChecker.rangeOfMisspelledWord(in : word ,
                                                                range : range ,
                                                                startingAt : 0 ,
                                                                wrap : false ,
                                                                language : "en")
        
        // STEP 4 • Check our spelling result to see whether there was a mistake or not :
        // return misspelledRange.location == NSNotFound
        
        return word.count > 3 && word != rootWord
            ? misspelledRange.location == NSNotFound
            : false
    }
    
    
    func createAlertWith(title: String ,
                         message: String) {
        
        isShowingAlert = true
        alertTitle = title
        alertMessage = message
    }
    
    
    func determineRealWordErrorMessage(with word: String)
    -> String {
        
        if word.count < 3 {
            return "Your word needs to be longer than three letters ."
            
        } else if word == rootWord {
            return "Your word needs to be different from the challenge word ."
            
        } else {
            return "This is not a real world . Try another one ."
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView().previewDevice("iPhone 12 Pro")
    }
}
