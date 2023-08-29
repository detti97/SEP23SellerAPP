//
//  QRCodeScannerView.swift
//  SEP23SellerAPP

import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {

    @State private var isShowingScanner = false
	@State private var isShowingAddressPanel = false
	@Binding var showShippingView: Bool
	@Binding var order: Order
	@State var addressEntered = false

    
    var body: some View {
        
        NavigationView{
            
            VStack{

                Button{
                    print("hello there")
                    isShowingScanner = true
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
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Steve&Jobs&Bernd-Rosemeyer-Straße&40&49808", completion: handleScan)
                }

				Button{

					isShowingAddressPanel = true

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
				.sheet(isPresented: $isShowingAddressPanel) {
					AddressEditView(recipient: $order.recipient, addressChanged: $addressEntered)
				}
				.onChange(of: addressEntered) { newValue in
					if newValue {
						showShippingView = true
					}
				}

            }
			.navigationTitle("Neue Bestellung aufgeben")
        }

    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result{
        case .success(let result):
            let details = result.string.components(separatedBy: "&")
            guard details.count <= 6 else { return }
            
            let decodedString = Recipient(firstName: details[1],
										  lastName: details[0],
										  address: Address(street: details[2],
										  houseNumber: details[3],
										  zip: details[4]))
			
			self.order.recipient = decodedString
			print(decodedString)
			print(self.order)
			showShippingView = true
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
		
		let showShippingView = Binding.constant(false)
		let order = Binding.constant(Order(timestamp: "", employeeName: "", recipient: Recipient(firstName: "", lastName: "", address: Address(street: "", houseNumber: "", zip: "")), packageSize: "", handlingInfo: "", deliveryDate: "", customDropOffPlace: ""))
		

		QRCodeScannerView(showShippingView: showShippingView, order: order)
    }
}
