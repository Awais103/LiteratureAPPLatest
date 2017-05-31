//
//  DashBoardViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 21/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "DashBoardViewController.h"
#import "SWRevealViewController.h"
#import "ShelfViewController.h"
#import "WebViewViewController.h"
@interface DashBoardViewController ()

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barMenu setTarget: self.revealViewController];
        [self.barMenu setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // Do any additional setup after loading the view.
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

- (IBAction)actionTafeem:(id)sender {

    [[NSUserDefaults standardUserDefaults] setValue:@"Tafheem" forKey:@"integer"];
   

    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionLibrary:(id)sender {
    
    ShelfViewController *shelfView = [self.storyboard instantiateViewControllerWithIdentifier:@"ShelfControllerid"];
    [self.navigationController pushViewController:shelfView animated:YES];
}

- (IBAction)actionAfkaar:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"Afkaar" forKey:@"integer"];
    
    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionBlog:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"Blog" forKey:@"integer"];
    
    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionEvents:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"Events" forKey:@"integer"];
    
    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionNews:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"News" forKey:@"integer"];
    
    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionWebsite:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"Website" forKey:@"integer"];
    
    WebViewViewController *WebView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:WebView animated:YES];
}

- (IBAction)actionAbout:(id)sender {
}
@end
