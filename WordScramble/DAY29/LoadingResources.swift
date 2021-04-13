//  LoadingResources.swift
// SOURCE : https://www.hackingwithswift.com/books/ios-swiftui/loading-resources-from-your-app-bundle

import SwiftUI



struct LoadingResources: View {
    
    
    var body: some View {
        
        // STEP 1 • Find the file :
        if
            let _fileURL = Bundle.main.url(forResource : "some-file" ,
                                           withExtension : "txt") {
            // STEP 2 • Read the contents of the file :
            if
                let _fileContents = try? String(contentsOf : _fileURL) {
                print(_fileContents) // OLIVIER : You could do whatever you want here .
            }
        }
        
        
        return Text("Hello World")
    }
}





struct LoadingResources_Previews: PreviewProvider {
    
    static var previews: some View {
        
        LoadingResources().previewDevice("iPhone 12 Pro")
    }
}
