//
//  AddressControllView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.04.23.
//

import SwiftUI

struct AddressControllView: View {
    
    var currentRecipientAddress: recipientAddress
    
	var body: some View {
		VStack{
			HStack{
				Image(systemName: "person")
				Text(currentRecipientAddress.surName)
					.font(.headline)
				Text(currentRecipientAddress.name)
					.font(.headline)
			}
			Spacer()
				.frame(height: 30)
			HStack{
				
				Image(systemName: "house")
					.font(.system(size: 30))
				VStack{
					HStack{
						Text(currentRecipientAddress.street)
						Text(currentRecipientAddress.streetNr)
					}
					HStack{
						Text(currentRecipientAddress.zip)
						Text("Lingen")
					}
				}
			}
		}
	}
}

struct AddressControllView_Previews: PreviewProvider {
    static var previews: some View {
        
        let currentAddress = recipientAddress(name: "dettler", surName: "jan", street: "Musterstraße", streetNr: "49", zip: "49809")
        
        AddressControllView(currentRecipientAddress: currentAddress)
    }
}
