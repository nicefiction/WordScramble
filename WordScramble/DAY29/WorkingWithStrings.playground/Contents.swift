import UIKit

// SOURCE : https://www.hackingwithswift.com/books/ios-swiftui/working-with-strings


let vowels = "a e i o u"

let vowelsArray = vowels.components(separatedBy : " ") // ["a", "e", "i", "o", "u"]

/**
 Regardless of what string we split on ,
 the result will be an array of strings :
 */

let someOtherInput = """
a
b
c
"""

let lettersArray = someOtherInput.components(separatedBy : "\n") // ["a", "b", "c"]


/**
 The `randomElement()` method
 returns one random item from the array :
*/

let randomVowel = vowelsArray.randomElement() // "o"
// let randomVowel: String?

/**
 Now , although we can see that the letters array will contain three items ,
 Swift doesn’t know that
 – perhaps we tried to split up an empty string , for example .
 As a result , the `randomElement()` method returns an optional string ,
 which we must either unwrap or use with `nil coalescing` .
 */
/**
 Another useful string method is `trimmingCharacters(in:)` ,
 which asks Swift
 to remove certain kinds of characters
 from the start
 and end
 of a string .
 */

let trimmedVowels = randomVowel?.trimmingCharacters(in : .whitespacesAndNewlines) // u
// let trimmedVowels: String?

/**
 Checking a string for misspelled words takes four steps in total :
 
 `STEP 1`
 First , we create a word to check
 and an instance of `UITextChecker` that we can use to check that string :
 */

let word = "swift"

let textChecker = UITextChecker()

/**
 `STEP 2`
 Second , we need to tell the checker
 how much of our string we want to check .
 However , there is a catch :
 Swift uses a very clever , very advanced way of working with strings ,
 which allows it to use complex characters
 such as emoji
 in exactly the same way that it uses the English alphabet .
 However , Objective-C does not use this method of storing letters ,
 which means we need to ask Swift to create an Objective-C string range
 using the entire length of all our characters , like this :
 */

let range = NSRange(location : 0 ,
                    length : word.utf16.count) // {0 , 5}

/**
 `UTF-16` is what’s called a _character encoding_
 – a way of storing letters in a string .
 We use it here so that Objective-C can understand
 how Swift’s strings are stored ;
 it is a nice bridging format for us to connect the two .
 
 `STEP 3`
 Third , we can ask our text checker
 to report
 where it found any misspellings in our word ,
 passing in the range to check ,
 a position to start within the range (so we can do things like “Find Next”) ,
 whether it should wrap around once it reaches the end ,
 and what language to use for the dictionary :
 */

let misspelledRange = textChecker.rangeOfMisspelledWord(in : word ,
                                                        range : range ,
                                                        startingAt : 0 ,
                                                        wrap : false ,
                                                        language : "en")
/**
 That sends back another Objective-C string range ,
 telling us where the misspelling was found .
 Even then , there is still one complexity here :
 Objective-C didn’t have any concept of optionals ,
 so instead relied on special values to represent missing data .
 In this instance , if the Objective-C range comes back as empty
 – i.e., if there was no spelling mistake because the string was spelled correctly –
 then we get back the special value `NSNotFound` .
 So , we could check our spelling result
 to see whether there was a mistake or not like this :
 */

let allGood = misspelledRange.location == NSNotFound // true
