//
//  Order.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI
import Foundation

struct Order: Encodable{
    
    //var id = UUID()
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
    
}
