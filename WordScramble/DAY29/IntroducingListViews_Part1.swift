//  IntroducingListViews_Part1.swift

import SwiftUI



struct IntroducingListViews_Part1: View {
    
    var body: some View {
        
        List {
            Section(header: Text("Section 1")) {
                Text("Hello , World !")
                Text("Hello , World !")
            }
            Section(header: Text("Section 2")) {
                ForEach(1..<5) { (number: Int) in
                    Text("Row \(number)")
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}





struct IntroducingListViews_Part1_Previews: PreviewProvider {
    
    static var previews: some View {
        
        IntroducingListViews_Part1().previewDevice("iPhone 12 Pro")
    }
}
