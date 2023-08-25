//
//  Order.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI
import Foundation

struct Order: Decodable, Encodable{

	var token: String
	var timestamp: String
	var employeeName: String
	var firstName: String
	var lastName: String
	var street: String
	var houseNumber: String
	var zip: String
	var city: String
	var packageSize: String
	var handlingInfo: String
	var deliveryDate: String
	var customDropOffPlace: String

	func toString() -> String {
		let string = """
				Bestellung
				Zeitstempel: \(timestamp)
				Mitarbeiter-ID: \(employeeName)
				Vorname: \(firstName)
				Nachname: \(lastName)
				Straße: \(street)
				Hausnummer: \(houseNumber)
				PLZ: \(zip)
				Stadt: \(city)
				Paket Größe: \(packageSize)
				Handhabungsinformationen: \(handlingInfo)
				"""
		return string
	}

	func sendOrder(newOrder: Order, completion: @escaping (String) -> Void) {
		var orderSuccess = false
		var toSendOrder = newOrder
		var orderID = ""
		toSendOrder.token = getSavedToken()!

		print("Order object \(toSendOrder)")

		NetworkManager.sendPostRequest(to: APIEndpoints.order, with: toSendOrder, responseType: ServerAnswer.self) { result in
			switch result {
			case .success(let response):
				print("Token: \(response)")
				orderSuccess = true
				orderID = String(response.orderID)

			case .failure(let error):
				print("Error: \(error)")
				orderSuccess = false

			case .successNoAnswer(_):
				print("Success")
			}

			completion(orderID)
		}
	}



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

	}

