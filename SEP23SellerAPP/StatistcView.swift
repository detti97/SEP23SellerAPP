//
//  StatistcView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.08.23.
//

import SwiftUI

struct StatistcView: View {

	@State var allOrders: [PlacedOrder] = []


	var body: some View {
		NavigationView {
			VStack {

				List(allOrders, id: \.orderID) { order in
					NavigationLink(destination: OrderDetailView(order: order)) {

						HStack{

							Spacer(minLength: 5)
							VStack{
								Image(systemName: "shippingbox.fill")
								Image(systemName: "person")
								Image(systemName: "calendar")

							}
							Spacer(minLength: 5)
							VStack(alignment: .trailing){

								Text("Bestellnummer: \(order.orderID)")
								Text("Empfänger: \(order.firstName) \(order.lastName)")
								Text("Bestelldatum: \(order.timestamp)")

							}
							Spacer(minLength: 5)
							VStack{


							}
							Spacer(minLength: 5)


						}
						.frame(height: 80)



					}
				}
			}
			.onAppear{
				getAllOrders()
			}
			.navigationTitle("Alle Bestellungen")
			.navigationBarTitleDisplayMode(.large)

		}


	}
	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

	func getAllOrders(session: URLSession = URLSession.shared) {

		print("hallo")
		let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdG9yZUlEIjozLCJzdG9yZU5hbWUiOiJUd2l0dGVyIiwib3duZXIiOiJFbG9uX3N1Y2tzIiwibG9nbyI6ImVsb24iLCJ0ZWxlcGhvbmUiOiIwOTg3NjQzMjEiLCJlbWFpbCI6InNkZnNkLnNkZnNkQHR3aXR0ZXIuY29tIiwiaWF0IjoxNjkxNjc1NjA5LCJzdWIiOiJhdXRoX3Rva2VuIn0._c2pnpuPlGCFE6ah5uosnhabaCQdRKCuoH13GSS4fRM"

		guard let data = try? JSONEncoder().encode(["token": testToken]) else {
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
			print("Received JSON Data: \(String(data: data, encoding: .utf8) ?? "")")

			if response.statusCode == 200 {
				do {
					let decoder = JSONDecoder()
					let placedOrders = try decoder.decode([PlacedOrder].self, from: data)

					DispatchQueue.main.async {
						self.allOrders = placedOrders
						//self.errorLoading = false
						print("Loaded Orders: \(placedOrders)")
					}
				} catch let error {
					print("Fehler beim Decodieren der Daten: \(error.localizedDescription)")
					DispatchQueue.main.async {
						//self.errorLoading = true
					}
				}
			}
		}

		task.resume()
	}
}



struct StatistcView_Previews: PreviewProvider {
	static var previews: some View {
		StatistcView()
	}
}
