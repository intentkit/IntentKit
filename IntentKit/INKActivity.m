//
//  INKActivity.m
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivity.h"
#import "NSString+Helpers.h"
#import "IntentKit.h"

@interface INKActivity ()

@property (readonly) UIImage *_activityImage;

@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) IntentKit *intentKit;

@property (strong, nonatomic) NSString *activityCommand;
@property (strong, nonatomic) NSDictionary *activityArguments;
@property (strong, nonatomic) NSDictionary *names;


@end

@implementation INKActivity

- (instancetype)initWithActions:(NSDictionary *)actions
                 optionalParams:(NSDictionary *)optionalParams
                              name:(NSString *)name
                       application:(UIApplication *)application
                         bundle:(NSBundle *)bundle {
    return [self initWithActions:actions
                  optionalParams:optionalParams
                           names:@{@"en":name}
                     application:application
                          bundle:bundle];
}

- (instancetype)initWithActions:(NSDictionary *)actions
                 optionalParams:(NSDictionary *)optionalParams
                         names:(NSDictionary *)names
                    application:(UIApplication *)application
                         bundle:(NSBundle *)bundle {
    if (self = [super init]) {
        self.names = names;
        self.actions = actions;
        self.optionalParams = optionalParams;
        self.application = application;
        self.intentKit = [IntentKit sharedInstance];
        self.bundle = bundle;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"INKActivity <actions: %@, optionalParams: %@, name: %@, application: %@>",
                    self.actions, self.optionalParams, self.name, self.application];
}

- (BOOL)canPerformCommand:(NSString *)command {
    if (!self.actions[command]) { return NO; }
    NSURL *url = [NSURL URLWithString:[self.actions[command] urlScheme]];
    return [self.application canOpenURL:url];
}

- (NSString *)name {
    if (self.names[@"en"]) {
        return self.names[@"en"];
    } else {
        return self.names[self.names.allKeys.firstObject];
    }
}

- (NSString *)localizedName {
    for (NSString *language in [self.intentKit preferredLanguages]) {
        if (self.names[language]) {
            return self.names[language];
        }
    }
    return self.name;
}

#pragma mark - UIActivity methods
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle {
    return self.localizedName;
}

- (NSString *)activityType {
    return self.name;
}

- (UIImage *)activityImage {
    return self._activityImage;
}

- (UIImage *)_activityImage {
    NSString *filename = [self.bundle pathForResource:self.name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:filename];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    if (activityItems.count != 2) return;

    self.activityCommand = [activityItems firstObject];
    self.activityArguments = [activityItems lastObject];
}

- (void)performActivity {
    if (!self.actions[self.activityCommand]) { return; }

    NSString *urlString = self.actions[self.activityCommand];
    urlString = [urlString stringByEvaluatingTemplateWithData:self.activityArguments];
    urlString = [urlString stringWithTemplatedQueryParams:self.optionalParams
                                                     data:self.activityArguments];

    NSURL *url = [NSURL URLWithString:urlString];
    [self.application openURL:url];
}

@end
