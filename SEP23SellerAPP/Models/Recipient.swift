//
//  Recipient.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 26.08.23.
//

import Foundation

struct Recipient: Decodable, Encodable {

	var firstName: String
	var lastName: String
	var address: Address

}


