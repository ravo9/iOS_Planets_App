import XCTest
import CoreData

@testable import Planets_App

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
    }
    
    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }
    
    func testSharedInstance() {
        // Ensure that the shared instance is not nil
        XCTAssertNotNil(CoreDataManager.shared)
        
        // Ensure that subsequent access returns the same instance
        XCTAssertIdentical(CoreDataManager.shared, coreDataManager)
    }
    
    func testMainContext() {
        // Ensure that the main context is not nil
        XCTAssertNotNil(coreDataManager.mainContext)
        
        // Ensure that the main context is of the correct type
        XCTAssertTrue(coreDataManager.mainContext is NSManagedObjectContext)
    }
    
    func testBackgroundContext() {
        // Ensure that the background context is not nil
        let backgroundContext = coreDataManager.backgroundContext()
        XCTAssertNotNil(backgroundContext)
        
        // Ensure that the background context is of the correct type
        XCTAssertTrue(backgroundContext is NSManagedObjectContext)
        
        // Ensure that the background context is not the same as the main context
        XCTAssertNotEqual(backgroundContext, coreDataManager.mainContext)
    }
}
