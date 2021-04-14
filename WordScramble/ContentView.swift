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
}





struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView().previewDevice("iPhone 12 Pro")
    }
}
