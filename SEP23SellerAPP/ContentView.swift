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
            if hasSavedToken() || signInSuccess {

				if !showShippingView {
					TabView{
						QRCodeScannerView(showShippingView: $showShippingView , repAddress: $repAddress).tabItem{
							Label("Qr-code", systemImage: "qrcode")
						}

						SettingView(signInSuccess: $signInSuccess).tabItem{
							Label("Settings", systemImage: "gear")
						}
						.onAppear() {
							/*
										let standardAppearance = UITabBarAppearance()
										standardAppearance.backgroundColor = UIColor(Color.gray)
										standardAppearance.shadowColor = UIColor(Color.black)
										let itemAppearance = UITabBarItemAppearance()
										itemAppearance.normal.iconColor = UIColor(Color.white)
										itemAppearance.selected.iconColor = UIColor(Color.red)
										standardAppearance.inlineLayoutAppearance = itemAppearance
										standardAppearance.stackedLayoutAppearance = itemAppearance
										standardAppearance.compactInlineLayoutAppearance = itemAppearance
										UITabBar.appearance().standardAppearance = standardAppearance
							 */
									}
									.edgesIgnoringSafeArea(.bottom)

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

	func handleScan(result: Result<ScanResult, ScanError>) {
		//isShowingScanner = false
		switch result{
		case .success(let result):
			let details = result.string.components(separatedBy: "&")
			guard details.count == 5 else { return }

			let repAddress = recipientAddress(name: details[1],
											  surName: details[0],
											  street: details[2],
											  streetNr: details[3],
											  zip: details[4])
			print(repAddress.toString())
			//AddressControllView(currentRecipientAddress: repAddress)
			//NavigationLink("",destination: FirstStepView(repAddress: repAddress))
			//self.repAddress = repAddress

		case .failure(let error):
			print("Scanning failed: \(error.localizedDescription)")
		}

	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
