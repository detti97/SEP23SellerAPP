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
    
	var body: some View {
		TabView { //
			QRCodeScannerView()
				.tabItem {
					Label("Lingen Code", systemImage: "qrcode")
				}

			LogINView()
				.tabItem {
					Label("Erkunden", systemImage: "location")
				}
		}

	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
