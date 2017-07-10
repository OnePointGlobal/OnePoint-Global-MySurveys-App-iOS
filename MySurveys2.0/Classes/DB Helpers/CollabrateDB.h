//
//  CollabrateDB.h
//  DemoSurveys_API
//
//  Created by ThamaraiD on 14/10/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+NSDate.h"
#import <OnePoint.POM/PanelPanellistFactory.h>
#import <OnePoint.POM/ThemeFactory.h>
#import <OnePoint.MOM/MediaAttachment.h>
#import <OnePoint.MOM/MediaAttachmentFactory.h>
#import <OnePoint.POM/PanellistProfileFactory.h>
#import <OnePoint.PROM/ScriptFactory.h>
#import <OnePoint.PROM/ScriptContentFactory.h>
#import <OnePoint.PROM/Script.h>
#import <OnePoint.PROM/ScriptContent.h>
#import <OnePoint.PROM/Survey.h>
#import <OnePoint.PROM/SurveyFactory.h>
#import <OnePoint.PROM/SurveyBase.h>
#import <OnePoint.PROM/SurveyPanelFactory.h>
#import <OnePoint.PROM/SurveyPanel.h>
#import <OnePoint.POM/PanelTheme.h>
#import <OnePoint.POM/PanelThemeFactory.h>
#import <OnePoint.PROM/AppNotification.h>
#import <OnePoint.PROM/AppNotificationFactory.h>
#import <OnePoint.PROM/GeofenceSurvey.h>
#import <OnePoint.PROM/GeofenceSurveyBase.h>
#import <OnePoint.PROM/GeofenceSurveyFactory.h>
#import <OnePoint.PROM/GeofenceSurveyFactoryBase.h>
#import <OnePointFramework/SqlQueryCommand.h>
#import <OnePointFramework/OPGDB.h>
#import <OnePoint.PROM/ProjectSurvey.h>
#import <OnePoint.PROM/ProjectSurveyFactory.h>
#import <OnePoint.PROM/AddressListFactory.h>
#import <OnePoint.PROM/AddressFactory.h>
#import <OnePoint.PROM/Address.h>
#import <OnePoint.PROM/AddressList.h>
#import <OnePointSDK/OPGSurvey.h>
#import <OnePointSDK/OPGTheme.h>
#import <OnePointSDK/OPGPanelPanellist.h>
#import <OnePointSDK/OPGPanel.h>
#import <OnePointSDK/OPGSurveyPanel.h>
#import <OnePointSDK/OPGPanellistProfile.h>
#import <OnePointSDK/OPGCountry.h>
#import <OnePointSDK/OPGGeofenceSurvey.h>
#import <OnePoint.POM/CountryFactory.h>
#import <OnePoint.POM/Country.h>


@interface CollabrateDB : NSObject
+(CollabrateDB*)sharedInstance;

-(void)saveSurveys:(OPGSurvey*)surveyFromList
          withBool:(BOOL)status;

-(NSArray*)getAllSurveys:(NSString*)panelID;

-(NSArray*)getAllSurveys;

-(OPGSurvey*)getSurvey:(NSNumber*)surveyID;

-(void)saveThemes:(OPGTheme*)themes;

-(NSArray*)getThemes;

-(void)savePanelPanellist:(OPGPanelPanellist*)panelPanellist;

-(void)savePanels:(OPGPanel*)panels;

-(NSArray*)getPanels;

-(void)saveSurveyPanels:(OPGSurveyPanel*)surveyPanels;

-(void)savePanellistProfile:(OPGPanellistProfile*)profileDetails;

-(OPGPanellistProfile*)getPanellistProfile;

-(void)saveCountry:(NSString*)name
           withStd:(NSString*)std;

-(OPGCountry*)getCountry;

-(void)updateSurvey:(NSNumber *)surveyID
         withStatus:(NSString *)status
         withDownloadStatus:(NSNumber*)downloadStatus;

-(void)updateOfflineCount:(NSString *)surveyRef
       withDownloadStatus:(NSNumber *)downloadStatus;

-(void)updatePanellistProfile:(OPGPanellistProfile*)profileDetails;

-(void)updateCountry:(NSString*)name withStd:(NSString*)std;

-(void)saveNotifications:(NSDictionary*)payload;

-(void)saveLocalNotifications:(NSDictionary *)info;

-(NSArray*)loadNotifications;

-(void)deleteNotifications:(NSNumber*)notificationID;

-(void)updateNotifications:(NSNumber *)notificationID;

-(void)saveGeoFenceSurveys:(OPGGeofenceSurvey *)geoFencedSurveys;

-(NSArray*)getAllGeoFenceSurveys;

-(OPGGeofenceSurvey*)getGeofenceSurvey:(NSNumber*)surveyID;

-(void)updateGeoFenceSurvey:(NSNumber *)geoFenceID withSurveyReference:(NSString *)surveyReference withStatus:(NSNumber *)isEntered;

-(void)deleteGeoFenceSurvey:(NSNumber*)geoFencedSurveyID;

-(NSMutableDictionary*) getThemesForPanelID:(NSString*)panelID
                            themeTemplateID:(NSString*)themeTemplateID;





@end
