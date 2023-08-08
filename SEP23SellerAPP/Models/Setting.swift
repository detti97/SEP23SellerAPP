//
//  Setting.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 12.07.23.
//

import Foundation

struct Setting: Codable {

	var storeID: Int
	var storeName: String
	var shopOwner: String
	var phoneNumber: String
	var openingHours: OpeningHours

}

struct OpeningHours: Codable{

	var mondayOpenCloseTime: String
	var tuesdayOpenCloseTime: String
	var wednesdayOpenCloseTime: String
	var thursdayOpenCloseTime: String
	var fridayOpenCloseTime: String
	var saturdayOpenCloseTime: String


}
