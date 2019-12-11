import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CharacterTests.allTests),
        testCase(HanakoLibTests.allTests),
        testCase(ParserTests.allTests),
        testCase(StringTests.allTests),
    ]
}
#endif
