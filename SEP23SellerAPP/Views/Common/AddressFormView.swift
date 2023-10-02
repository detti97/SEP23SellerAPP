//
//  AddressFormView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 24.08.23.
//

import SwiftUI

struct FieldTapped{

	var turnRed: Bool = false
	var fieldTapped: Bool = false
	var textEntert: Bool = false

}

extension String {
	var containsEmoji: Bool {
		return unicodeScalars.contains { $0.isEmoji }
	}

	var removingEmoji: String {
		return String(unicodeScalars.filter { !$0.isEmoji })
	}
}

extension UnicodeScalar {

	var isEmoji: Bool {
		return (0x1F600...0x1F64F).contains(value) || // Emoticons
			(0x1F300...0x1F5FF).contains(value) ||   // Verschiedene Symbole und Piktogramme
			(0x1F680...0x1F6FF).contains(value) ||   // Transport und Landkarten Symbole
			(0x1F700...0x1F77F).contains(value) ||   // Alchemie Symbole
			(0x1F780...0x1F7FF).contains(value) ||   // Geometrische Formen erweitert
			(0x1F800...0x1F8FF).contains(value) ||   // Verschiedene Symbole erweitert
			(0x1F900...0x1F9FF).contains(value) ||   // Supplementär Mathematische Operatoren
			(0x1FA00...0x1FA6F).contains(value) ||   // Unterstützung für Zodiac und Mitzodiak Zeichen
			(0x1FA70...0x1FAFF).contains(value) ||   // Verschiedene Symbole erweitert - Astronomie und Astrologie
			(0x1FAB0...0x1FABF).contains(value) ||   // Verschiedene Symbole erweitert - Gesteinszeichnungen
			(0x1FAC0...0x1FAFF).contains(value) ||   // Verschiedene Symbole erweitert - Astrologische Symbole
			(0x1FAD0...0x1FAFF).contains(value) ||   // Verschiedene Symbole erweitert - Ornamente
			(0x1FAE0...0x1FAFF).contains(value) ||   // Verschiedene Symbole erweitert - Fleisch, Knochen
			(0x1FAF0...0x1FAFF).contains(value) ||   // Verschiedene Symbole erweitert - Umwelt
			(0x1FDB0...0x1FDBF).contains(value) ||   // Zusätzliche Emoticons
			(0x1F004...0x1F0CF).contains(value) ||   // Zusätzliche Emoticons und Symbole
			(0x1F170...0x1F251).contains(value)      // Zusätzliche Symbole
	}
}


struct addressFormView: View {


	@Binding var recipient: Recipient
	@Binding var success: Bool
	@State var label = ""

	@State private var showSuccessAlert = false
	@Environment(\.dismiss) var dismiss


	let zipCodes = ["49808", "49809" , "49811"]

	@FocusState private var focusField: Field?

	enum Field{
		case surname, name, street, housenumber, zip, discription
	}

	@State var fields: [FieldTapped] = Array(repeating: FieldTapped(), count: 5)
	@State private var isTitleMissing: Bool = false
	@State private var inputTitle: String = ""





