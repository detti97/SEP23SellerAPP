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

	@State private var isActiveAddresPanel = false

	@State private var orderSuccess = false
	@State private var orderFail = false

	@Binding var showShippingView: Bool

	@Environment(\.presentationMode) private var presentationMode

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
					order.sendOrder(newOrder: order) { orderID in
						print("Received order ID: \(orderID)")
						self.orderID = orderID
					}
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

				HStack(spacing: 16) {
					Button(action: {
						presentationMode.wrappedValue.dismiss()
					}) {


							Text("Daten bearbeiten")
								.padding()
								.foregroundColor(.white)
								.fontWeight(.heavy)
								.background(Color.red)
								.cornerRadius(8)

					}

					Button(action: {
						isActiveAddresPanel = true
					}) {
						Text("Adresse ändern")
							.padding()
							.foregroundColor(.white)
							.fontWeight(.heavy)
							.background(Color.red)
							.cornerRadius(8)
					}
				}
				.padding()


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

	/*func sendOrder(newOrder: Order){

		var toSendOrder = newOrder
		toSendOrder.token = getSavedToken()!

		print("Order object \(toSendOrder)")

		NetworkManager.sendPostRequest(to: APIEndpoints.order, with: toSendOrder, responseType: ServerAnswer.self){ result in
			switch result {
			case .success(let response):
				print("Token: \(response)")
				orderSuccess = true
				self.orderID = String(response.orderID)

			case .failure(let error):
				print("Error: \(error)")
				orderFail = true
			case .successNoAnswer(_):
				print("Success")
			}
		}

	}*/

}

struct DeliveryControllView_Previews: PreviewProvider {
	static var previews: some View {
		let order = Order(token: "", timestamp: "22-11-2023", employeeName: "WB", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", packageSize: "L", handlingInfo: "Gebrechlich", deliveryDate: "10-04-2023", customDropOffPlace: "Garage")
		DeliveryControllView(order: order, showShippingView: Binding.constant(false))
	}
}
