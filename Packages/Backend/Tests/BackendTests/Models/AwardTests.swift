import XCTest
@testable import Backend

final class AwardTests: XCTestCase {
    
    func test_defaultValueAreCorrect() {
        XCTAssertEqual(Award.default.id, "award")
        XCTAssertEqual(Award.default.name, "Awesome")
        XCTAssertEqual(Award.default.staticIconUrl, URL(staticString: "https://i.redd.it/award_images/t5_22cerq/5smbysczm1w41_Hugz.png"))
        XCTAssertEqual(Award.default.description, "Awesome reward")
        XCTAssertEqual(Award.default.count, 5)
        XCTAssertEqual(Award.default.coinPrice, 200)
    }
    
}
