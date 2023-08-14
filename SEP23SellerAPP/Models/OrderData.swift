//
//  OrderData.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import Foundation

class DataManager: ObservableObject {

	struct Token: Encodable {

		var token: String
	}

	@Published var errorLoading = false
	@Published var allOrders: [PlacedOrder] = []

	func loadData(){
		getAllOrders()
	}

	private func getAllOrders(session: URLSession = URLSession.shared) {
		let jwt = Token(token: getSavedToken()!)

		NetworkManager.sendPostRequestWithArrayResponse(to: APIEndpoints.placedOrders, with: jwt, responseType: [PlacedOrder].self) { result in
			
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					self.allOrders = response
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		}
	}


	private func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
}