	var body: some View {

		VStack{

			VStack{

				TextField("Vorname", text: $recipient.firstName)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.textFieldStyle(CustomTextFieldStyleView(systemImageName: "person.crop.square.fill"))
					.onTapGesture{
						checkForEmptyField()
						fields[0].fieldTapped = true
						fields[0].turnRed = false

					}
					.onChange(of: recipient.firstName) { _ in

						fields[0].textEntert = true
					}
					.onChange(of: recipient.firstName) { newValue in
									// Überprüfe die Eingabe auf Emojis
									if newValue.containsEmoji {
										// Emoji gefunden, entferne es aus der Eingabe
										recipient.firstName = newValue.removingEmoji
									}
								}
					.overlay(RoundedRectangle(cornerRadius: 24)
						.stroke(fields[0].turnRed ? Color.red : Color.gray, lineWidth: 3)
					)
					.frame(maxWidth: .infinity)
					.focused($focusField, equals: .surname)
					.submitLabel(.next)
					.onSubmit {
						focusField = .name
					}

				TextField("Nachname", text: $recipient.lastName)
					.frame(height: 30)
					.padding(10)
					.frame(maxWidth: .infinity)
					.textFieldStyle(CustomTextFieldStyleView(systemImageName: "person.crop.square"))
					.onTapGesture{
						checkForEmptyField()
						fields[1].fieldTapped = true
						fields[1].turnRed = false


					}
					.onChange(of: recipient.lastName) { _ in

						fields[1].textEntert = true
					}
					.overlay(RoundedRectangle(cornerRadius: 24)
						.stroke(fields[1].turnRed ? Color.red : Color.gray, lineWidth: 3)
					)
					.focused($focusField, equals: .name)
					.submitLabel(.next)
					.onSubmit {
						focusField = .street
					}

				TextField("Straße", text: $recipient.address.street)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 24)
							.stroke(Color.gray, lineWidth: 3)
					)
					.textFieldStyle(CustomTextFieldStyleView(systemImageName: "house"))
					.onTapGesture{
						checkForEmptyField()
						fields[2].fieldTapped = true
						fields[2].turnRed = false


					}
					.onChange(of: recipient.address.street) { _ in

						fields[2].textEntert = true
					}
					.overlay(RoundedRectangle(cornerRadius: 24)
						.stroke(fields[2].turnRed ? Color.red : Color.gray, lineWidth: 3)
					)
					.focused($focusField, equals: .street)
					.submitLabel(.next)
					.onSubmit {
						focusField = .housenumber
					}

				TextField("Hausnummer", text: $recipient.address.houseNumber)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 24)
							.stroke(Color.gray, lineWidth: 3)
					)
					.textFieldStyle(CustomTextFieldStyleView(systemImageName: "numbersign"))
					.onTapGesture{
						checkForEmptyField()
						fields[3].fieldTapped = true
						fields[3].turnRed = false
					}
					.onChange(of: recipient.address.houseNumber) { _ in

						fields[3].textEntert = true
					}
					.overlay(RoundedRectangle(cornerRadius: 24)
						.stroke(fields[3].turnRed ? Color.red : Color.gray, lineWidth: 3)
					)
					.focused($focusField, equals: .housenumber)
					.submitLabel(.next)
					.onSubmit {
						focusField = .zip
					}
					.onChange(of: recipient.address.houseNumber) { newValue in
									if newValue.count > 5 {
										recipient.address.houseNumber = String(newValue.prefix(5))
									}
								}
					.keyboardType(.decimalPad)
				Picker("Postleitzahl", selection: $recipient.address.zip) {
					ForEach(zipCodes, id: \.self) { plz in
						Text(plz)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.focused($focusField, equals: .zip)
				.overlay(RoundedRectangle(cornerRadius: 24)
					.stroke(fields[4].turnRed ? Color.gray : Color.gray, lineWidth: 3)
				)

				TextField("Ablageort (optional)", text: $label)
					.frame(height: 30)
					.frame(maxWidth: .infinity)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 24)
							.stroke(Color.gray, lineWidth: 3)
					)
					.textFieldStyle(CustomTextFieldStyleView(systemImageName: "square.and.pencil"))
					.focused($focusField, equals: .discription)
					.submitLabel(.next)
					.onSubmit {
						focusField = nil
					}
					.onTapGesture{
						checkForEmptyField()
					}
			}

			VStack{

				Button(action: {

					//address.label = label

					showSuccessAlert = true
					success = true

				}) {
					HStack {
						Image(systemName: "square.and.arrow.down.fill")
						Text("Adresse speichern")
					}
					.font(.headline)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.accentColor)
					.foregroundColor(.white)
					.cornerRadius(18)
					.padding()
				}
				.disabled(recipient.firstName.isEmpty || recipient.address.street.isEmpty || recipient.address.houseNumber.isEmpty || recipient.lastName.isEmpty)
				.onTapGesture{
					checkForEmptyFieldFinal()
				}


			}
			.alert(isPresented: $showSuccessAlert, content: {
				Alert(
					title: Text("Adresse gespeichert"),
					message: nil,
					dismissButton: .default(
						Text("OK"),
						action: { dismiss()
						}
					)
				)
			})

		}
	}

	func checkForEmptyField() {

		for index in fields.indices {

			if fields[index].fieldTapped && !fields[index].textEntert{
				fields[index].turnRed = true
				print("Field \(index): Nichts eingegeben!")
			}
		}
	}
	func checkForEmptyFieldFinal() {

		for index in fields.indices {

			if !fields[index].textEntert {
				fields[index].turnRed = true
			}
		}
	}


}

struct AddressFormView_Previews: PreviewProvider {
	static var previews: some View {

		let address = Recipient(firstName: "", lastName: "", address: Address(street: "", houseNumber: "", zip: ""))
		let success = false

		addressFormView(recipient: Binding.constant(address), success: Binding.constant(success))
	}
}
