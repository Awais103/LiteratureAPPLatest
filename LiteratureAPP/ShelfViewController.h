//
//  ShelfViewController.h
//  LiteratureAPP
//
//  Created by Zain Haider on 20/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShelfViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *ArrayTestImg;
    NSMutableArray *arraybook;
    int c;
}

@property (weak, nonatomic) IBOutlet UITableView *tblTest;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barMenu;
@property(nonatomic,strong) NSArray *BookList;
@property(nonatomic,strong) NSArray *BookImg;


@end
