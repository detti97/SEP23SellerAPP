//
//  DeliveryControllView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.04.23.
//

import SwiftUI

struct DeliveryControllView: View {
    
    var order: Order
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Group{
                        Text("Token: \(order.token)")
                        Text("Zeitstempel: \(order.timestamp)")
                        Text("Mitarbeiter-ID: \(order.employeName)")
                        Text("Anzahl Pakete: \(order.numberPackage!)")
                        Text("Paket Größe: \(order.packageSize)")
                        Text("Handhabungsinformationen: \(order.handlingInfo)")
                        Text("Lieferdatum: \(order.deliveryDate)")
                    }
                    .font(.headline)
                    Spacer()
                    Group{
                        HStack{
                            Image(systemName: "house")
                            Text("Lieferadresse")
                                
                                
                        }
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                        Group{
                            HStack{
                                Text(order.firstName)
                                Text(order.lastName)
                            }
                            HStack{
                                Text(order.street)
                                Text(order.houseNumber)
                            }
                            HStack{
                                Text(order.zip)
                                Text(order.city)
                            }
                        }
                        
                    }
                }
                .padding()
            }
            .navigationTitle("Lieferungsdetails")
        }
    }

struct DeliveryControllView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(token: "abc-def", timestamp: "22-11-2023", employeName: "WB", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", numberPackage: "2", packageSize: "L", handlingInfo: "none", deliveryDate: "10-04-2023")
        DeliveryControllView(order: order)
    }
}
