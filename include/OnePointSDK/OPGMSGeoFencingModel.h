//
//  OPGMSGeoFencingModel.h
//  OnePointSDK
//
//  Created by OnePoint Global on 28/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGMSGeoFencingModel : NSObject

@property(nonatomic, strong) NSString* surveyName;
@property(nonatomic, strong) NSString* surveyReference;
@property(nonatomic, strong) NSString* address;
@property(nonatomic, strong) NSNumber* surveyID;
@property(nonatomic, strong) NSNumber* addressID;
@property(nonatomic, strong) NSNumber* latitude;
@property(nonatomic, strong) NSNumber* longitude;
@property(nonatomic, strong) NSString* geocode;
@property(nonatomic, strong) NSString* createdDate;
@property(nonatomic, strong) NSString* lastUpdatedDate;
@property(nonatomic, strong) NSNumber* isDeleted;
@property(nonatomic, strong) NSNumber* distance;
@property(nonatomic, strong) NSNumber* range;

@end
