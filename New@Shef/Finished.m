//
//  Finished.m
//  New@Shef
//
//  Created by Wanchun Zhang on 04/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "Finished.h"

@implementation Finished
@synthesize activityId, finishedTime;

- (Finished *)initWithId:(int)Id
            finishedTime:(NSString *)ft
{
    if ((self = [super init]))
    {
        self.activityId = Id;
        self.finishedTime = ft;
         
    }
    return self;
}

- (NSArray *) getFinishedActivityCollection:(NSString *)iCloudText
{
    NSLog(@"sdfssdfsdfsdfsdf");
    NSLog(iCloudText);
    NSMutableArray *collection = [[NSMutableArray alloc] init];
    if (iCloudText.length != 0) {
        NSArray *words = [iCloudText componentsSeparatedByString:@"end"];
        
    
        int x = 0;
        
        int i = 0;
        int j = 1;
        while (x<words.count-1) {
            NSArray *myWords = [[words objectAtIndex:x] componentsSeparatedByString:@"("];
            NSString *str1 = [myWords objectAtIndex:i];
        
            NSString *str2 =[myWords objectAtIndex:j];
 
            if ([str1 hasPrefix:@"Status:"]) {
                Finished *record = [[Finished alloc] initWithId:[str2 integerValue] finishedTime:str1];
                    NSLog(str2);
                [collection addObject:record];
            }
            else
            {
                Finished *record = [[Finished alloc] initWithId:[str1 integerValue] finishedTime:str2];
                  NSLog(str1);
                [collection addObject:record];
            }
            
            x++;
        }
        
        NSLog( [NSString stringWithFormat:@"dont know%d",collection.count]);
    }
  

 
        /*
    for (int i = 0; i< myWords.count; i++) {
        NSArray* temp = [[myWords objectAtIndex:i] componentsSeparatedByString: @"("];
        NSString *Id = [temp objectAtIndex:1];
        NSLog(Id);
        //Finished *record = [[Finished alloc] initWithId:[Id integerValue] finishedTime:ft];
        //[collection addObject:record];
    }
     */
    return collection;
}
@end
