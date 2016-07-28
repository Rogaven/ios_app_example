#import <Cedar/Cedar.h>
#import "DAWord.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WordSpec)

beforeEach(^{
    NSLog(@"before each");
});

describe(@"DAWord", ^{
    DAWord *w = [DAWord wordWithNSDictionary:@{ @"id": @1, @"sentence": @"fire", @"translation": @"火" }];
    
    it(@"should be valid with valid dictionary at input", ^{
        w.uuid should equal(@1);
        w.value should equal(@"fire");
        w.translation should equal(@"火");
    });
});

afterEach(^{
    NSLog(@"after each");
});

SPEC_END
