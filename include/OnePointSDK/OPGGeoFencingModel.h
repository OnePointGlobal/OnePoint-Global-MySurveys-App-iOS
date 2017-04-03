//
//  OPGGeoFencingModel.h
//  OnePointSDK
//
//  Created by OnePoint Global.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGGeoFencingModel : NSObject

/*!
 * @brief surveyName : Name of the Survey.
 */
@property (nonatomic, strong) NSString* surveyName;
/*!
 * @brief address : Address to which survey is available.
 */
@property (nonatomic, strong) NSString*  address;
/*!
 * @brief surveyRef : SurveyReference which required to take the survey.
 */
@property (nonatomic, strong) NSString* surveyRef;
/*!
 * @brief GeoCode : GeoCode has the latitude and longitude of the Address.
 */
@property (nonatomic, strong) NSString* geoCode;

@end
