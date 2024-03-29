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
	@Published var allOrders: [Order] = []

	func loadData(){
		getAllOrders()
	}

	private func getAllOrders(session: URLSession = URLSession.shared) {

		NetworkManager.sendGetRequestWithArrayResponse(to: APIEndpoints.placedOrders, responseType: [Order].self) { result in
			
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					self.allOrders = response
				case .failure(let error):
					self.errorLoading = true
					print("Error: \(error)")
				case .successNoAnswer(_):
					self.errorLoading = true
					print("Success")
				}
			}
		}
	}

	func setErrorLoading(fail: Bool){
		self.errorLoading = fail
		print("setFailBool \(fail)")
	}

	func getErrorLoading() -> Bool{
		return errorLoading
	}

	private func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
}


