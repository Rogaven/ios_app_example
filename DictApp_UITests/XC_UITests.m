#import <XCTest/XCTest.h>

@interface WordsViewControllerTest : XCTestCase
@end

@implementation WordsViewControllerTest {
    XCUIApplication *app;
}

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
   
    app = [XCUIApplication new];
    [app launch];
}

- (void)testLearnTwoWords {
    XCUIElement *activity = app.activityIndicators[@"In progress"];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists == 0"]
              evaluatedWithObject:activity handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCTAssert(app.tables.cells.count > 0);
    
    XCUIElement *studyingCounter = app.staticTexts[@"studying"];
    XCUIElement *studiedCounter = app.staticTexts[@"studied"];
        
    XCTAssertTrue([studyingCounter.value isEqualToString:@"0"]);
    XCTAssertTrue([studiedCounter.value isEqualToString:@"0"]);
    
    XCUIElementQuery *tables = app.tables;
    [tables.staticTexts[@"Adventurous"] tap];
    [tables.staticTexts[@"Ambitious"] tap];
    
    XCTAssertTrue([studyingCounter.value isEqualToString:@"2"]);
    [app.buttons[@"Train"] tap];
    
    XCUIElement *item1 = app.buttons[@"0"];
    XCUIElement *item3 = app.buttons[@"1"];
    [item1 pressForDuration:0.1 thenDragToElement:item3];
    
    XCUIElement *item2 = app.buttons[@"2"];
    XCUIElement *item4 = app.buttons[@"3"];
    [item2 pressForDuration:0.1 thenDragToElement:item4];
    
    XCTAssertTrue([studyingCounter.value isEqualToString:@"0"]);
    XCTAssertTrue([studiedCounter.value isEqualToString:@"2"]);
    
    XCUIElement *firstCellCheckbox = [[tables.cells containingType:XCUIElementTypeStaticText
                                                        identifier:@"Adventurous"].buttons elementBoundByIndex:0];
    XCTAssertTrue([firstCellCheckbox.label isEqualToString:@"✔︎"]);    
}

- (void)testShowActivityAfterAppStarted {
    XCTAssert([app.activityIndicators[@"In progress"] exists]);
}

@end
