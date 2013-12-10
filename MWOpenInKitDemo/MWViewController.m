//
//  MWViewController.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWViewController.h"
#import "MWOpenInKit.h"
#import "MWActivityPresenter.h"

@interface MWViewController ()

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UISwitch *activitySwitch;
@end

@implementation MWViewController

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
             @{@"name": @"MWBrowserHandler",
               @"items": @[
                       @{@"description": @"Open an HTTP URL",
                         @"action": (UIActivityViewController *)^{
                             MWBrowserHandler *handler = [[MWBrowserHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             NSURL *url = [NSURL URLWithString:@"http://google.com"];
                             return [handler openURL:url];
                         }
                        },
                       ]
               },

             @{@"name": @"MWMapsHandler",
               @"items": @[
                       @{@"description": @"Search for a map location",
                         @"action": (UIActivityViewController *)^{
                             MWMapsHandler *handler = [[MWMapsHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             handler.center = CLLocationCoordinate2DMake(32.715, -117.1625); // New York City
                             return [handler searchForLocation:@"Ray's Pizza"];
                         }},
                       @{@"description": @"Get turn-by-turn directions",
                         @"action": (UIActivityViewController *)^{
                             MWMapsHandler *handler = [[MWMapsHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             handler.center = CLLocationCoordinate2DMake(32.715, -117.1625); // New York City
                             return [handler directionsFrom:@"Central Park" to:@"Radio City Music Hall"];
                         }}
                       ]
               },
             @{@"name": @"MWTwitterHandler",
               @"items": @[
                       @{@"description": @"Show a specific tweet",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showTweetWithId:@"28"];
                         }},
                       @{@"description": @"Show a user by screen name",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showUserWithScreenName:@"Seinfeld2000"];
                         }},
                       @{@"description": @"Show a user by ID",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showUserWithId:@"1081562149"];
                         }},
                       @{@"description": @"Show timeline",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showTimeline];
                         }},
                       @{@"description": @"Show mentions",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showMentions];
                         }},
                       @{@"description": @"Show DMs",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler showDirectMessages];
                         }},
                       @{@"description": @"Search",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler searchFor:@"#yolo"];
                         }},
                       @{@"description": @"Post a tweet",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler tweetMessage:@"MWOpenInKit is blowing my mind! https://github.com/lazerwalker/MWOpenInKit"];
                         }},
                       @{@"description": @"Reply to a tweet",
                         @"action": (UIActivityViewController *)^{
                             MWTwitterHandler *handler = [[MWTwitterHandler alloc] init];
                             handler.alwaysShowActivityView = self.activitySwitch.on;
                             return [handler tweetMessage:@"MWOpenInKit is blowing my mind! https://github.com/lazerwalker/MWOpenInKit" inReplyTo:@"28"];
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
    MWActivityPresenter *(^action)() = self.content[indexPath.section][@"items"][indexPath.row][@"action"];
    [action() presentActivitySheetFromViewController:self popoverFromRect:[tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

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
