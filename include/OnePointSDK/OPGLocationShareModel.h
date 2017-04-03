//
//  OPGLocationShareModel.h
//  OnePointSDK
//
//  Created by OnePoint Global.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "OPGBackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OPGLocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) OPGBackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;

+(id)sharedModel;

@end
