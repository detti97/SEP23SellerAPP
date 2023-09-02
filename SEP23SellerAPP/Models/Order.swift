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
/*
	func sendOrder(newOrder: Order, completion: @escaping (String) -> Void) {
		var toSendOrder = newOrder
		var orderID = ""

		print("Order object \(toSendOrder)")

		NetworkManager.sendPostRequest(to: APIEndpoints.order, with: toSendOrder, responseType: ServerAnswer.self) { result in
			switch result {
			case .success(let response):
				print("Token: \(response)")
				orderID = String(response.orderID)

			case .failure(let error):
				print("Error: \(error)")

			case .successNoAnswer(_):
				print("Success")
			}

			completion(orderID)
		}
	}

*/

		func getSavedToken() -> String? {
			return UserDefaults.standard.string(forKey: "AuthToken")
		}

	}

	struct PlacedOrder: Decodable {

		var orderID: Int
		var timestamp: String
		var employeeName: String
		var packageSize: String
		var deliveryDate: String
		var customDropoffPlace: String
		var handlingInfo: String
		var firstName: String
		var lastName: String
		var street: String
		var houseNumber: String
		var ZIP: Int


	}

	struct Address: Decodable, Encodable{

		var street: String
		var houseNumber: String
		var zip: String
		var city: String?

	}

