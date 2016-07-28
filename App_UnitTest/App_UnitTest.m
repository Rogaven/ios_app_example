#import <XCTest/XCTest.h>
#import "DAWord.h"

@interface App_UnitTest : XCTestCase
@end

@implementation App_UnitTest

- (void)testWordFromDictionary {
    DAWord *w = [DAWord wordWithNSDictionary:@{ @"id": @1, @"sentence": @"fire", @"translation": @"火" }];
    XCTAssertTrue([w.uuid isEqualToNumber:@1] && [w.value isEqualToString:@"fire"] && [w.translation isEqualToString:@"火"]);
}

- (void)testWordFromDictionaryPerformance {
    [self measureBlock:^{
        [DAWord wordWithNSDictionary:@{ @"id": @1, @"sentence": @"fire", @"translation": @"火" }];
    }];
}

@end
