#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OKActivity.h"

SpecBegin(OKActivity)

describe(@"OKActivity", ^{
    __block NSDictionary *dict;
    __block UIApplication *app;
    __block OKActivity *activity;

    beforeEach(^{
        app = mock([UIApplication class]);

        NSString *path = [NSBundle.mainBundle pathForResource:@"Chrome" ofType:@"plist" inDirectory:@"Web Browsers"];
        dict = [NSDictionary dictionaryWithContentsOfFile:path];

        activity = [[OKActivity alloc] initWithDictionary:dict application:app];

    });


    describe(@"activityTitle", ^{
        it(@"should be the dictionary title", ^{
            expect(activity.activityTitle).to.equal(@"Chrome");
        });
    });

    describe(@"activityType", ^{
        it(@"should be the dictionary title", ^{
            expect(activity.activityType).to.equal(@"Chrome");
        });
    });
});

SpecEnd