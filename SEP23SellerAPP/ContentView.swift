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

    @State private var signInSuccess = false

    var body: some View {


        Group{
            if hasSavedToken() || signInSuccess {
                TabView{
                    QRCodeScannerView().tabItem{
                        Label("Qr-code", systemImage: "qrcode")
                    }
                    SettingView(signInSuccess: $signInSuccess).tabItem{
                        Label("Setting", systemImage: "gear")
                    }
                }
            }else{
                LogINView(signInSuccess: $signInSuccess)
            }
        }
    }
	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

	func hasSavedToken() -> Bool {
		   return getSavedToken() != nil
	   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
