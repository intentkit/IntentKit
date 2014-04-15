//
//  INKLocalizedString.m
//  Pods
//
//  Created by Michael Walker on 1/10/14.
//
//

#import "INKLocalizedString.h"

NSString *INKLocalizedString(NSString *key, NSString *comment) {
    NSString *result = @"";

    static NSBundle *bundle = nil;
    if (bundle == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"IntentKit-Localizations" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
        
        NSString *language = [[NSLocale preferredLanguages] count]? [NSLocale preferredLanguages][0]: @"en";
        if (![[bundle localizations] containsObject:language])
        {
            language = [language componentsSeparatedByString:@"-"][0];
        }
        if ([[bundle localizations] containsObject:language])
        {
            bundlePath = [bundle pathForResource:language ofType:@"lproj"];
        }

        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
    }
    result = [bundle localizedStringForKey:key value:result table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:result table:nil];

};
