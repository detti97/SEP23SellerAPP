//
//  Setting.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 12.07.23.
//

import Foundation

struct Setting: Decodable {

	var token: String
	var storeName: String
	var owner: String
	var address: Address
	var telephone: String
	var email: String
	var logo: String
	var backgroundImage: String

	init(token: String?, storeName: String, owner: String, address: Address, telephone: String, email: String, logo: String, backgroundImage: String) {
			self.token = token ?? "StandardToken"
			self.storeName = storeName
			self.owner = owner
			self.address = address
			self.telephone = telephone
			self.email = email
			self.logo = logo
			self.backgroundImage = backgroundImage
		}

}

struct SetSetting: Codable{

	enum Parameters{
		static let storeName = "storeName"
		static let owner = "owner"
		static let telephone = "telephone"
		static let email = "email"
		static let logo = "logo"
		static let backgroundImage = "backgroundImage"
		static let password = "password"
	}

	var token: String
	var parameter: String
	var value: String

}
