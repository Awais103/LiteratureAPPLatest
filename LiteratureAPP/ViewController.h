//
//  ViewController.h
//  LiteratureAPP
//
//  Created by Zain Haider on 04/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController : UIViewController<ServiceManagerCallBackDelegate>{
    NSMutableArray *arrayCollect;
    ServiceManager *serviceManager;
    NSMutableArray *arrayQuery;
    NSMutableArray *arrayImg;
    NSMutableArray *arrayDelete;
}
- (IBAction)btnCLearTable:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNorth;
@property (weak, nonatomic) IBOutlet UILabel *lblSouth;
@property (weak, nonatomic) IBOutlet UILabel *lblEast;
@property (weak, nonatomic) IBOutlet UILabel *lblWest;
@property (weak, nonatomic) IBOutlet UITextField *txtNorth;
@property (weak, nonatomic) IBOutlet UITextField *txtSouth;
@property (weak, nonatomic) IBOutlet UITextField *txtEast;
@property (weak, nonatomic) IBOutlet UITextField *txtWest;

- (IBAction)SubmitAction:(id)sender;
- (void)_loadData;


@property (weak, nonatomic) IBOutlet UITableView *tblZain;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

