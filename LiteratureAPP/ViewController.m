//
//  ViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 04/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "CustomTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HTTPService.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //for facebook login
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.loginBehavior = FBSDKLoginBehaviorBrowser;
    // Optional: Place the button in the center of your view.
    [self.view addSubview:loginButton];
 

    
  
    //...................................//
      arrayImg = [[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg", nil];
    // Do any additional setup after loading the view, typically from a nib.

    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    

//    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Zain",@"name",@"Naeem",@"father_name",@"Bahria Orchard",@"address", nil];   
//    NSMutableArray *srrTest = [[NSMutableArray alloc] init];
//    [srrTest addObject:dict1];
//    
//    
//    
//    //    for (int x = 0; x<[srrTest count]; x++) {
//    //        NSLog(@"%@",[srrTest objectAtIndex:x]);
//    //        NSLog(@"%@",[[srrTest objectAtIndex:x] objectForKey:@"Name"]);
//    //
//    //    }
//    
//    [[DBManager getSharedInstance]insertTest:srrTest];
    NSMutableDictionary *myDictionaryForChatFriendList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"10204902782444069",@"facebook_id", nil];
    
    serviceManager = [[ServiceManager alloc] init];
    serviceManager.delegate = self;
    [serviceManager getUserListForChatService:myDictionaryForChatFriendList];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SubmitAction:(id)sender {
    
    
//    NSLog(@"Noth is = %@",_txtNorth.text);
//    NSLog(@"South is = %@",_txtSouth.text);
//    NSLog(@"East is = %@",_txtEast.text);
//    NSLog(@"West is = %@",_txtWest.text);
//    
//    
//    NSString *strURL = [NSString stringWithFormat:@"http://api.geonames.org/citiesJSON?north=%@&south=%@&east=%@&west=%@&lang=de&username=demo",_txtNorth.text,_txtSouth.text,_txtEast.text,_txtWest.text];
//
//    
//    NSLog(@"strURL is = %@",strURL);
//
//
//    
//    serviceManager = [[ServiceManager alloc] init];
//    serviceManager.delegate = self;
//    [serviceManager geoNamesService:strURL];
//    
//    
//    //////
}


-(void)serviceManagerCallBackMethodForChatUserList:(NSArray*)arrayFriendList{
    
    NSLog(@"FriendList = %@",arrayFriendList);
    //To store Data from api to DBmanager
    arrayCollect = [arrayFriendList mutableCopy];
    for (int x=0; x<[arrayCollect count]; x++)
    {
        NSLog(@"%@",[arrayCollect objectAtIndex:x]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"block_status"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"chat_status"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"gcm_id"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"match_status"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"msg"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"msg_date"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"msg_type"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"mute_status"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"my_block_status"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"new_msg_cnt"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"open_chat"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"stepper_id"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"stepper_name"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"transaction_date"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"venue_id"]);
        NSLog(@"%@",[[arrayCollect objectAtIndex:x] objectForKey:@"venue_name"]);
    }
    
    
    [self.tblZain reloadData];

    [[DBManager getSharedInstance]insertFB:arrayCollect];
}


/////////Table Data////////



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 44;
    }if (indexPath.row == 1) {
        return 54;
    }if (indexPath.row == 2) {
        return 74;
    }else{
        return 100;
    }
    
//    self.tblZain.estimatedRowHeight = 44.0;
//    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayCollect.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"custom_cell" forIndexPath:indexPath];
    cell.lblCustomLabel.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.lblMessage.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"stepper_name"];
    cell.lblblock_status.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"block_status"];
    cell.lblchat_status.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"chat_status"];
    cell.lblgcm_id.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"gcm_id"];
    cell.lblmatch_status.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"match_status"];
    cell.lblmsg_date.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"msg_date"];
    cell.lblmsg_type.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"msg_type"];
    cell.lblmute_status.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"mute_status"];
    cell.lblmy_block_status.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"my_block_status"];
    cell.lblnew_msg_cnt.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"new_msg_cnt"];
    cell.lblopen_chat.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"open_chat"];
    cell.lblstepper_id.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"stepper_id"];
    cell.lbltransaction_date.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"transaction_date"];
    cell.lblvenue_id.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"venue_id"];
    cell.lblvenue_name.text = [[arrayCollect objectAtIndex:indexPath.row] objectForKey:@"venue_name"];

    NSLog(@"%@",[arrayImg objectAtIndex:indexPath.row]);
     cell.imgCustom.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrayImg objectAtIndex:indexPath.row]]];
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)btnCLearTable:(id)sender {
        [self.tblZain reloadData];
}
@end
