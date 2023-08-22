//
//  AddressPanelView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

struct AddressPanelView: View {

	let zipCodes = ["49808", "49809" , "49811"]

	@Binding var showShippingView: Bool
	@Binding var isActiveAddressPanel: Bool
	@Binding var repAddress: recipientAddress


	@State private var name: String = ""
	@State private var surName: String = ""
	@State private var street: String = ""
	@State private var streetNr: String = ""
	@State private var plz: String = ""
	@State private var label: String = ""

	@FocusState private var focusField: Field?

	enum Field{
		case surname, name, street, housenumber, zip, discription
	}

    var body: some View {

		VStack {

			VStack{


				Text("Geben Sie hier \n die Anschrift ein")
					.font(.largeTitle)
					.fontWeight(.heavy)
					.padding()
					.multilineTextAlignment(.center)

				Spacer()
					.frame(height: 10)

				TextField("Vorname", text: $surName)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.textFieldStyle(CustomTextFieldStyle(systemImageName: "person"))
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.gray, lineWidth: 1)
					)

					.frame(maxWidth: .infinity)
					.focused($focusField, equals: .surname)
					.submitLabel(.next)
					.onSubmit {
						focusField = .name
					}
				TextField("Nachname", text: $name)
					.frame(height: 30)
					.padding(10)
					.frame(maxWidth: .infinity)
					.textFieldStyle(CustomTextFieldStyle(systemImageName: "figure.fall"))
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.gray, lineWidth: 1)
					)
					.focused($focusField, equals: .name)
					.submitLabel(.next)
					.onSubmit {
						focusField = .street
					}
				TextField("Straße", text: $street)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.gray, lineWidth: 1)
					)
					.textFieldStyle(CustomTextFieldStyle(systemImageName: "house"))
					.focused($focusField, equals: .street)
					.submitLabel(.next)
					.onSubmit {
						focusField = .housenumber
					}
				TextField("Hausnummer", text: $streetNr)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.gray, lineWidth: 1)
					)
					.textFieldStyle(CustomTextFieldStyle(systemImageName: "figure.skiing.downhill"))
					.focused($focusField, equals: .housenumber)
					.submitLabel(.next)
					.onSubmit {
						focusField = .zip
					}
				Picker("Postleitzahl", selection: $plz) {
					ForEach(zipCodes, id: \.self) { plz in
						Text(plz)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.focused($focusField, equals: .zip)
				TextField("Ablage Ort (optional)", text: $label)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.gray, lineWidth: 1)
					)
					.textFieldStyle(CustomTextFieldStyle(systemImageName: "square.and.pencil"))
					.focused($focusField, equals: .discription)
					.submitLabel(.next)
					.onSubmit {
						focusField = nil
					}
			}

				Spacer()
					.frame(height: 50)

			VStack{

				Button(action: {

					let address = recipientAddress(name: name, surName: surName, street: street, streetNr: streetNr, zip: plz)
					repAddress = address
					name = ""
					surName = ""
					street = ""
					streetNr = ""
					plz = ""
					label = ""

					showShippingView = true

				}) {
					HStack {
						Image(systemName: "square.and.arrow.down.fill")
						Text("Adresse bestätigen")
					}
					.font(.headline)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(18)

				}
				.disabled(name.isEmpty || street.isEmpty || streetNr.isEmpty || plz.isEmpty)

				Button(action: {


					name = ""
					surName = ""
					street = ""
					streetNr = ""
					plz = ""
					label = ""

					isActiveAddressPanel = false



				}) {
					HStack {
						Image(systemName: "trash")
						Text("Abbrechen")
					}
					.font(.headline)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.red)
					.foregroundColor(.white)
					.cornerRadius(18)

				}
				
			}

		}
		.padding(20)
    }
}

struct recipient {

	var lastName: String
	var firstName: String
	var street: String
	var streetNr: String
	var plz: String
	var label: String?

}

struct AddressPanelView_Previews: PreviewProvider {
    static var previews: some View {

		let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", zip: "49809")
		let showShippingView = Binding.constant(false)
		let showAddressPanel = Binding.constant(false)

		AddressPanelView(showShippingView: showShippingView, isActiveAddressPanel: showAddressPanel, repAddress: Binding.constant(repAdress))
    }
}
