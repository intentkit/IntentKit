#import "OKViewController.h"
#import "OKWebBrowser.h"

@interface OKViewController ()

@end

@implementation OKViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated]
    ;
    OKWebBrowser *browserOpen = [[OKWebBrowser alloc] init];
    [browserOpen openURL:[NSURL URLWithString:@"http://google.com/"]];

    NSString *path = [NSBundle.mainBundle pathForResource:@"Chrome" ofType:@"png" inDirectory:@"Web Browsers/Icons"];

    NSLog(@"HI ================> %@", [UIImage imageWithContentsOfFile:path]);
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]]];
}
@end
