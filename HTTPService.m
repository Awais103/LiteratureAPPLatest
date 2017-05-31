//
//  HTTPService.m
//  LiteratureAPP
//
//  Created by AFFAN on 16/05/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "HTTPService.h"
#define URL_Base "http://jamaat.org/ur"
#define URL_Books "/books_api.php"

@implementation HTTPService

+(id) instance {
    static HTTPService *sharedInstance = nil;
    
    @synchronized (self) {
        if (sharedInstance == nil)
            sharedInstance =[[self alloc]init];
        
    }
    return sharedInstance;
}

-(void)getBooks:(nullable onComplete)completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s",URL_Base, URL_Books]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (data != nil) {
            NSError *err;
            NSArray *json= [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err==nil) {
                completionHandler(json, nil);
                
            }else{
                completionHandler(nil ,@"Data is corrupt. Plz try Again");
            }
        }else{
            NSLog(@"Network Err: %@",error.debugDescription);
            completionHandler(nil,@"Problem Connectiing to the sever");
        }
        
        
        
        
        
    }]resume];
}






@end
