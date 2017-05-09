//
//  OPGMSGeoFencing.h
//  OnePointSDK
//
//  Created by OnePoint Global on 24/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OPGGeoFencingModel.h"

@protocol OPGGeoFencingDelegate <NSObject>

-(void)geoFencedAreas:(NSArray*)locations;
-(void)didEnterRegion:(OPGGeoFencingModel*)regionEntered;
-(void)didExitRegion:(OPGGeoFencingModel*)regionExited;

@end

@interface OPGGeoFencing : NSObject

+(OPGGeoFencing*)sharedInstance;

-(void)startGeoFencing;
-(void)stopGeoFencing;
-(void)monitorForGeoFencing:(NSArray*)locations;
-(void)getGeofencingLocations;

@property(assign, nonatomic) id<OPGGeoFencingDelegate> fencingDelegate;
@property (nonatomic, strong) CLLocationManager* locationManager;


@end
