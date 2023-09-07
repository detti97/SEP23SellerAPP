//
//  OrderDetailView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

struct OrderDetailHistoryView: View {
	
	var order: Order

	var body: some View {

		NavigationView{

			OrderView(order: order)

		}
		.navigationTitle("Bestellnummer \(order.orderID ?? 1)")

	}

}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {

		let test = Order(timestamp: "20-08-2023", employeeName: "WB", recipient: Recipient(firstName: "Jan", lastName: "de", address: Address(street: "Kaiserstraße", houseNumber: "12", zip: "49809")), packageSize: "L", handlingInfo: "Gebrechlich&Zerbrechlich&Schwer", deliveryDate: "06-12-2023", customDropOffPlace: "Garage")

        OrderDetailHistoryView(order: test)
    }
}


