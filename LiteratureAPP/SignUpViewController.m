//
//  SignUpViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 21/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "SignUpViewController.h"
#import "DBManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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

- (IBAction)actionNext:(id)sender {
        if (_txtPassword.text == _txtConfirmPassword.text)
        {
            UIAlertView *alertPassed = [[UIAlertView alloc]initWithTitle:@"Success" message:@"signup form submitted" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertPassed show];
            //////--------Store Data in DataBase from Signup Table-----------//////////////
            NSDictionary *dictSignup = [[NSDictionary alloc]initWithObjectsAndKeys:_txtFullName.text,@"full_name",_txtEmailAddress.text,@"email_address",_txtPassword.text,@"password", nil];
            NSMutableArray *arrSignup = [[NSMutableArray alloc] init];
            [arrSignup addObject:dictSignup];
            [[DBManager getSharedInstance]insertSignup:arrSignup];
            ////////-----------------------------------------------///////////////////////
            [self.navigationController popViewControllerAnimated:YES];

        }
        else {
            UIAlertView *alertfaild = [[UIAlertView alloc] initWithTitle:@"Faild" message:@"Password does not match" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertfaild show];
        }
}
- (IBAction)actionSignin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
