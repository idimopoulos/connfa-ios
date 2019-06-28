
#import "DCSocialMediaViewController.h"
#import "UIConstants.h"
#import "DCAppSettings.h"
#import "UIScrollView+EmptyDataSet.h"
#import <WebKit/WebKit.h>

@interface DCSocialMediaViewController () <WKUIDelegate>

@property(nonatomic) __block DCMainProxyState previousState;
@property(weak, nonatomic) IBOutlet UIView *placeholderView;
@property WKWebView *webView;

@end

@implementation DCSocialMediaViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.UIDelegate = self;
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self arrangeNavigationBar];
    
    NSString *HTML = @"<a class=\"twitter-timeline\" data-theme=\"light\" href=\"https://twitter.com/CEST2019_RODOS?ref_src=twsrc^tfw\">Tweets by CEST2019</a> <script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>";
    [self.webView loadHTMLString:HTML baseURL:[NSURL URLWithString:@"https://twitter.com"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerScreenLoadAtGA:[NSString stringWithFormat:@"%@", self.navigationItem.title]];
}

#pragma mark - View appearance

- (void)arrangeNavigationBar {
    self.navigationController.navigationBar.barTintColor = [DCAppConfiguration navigationBarColor];
    NSDictionary *textAttributes = NAV_BAR_TITLE_ATTRIBUTES;

    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.translucent = NO;

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

#pragma mark - Google Analytics

- (void)registerScreenLoadAtGA:(NSString *)message {
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:message];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


@end
