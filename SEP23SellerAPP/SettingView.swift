import SwiftUI

struct SettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showEditAddress = false
    @State private var showEditOpeningHours = false
    @State private var showEditPhoneNumber = false
    @State private var zipCode = ""
    @State private var homeNumber = ""
    @State private var address = ""
    @State private var openingHours = ""
    @State private var phoneNumber = ""

    @Binding var signInSuccess: Bool // Hinzugefügtes Binding-Attribut für den Anmeldestatus

    var body: some View {
        Form {
            Section(header: Text("Ladeninformationen")) {
                Button(action: {
                    showEditAddress = true
                }) {
                    Text("Adresse bearbeiten")
                }
                .sheet(isPresented: $showEditAddress) {
                    EditAddressView(address: $address, homeNumber: $homeNumber, zipCode: $zipCode)
                }

                Button(action: {
                    showEditOpeningHours = true
                }) {
                    Text("Öffnungszeiten bearbeiten")
                }
                .sheet(isPresented: $showEditOpeningHours) {
                    EditOpeningHoursView(openingHours: $openingHours)
                }

                Button(action: {
                    showEditPhoneNumber = true
                }) {
                    Text("Telefonnummer bearbeiten")
                }
                .sheet(isPresented: $showEditPhoneNumber) {
                    EditPhoneNumberView(phoneNumber: $phoneNumber)
                }
            }

            Section {
                Button(action: {
                    signOut()
                }) {
                    Text("Abmelden")
                        .foregroundColor(.red)
                }
            }

            Section(header: Text("Einstellungen")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
            }

        }
        .navigationBarTitle("Einstellungen")
    }

    private func signOut() {
        // Implementiere hier die Logik für das Abmelden
        // ...

        signInSuccess = false // Setze den Anmeldestatus auf false
    }
}

struct EditAddressView: View {
    @Binding var address: String
    @Binding var homeNumber: String
    @Binding var zipCode: String

    var body: some View {
        NavigationView {
            Form {
                TextField("Adresse", text: $address)
                TextField("Hausnummer", text: $homeNumber)
                TextField("PLZ", text: $zipCode)
            }
            .navigationBarTitle("Adresse bearbeiten")
            .navigationBarItems(trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...
        }) {
            Text("Speichern")
        }
    }
}

struct EditOpeningHoursView: View {
    @Binding var openingHours: String

    var body: some View {
        NavigationView {
            Form {
                TextField("Öffnungszeiten", text: $openingHours)
            }
            .navigationBarTitle("Öffnungszeiten bearbeiten")
            .navigationBarItems(trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...
        }) {
            Text("Speichern")
        }
    }
}

struct EditPhoneNumberView: View {
    @Binding var phoneNumber: String

    var body: some View {
        NavigationView {
            Form {
                TextField("Telefonnummer", text: $phoneNumber)
            }
            .navigationBarTitle("Telefonnummer bearbeiten")
            .navigationBarItems(trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...
        }) {
            Text("Speichern")
        }
    }
}
