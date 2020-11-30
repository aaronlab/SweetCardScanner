//
//  ResultView.swift
//  SweetCardScannerExample
//
//  Created by Aaron Lee on 2020-11-14.
//

import SwiftUI
import struct SweetCardScanner.CreditCard

struct ResultView: View {
    // MARK: - PROPERTIES
    
    let card: CreditCard?
    
    // MARK: - BODY
    
    var body: some View {
        
        VStack {
            Text("Card Holder Name: \(card?.name ?? "N/A")")
            Text("Number: \(card?.number ?? "N/A")")
            Text("Expire Year: \(String(card?.year ?? 00))")
            Text("Expire Month: \(String(card?.month ?? 00))")
            Text("Card Vendor: \(card?.vendor.rawValue ?? "Unknown")")
            
            if let isNotExpired = card?.isNotExpired {
                isNotExpired ? Text("Expired: Not Expired") : Text("Expired: Expired")
            }
            
        }
        
    }
    
}
