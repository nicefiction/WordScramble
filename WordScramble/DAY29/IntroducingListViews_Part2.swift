//  IntroducingListViews_Part2.swift
// SOURCE : https://www.hackingwithswift.com/books/ios-swiftui/introducing-list-your-best-friend

/**
 When working with an array of data ,
 SwiftUI still needs to know how to identify each row uniquely ,
 so if one gets removed
 it can simply remove that one
 rather than having to redraw the whole list .
 This is where the `id` parameter comes in ,
 and it works identically in both `List` and `ForEach`
 – it lets us tell SwiftUI
 exactly what makes each item in the array unique .
 */

import SwiftUI



struct IntroducingListViews_Part2: View {
    
    let humans: [String] = [
        "Dorothy" , "Glinda" , "Ozma" , "Dahlia"
    ]
    
    
    
    var body: some View {
        
        VStack {
            List(humans , id : \.self) { (name: String) in
                Text(name)
                    .font(.title)
            }
            /**
             That works just the same with `ForEach` ,
             so if we wanted to mix static and dynamic rows
             we could have written this instead :
             */
            List {
                Section(header : Text("For Each")) {
                    ForEach(humans.reversed() , id: \.self) {
                        Text($0)
                            .font(.title)
                    }
                }
                Section(header : Text("Static rows")) {
                    Text("Row 1")
                    Text("Row 2")
                    Text("Row 3")
                }
            }
        }
    }
}





struct IntroducingListViews_Part2_Previews: PreviewProvider {
    
    static var previews: some View {
        
        IntroducingListViews_Part2().previewDevice("iPhone 12 Pro")
    }
}
