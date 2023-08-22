//  ContentView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.04.23.
//

import SwiftUI
import CodeScanner

struct Person {
    var name: String
    var age: Int
}

struct ContentView: View {

    @State private var signInSuccess = false
	@State private var showShippingView = false
	@State private var repAddress = recipientAddress(name: "", surName: "", street: "", streetNr: "", zip: "")

	

    var body: some View {


        Group{
            if signInSuccess == true {

				if !showShippingView {
					TabView{
						QRCodeScannerView(showShippingView: $showShippingView , repAddress: $repAddress).tabItem{
							Label("Neue Bestellung", systemImage: "airplane.departure")
						}

						StatistcView().tabItem{
							Label("Aufgegebe Bestellungen", systemImage: "shippingbox.and.arrow.backward.fill")
						}

						SettingView(signInSuccess: $signInSuccess).tabItem{
							Label("Einstellungen", systemImage: "gear")

						}

					}
					.onAppear {
						let appearance = UITabBarAppearance()
						appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
						appearance.backgroundColor = UIColor(Color.white.opacity(0.3))

						UITabBar.appearance().standardAppearance = appearance
						UITabBar.appearance().scrollEdgeAppearance = appearance

					}

				}else {
					FirstStepView(showShippingView: $showShippingView, repAddress: $repAddress)
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
