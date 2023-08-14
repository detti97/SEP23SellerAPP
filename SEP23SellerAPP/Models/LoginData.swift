//
//  LoginData.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 13.08.23.
//

import Foundation


struct LoginData: Codable {

	var username: String
	var password: String

	}

struct ResponseToken: Codable {

	let token: String
}
