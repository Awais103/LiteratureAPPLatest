#import "WebViewViewController.h"
#import "DashBoardViewController.h"

@interface WebViewViewController ()
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//-----------Storing NSUser Value to a New URL var--------------//
    NSURL *myURL= [[NSURL alloc]init];
    NSString *myvalue =[[NSUserDefaults standardUserDefaults] objectForKey:@"integer"];
    
//-----------Matching the corresponding value to URL--------------//
    if ([myvalue isEqual:@"Afkaar"])
    {
        myURL = [NSURL URLWithString:@"https://www.facebook.com/Afkaar.Maududi/"];
    }
    else if ([myvalue isEqual:@"Tafheem"])
    {
        myURL = [NSURL URLWithString:@"http://tafheemulquran.org/tafhim_u/000/surah_all.htm"];
    }
    else if ([myvalue isEqual:@"Blog"])
        {
            myURL = [NSURL URLWithString:@"http://forum.jamaat.org.htm"];
        }
    else if ([myvalue isEqual:@"Events"])
        {
            myURL = [NSURL URLWithString:@"https://www.facebook.com/JIPOfficial1"];
        }
    else if ([myvalue isEqual:@"News"])
        {
            myURL = [NSURL URLWithString:@"http://jamaat.org/ur/"];
        }
    else if ([myvalue isEqual:@"Website"])
        {
            myURL = [NSURL URLWithString:@"http://http://jamaat.org/ur/"];
        }
    
//----------------Loading URL and Webview--------------//
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    [myWebview loadRequest:myRequest];


}
//-------Loader-------/////
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_Loader startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _lblNoInternet.hidden=YES;
    [_Loader stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _lblNoInternet.text=@"Something wen't wrong Try again";
    [_Loader stopAnimating];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
