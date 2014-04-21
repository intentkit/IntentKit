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
#import "INKBrowserHandler.h"

#import "INKLocalizedString.h"

static NSString * const CellIdentifier = @"cell";

@interface INKDefaultsViewController ()

@end

@implementation INKDefaultsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;

    [self.tableView registerClass:[INKDefaultsCell class] forCellReuseIdentifier:CellIdentifier];

    self.title = @"App Defaults";

    return self;
}

- (id)initWithAllowedHandlers:(NSArray *)allowedHandlers {
    self = [self init];
    if (!self) return nil;

    self.allowedHandlers = allowedHandlers;

    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedHandlers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groupedHandlers[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Class handlerClass = [self handlerClassForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    INKHandlerCategory category = [handlerClass category];
    return self.sectionHeaders[@(category)];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(INKDefaultsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.handlerClass = [self handlerClassForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    INKDefaultsCell *cell = (INKDefaultsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isUsingFallback) {
        Class handlerClass = [self handlerClassForIndexPath:indexPath];
        INKHandler *handler = [[handlerClass alloc] init];
        [[handler promptToSetDefault] presentActivitySheetFromViewController:self popoverFromRect:[tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:^{
                [self.tableView reloadData];
        }];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private
- (Class)handlerClassForIndexPath:(NSIndexPath *)indexPath {
    return self.groupedHandlers[indexPath.section][indexPath.row];
}

- (NSArray *)groupedHandlers {
    NSMutableDictionary *categories = [NSMutableDictionary new];
    for (Class handlerClass in self.handlers) {
        NSNumber *category = @([handlerClass category]);
        if (!categories[category]) {
            categories[category] = [NSMutableArray new];
        }

        [categories[category] addObject:handlerClass];
    }

    NSMutableArray *handlersAsArray = [NSMutableArray new];
    for (NSNumber *category in [categories.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        [handlersAsArray addObject:categories[category]];
    }

    return [handlersAsArray copy];
}

- (NSArray *)handlers {
    NSArray *installedHandlers = [INKApplicationList availableHandlers];
    if (self.allowedHandlers && self.allowedHandlers.count > 0) {
        NSMutableArray *availableHandlers = [NSMutableArray new];
        for (Class handlerClass in self.allowedHandlers) {
            if ([installedHandlers containsObject:handlerClass]) {
                [availableHandlers addObject:handlerClass];
            }
        }
        return [availableHandlers copy];
    } else {
        return installedHandlers;
    }
}

- (NSDictionary *)sectionHeaders {
    return @{@(INKHandlerCategorySocialNetwork): INKLocalizedString(@"INKHandlerCategorySocialNetwork", nil),
             @(INKHandlerCategoryUtility): INKLocalizedString(@"INKHandlerCategoryUtility", nil)};
}
@end
