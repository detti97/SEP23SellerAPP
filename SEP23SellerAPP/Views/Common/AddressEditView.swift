//
//  AddressEditView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 24.08.23.
//

import SwiftUI

struct AddressEditView: View {

	@Binding var recipient: Recipient
	@Binding var addressChanged: Bool

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
				addressFormView(recipient: $recipient ,success: $addressChanged)

				if addressChanged{
					
				}

			}
			.padding(38)

		}


    }
}

struct AddressEditView_Previews: PreviewProvider {
    static var previews: some View {

		let address = Recipient(firstName: "ja", lastName: "de", address: Address(street: "kais", houseNumber: "12", zip: "49809"))

		AddressEditView(recipient: Binding.constant(address), addressChanged: Binding.constant(false))
    }
}