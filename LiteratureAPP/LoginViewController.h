//
//  LoginViewController.h
//  LiteratureAPP
//
//  Created by Zain Haider on 20/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblForgetPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblDontHaveAnAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)actionFacebook:(id)sender;
- (IBAction)actionTwitter:(id)sender;
- (IBAction)actionGmail:(id)sender;
- (IBAction)actionRecover:(id)sender;
- (IBAction)actionNext:(id)sender;
- (IBAction)actionSignUp:(id)sender;

@end
