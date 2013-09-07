//
//  Finished.h
//  New@Shef
//
//  Created by Wanchun Zhang on 04/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Finished : NSObject
{
    int activityId;
    NSString *finishedTime;
}

@property (nonatomic, assign) int activityId;
@property (nonatomic, retain) NSString *finishedTime;

- (Finished *)initWithId:(int)Id
                    finishedTime:(NSString *)ft;
- (NSArray *) getFinishedActivityCollection:(NSString *)iCloudText;

@end
