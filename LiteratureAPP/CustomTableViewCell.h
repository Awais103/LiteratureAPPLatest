//
//  CustomTableViewCell.h
//  LiteratureAPP
//
//  Created by Zain Haider on 05/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblvenue_id;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblblock_status;
@property (weak, nonatomic) IBOutlet UILabel *lblgcm_id;
@property (weak, nonatomic) IBOutlet UILabel *lblmy_block_status;
@property (weak, nonatomic) IBOutlet UIImageView *imgCustom;
@property (weak, nonatomic) IBOutlet UILabel *lblchat_status;
@property (weak, nonatomic) IBOutlet UILabel *lblmatch_status;
@property (weak, nonatomic) IBOutlet UILabel *lblvenue_name;
@property (weak, nonatomic) IBOutlet UILabel *lblmsg_date;
@property (weak, nonatomic) IBOutlet UILabel *lblopen_chat;
@property (weak, nonatomic) IBOutlet UILabel *lblstepper_id;
@property (weak, nonatomic) IBOutlet UILabel *lbltransaction_date;
@property (weak, nonatomic) IBOutlet UILabel *lblmsg_type;
@property (weak, nonatomic) IBOutlet UILabel *lblmute_status;
@property (weak, nonatomic) IBOutlet UILabel *lblnew_msg_cnt;

@end
