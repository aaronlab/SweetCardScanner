//
//  CreditCardUtils.swift
//  SweetCardScanner
//
//  Created by Aaron Lee on 2020-11-30.
//

import Foundation

public class CreditCardUtil {
    
    /// Get Card Vendor
    static func getVendor(candidate: String?) -> CardVendor {
        guard let candidate = candidate else { return .Unknown }
        let onlyNumber = candidate.replacingOccurrences(of: "-", with: "")
        
        var type: CardVendor = .Unknown
        
        for card in CardVendor.allCards {
            if (matchCardRegex(regex: card.regex, candidate: onlyNumber)) {
                type = card
                break
            }
        }
        
        return type
    }
    
    /// Match Card Vendor
    static func matchCardRegex(regex: String, candidate: String)-> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = candidate as NSString
            let match = regex.firstMatch(in: candidate, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    /// Validate Expiration
    static func isValid(candidate: DateComponents?) -> Bool? {
        if let candidate = candidate {
            let year = candidate.year ?? 0
            let month = candidate.month ?? 0
            
            let now = Date()
            let yearFormatter = DateFormatter()
            let monthFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            monthFormatter.dateFormat = "MM"
            
            let currentYear = Int(yearFormatter.string(from: now))
            let currentMonth = Int(monthFormatter.string(from: now))
            
            if let currentYear = currentYear, let currentMonth = currentMonth {
                if year > currentYear || year == currentYear && month >= currentMonth && month <= 12 && month > 0 {
                    
                    return true
                }
                
                return false
            }
            
            return nil
        }
        
        return nil
    }
    
}

/// Card Vendors
public enum CardVendor: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
        
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
    
    var regex: String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
    
}
