#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "INKDefaultsCell.h"
#import "INKBrowserHandler.h"

SpecBegin(INKDefaultsCell)

fdescribe(@"INKDefaultsCell", ^{
    __block INKDefaultsCell *cell;

    beforeEach(^{
        cell = [[INKDefaultsCell alloc] init];
        cell.handlerClass = [INKBrowserHandler class];
    });

    it(@"should have the right handler name", ^{
        expect(cell.detailTextLabel.text).to.equal(@"Web Browser");
    });

    context(@"when the default application is available", ^{
        it(@"should set the app's name", ^{
            expect(cell.textLabel.text).to.equal(@"Safari");
        });

        // TODO: This is failing because async.
        xit(@"should set the app icon", ^{
            expect(cell.imageView.image).toNot.beNil();
        });
    });

    // TODO: Making this testable requires some refactoring.
    xcontext(@"when the default application is not available", ^{
        it(@"should not have an image", ^{
            expect(cell.imageView.image).to.beNil();
        });

        it(@"should have explanatory text", ^{
            expect(cell.textLabel.text).to.equal(@"No app available");
        });
    });
});

SpecEnd