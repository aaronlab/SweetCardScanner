//
//  ContentView.swift
//  SweetCardScannerExample
//
//  Created by Aaron Lee on 2020-11-14.
//

import SwiftUI
import SweetCardScanner

struct ContentView: View {
    // MARK: - PROPERTIES
    
    @State var navigationStatus: NavigationStatus? = .ready
    @State var card: CreditCard?
    
    // MARK: - BODY
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                ZStack {
                    
                    NavigationLink(
                        destination: ResultView(card: card)
                            .onDisappear {
                                /*
                                 You will be able to turn on the camera again
                                 when you come back to this view from the result view
                                 by changing your own customized navigation status.
                                 */
                                self.navigationStatus = .ready
                            },
                        tag: NavigationStatus.pop,
                        selection: $navigationStatus) {
                        EmptyView()
                    }
                    
                    /*
                     You will be able to turn off the camera when you move to the result view
                     with the `if` statement below.
                     */
                    if navigationStatus == .ready {
                        /*
                         You can add some words "in lowercase" to try to skip in recognition to improve the performance like bank names,
                         such as "td", "td banks", "cibc", and so on.
                         Also you can try to add some words "in lowercase" for invalid names, such as "thru", "authorized", "signature".
                         Or you can just simply usw liek "SweetCardScanner()"
                         */
                        SweetCardScanner(
                            wordsToSkip: ["td", "td bank", "cibc"],
                            invalidNames: ["thru", "authorized", "signature"]
                        )
                        .onError { err in
                            print(err)
                        }
                        .onSuccess { card in
                            self.card = card
                            self.navigationStatus = .pop
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke()
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(width: geometry.size.width, height: geometry.size.width * 0.63, alignment: .center)
                    
                } //: ZSTACK
                
            } //: GEOMETRY
            
        } //: NAVIGATION
        
    }
}

// MARK: - NavigationStatus

enum NavigationStatus {
    case ready, pop
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
