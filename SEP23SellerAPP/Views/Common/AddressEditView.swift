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
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {

		NavigationView{

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
			.navigationBarTitle("Adresse Eingeben")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(leading: cancelButton)

		}

    }

	private var cancelButton: some View {
		Button(action: {
			// Schließe die Ansicht und kehre zum Einstellungsmenü zurück
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Zurück")
		}
	}
}

struct AddressEditView_Previews: PreviewProvider {
    static var previews: some View {

		let address = Recipient(firstName: "ja", lastName: "de", address: Address(street: "kais", houseNumber: "12", zip: "49809"))

		AddressEditView(recipient: Binding.constant(address), addressChanged: Binding.constant(false))
    }
}
