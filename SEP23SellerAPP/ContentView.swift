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
	@State private var order = Order.defaultOrder()

	

    var body: some View {


        Group{
            if signInSuccess == true {

				if !showShippingView {
					TabView{
						NewOrderMenuView(showShippingView: $showShippingView , order: $order).tabItem{
							Label("Neue Bestellung", systemImage: "airplane.departure")
						}

						OrderHistoryListView().tabItem{
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
					FirstStepView(showShippingView: $showShippingView, order: $order)
				}
            }else{
                LogInView(signInSuccess: $signInSuccess)
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
