//
//  INKWebViewSpec.m
//  IntentKitDemo
//
//  Created by Michael Walker on 4/16/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "INKWebView.h"
#import "INKWebViewController.h"
#import "UIViewController+Spec.h"

SpecBegin(INKWebView)

describe(@"INKWebView", ^{
    __block INKWebView *webView;
    __block UIViewController *rootController;

    beforeEach(^{
        webView = [INKWebView new];
        rootController = [UIViewController new];
    });

    describe(@"loading a web page", ^{
        it(@"should show a web view", ^{
            [webView performAction:@"openHttpsURL:" params:@{@"url":@"google.com"} inViewController:rootController];
            expect(rootController.presentedViewController).to.beInstanceOf(UINavigationController.class);

            expect([(UINavigationController *)rootController.presentedViewController topViewController]).to.beInstanceOf(INKWebViewController.class);
        });

    });
});

SpecEnd