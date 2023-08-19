//
//  Setting.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 12.07.23.
//

import Foundation

struct Setting: Codable, Equatable {

	var token: String
	var storeName: String
	//var password: String
	var owner: String
	var street: String
	var houseNumber: String
	var zip: String
	var telephone: String
	var email: String
	var logo: String
	var backgroundImage: String

	init(token: String?, storeName: String, owner: String, street: String, houseNumber: String, zip: String, telephone: String, email: String, logo: String, backgroundImage: String) {
			self.token = token ?? "StandardToken"
			self.storeName = storeName
			//self.password = password
			self.owner = owner
			self.street = street
			self.houseNumber = houseNumber
			self.zip = zip
			self.telephone = telephone
			self.email = email
			self.logo = logo
			self.backgroundImage = backgroundImage
		}

}
