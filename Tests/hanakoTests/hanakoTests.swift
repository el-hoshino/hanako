import XCTest
@testable import hanako

final class HanakoTests: XCTestCase {
	
	func testCommandParsing() {
        
        let command = "hanako"
        let arguments = command.components(separatedBy: " ")
        let parser = Parser()
        XCTAssertNoThrow({
            let result = try parser.parse(arguments)
            XCTAssertEqual(result.generatedString?.count, 10)
        })
        
        		
	}
	
}

private extension Parser.Result {
    
    var generatedString: String? {
        switch self {
        case .showHelp, .showVersion:
            return nil
            
        case .generateString(let result):
            return result.generatedString
        }
    }
    
}
