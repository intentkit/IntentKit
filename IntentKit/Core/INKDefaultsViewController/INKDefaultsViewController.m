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

- (id)initWithAllowedHandlers:(NSArray *)allowedHandlers {
    self = [self init];
    if (!self) return nil;

    self.allowedHandlers = allowedHandlers;

    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.handlers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(INKDefaultsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.handlerClass = self.handlers[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class handlerClass = self.handlers[indexPath.row];
    INKHandler *handler = [[handlerClass alloc] init];
    [[handler promptToSetDefault] presentActivitySheetFromViewController:self popoverFromRect:[tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:^{
            [self.tableView reloadData];
    }];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private
- (NSArray *)handlers {
    NSArray *installedHandlers = [INKApplicationList availableHandlers];
    if (self.allowedHandlers && self.allowedHandlers.count > 0) {
        NSMutableArray *availableHandlers = [NSMutableArray new];
        for (Class handlerClass in self.allowedHandlers) {
            if ([installedHandlers containsObject:handlerClass]) {
                [availableHandlers addObject:installedHandlers];
            }
        }
        return [availableHandlers copy];
    } else {
        return installedHandlers;
    }
}
@end
