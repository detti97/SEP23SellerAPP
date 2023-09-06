//
//  Order.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI
import Foundation

struct Order: Decodable, Encodable{

	var orderID: Int?
	var timestamp: String
	var employeeName: String
	var recipient: Recipient
	var packageSize: String
	var handlingInfo: String
	var deliveryDate: String
	var customDropOffPlace: String

	func toString() -> String {
		let string = """
	Bestellung
	Zeitstempel: \(timestamp)
	Mitarbeiter-ID: \(employeeName)
	Vorname: \(recipient.firstName)
	Nachname: \(recipient.lastName)
	Straße: \(recipient.address.street)
	Hausnummer: \(recipient.address.houseNumber)
	PLZ: \(recipient.address.zip)
	Stadt: \(recipient.address.city ?? "Lingen")
	Paket Größe: \(packageSize)
	Handhabungsinformationen: \(handlingInfo)
	"""
		return string
	}

	static func defaultOrder() -> Order {
		return Order(timestamp: "",
					 employeeName: "",
					 recipient: Recipient(firstName: "", lastName: "", address: Address(street: "", houseNumber: "", zip: "", city: "")),
					 packageSize: "M",
					 handlingInfo: "",
					 deliveryDate: "",
					 customDropOffPlace: "")
	}
	

}

