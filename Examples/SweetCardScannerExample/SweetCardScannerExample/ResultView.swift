//
//  ResultView.swift
//  SweetCardScannerExample
//
//  Created by Aaron Lee on 2020-11-14.
//

import SwiftUI
import SweetCardScanner

struct ResultView: View {
    // MARK: - PROPERTIES
    
    let card: CreditCard?
    
    // MARK: - BODY
    
    var body: some View {
        
        VStack {
            Text("Name: \(card?.name ?? "N/A")")
            Text("Number: \(card?.number ?? "N/A")")
            Text("Expire Year: \(String(card?.expireDate?.year ?? 00))")
            Text("Expire Month: \(String(card?.expireDate?.month ?? 00))")
        }
        
    }
    
}
