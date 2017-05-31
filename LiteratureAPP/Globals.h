//
//  Globals.h
//  StepOne
//
//  Created by Tahir Hameed on 06/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GlobalsDelegate;
@interface Globals : NSObject {
    
}

@property (nonatomic, strong) NSString *strTest;
@property (assign) BOOL isFromReader;

+(Globals *) sharedInstance;


@end
