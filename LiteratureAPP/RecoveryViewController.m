//
//  RecoveryViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 21/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "RecoveryViewController.h"

@interface RecoveryViewController ()

@end

@implementation RecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)actionSendPassword:(id)sender {
    
    UIAlertView *alertPassed = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Check your email" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertPassed show];
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
