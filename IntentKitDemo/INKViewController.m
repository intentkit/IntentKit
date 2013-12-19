//
//  INKViewController.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKViewController.h"
#import "IntentKit.h"
#import "INKActivityPresenter.h"

@interface INKViewController ()

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UISwitch *activitySwitch;
@end

@implementation INKViewController

- (instancetype)init {
    if (self = [super init]) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 44, 0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    self.activitySwitch = [[UISwitch alloc] init];
    self.activitySwitch.on = YES;
    [headerView addSubview:self.activitySwitch];

    CGFloat rightEdgeOfSwitch = self.activitySwitch.frame.origin.x + self.activitySwitch.frame.size.width + 5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.activitySwitch.frame.origin.x + self.activitySwitch.frame.size.width + 5, 0,
                                                               headerView.frame.size.width - rightEdgeOfSwitch, 44)];
    label.text = @"Always show activity view";
    label.minimumScaleFactor = 0.1f;
    [headerView addSubview:label];

    self.tableView.tableHeaderView = headerView;
}

- (NSArray *)content {
    return @[
             @{@"name": @"INKBrowserHandler",
               @"items": @[
                       @{@"description": @"Open an HTTP URL",
                         @"action": (UIActivityViewController *)^{
                             INKBrowserHandler *handler = [[INKBrowserHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             NSURL *url = [NSURL URLWithString:@"http://google.com"];
                             return [handler openURL:url];
                         }
                        },
                       ]
               },

             @{@"name": @"INKMapsHandler",
               @"items": @[
                       @{@"description": @"Search for a map location",
                         @"action": (UIActivityViewController *)^{
                             INKMapsHandler *handler = [[INKMapsHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             handler.center = CLLocationCoordinate2DMake(32.715, -117.1625); // New York City
                             return [handler searchForLocation:@"Ray's Pizza"];
                         }},
                       @{@"description": @"Get turn-by-turn directions",
                         @"action": (UIActivityViewController *)^{
                             INKMapsHandler *handler = [[INKMapsHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             handler.center = CLLocationCoordinate2DMake(32.715, -117.1625); // New York City
                             return [handler directionsFrom:@"Central Park" to:@"Radio City Music Hall"];
                         }}
                       ]
               },
             @{@"name": @"INKTwitterHandler",
               @"items": @[
                       @{@"description": @"Show a specific tweet",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showTweetWithId:@"28"];
                         }},
                       @{@"description": @"Show a user by screen name",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showUserWithScreenName:@"Seinfeld2000"];
                         }},
                       @{@"description": @"Show a user by ID",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showUserWithId:@"1081562149"];
                         }},
                       @{@"description": @"Show timeline",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showTimeline];
                         }},
                       @{@"description": @"Show mentions",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showMentions];
                         }},
                       @{@"description": @"Show DMs",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showDirectMessages];
                         }},
                       @{@"description": @"Search",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler searchFor:@"#yolo"];
                         }},
                       @{@"description": @"Post a tweet",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler tweetMessage:@"IntentKit is blowing my mind! https://github.com/intentkit/IntentKit"];
                         }},
                       @{@"description": @"Reply to a tweet",
                         @"action": (UIActivityViewController *)^{
                             INKTwitterHandler *handler = [[INKTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler tweetMessage:@"IntentKit is blowing my mind! https://github.com/intentkit/IntentKit" inReplyTo:@"28"];
                         }},
                       ]
               },
             @{@"name": @"INKMailHandler",
               @"items": @[
                       @{@"description": @"Send a mail",
                         @"action": (UIActivityViewController *)^{
                            INKMailHandler *handler = [[INKMailHandler alloc] init];
                            handler.alwaysShowActivityView = self.activitySwitch.on;
                            handler.subject = @"IntentKit is blowing my mind!";
                            handler.messageBody = @"Check it out on GitHub! https://github.com/intentkit/IntentKit";
                            return [handler sendMailTo:@"appleseed@apple.com"];
                         }},
                       ]
               },
             @{@"name": @"INKFacebookHandler",
               @"items": @[
                       @{@"description": @"Open Facebook Profile",
                         @"action": (UIActivityViewController *)^{
                             INKFacebookHandler *handler = [[INKFacebookHandler alloc] init];
                             [handler setFallback:YES];
                             return [handler showProfileWithId:@"345800612130911"];
                         }},
                       ]
               },
             @{@"name": @"INKGPlusHandler",
               @"items": @[
                     @{@"description": @"Open Google+ Profile",
                       @"action": (UIActivityViewController *)^{
                             INKGPlusHandler *handler = [[INKGPlusHandler alloc] init];
                             [handler setFallback:YES];
                             return [handler showGPlusProfileWithName:@"ArvidGerstmann"];
                       }},
                     ]
               }
             ];
};

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.content[indexPath.section][@"items"][indexPath.row][@"description"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    INKActivityPresenter *(^action)() = self.content[indexPath.section][@"items"][indexPath.row][@"action"];
    INKActivityPresenter *presenter = action();

    [presenter presentActivitySheetFromViewController:self popoverFromRect:[tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content[section][@"items"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.content[section][@"name"];
}
@end
