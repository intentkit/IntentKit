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

SpecBegin(INKDefaultsViewController)

describe(@"INKDefaultsViewController", ^{
    __block INKDefaultsViewController *controller;

    beforeEach(^{
        controller = [[INKDefaultsViewController alloc] init];
        [controller.tableView reloadData];
    });

    describe(@"displaying cells", ^{
        it(@"should have one section for each handler", ^{
            expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to.equal(INKApplicationList.availableHandlers.count);
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

    xdescribe(@"selecting a cell", ^{
        it(@"should show an activity view controller", ^{
            [controller tableView:controller.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

            expect(controller.presentedViewController).to.beKindOf([INKActivityViewController class]);
        });
    });
});

SpecEnd
