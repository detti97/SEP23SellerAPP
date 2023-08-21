import XCTest
@testable import SEP23SellerAPP
import SwiftUI

class APITests: XCTestCase {
    
    
    //Überprüfen ob die sendPostRequest Methode einen Fehler zurückgibt, wenn ungültige URL übergeben wird.
    //Überprüfen ob die sendPostRequest Methode einen Fehler zurückgibt, wenn die Daten nicht in JSON umgewandelt werden können.
    //Überprüfen ob die sendPostRequestWithArrayResponse Methode funktioniert, wie sie soll.
    
    // Wird vor dem Ausführen der Testmethode aufgerufen
    override func setUpWithError() throws {
        
        // Hier können Sie den Initialisierungscode platzieren.
    }
    
    // Wird nach der Ausführung der Testmethode aufgerufen
    override func tearDownWithError() throws {
        // Hier können Sie den Aufräumcode platzieren.
    }
    
    func testInvalidURL() {
        let expectation = self.expectation(description: "Completion handler invoked")
        var resultError: Error?
        
        NetworkManager.sendPostRequest(to: "invalidURL", with: ["key": "value"], responseType: [String: String].self) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                resultError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.localizedDescription, "unsupported URL")
    }
    
    func testInvalidJSON() {
        // Ähnlicher Test wie oben, aber sende ungültige Daten, die nicht zu JSON codiert werden können.
    }
    
    func testSendPostRequestWithArrayResponse() {
        // Teste die sendPostRequestWithArrayResponse Methode.
    }
    
    
    
    class OrderDetailViewTests: XCTestCase {
        
        func testOrderDetailViewDisplaysCorrectData() throws {
            let testOrder = PlacedOrder(orderID: 1, timestamp: "12-08-2023:23-23", employeeName: "Jobs", packageSize: "M", deliveryDate: "2014-08-22T22:00:00.000Z", customDropoffPlace: "Garage", handlingInfo: "Zerbrechlich&Zerbrechlich&Zerbrechlich", firstName: "Test", lastName: "test", street: "Kaiserstraße", houseNumber: "12", ZIP: 49809)
            
            let view = OrderDetailView(order: testOrder)
            
            // Verwende XCTestExpectation, um auf das Rendern der Ansicht zu warten
            let expectation = XCTestExpectation(description: "View rendered")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
        
    }
    
}
