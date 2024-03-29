//
//  FirstStepView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI

struct FirstStepView: View {

	@Binding var showShippingView: Bool
	@Binding var order: Order
	@State private var choosenPackage: String = "M"
	@State private var selectedDate = Date()
	@State private var currentTime = Date()
	@State private var isShowingDeliveryControll = false
	@State private var isActiveAddressPanel = false
	@State private var textFieldTapped = false

	@State private var orderID = "_"

	@State var handInfo = [ HandlingInfo(name: "Zerbrechlich", isMarked: false), HandlingInfo(name: "Glas", isMarked: false), HandlingInfo(name: "Flüßigkeiten", isMarked: false), HandlingInfo(name: "Schwer", isMarked: false)]
	private let packageSizes = ["S", "M", "L", "XL" ]

	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}


	var body: some View {

		NavigationView{

			ZStack(alignment: .bottom){
				Form{

					Section(header: Text("Empfänger")){
						HStack(){

							VStack(){
								Image(systemName: "person")
									.font(.headline)

								Image(systemName: "house")
									.font(.headline)
							}

							VStack(alignment: .leading){
								Text(order.recipient.firstName + " " + order.recipient.lastName)
									.onAppear {
												NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
													self.textFieldTapped = true
												}

												NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
													self.textFieldTapped = false
												}
											}
											.onDisappear {
												NotificationCenter.default.removeObserver(self)
											}
								Text(order.recipient.address.street + " " + order.recipient.address.houseNumber)

							}


						}
						.fontWeight(.heavy)

					}

					Section(header: Text("Handling Info")){

						Picker("PackageSize", selection: $order.packageSize) {
							ForEach(packageSizes, id: \.self) { packageSizes in
								Text(packageSizes)

							}
							.fontWeight(.heavy)
						}
						.pickerStyle(SegmentedPickerStyle())

						List($handInfo) { $HandlingInfo in
							HStack{
								Text(HandlingInfo.name)
									.fontWeight(.heavy)
								Spacer()
								Image(systemName: HandlingInfo.isMarked ? "checkmark.square": "square")
									.font(.system(size: 30))
									.onTapGesture {
										HandlingInfo.isMarked.toggle()
									}
							}
						}

						DatePicker(
							"Lieferdatum wählen",
							selection: $selectedDate,
							in: dateRange(),
							displayedComponents: .date
						)
						.datePickerStyle(CompactDatePickerStyle())
						.onChange(of: selectedDate){ newValue in
							order.deliveryDate = setDeliveryDate()
						}
						.fontWeight(.heavy)
					}

					Section(header: Text("Ablageort")){

						TextField("Abweichender Ablageort", text: $order.customDropOffPlace)
							.onTapGesture {
								textFieldTapped = true
							}
						TextField("Mitarbeiter (Optional)", text: $order.employeeName)
					}

				}


				VStack{

					if !textFieldTapped{

						VStack{

							Button {

								isActiveAddressPanel = true

							} label: {
								ButtonView(buttonText: "Anschrift ändern", buttonColor: .green)
							}
							.sheet(isPresented: $isActiveAddressPanel){
								AddressEditView(recipient: $order.recipient, addressChanged: Binding.constant(false))
							}


							HStack(spacing: 60){

								Button {

									order = Order.defaultOrder()
									showShippingView = false

								} label: {
									ButtonView(buttonText: "Abbrechen", buttonColor: .red)
								}

								Button(action: {
									order.handlingInfo = handInfoToString()
									isShowingDeliveryControll = true

								}) {
									ButtonView(buttonText: "Bestätigen", buttonColor: .blue)
								}
								.sheet(isPresented: $isShowingDeliveryControll, onDismiss: {
									if orderID != "_"{
										showShippingView = false
									}
								}) {
									DeliveryControllView(order: $order, orderID: $orderID, showShippingView: $showShippingView)
								}
							}

						}

					}

				}
				.navigationTitle("Bestellung für" + order.recipient.firstName + " " + order.recipient.lastName)
				.navigationBarTitleDisplayMode(.inline)
				.onAppear{
					print(defaultDeliveryDate())
					order.deliveryDate = defaultDeliveryDate()

				}
			}
		}
	}
	func setDeliveryDate() -> String {

		let selectedDateString = dateFormatter.string(from: selectedDate)
		print("Gewähltes Datum: \(selectedDateString)")
		return selectedDateString

	}

	func handInfoToString() -> String {
		let markedInfos = handInfo.filter { $0.isMarked }
		let combinedNames = markedInfos.map { $0.name }.joined(separator: "&")
		return combinedNames
	}

	func getCurrentDateTime() -> String {
		let now = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy:HH-mm-ss.SSS"
		print(formatter.string(from: now))
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

		FirstStepView(showShippingView: Binding.constant(false), order: Binding.constant(Order.defaultOrder()))
	}
}


