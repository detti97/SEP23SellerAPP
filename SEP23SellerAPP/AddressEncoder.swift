//
//  AddressEncoder.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.04.23.
//

import SwiftUI

struct recipientAddress: Identifiable {
    var id = UUID()
    var name: String
    var surName: String
    var street: String
    var streetNr: String
    var plz: String
    var label: String?
    
    func toString() -> String {
        var result = "\n\(surName) \(name) \n"
        result += "\(street) \(streetNr)\n"
        
        return result
    }
}

struct AddressEncoder: View {
    
    var qrCodeString: String
    
    var body: some View {
        
        let reAddres = encodeQRCode(qrCodeString: qrCodeString)
        Text(reAddres.toString())
        
    }
    func encodeQRCode(qrCodeString: String)-> recipientAddress{
        
        let array = qrCodeString.components(separatedBy: "&")
        let newAddress = recipientAddress(name: array[1], surName: array[0], street: array[2], streetNr: array[3], plz: array[4])
        
        return newAddress
    }
}

struct AddressEncoder_Previews: PreviewProvider {
    static var previews: some View {
        AddressEncoder(qrCodeString: "jan&abc&123&abb&49809")
    }
}
