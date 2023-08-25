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

		NetworkManager.sendGetRequestWithArrayResponse(to: APIEndpoints.placedOrders, responseType: [PlacedOrder].self) { result in
			
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					self.allOrders = response
				case .failure(let error):
					print("Error: \(error)")
				case .successNoAnswer(_):
					print("Success")
				}
			}
		}
	}


	private func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
}


