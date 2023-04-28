//
//  ContentView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.04.23.
//

import SwiftUI

struct Person {
    var name: String
    var age: Int
}

struct ContentView: View {
    
    let person1 = Person(name: "Jan", age: 26)
    
    var body: some View {
        
        Text("Hello " + person1.name)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
