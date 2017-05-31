//
//  DashBoardViewController.h
//  LiteratureAPP
//
//  Created by Zain Haider on 21/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardViewController : UIViewController
- (IBAction)actionTafeem:(id)sender;
- (IBAction)actionLibrary:(id)sender;
- (IBAction)actionAfkaar:(id)sender;
- (IBAction)actionBlog:(id)sender;
- (IBAction)actionEvents:(id)sender;
- (IBAction)actionNews:(id)sender;
- (IBAction)actionWebsite:(id)sender;
- (IBAction)actionAbout:(id)sender;

@property(nonatomic, assign) NSString *myValue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barMenu;
@end
