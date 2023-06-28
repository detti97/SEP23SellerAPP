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

	@State var signInSuccess = false

	var body: some View {
		Group{
			if signInSuccess {
                TabView{
    
                    QRCodeScannerView().tabItem{
                        Label("Qr-code", systemImage: "qrcode")
                    }
                    SettingView().tabItem{
                        Label("Setting", systemImage: "gear")
                    }
                }
				
			}else{
				LogINView(signInSuccess: $signInSuccess)
		 }
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
