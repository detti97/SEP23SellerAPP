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

	@Binding var order: Order
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

				OrderView(order: order)

				Button(action: {
					isActiveDeliveryControll = false
					isActiveOrderSuccess = true
					order.timestamp = getCurrentDateTime()
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
			.navigationTitle("New Order for " + order.recipient.firstName + " " + order.recipient.lastName)
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
							order = Order.defaultOrder()

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

	
	func sendOrder(newOrder: Order){

		NetworkManager.sendPostRequest(to: APIEndpoints.order, with: newOrder, responseType: ServerAnswer.self){ result in
			switch result {
			case .success(let response):
				print("OrderID: \(response)")
				orderSuccess = true
				self.orderID = String(response.orderID)

			case .failure(let error):
				print("Error: \(error)")
				orderFail = true
			case .successNoAnswer(_):
				print("Success")
			}
		}

	}

	func getCurrentDateTime() -> String {
		let now = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy:HH-mm-ss.SSS"
		print(formatter.string(from: now))
		return formatter.string(from: now)
	}

}

struct DeliveryControllView_Previews: PreviewProvider {
	static var previews: some View {

		DeliveryControllView(order: Binding.constant(Order.defaultOrder()), showShippingView: Binding.constant(false))
	}
}
