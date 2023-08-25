//
//  AddressEditView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 24.08.23.
//

import SwiftUI

struct AddressEditView: View {

	@Binding var address: recipientAddress
	@State var addressChanged = false

	var body: some View {


		VStack{


			Text("Bearbeiten Sie hier \n die Anschrift")
				.font(.largeTitle)
				.fontWeight(.heavy)
				.padding()
				.multilineTextAlignment(.center)

			Spacer()
				.frame(height: 5)



			VStack{
				addressFormView(address: $address ,success: $addressChanged)

				if addressChanged{
					
				}

			}
			.padding(38)

		}


    }
}

struct AddressEditView_Previews: PreviewProvider {
    static var previews: some View {

		let address = recipientAddress(name: "jan", surName: "de", street: "kais", streetNr: "12", zip: "49809")

		AddressEditView(address: Binding.constant(address))
    }
}
