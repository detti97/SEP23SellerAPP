//
//  OrderDetailView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

struct OrderDetailView: View {
	
	var order: PlacedOrder

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

						Text(String(order.orderID))
						Text(timeStampFormatter(timeStamp: order.timestamp))
						Text(order.employeeName)
						Text(order.packageSize)
						Text(timeStampFormatter(timeStamp: order.deliveryDate))
						Text(order.customDropoffPlace)

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

						Text(order.firstName + " " + order.lastName )
						Text(order.street + " " + order.houseNumber )
						Text(String(order.ZIP) + " Lingen")

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
		.navigationTitle(order.lastName)

	}

}



struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {

		let test = PlacedOrder(orderID: 1, timestamp: "12-08-2023:23-23", employeeName: "Jobs", packageSize: "M", deliveryDate: "2014-08-22T22:00:00.000Z", customDropoffPlace: "Garage", handlingInfo: "Zerbrechlich&Zerbrechlich&Zerbrechlich", firstName: "Test", lastName: "test", street: "Kaiserstraße", houseNumber: "12", ZIP: 49809)

        OrderDetailView(order: test)
    }
}


