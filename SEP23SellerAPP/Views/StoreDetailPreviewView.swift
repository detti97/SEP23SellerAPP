//
//  StoreDetailPreviewView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 18.08.23.
//

import SwiftUI

struct StoreDetailPreviewView: View {

	@Binding var showPreview: Bool

	@State var store = Setting(token: "", storeName: "", owner: "", address: Address(street: "", houseNumber: "", zip: ""), telephone: "", email: "", logo: "", backgroundImage: "https://images.ctfassets.net/uaddx06iwzdz/23fraOkNA2L2nYsNhqQePb/72d26aa66f33cca8b639f4ca4c344474/porsche-911-gt3-touring-front.jpg")

	var body: some View {
		
		ZStack{

			if let url = URL(string: store.backgroundImage) {
						AsyncImage(url: url) { phase in
							switch phase {
							case .success(let image):
								image.resizable()
									.scaledToFill()
									.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
									.opacity(0.6)
							default:
								Color.clear
							}
						}
						.edgesIgnoringSafeArea(.all)

		}
			
			VStack {
				Spacer().frame(height: 20)
				
				AsyncImage(url: URL(string: store.logo)) { image in
					image.resizable()
				} placeholder: {
					ProgressView()
				}
				.frame(width: 150, height: 150)
				.clipShape(Circle())
				.overlay {
					Circle().stroke(Color.white, lineWidth: 4)
				}
				.shadow(radius: 6)
				.accessibility(identifier: "storeLogo")
				
				Text(store.storeName)
					.font(.largeTitle)
					.padding(.top)
					.fontWeight(.heavy)
					.foregroundColor(.white)
					.accessibility(identifier: "storeNameLabel")
				
				
				HStack {
					VStack(spacing: 4) {
						Image(systemName: "person")
						Image(systemName: "house")
						Image(systemName: "phone")
						Image(systemName: "envelope")
					}
					.fontWeight(.heavy)
					
					VStack(alignment: .trailing, spacing: 4) {
						Text(store.owner)
							.accessibility(identifier: "storeOwnerLabel")
						Text("\(store.address.street) \(store.address.houseNumber)")
							.accessibility(identifier: "storeAddressLabel")
						Text(store.telephone)
							.accessibility(identifier: "storePhoneLabel")
						Text(store.email)
							.accessibility(identifier: "storeEmailLabel")
					}
					.fontWeight(.heavy)
				}
				.frame(width: 250, height: 100)
				.font(Font.system(size: 20))
				.padding()
				.background(
					Color.white
						.opacity(0.6)
						.cornerRadius(15)
						.shadow(radius: 6)
				)
				
				
			}

			
			VStack {
				/*MapView(coordinate: store.locationCoordinate, storeName: store.name)
				 .ignoresSafeArea()
				 .frame(width: 400, height: 300)
				 .accessibility(identifier: "mapView")
				 */
			}
		}
	}
	}


	struct StoreDetail_Previews: PreviewProvider {
		static var previews: some View {
			Group{

				let store = Setting(token: "", storeName: "Apple", owner: "Steve Jobs", address: Address(street: "Apple Park", houseNumber: "1", zip: "49809"), telephone: "123456", email: "jobs@apple.com", logo: "https://img.freepik.com/freie-ikonen/mac-os_318-10374.jpg", backgroundImage: "https://wallpapers.com/wp-content/themes/wallpapers.com/src/splash-n.jpg")


				StoreDetailPreviewView(showPreview: Binding.constant(false), store: store)
			}


		}
	}
