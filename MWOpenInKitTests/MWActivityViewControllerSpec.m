//
//  MWActivityViewControllerSpec
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/4/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "MWActivityPresenter.h"
#import "MWActivityViewController.h"

@interface MWActivityViewController ()
@property UIButton *cancelButton;
@property UICollectionView *collectionView;
@end

SpecBegin(MWActivityViewControllerSpec)

describe(@"MWActivityViewController", ^{
    __block MWActivityViewController *activitySheet;
    __block NSArray *activityItems;
    __block NSArray *applicationActivities;

    beforeEach(^{
        activityItems = @[];
        applicationActivities = @[mock([UIActivity class]), mock([UIActivity class]), mock([UIActivity class])];
        activitySheet = [[MWActivityViewController alloc] initWithActivityItems:activityItems
                                                          applicationActivities:applicationActivities];
        activitySheet.presenter = mock([MWActivityPresenter class]);
    });

    describe(@"when the cancel button is tapped", ^{
        it(@"should inform the presenter", ^{
            [activitySheet.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [verify(activitySheet.presenter) dismissActivitySheet];
        });
    });

    describe(@"the collection view", ^{
        it(@"should have the correct number of sections", ^{
            expect([activitySheet numberOfSectionsInCollectionView:activitySheet.collectionView]).to.equal(1);
        });

        it(@"should have the correct number of sections", ^{
            expect([activitySheet collectionView:activitySheet.collectionView numberOfItemsInSection:0]).to.equal(3);
        });

        context(@"tapping a cell", ^{
            it(@"should perform the given action", ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [activitySheet collectionView:activitySheet.collectionView didSelectItemAtIndexPath:indexPath];
                [verify(applicationActivities[1]) prepareWithActivityItems:activityItems];
                [verify(applicationActivities[1]) performActivity];
            });
        });
    });

});

SpecEnd
