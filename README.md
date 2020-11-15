![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)
![Platform](https://img.shields.io/cocoapods/p/SwiftOCR.svg?style=flat)

# SweetCardScanner

SweetCardScanner is a fast and simple Card Scanner library written in Swift, based on [CreditCardScanner](https://github.com/yhkaplan/credit-card-scanner) and [Reg](https://github.com/yhkaplan/Reg) libraries by [@yhkaplan](https://github.com/yhkaplan) so that users can pay much more easily by capturing their credit/debit card with their rear camera.

<center>
<img src="./preview.gif" width="260">
</center>

## Requirements

- iOS 13.0+ (due to SwiftUI, Vision Framework)
  - Tesed on iOS 14.1 with iPhone X

## Installation

- In Xcode, add SwiftPM with the URL of this repository:

  ```http
  https://github.com/aaronLab/SweetCardScanner.git
  ```

## Usage

1. Add `NSCameraUsageDescription` into `Info.plist` for Camera Useage Description.
2. `import SweetCardScanner` on top of the `ContentView.swift`.
3. Now, you can use like `SweetCardScanner()` inside of the body.
4. Also, you can use completion clousures, such as `.onDismiss`, `.onError`, `.onSuccess` right after `SweetCardScanner()` like below.

   ```Swift
   var body: some View {
     SweetCardScanner()
        .onDismiss {
          // Do something when the view dismissed.
        }
        .onError { error in
          // The 'error' above gives you 'CreditCardScannerError' struct below.
          print(error)
        }
        .onSuccess { card in
          // The card above gives you 'CreditCard' struct below.
          print(card)
        }
   }
   ```

## CreditCardScannerError

```Swift
public struct CreditCardScannerError: LocalizedError {
  public enum Kind { case cameraSetup, photoProcessing, authorizationDenied, capture }
  public var kind: Kind
  public var underlyingError: Error?
  public var errorDescription: String? { (underlyingError as? LocalizedError)?.errorDescription }
}
```

## CreditCard

```Swift
public struct CreditCard {
  public var number: String?
  public var name: String?
  public var expireDate: DateComponents?
}
```

## Example

You can customize your own view with SweetCardScanner, and SwiftUI like below.

```Swift
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
                        destination: ResultView(card: card),
                        tag: NavigationStatus.pop,
                        selection: $navigationStatus) {
                        EmptyView()
                    }

                    SweetCardScanner()
                        .onError { err in
                            print(err)
                        }
                        .onSuccess { card in
                            self.card = card
                            self.navigationStatus = .pop
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
```

## License

Licensed under [MIT](https://github.com/aaronLab/SweetCardScanner/blob/main/LICENSE) license.
