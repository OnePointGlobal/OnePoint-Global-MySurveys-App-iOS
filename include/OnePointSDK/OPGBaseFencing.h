//
//  OPGBaseFencing.h
//  OnePointSDK
//
//  Created by OnePoint Global.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface OPGBaseFencing : NSObject

#pragma mark  Functions for GeoFencing

-(id)initWithGeoFencingSurveys:(NSArray*)surveys;
- (void) startGeoFencing;
- (void) stopGeoFencing;

@end
