//
//  Globals.m
//  StepOne
//
//  Created by Tahir Hameed on 06/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import "Globals.h"

@implementation Globals
@synthesize strTest,isFromReader;
static Globals *singletonObject;

- (id) init
{
	if (self = [super init]) {
        
        strTest = @"";
  
    }
    
    return self;
    
}

+(Globals *) sharedInstance{
    
	@synchronized(self){
        
		if(singletonObject == nil){
			singletonObject = [[self alloc] init];
        }
	}
    
	return singletonObject;

}

+(void)resetSharedInstance {
    @synchronized(self) {
        singletonObject = nil;
    }

}

@end
