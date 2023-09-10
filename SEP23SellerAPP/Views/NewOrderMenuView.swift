//
//  QRCodeScannerView.swift
//  SEP23SellerAPP

import SwiftUI
import CodeScanner

struct NewOrderMenuView: View {

    @State private var isShowingScanner = false
	@State private var isShowingAddressPanel = false
	@Binding var showShippingView: Bool
	@Binding var order: Order
	@State var addressEntered = false
	@State var scanFail = false
	@State var showScanFailAlert = false

    
    var body: some View {
        
        NavigationView{
            
            VStack{

                Button{
					isShowingScanner = true
                    print("Scanner start")
					print(isShowingScanner)
                }label: {
                    
                    ZStack{
                        Capsule()
							.fill(Color.accentColor)
                            .frame(width: 330, height: 130)
                            .shadow(radius: 11)
                        
                        HStack{
                            
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.yellow)
                                .font(.system(size: 80))
                            
                            Text("Scanner starten")
								.fontWeight(.heavy)
								.foregroundColor(.white)
                        }
                    }
                }
                .foregroundColor(.white)
				.fontWeight(.heavy)
				.sheet(isPresented: $isShowingScanner, onDismiss: {
					scanFail = true
					isShowingScanner = false
				}) {
                    CodeScannerSheetView(isShowingScanner: $isShowingScanner, showShippingView: $showShippingView, order: $order)
                }

				Button{
					isShowingAddressPanel = true
					addressEntered = false

					print("Address panel")
					print(isShowingAddressPanel)

				}label: {

					ZStack{
						Capsule()
							.fill(Color.accentColor)
							.frame(width: 330, height: 130)
							.shadow(radius: 11)

						HStack{

							Image(systemName: "house.fill")
								.foregroundColor(.yellow)
								.font(.system(size: 70))

							Text("Adress Eingabe")
								.font(.headline)
						}
					}

				}
				.foregroundColor(.white)
				.fontWeight(.heavy)
				.sheet(isPresented: $isShowingAddressPanel, onDismiss: {
					isShowingAddressPanel = false
				}) {
					AddressEditView(recipient: $order.recipient, addressChanged: $addressEntered)
				}
				.onChange(of: addressEntered) { newValue in
					if newValue {
						showShippingView = true
					}
				}
            }
			.navigationTitle("Neue Bestellung aufgeben")
			.navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
		
		let showShippingView = Binding.constant(false)
		let order = Binding.constant(Order(timestamp: "", employeeName: "", recipient: Recipient(firstName: "", lastName: "", address: Address(street: "", houseNumber: "", zip: "")), packageSize: "", handlingInfo: "", deliveryDate: "", customDropOffPlace: ""))
		

		NewOrderMenuView(showShippingView: showShippingView, order: order)
    }
}
