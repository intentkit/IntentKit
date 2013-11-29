#import "OKViewController.h"
#import "OKWebBrowser.h"

@interface OKViewController ()

@end

@implementation OKViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated]
    ;
    OKWebBrowser *browserOpen = [[OKWebBrowser alloc] init];
    //[browserOpen openURL:[NSURL URLWithString:@"http://google.com/"]];
}
@end
