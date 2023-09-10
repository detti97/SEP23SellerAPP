//
//  OrderView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 06.09.23.
//

import SwiftUI

struct OrderView: View {


	var order: Order

	var body: some View {

		VStack(alignment: .leading, spacing: 20) {

			HStack{
				Image(systemName: "shippingbox")
				Text("Lieferungsübersicht")
			}
			.foregroundColor(.accentColor)
			.font(.system(size: 26))
			.fontWeight(.heavy)

			VStack(alignment: .leading, spacing: 10) {
				if order.timestamp != "" {
					HStack {
						Text("Bestelldatum: ")
						Text(timeStampFormatter(timeStamp: order.timestamp))
					}
				}

				HStack {
					Text("Mitarbeiter: ")
					Text(order.employeeName)
				}

				HStack {
					Text("Paket Größe: ")
					Text(order.packageSize)
				}

				HStack {
					Text("Lieferdatum: ")
					Text(timeStampFormatter(timeStamp: order.deliveryDate))
				}

				Text("Wichtige Hinweise: ")
			}
			.fontWeight(.heavy)

			VStack(alignment: .trailing, spacing: 10) {
				Text(handlingInfoStringFormat(handlingInfo: order.handlingInfo))
			}

			HStack{
				Image(systemName: "house")
				Text("Lieferadresse")
			}
			.foregroundColor(.accentColor)
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

					Text(order.recipient.firstName + " " + order.recipient.lastName )
					Text(order.recipient.address.street + " " + order.recipient.address.houseNumber )
					Text(order.recipient.address.zip + " Lingen")

				}

			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.white)
				.shadow(radius: 5)
		)

	}

	/*func handlingInfoStringFormat(handlingInfo: String) -> [String] {

	 let handInfoSingel = handlingInfo.components(separatedBy: "&")
	 return handInfoSingel
	 }*/

	private func handlingInfoStringFormat(handlingInfo: String) -> String {
		let handInfoSingel = handlingInfo.components(separatedBy: "&")
		return handInfoSingel.joined(separator: "\n")
	}

	private func timeStampFormatter(timeStamp: String) -> String{

		var formattetString = timeStamp.components(separatedBy: ":").first ?? ""

		formattetString = formattetString.replacingOccurrences(of: "-", with: ".")

		return formattetString

	}


}

struct OrderView_Previews: PreviewProvider {
	static var previews: some View {
		OrderView(order: Order.defaultOrder())
	}
}
