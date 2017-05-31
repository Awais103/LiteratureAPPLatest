
#import "ViewController.h"
#import "DashBoardViewController.h"

@interface WebViewViewController : ViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *myWebview;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Loader;
@property (weak, nonatomic) IBOutlet UILabel *lblNoInternet;


@end
