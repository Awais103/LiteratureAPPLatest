//
//  LoginViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 20/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "LoginViewController.h"
#import "RecoveryViewController.h"
#import "DashBoardViewController.h"
#import "SignUpViewController.h"
#import "SWRevealViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
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

- (IBAction)actionFacebook:(id)sender {
}

- (IBAction)actionTwitter:(id)sender {
}

- (IBAction)actionGmail:(id)sender {
}

- (IBAction)actionRecover:(id)sender {
    
    RecoveryViewController *recoverView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoveryControllerid"];
    [self.navigationController pushViewController:recoverView animated:YES];
}

- (IBAction)actionNext:(id)sender {
    
    SWRevealViewController *revealView = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealControllerid"];
    [self.navigationController pushViewController:revealView animated:YES];
}

- (IBAction)actionSignUp:(id)sender {
    
    SignUpViewController *signupView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupControllerid"];
    [self.navigationController pushViewController:signupView animated:YES];
}
@end
