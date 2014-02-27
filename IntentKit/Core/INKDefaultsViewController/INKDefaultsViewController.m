//
//  INKDefaultsViewController.m
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import "INKDefaultsViewController.h"
#import "INKApplicationList.h"
#import "INKDefaultsCell.h"
#import "INKHandler.h"

static NSString * const CellIdentifier = @"cell";

@interface INKDefaultsViewController ()

@end

@implementation INKDefaultsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;

    [self.tableView registerClass:[INKDefaultsCell class] forCellReuseIdentifier:CellIdentifier];

    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [INKApplicationList availableHandlers].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    INKHandler *handler = [[[INKApplicationList availableHandlers][section] alloc] init];
    return handler.name;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(INKDefaultsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.handlerClass = [INKApplicationList availableHandlers][indexPath.section];
}

@end
