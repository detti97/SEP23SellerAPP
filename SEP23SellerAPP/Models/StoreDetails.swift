//
//  StoreDetails.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 12.07.23.
//

import Foundation
import CoreLocation

struct StoreDetails: Decodable {

	var id: String?
	var storeName: String
	var owner: String
	var address: Address
	var telephone: String
	var email: String
	var logo: String
	var backgroundImage: String
	var coordinates: Coordinates?

	var locationCoordinate: CLLocationCoordinate2D {
			CLLocationCoordinate2D(
				latitude: coordinates!.latitude, longitude: coordinates!.longitude)
		}


	init(id: String, storeName: String, owner: String, address: Address, telephone: String, email: String, logo: String, backgroundImage: String, coordinates: Coordinates) {
			self.id = id
			self.storeName = storeName
			self.owner = owner
			self.address = address
			self.telephone = telephone
			self.email = email
			self.logo = logo
			self.backgroundImage = backgroundImage
			self.coordinates = coordinates
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

	var parameter: String
	var value: String

}

struct Coordinates: Hashable, Codable {

	var latitude: Double
	var longitude: Double
}
