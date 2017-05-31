//
//  TestTableViewCell.h
//  LiteratureAPP
//
//  Created by Zain Haider on 20/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Books;

@interface TestTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imgtest;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imgtest1;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imgtest2;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable btnBook1;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable btnBook2;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable btnBook3;

@end
