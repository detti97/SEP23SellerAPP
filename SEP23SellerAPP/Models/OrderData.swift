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

		if getSavedToken() == nil {
			print("No token")
			return
		}

		let test = Token(token: getSavedToken()!)

		guard let data = try? JSONEncoder().encode(test) else {
			print("Fehler beim Codieren des Tokens")
			return
		}

		guard let url = URL(string: "http://131.173.65.77:8080/api/allOrders") else {
			print("Ungültige URL")
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = data

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				print("Fehler bei der Anfrage: \(error.localizedDescription)")
				return
			}

			guard let data = data, let response = response as? HTTPURLResponse else {
				print("Keine Daten oder ungültige Antwort")
				return
			}

			print("Antwort-Statuscode: \(response.statusCode)")

			if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
				if let responseString = String(data: data, encoding: .utf8) {
					print("Antwort des Servers: \(responseString)")
					print("Erfolg")
				}

				do {
					let decoder = JSONDecoder()
					let loadedData = try decoder.decode([PlacedOrder].self, from: data)

					DispatchQueue.main.async {
						self.allOrders = loadedData
						self.errorLoading = false
						//print(loadedData)
					}
				} catch {
					DispatchQueue.main.async {
						self.errorLoading = true
						print("Fehler beim decodiern der Daten")
					}
				}
			}
		}

		task.resume()
	}

	private func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
}


