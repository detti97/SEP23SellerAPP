//
//  FirstStepView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI

struct FirstStepView: View {

	let packageSizes = ["S", "M", "L", "XL" ]
	@State private var employeSign = ""
	@State private var choosenPackage: String = "M"
	@State private var selectedDate = Date()
	@State private var selectedDateString = ""
	@State private var customDropOffPlace = ""
	@State private var handInfo = [ HandlingInfo(name: "Zerbrechlich", isMarked: false), HandlingInfo(name: "Glas", isMarked: false), HandlingInfo(name: "Flüßigkeiten", isMarked: false), HandlingInfo(name: "Schwer", isMarked: false)]
	@State private var currentTime = Date()
	@State private var isShowingDeliveryControll = false
	@Binding var showShippingView: Bool
	@Binding var repAddress: recipientAddress



	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yy"
		return formatter
	}


	var body: some View {

		NavigationView{

			VStack{

				Form{
					/*
					 Section(header: Text("Empfänger")){
					 HStack(){

					 VStack(){
					 Image(systemName: "person")
					 .font(.headline)

					 Image(systemName: "house")
					 .font(.headline)
					 }

					 VStack(){
					 Text(repAddress.surName + " " + repAddress.name)
					 Text(repAddress.street + " " + repAddress.streetNr)

					 }
					 }

					 }

					 .cornerRadius(10)
					 .shadow(radius: 6)
					 */
					Section(header: Text("Paket Größe auswählen")){
						Picker("PackageSize", selection: $choosenPackage) {
							ForEach(packageSizes, id: \.self) { packageSizes in
								Text(packageSizes)
							}
						}
						.pickerStyle(SegmentedPickerStyle())
					}

					Section(header: Text("Handling Info")){
						List($handInfo) { $HandlingInfo in
							HStack{
								Text(HandlingInfo.name)
									.font(.headline)
								Spacer()
								Image(systemName: HandlingInfo.isMarked ? "checkmark.square": "square")
									.font(.system(size: 30))
									.onTapGesture {
										HandlingInfo.isMarked.toggle()
									}
							}
						}
					}

					Section(header: Text("Lieferdatum wählen")){
						DatePicker(
							"Lieferdatum wählen",
							selection: $selectedDate,
							in: dateRange(),
							displayedComponents: .date
						)
						.datePickerStyle(CompactDatePickerStyle())
						.onChange(of: selectedDate){ newValue in
							setDeliveryDate()
						}
					}
					Section(header: Text("Mitarbeiter Kürzel")){
						TextField("Optional", text: $employeSign)
					}
					Section(header: Text("Ablage Ort")){
						TextField("Abweichender Ablageort", text: $customDropOffPlace)
					}

				}
				
					HStack{

						Button {

							showShippingView = false

						} label: {
							Text("Order abbrechen")
								.padding()
								.foregroundColor(.white)
								.fontWeight(.heavy)
								.background(Color.red)
								.cornerRadius(8)
						}
						.frame(maxWidth: .infinity, alignment: .center)

						Button {

							isShowingDeliveryControll = true

						} label: {
							Text("Confirm details")
								.padding()
								.foregroundColor(.white)
								.fontWeight(.heavy)
								.background(Color.blue)
								.cornerRadius(8)
						}
						.sheet(isPresented: $isShowingDeliveryControll) {
							DeliveryControllView(order: setOrder(repAddress: repAddress, handInfo: handInfoToString(), packageSize: choosenPackage, numberPackages: 1, employeSign: employeSign, deliveryDate: selectedDateString, customDropOffPlace: customDropOffPlace), showShippingView: $showShippingView)
						}
						.frame(maxWidth: .infinity, alignment: .center)


					}
					.background(
						Color.clear)




			}
			.navigationTitle("New Order for " + repAddress.surName + " " + repAddress.name)
			.navigationBarTitleDisplayMode(.inline)
			.onAppear{
				print(defaultDeliveryDate())
				selectedDateString = defaultDeliveryDate()
			}

		}


	}
	func setDeliveryDate(){

		selectedDateString = dateFormatter.string(from: selectedDate)
		print("Gewähltes Datum: \(selectedDateString)")

	}

	func handInfoToString() -> String {
		let markedInfos = handInfo.filter { $0.isMarked }
		let combinedNames = markedInfos.map { $0.name }.joined(separator: "&")
		return combinedNames
	}

	func setOrder(repAddress: recipientAddress, handInfo: String, packageSize: String, numberPackages: Int, employeSign: String, deliveryDate: String, customDropOffPlace: String ) -> Order{

		let newOrder = Order(token: "", timestamp: getCurrentDateTime(), employeeName: employeSign, firstName: repAddress.surName, lastName: repAddress.name, street: repAddress.street, houseNumber: repAddress.streetNr, zip: repAddress.zip, city: "Lingen", packageSize: packageSize, handlingInfo: handInfo, deliveryDate: deliveryDate, customDropOffPlace: customDropOffPlace )

		return newOrder
	}

	func setOrderAddress(repAddress: recipientAddress, handInfo: String, packageSize: Int, numberPackages: Int, employeSign: String, customDropOffPlace: String) -> Order{

		let newOrder = Order(token: "", timestamp: getCurrentDateTime(), employeeName: employeSign, firstName: repAddress.surName, lastName: repAddress.name, street: repAddress.street, houseNumber: repAddress.streetNr, zip: repAddress.zip, city: "Lingen", packageSize: packageSizes[packageSize], handlingInfo: handInfo, deliveryDate: "", customDropOffPlace: customDropOffPlace)

		return newOrder
	}

	func getCurrentDateTime() -> String {
		let now = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy:HH-mm"
		return formatter.string(from: now)
	}

	func defaultDeliveryDate() -> String {

		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yy"

		let calendar = Calendar.current
		let currentHour = calendar.component(.hour, from: currentTime)
		if currentHour >= 13 {

			if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentTime){
				return formatter.string(from: nextDay)
			}

		}else{

			return formatter.string(from: currentTime)

		}

		return ""
	}
	
	func dateRange() -> ClosedRange<Date> {
		let calendar = Calendar.current
		let currentHour = calendar.component(.hour, from: currentTime)
		let currentMinute = calendar.component(.minute, from: currentTime)

		// If current time is after 13:00, set the minimum date to the next day.
		if currentHour >= 13 || (currentHour == 12 && currentMinute > 0) {
			let nextDay = calendar.date(byAdding: .day, value: 1, to: currentTime)!
			let startOfDay = calendar.startOfDay(for: nextDay)
			return startOfDay...calendar.date(byAdding: .day, value: 7, to: startOfDay)!
		} else {
			let startOfDay = calendar.startOfDay(for: currentTime)
			return startOfDay...calendar.date(byAdding: .day, value: 7, to: startOfDay)!
		}
	}
}

struct FirstStepView_Previews: PreviewProvider {
	static var previews: some View {
		let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", zip: "49809")
		let showShippingView = Binding.constant(false)

		FirstStepView(showShippingView: showShippingView, repAddress: Binding.constant(repAdress))
	}
}

