//
//  SweetCardScanner.swift
//  SweetCardScanner
//
//  Created by Aaron Lee on 2020-11-14.
//

import SwiftUI

public struct SweetCardScanner: UIViewControllerRepresentable {
    
    private var onDismiss: (() -> Void)?
    private var onError: ((CreditCardScannerError) -> Void)?
    private var onSuccess: ((CreditCard) -> Void)?
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = CreditCardScannerViewController(delegate: context.coordinator)
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    public func onDismiss(perform callback: @escaping () -> ()) -> Self {
        var copy = self
        copy.onDismiss = callback
        return copy
    }
    
    public func onError(perform callback: @escaping (CreditCardScannerError) -> ()) -> Self {
        var copy = self
        copy.onError = callback
        return copy
    }
    
    public func onSuccess(perform callback: @escaping (CreditCard) -> ()) -> Self {
        var copy = self
        copy.onSuccess = callback
        return copy
    }
    
}

// MARK: - COORDINATOR

extension SweetCardScanner {
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(onDismiss: self.onDismiss, onError: self.onError, onSuccess: self.onSuccess)
    }
    
    public class Coordinator: NSObject, CreditCardScannerViewControllerDelegate {
        
        private var onDismiss: (() -> Void)?
        private var onError: ((CreditCardScannerError) -> Void)?
        private var onSuccess: ((CreditCard) -> Void)?
        
        public init(onDismiss: (() -> Void)?, onError: ((CreditCardScannerError) -> Void)?, onSuccess: ((CreditCard) -> Void)?) {
            self.onDismiss = onDismiss
            self.onError = onError
            self.onSuccess = onSuccess
        }
        
        public func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController) {
            self.onDismiss?()
        }
        
        public func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError) {
            self.onError?(error)
        }
        
        public func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: CreditCard) {
            self.onSuccess?(card)
        }
        
    }
    
}
