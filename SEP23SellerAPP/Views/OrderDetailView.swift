//
//  OrderDetailView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

struct OrderDetailView: View {
	
	var order: Order

	var body: some View {

		NavigationView{

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

						Text("Bestellnummer: ")
						Text("Datum: ")
						Text("Mitarbeiter: ")
						Text("Paket Größe: ")
						Text("Lieferdatum: ")
						Text("Ablageort: ")

					}
					.fontWeight(.heavy)

					VStack(alignment: .trailing, spacing: 10){

						Text(String(order.orderID!))
						Text(timeStampFormatter(timeStamp: order.timestamp))
						Text(order.employeeName)
						Text(order.packageSize)
						Text(timeStampFormatter(timeStamp: order.deliveryDate))
						//Text(order.customDropoffPlace)

						/*
						 ForEach(order.handlingInfo.components(separatedBy: "&"), id: \.self) { info in
						 Text(info.trimmingCharacters(in: .whitespacesAndNewlines))
						 }*/

					}

				}

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

						Text(order.recipient.firstName + " " + order.recipient.lastName )
						Text(order.recipient.address.street + " " + order.recipient.address.houseNumber )
						Text(String(order.recipient.address.zip) + " Lingen")

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
		.navigationTitle(order.recipient.lastName)

	}

}



struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {

		let test = Order.defaultOrder()

        OrderDetailView(order: test)
    }
}


