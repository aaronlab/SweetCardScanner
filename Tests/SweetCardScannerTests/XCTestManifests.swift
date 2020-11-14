import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SweetCardScannerTests.allTests),
    ]
}
#endif
