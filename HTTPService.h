//
//  HTTPService.h
//  LiteratureAPP
//
//  Created by AFFAN on 16/05/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^onComplete)(NSArray * __nullable dataArray, NSString *__nullable errMessage);
@interface HTTPService : NSObject
+(id  _Nullable ) instance;
-(void)getBooks:(nullable onComplete)completionHandler;


@end
