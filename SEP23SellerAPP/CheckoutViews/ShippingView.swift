//
//  FirstStepView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI

/**
 This code is written in Swift and is a view for a seller app that allows the seller to create a shipping order. The view is composed of three main sections:

 Handling Info: allows the seller to mark any special handling information for the package(s) such as "fragile," "glass," "liquids," or "heavy." The seller can mark multiple options.
 
 Employee Package: allows the seller to enter their employee sign and the number of packages they want to ship.
 
 Package Size: allows the seller to select the size of the package from a list of four options (S, M, L, XL) and choose a delivery date using a date picker. Once the package size and delivery date are selected, the seller can confirm the shipment and create the order.
 
 The view also has several state variables, such as packetCount, which keeps track of the number of packages, employeSign, which stores the seller's employee sign, choosenPackage, which keeps track of the selected package size, and selectedDate, which stores the selected delivery date.

 There are also several helper functions, such as handInfoToString(), which converts the marked handling information into a string, and setOrder(), which creates an order based on the information provided by the seller.

 */
struct ShippingpView: View {
    
    let packageSizes = ["S", "M", "L", "XL" ] /// available package sizes
    @State private var packetCount = 1 /// package Count miniumun is one
    @State private var employeSign = "" /// the employee who takes the order can write thier sing here
    @State private var choosenPackage: Int? = nil /// variable for the number of choosen packages from the stepper
    @State var repAddress: recipientAddress
    @State private var handInfo = [ HandlingInfo(name: "Gebrechlich", isMarked: false), HandlingInfo(name: "Glas", isMarked: false), HandlingInfo(name: "Flüßigkeiten", isMarked: false), HandlingInfo(name: "Schwer", isMarked: false)] // array filled with HandlingInfo objects
    
    /// isActive... variables are used for switching the view
    @State private var isActiveHandling = true
    @State private var isActiveEmpPackage = false
    @State private var isActivePackageSize = false
    @State private var isActiveDatePicker = false
    
    @State private var selectedDate = Date() // saves the selected date from the datepicker
    @State private var selectedDateString = "" // this string saves the formated date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        return formatter
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                if isActiveHandling{
                    Form{
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
                        Button(action:
                                { isActiveHandling = false
                            isActiveEmpPackage = true
                        }) {
                            HStack{
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("Bestätigen")
                                    .font(.system(size: 20))
                                
                            }
                            
                        }
                    }
                }
                if isActiveEmpPackage{
                    Form{
                        Section(header: Text("Mitarbeiter Kürzel")){
                            TextField("Optional", text: $employeSign)
                            Stepper("Anzahl Pakete: \(packetCount)", value: $packetCount, in: 1...10)
                                .padding(.vertical)
                        }
                        Button(action:
                                { isActiveEmpPackage = false
                            isActivePackageSize = true
                        }) {
                            HStack{
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))
                                Text("Bestätigen")
                                    .foregroundColor(.blue)
                            }
                        }
                        Button(action:
                                { isActiveHandling = true
                            isActiveEmpPackage = false
                        }) {
                            HStack{
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                                Text("Zurück")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                if isActivePackageSize{
                    
                    Form {
                        Button(action:
                                { isActiveEmpPackage = true
                            isActivePackageSize = false
                        }) {
                            HStack{
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                                Text("Zurück")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Section(header: Text("Paket Größe auswählen")){
                            List {
                                ForEach(packageSizes.indices, id: \.self) { index in
                                    Button(action: {
                                        if choosenPackage == index {
                                            choosenPackage = nil
                                        } else {
                                            choosenPackage = index
                                        }
                                    }) {
                                        HStack {
                                            Text(packageSizes[index])
                                            Spacer()
                                            if choosenPackage == index {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                    }
                                    .disabled(choosenPackage != nil && choosenPackage != index)
                                }
                            }
                        }
                        Section(header: Text("Lieferdatum wählen")){
                                DatePicker(
                                    "Lieferdatum wählen",
                                    selection: $selectedDate,
                                    in: Date()...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                
                                Button("Bestätigen") {
                                    selectedDateString = dateFormatter.string(from: selectedDate)
                                    print("Gewähltes Datum: \(selectedDateString)")
                                    isActiveDatePicker = false
                                }
                        }
                        
                        
                        NavigationLink("Lieferung beauftragen", destination: DeliveryControllView(order: setOrder(repAddress: repAddress, handInfo: handInfoToString(), packageSize: choosenPackage ?? 1, numberPackages: packetCount, employeSign: employeSign, deliveryDate: selectedDateString)))
                            .disabled(choosenPackage == nil || selectedDateString == "")
                            .foregroundColor(.blue)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func handInfoToString() -> String {
        let markedInfos = handInfo.filter { $0.isMarked }
        let combinedNames = markedInfos.map { $0.name }.joined(separator: "&")
        return combinedNames
    }
    func setOrder(repAddress: recipientAddress, handInfo: String, packageSize: Int, numberPackages: Int, employeSign: String, deliveryDate: String) -> Order{
        
        let newOrder = Order(token: "", timestamp: getCurrentDateTime(), employeName: employeSign, firstName: repAddress.surName, lastName: repAddress.name, street: repAddress.street, houseNumber: repAddress.streetNr, zip: repAddress.zip, city: "Lingen", numberPackage: "\(numberPackages)", packageSize: packageSizes[packageSize], handlingInfo: handInfo, deliveryDate: deliveryDate)
        
        return newOrder
    }
    
    func getCurrentDateTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy:HH-mm"
        return formatter.string(from: now)
    }
    
}

struct ShippingView_Previews: PreviewProvider {
    static var previews: some View {
        let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", zip: "49809")
        
        ShippingpView(repAddress: repAdress)
    }
}

