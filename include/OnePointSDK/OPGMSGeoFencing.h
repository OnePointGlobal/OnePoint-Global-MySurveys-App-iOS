//
//  OPGMSGeoFencing.h
//  OnePointSDK
//
//  Created by OnePoint Global on 24/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OPGMSGeoFencingModel.h"

@protocol MySurveysDelegate <NSObject>

-(void)geoFencedAreas:(NSArray*)locations;
-(void)didEnterRegion:(OPGMSGeoFencingModel*)regionEntered;
-(void)didExitRegion:(OPGMSGeoFencingModel*)regionExited;

@end

@interface OPGMSGeoFencing : NSObject

+(OPGMSGeoFencing*)sharedInstance;

-(void)startGeoFencing;
-(void)stopGeoFencing;
-(void)monitorForGeoFencing:(NSArray*)locations;
-(void)getGeofencingLocations;

@property(assign, nonatomic) id<MySurveysDelegate> fencingDelegate;
@property (nonatomic, strong) CLLocationManager* locationManager;


@end
