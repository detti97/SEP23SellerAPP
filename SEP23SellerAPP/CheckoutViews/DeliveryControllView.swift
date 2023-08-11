//
//  DeliveryControllView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.04.23.
//

import SwiftUI

struct ServerAnswer: Codable {

	let response: String
	let orderID: Int

}

struct DeliveryControllView: View {

	var order: Order
	@State private var orderID = "_"

	@State private var isActiveDeliveryControll = true
	@State private var isActiveSendOrder = false
	@State private var isActiveOrderSuccess = false

	@State private var orderSuccess = false
	@State private var orderFail = false

	@Binding var showShippingView: Bool

	var body: some View {

		if isActiveDeliveryControll{ // Delivery Controll Page

			ScrollView {
				Spacer(minLength: 70)
				VStack(alignment: .leading, spacing: 20) {

					HStack{
						Image(systemName: "shippingbox")
						Text("Lieferungsübersicht")
					}
					.foregroundColor(.purple)
					.font(.system(size: 26))
					.fontWeight(.heavy)

					HStack{

						VStack (alignment: .leading, spacing: 10){

							Text("Mitarbeiter: ")
							Text("Paket Größe: ")
							Text("Wichtige Hinweise: ")
							Text("Lieferdatum: ")



						}
						.fontWeight(.heavy)

						VStack(alignment: .trailing, spacing: 10){

							Text(order.employeeName)
							Text(order.packageSize)
							Text(order.handlingInfo)
							Text(order.deliveryDate)

						}

					}

					Spacer()

					HStack{
						Image(systemName: "house")
						Text("Lieferadresse")
					}
					.foregroundColor(.purple)
					.font(.system(size: 26))
					.fontWeight(.heavy)

					HStack{

						VStack (alignment: .leading, spacing: 10){

							Text("Empfänger: ")
							Text("Straße: ")
							Text("Stadt: ")

						}
						.fontWeight(.heavy)

						VStack(alignment: .trailing, spacing: 10){

							Text(order.firstName + " " + order.lastName )
							Text(order.street + " " + order.houseNumber )
							Text(order.zip + " Lingen")

						}

					}
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 10) // Radius für die abgerundeten Ecken
						.fill(Color.white) // Hintergrundfarbe des Rechtecks
						.shadow(radius: 5) // Schatten für das Rechteck
				)

				Spacer(minLength: 40)

				Button(action: {
					isActiveDeliveryControll = false
					isActiveOrderSuccess = true
					sendOrder(newOrder: order)
				}) {
					Text("Bestellung senden")
						.padding()
						.foregroundColor(.white)
						.fontWeight(.heavy)
						.background(Color.blue)
						.cornerRadius(8)
				}
				.padding()
				.frame(maxWidth: .infinity, alignment: .center)

			}
			.navigationTitle("New Order for " + order.firstName + " " + order.lastName)
			.navigationBarTitleDisplayMode(.inline)
			// Delivery Controll Page
		}
		if isActiveOrderSuccess{

			VStack{

				Spacer()
					.frame(height: 40)

				Image("delivery_truck")
					.resizable()
					.scaledToFit()

				Spacer()
					.frame(height: 60)

				if orderID == "_" {

					if orderFail {

						Text("Fehler bei der Kommunikation mit dem Server!")
							.font(.largeTitle)
							.fontWeight(.heavy)
							.padding()
							.multilineTextAlignment(.center)
							.foregroundColor(.red)

						Spacer()
							.frame(height: 20)

						Button(action: {
							isActiveOrderSuccess = false
							isActiveDeliveryControll = true
							orderFail = false

						}) {
							Text("Erneut Versuchen")
								.padding()
								.foregroundColor(.white)
								.fontWeight(.heavy)
								.background(Color.blue)
								.cornerRadius(8)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .center)

					}else{

						Text("Lieferung wird gesendet")
							.font(.largeTitle)
							.fontWeight(.heavy)
							.padding()
							.multilineTextAlignment(.center)
						Spacer()
							.frame(height: 20)
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .purple))
					}} else {

						Text("Lieferung Beauftragt")
							.font(.largeTitle)
							.fontWeight(.heavy)
							.padding()
							.multilineTextAlignment(.center)

						Spacer()
							.frame(height: 20)

						Text("Bitte das Paket mit \(orderID) beschriften")
							.font(.body)
							.fontWeight(.heavy)
							.padding()
							.multilineTextAlignment(.center)
							.foregroundColor(.purple)

						Spacer()
							.frame(height: 100)

						Button(action: {

							showShippingView = false

						}) {
							Text("Back to Dashboard")
								.font(.headline)
								.padding()
								.frame(maxWidth: .infinity)
								.background(Color.purple)
								.foregroundColor(.white)
								.cornerRadius(18)
								.padding()
						}
					}


			}

		}
	}

	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

	func sendOrder(newOrder: Order, session: URLSession = URLSession.shared) {
		let test = Order(token: getSavedToken()!, timestamp: newOrder.timestamp, employeeName: newOrder.employeeName, firstName: newOrder.firstName, lastName: newOrder.lastName, street: newOrder.street, houseNumber: newOrder.houseNumber, zip: newOrder.zip, city: newOrder.city, packageSize: newOrder.packageSize, handlingInfo: newOrder.handlingInfo, deliveryDate: newOrder.deliveryDate, customDropOffPlace: newOrder.customDropOffPlace)
		print("Order: \(test)")
		guard let data = try? JSONEncoder().encode(test) else {
			orderFail = true
			return
		}
		guard let url = URL(string: "http://131.173.65.77:8080/api/order") else {
			orderFail = true
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = data
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let _ = data else {
				orderFail = true
				return
			}
			if let httpResponse = response as? HTTPURLResponse,
			   httpResponse.statusCode == 200 {
				if let responseString = String(data: data!, encoding: .utf8) {
					print("Antwort des Servers: \(responseString)")
					orderSuccess = true

				}
				do {
					let responseData = try JSONDecoder().decode(ServerAnswer.self, from: data!)
					let orderID = responseData.orderID

					self.orderID = String(orderID)

					print(orderID)

				} catch let error {

					orderFail = true
					print("Fehler beim Parsen des JSON: \(error.localizedDescription)")

				}
				print("Order erfolgreich gesendet")
			}
		}
		task.resume()
	}

}

struct DeliveryControllView_Previews: PreviewProvider {
	static var previews: some View {
		let order = Order(token: "", timestamp: "22-11-2023", employeeName: "WB", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", packageSize: "L", handlingInfo: "Gebrechlich", deliveryDate: "10-04-2023", customDropOffPlace: "Garage")
		DeliveryControllView(order: order, showShippingView: Binding.constant(false))
	}
}
