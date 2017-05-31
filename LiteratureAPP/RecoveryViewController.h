//
//  RecoveryViewController.h
//  LiteratureAPP
//
//  Created by Zain Haider on 21/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecoveryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblRecoveryEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtRecoveryEmailAddress;
- (IBAction)actionSendPassword:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
