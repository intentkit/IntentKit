#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "INKApplicationList.h"
#import "INKDefaultsViewController.h"
#import "INKDefaultsCell.h"
#import "INKActivityViewController.h"

#import "INKBrowserHandler.h"
#import "INKMailHandler.h"

SpecBegin(INKDefaultsViewController)

describe(@"INKDefaultsViewController", ^{
    __block INKDefaultsViewController *controller;

    beforeEach(^{
        controller = [[INKDefaultsViewController alloc] init];
        [controller.tableView reloadData];
    });

    describe(@"displaying cells", ^{
        describe(@"number of cells", ^{
            context(@"when the list of allowed handlers has been set", ^{
                context(@"when every specified handler is available", ^{
                    it(@"should display all of them", ^{
                        controller.allowedHandlers = @[[INKBrowserHandler class], [INKMailHandler class]];
                        expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to.equal(2);

                    });
                });

                context(@"when some specified handlers are not available or valid", ^{
                    it(@"should not display them", ^{
                        controller.allowedHandlers = @[[INKBrowserHandler class], [UITableViewCell class]];
                        expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to.equal(1);

                    });
                });
            });

            context(@"when the list of allowed handlers has not been set", ^{
                it(@"should have one section for each installed handler", ^{
                    expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to.equal(INKApplicationList.availableHandlers.count);
                });
            });
        });

        it(@"should be an INKDefaultsCell", ^{
            UITableViewCell *cell = controller.tableView.visibleCells[0];
            expect(cell).to.beInstanceOf([INKDefaultsCell class]);
        });

        it(@"should have the correct object", ^{
            INKDefaultsCell *cell = controller.tableView.visibleCells[0];
            expect(cell.handlerClass).to.equal(INKApplicationList.availableHandlers[0]);
        });
    });

    // TODO: INKActivityPresenter doesn't actually use the default presenting mechanism; it just sort of injects it into a subview. There should be a way to test this that doesn't test implementation; this would be a good candidate for a KIF/Frank test.
    xdescribe(@"selecting a cell", ^{
        it(@"should show an activity view controller", ^{
            [controller tableView:controller.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

            expect(controller.presentedViewController).to.beKindOf([INKActivityViewController class]);
        });
    });
});

SpecEnd
