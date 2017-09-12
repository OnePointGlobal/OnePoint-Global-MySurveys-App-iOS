//
//  CollabrateDB.m
//  DemoSurveys_API
//
//  Created by ThamaraiD on 14/10/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "CollabrateDB.h"


@implementation CollabrateDB

+(CollabrateDB*)sharedInstance
{
    static CollabrateDB *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CollabrateDB alloc] init];
        // Do any other initialisation stuff here
        [OPGDB initializeWithDBVersion: 2];
        
    });
    return sharedInstance;
}

-(void)saveSurveys:(OPGSurvey *)surveyFromList withBool:(BOOL)status {

    @synchronized (self) {
        SurveyFactory *surveyFactory=[[SurveyFactory alloc]init];
        Survey *survey = [[Survey alloc]init];

        survey.SurveyID = surveyFromList.surveyID;
        survey.UserID = [NSNumber numberWithInt:07];
        survey.Name = [surveyFromList.surveyName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        survey.Description = [surveyFromList.surveyReference stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        survey.IsOffline=[NSNumber numberWithInteger:[surveyFromList.isOffline integerValue]];
        survey.IsGeofencing = [NSNumber numberWithInteger:[surveyFromList.isGeoFencing integerValue]];
        survey.SearchTags = [surveyFromList.surveyReference stringByReplacingOccurrencesOfString:@"'" withString:@"''"];      // Problem in search tags in PROM class. Check later
        if ([surveyFromList.isOffline integerValue] == 1) {
            survey.Status = @"Download";
        } else {
            survey.Status = @"New";
        }
        survey.Type = [NSNumber numberWithInt:1];
        survey.MediaID = [NSNumber numberWithInt:1];
        survey.ScriptID = [NSNumber numberWithInt:2];
        survey.IsDeleted=[NSNumber numberWithInt:0];
        if (([surveyFromList.startDate isEqualToString:@""]) || (surveyFromList.startDate == nil)) {
            NSString *dateString =  @"2100-10-07 02:02:00";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            survey.CreatedDate = [dateFormatter dateFromString:dateString];
        } else {
            survey.CreatedDate = [NSString stringToDate:surveyFromList.startDate];                //saving startDate to DB instead of createdDate
        }
        survey.LastUpdatedDate=[NSString stringToDate:surveyFromList.lastUpdatedDate];
        survey.IsCapi=[NSNumber numberWithInt:0];
        survey.EstimatedTime=surveyFromList.estimatedTime;
        survey.Occurences=[NSNumber numberWithInt:0];
        if (([surveyFromList.endDate isEqualToString:@""]) || (surveyFromList.endDate == nil)) {
            NSString *dateString =  @"2100-10-10 02:02:00";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            survey.DeadLine = [dateFormatter dateFromString:dateString];
        } else {
            survey.DeadLine= [NSString stringToDate:surveyFromList.endDate];                    //saving endDate to DB instead of deadline
        }
        [surveyFactory Save:survey];
    }

}

-(NSArray *)getAllSurveys:(NSString *)panelID
{
    @synchronized (self) {
        SurveyPanelFactory *surveyPanelFactory = [[SurveyPanelFactory alloc]init];
        SurveyFactory *surveyFactory = [[SurveyFactory alloc]init];
        NSArray *array=(NSArray*)[surveyPanelFactory FindByPanelID:[NSNumber numberWithInt:[panelID intValue]]];

        NSMutableArray *mArray=[[NSMutableArray alloc]init];
        for (SurveyPanel *sPanel in array) {
            @synchronized (sPanel) {
                NSArray *surveysArray=(NSArray*)[surveyFactory FindBySurveyID:sPanel.SurveyID];
                for (Survey *survey in surveysArray ) {
                    if (survey) {
                        OPGSurvey *opgsurvey = [OPGSurvey new];
                        opgsurvey.surveyName = survey.Name;
                        opgsurvey.surveyDescription = survey.Status;        // Problem in search tags in PROM class. Check later
                        opgsurvey.surveyReference = survey.Description;
                        opgsurvey.lastUpdatedDate = [NSString stringFromDate:survey.LastUpdatedDate];
                        opgsurvey.createdDate = [NSString stringFromDate:survey.CreatedDate];
                        opgsurvey.startDate = [NSString stringFromDate:survey.CreatedDate];
                        opgsurvey.endDate = [NSString stringFromDate:survey.DeadLine];
                        opgsurvey.isOffline = [NSNumber numberWithInt:[survey.IsOffline intValue]];
                        opgsurvey.isGeoFencing = [NSNumber numberWithInt:[survey.IsGeofencing intValue]];
                        opgsurvey.surveyID = survey.SurveyID;
                        opgsurvey.estimatedTime = survey.EstimatedTime;
                        opgsurvey.deadline = [NSString stringFromDate:survey.DeadLine];
                        opgsurvey.isOfflineDownloaded = [NSNumber numberWithInt:[survey.Occurences intValue]];

                        [mArray addObject:opgsurvey];
                    }
                }
            }
        }
        NSLog(@"the  surveys for panel %@ are %lu", panelID, (unsigned long)mArray.count);
        return [[mArray reverseObjectEnumerator] allObjects];
    }

}

-(OPGSurvey*)getSurvey:(NSNumber*)surveyID {
    @synchronized (self) {
        SurveyFactory *surveyFactory = [[SurveyFactory alloc]init];
        Survey *survey = (Survey*)[surveyFactory FindObject:surveyID];
        OPGSurvey *opgsurvey = [OPGSurvey new];
        opgsurvey.surveyName = survey.Name;
        opgsurvey.surveyDescription = survey.Status;
        opgsurvey.surveyReference = survey.Description;
        opgsurvey.lastUpdatedDate = [NSString stringFromDate:survey.LastUpdatedDate];
        opgsurvey.createdDate = [NSString stringFromDate:survey.CreatedDate];
        opgsurvey.startDate = [NSString stringFromDate:survey.CreatedDate];
        opgsurvey.endDate = [NSString stringFromDate:survey.DeadLine];
        opgsurvey.isOffline = [NSNumber numberWithInt:[survey.IsOffline intValue]];
        opgsurvey.isGeoFencing = [NSNumber numberWithInt:[survey.IsGeofencing intValue]];
        opgsurvey.surveyID = survey.SurveyID;
        opgsurvey.estimatedTime = survey.EstimatedTime;
        opgsurvey.deadline = [NSString stringFromDate:survey.DeadLine];
        opgsurvey.isOfflineDownloaded = [NSNumber numberWithInt:[survey.Occurences intValue]];
        return opgsurvey;
    }
}

-(void)saveThemes:(OPGTheme *)themes {
    @synchronized (self) {
        ThemeFactory *themesFactory=[[ThemeFactory alloc]init];
        Theme *theme=[[Theme alloc]init];
        theme.IsNew = TRUE;
        theme.CreatedDate = themes.createdDate;
        theme.IsDeleted = themes.isDeleted;
        if (![themes.themeName isKindOfClass:[NSNull class]] && themes.themeName !=nil) {
            theme.Name=[themes.themeName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        theme.ThemeElementTypeID = [NSNumber numberWithInt:[themes.themeElementTypeID intValue]];
        theme.ThemeTemplateID = [NSNumber numberWithInt:[themes.themeTemplateID intValue]];
        theme.ThemeID = [NSNumber numberWithInt:[themes.themeID intValue]];
        if (![themes.value isKindOfClass:[NSNull class]] && themes.value !=nil) {
            theme.Value=[(NSString*) themes.value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        theme.LastUpdatedDate = themes.lastUpdatedDate ;
        [themesFactory Save:theme];
    }
}

- (NSArray *)getThemes {
    @synchronized (self) {
        ThemeFactory *themesFactory=[[ThemeFactory alloc]init];
        NSArray *__themesArray=(NSArray*)[themesFactory FindAllObjects];
        NSMutableArray *themesArray=[[NSMutableArray alloc]init];
        for (Theme *theme in __themesArray) {
            OPGTheme* opgTheme = [OPGTheme new];
            opgTheme.themeID = theme.ThemeID;
            opgTheme.themeName = theme.Name;
            opgTheme.themeTemplateID = theme.ThemeTemplateID;
            opgTheme.themeElementTypeID = theme.ThemeElementTypeID;
            opgTheme.value = theme.Value;
            opgTheme.isDeleted = theme.IsDeleted;
            opgTheme.createdDate = theme.CreatedDate;
            opgTheme.lastUpdatedDate = theme.LastUpdatedDate;
            
            [themesArray addObject:opgTheme];
        }
        return themesArray;
    }
}

-(void)savePanelPanellist:(OPGPanelPanellist *)panelPanellist {
    @synchronized (self) {
        PanelPanellistFactory *panellistFactory=[[PanelPanellistFactory alloc]init];
        PanelPanellist *panellist=[[PanelPanellist alloc]init];
        panellist.IsNew = TRUE;
        panellist.CreatedDate = panelPanellist.createdDate;
        panellist.Included = [NSNumber numberWithInt:1];
        panellist.LastUpdatedDate = panelPanellist.lastUpdatedDate;
        panellist.PanelID = [NSNumber numberWithInt:[panelPanellist.panelID intValue]];
        panellist.PanelPanellistID = [NSNumber numberWithInt:[panelPanellist.panelPanellistID intValue]];
        panellist.PanellistID = [NSNumber numberWithInt:[panelPanellist.panellistID intValue]];
        panellist.IsDeleted = panelPanellist.isDeleted;

        [panellistFactory Save:panellist];
    }
}

-(void)savePanels:(OPGPanel *)panels {
    @synchronized (self) {
        Panel *panel = [[Panel alloc]init];
        PanelFactory *panelFactory = [[PanelFactory alloc]init];
        panel.IsNew = TRUE;
        panel.CreatedDate = panels.createdDate;

     //   panel.IsDeleted = panels.isDeleted;
        panel.PanelID = [NSNumber numberWithInt:[panels.panelID intValue]];
        panel.LastUpdatedDate = panels.lastUpdatedDate;
        if (![panels.panelName isKindOfClass:[NSNull class]] && panels.panelName !=nil) {
            panel.Name=[panels.panelName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
      //  panel.PanelType = panels.panelType;
        panel.Remark = panels.remark;               //remark is TEXT in DB schema but coming as NSNumber from PROM **Problem**
        if (![panels.mediaUrl isKindOfClass:[NSNull class]] && panels.mediaUrl !=nil) {
            panel.Description = panels.mediaUrl;            //save media URl in Description column of panels Table
        }
        else
        {
            panel.Description=@"";
        }
        if (![panels.logoUrl isKindOfClass:[NSNull class]] && panels.logoUrl !=nil) {
            panel.SearchTag=panels.logoUrl;      //save logo URl in SearchTag column of panels Table
        }
        else
        {
            panel.SearchTag=@"";
        }
        
        if (panels.logoID == nil ) {                // assign logoID to isDeleted as we're shortage of variables in POM
            panel.IsDeleted = @0;
        } else {
            panel.IsDeleted = panels.logoID;
        }
        
        if (panels.mediaID == nil ) {               // assign MediaID to PanelType as we're shortage of variables in POM
            panel.PanelType = @0;
        } else {
            panel.PanelType = panels.mediaID;
        }
        panel.UserID = [NSNumber numberWithInt:[panels.userID intValue]];
        panel.ThemeTemplateID = [NSNumber numberWithInt:[panels.themeTemplateID intValue]];
        panel.ThemeTemplateIDSpecified = [NSNumber numberWithInt:1];
        [panelFactory Save:panel];
    }
}

-(NSArray *)getPanels {
    @synchronized (self) {
        PanelFactory *pFactory=[[PanelFactory alloc]init];
        NSArray *__panelsarray=(NSArray*)[pFactory FindAllObjects];
        NSMutableArray *panelsArray=[[NSMutableArray alloc]init];

        for (Panel *panel in __panelsarray) {
            OPGPanel* opgPanel = [OPGPanel new];
            opgPanel.panelID = panel.PanelID;
            opgPanel.panelName = panel.Name;
            opgPanel.panelDescription = panel.Description;
            opgPanel.themeTemplateID = panel.ThemeTemplateID;
            opgPanel.themeTemplateIDSpecified = panel.ThemeTemplateIDSpecified;
            opgPanel.panelType = panel.PanelType;
            opgPanel.remark = panel.Remark;
            opgPanel.searchTag = @"";         //search tag actually contains logo url
            opgPanel.isDeleted = panel.IsDeleted;
            opgPanel.createdDate = panel.CreatedDate;
            opgPanel.lastUpdatedDate = panel.LastUpdatedDate;
            opgPanel.userID = panel.UserID;
            opgPanel.mediaUrl = panel.Description;             //assign Description column to opgpanel mediaURL field
            opgPanel.logoUrl = panel.SearchTag;         //assign SearchTag column to opgpanel logoURL field
            opgPanel.mediaID = panel.PanelType;         // assign PanelType to MediaID
            opgPanel.logoID = panel.IsDeleted;          // assign isDeleted to logoID
            [panelsArray addObject:opgPanel];
        }
        return panelsArray;
    }
}

-(void)saveSurveyPanels:(OPGSurveyPanel *)surveyPanels {
    @synchronized (self) {
        SurveyPanelFactory *spanelFactory = [[SurveyPanelFactory alloc]init];
        SurveyPanel *sPanel = [[SurveyPanel alloc]init];
        sPanel.SurveyPanelID = [NSNumber numberWithInt:[surveyPanels.surveyPanelID intValue]];
        sPanel.SurveyID = [NSNumber numberWithInt:[surveyPanels.surveyID intValue]];
        sPanel.PanelID = [NSNumber numberWithInt:[surveyPanels.panelID intValue]];
        sPanel.Excluded =  [NSNumber numberWithInt:1];
        sPanel.ExcludedSpecified = TRUE;
        sPanel.IsDeleted = surveyPanels.isDeleted;
        sPanel.CreatedDate = surveyPanels.createdDate;
        sPanel.LastUpdatedDate = surveyPanels.lastUpdatedDate;
        sPanel.IsNew = TRUE;
        [spanelFactory Save:sPanel];
    }
}

-(NSMutableDictionary*) getThemesForPanelID:(NSString*)panelID themeTemplateID:(NSString*)themeTemplateID
{
    NSArray *themesArray = [self getThemes];
    NSMutableDictionary *themeDictionary= [[NSMutableDictionary alloc] init];

    for (OPGTheme *theme in themesArray)
    {
        if ([themeTemplateID isEqualToString:[theme.themeTemplateID stringValue]])
        {
            themeDictionary[theme.themeName] = theme.value;
        }
    }
    return themeDictionary;
}

-(void)savePanellistProfile:(OPGPanellistProfile *)profileDetails
{
    @synchronized (self) {
        PanellistProfileFactory *panelPanellistFactory = [[PanellistProfileFactory alloc]init];
        PanellistProfile *profile =[[PanellistProfile alloc]init];

        profile.PanellistID = [NSNumber numberWithInt:32];
        profile.Title = profileDetails.title;
        profile.Website = @"www";
        if (![profileDetails.firstName isKindOfClass:[NSNull class]]&& profileDetails.firstName !=nil) {
            profile.FirstName=[profileDetails.firstName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        if (![profileDetails.lastName isKindOfClass:[NSNull class]] && profileDetails.lastName !=nil) {
            profile.LastName=[profileDetails.lastName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        profile.UserName = [NSString stringWithFormat:@"%@ %@",profileDetails.firstName,profileDetails.lastName];
        profile.Email = profileDetails.email;
        profile.MobileNumber = profileDetails.mobileNumber;
        profile.Password = @"1234";
        profile.PasswordLastUpdated=[NSString stringToDate:@"12-12-2012"];
        profile.DOB=[NSString stringToDate:profileDetails.DOB];
        if (![profileDetails.address1 isKindOfClass:[NSNull class]] && profileDetails.address1 !=nil) {
            profile.Address1=[profileDetails.address1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        if (![profileDetails.address2 isKindOfClass:[NSNull class]] && profileDetails.address2 !=nil) {
            profile.Address2=[profileDetails.address2 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        }
        profile.PostalCode = profileDetails.postalCode;
        profile.GeoLocation = @"Bangalore";
        profile.MediaID = profileDetails.mediaID;
        profile.CountryCode = [NSNumber numberWithInt:23];
        profile.TermsCondition = [NSNumber numberWithInt:20];
        profile.Status = [NSNumber numberWithInt:1];
        profile.IsDeleted = [NSNumber numberWithInt:1];
        profile.CreatedDate = [NSString stringToDate:@"12-12-2012"];
        profile.LastUpdatedDate = [NSString stringToDate:@"12-12-2012"];
        profile.SearchTag = @"SearchTag";
        profile.Remark = @"Remark";
        profile.Gender = profileDetails.gender;
        profile.MaritalStatus = [NSNumber numberWithInt:1] ;
        profile.isGenderSpecified = [[NSNumber numberWithInt:1] boolValue];
        profile.isMaritalStatusSpecified = [[NSNumber numberWithInt:1] boolValue];
        
        profile.IsNew = [[NSNumber numberWithInt:1] boolValue];
        [panelPanellistFactory Save:profile];
    }

}

-(OPGPanellistProfile *)getPanellistProfile {

    @synchronized (self) {
        PanellistProfileFactory *panellistProfileFactory=[[PanellistProfileFactory alloc]init];
        NSArray *panellistProfileArray=(NSArray*)[panellistProfileFactory FindAllObjects];
        OPGPanellistProfile* panllistProfile = [OPGPanellistProfile new];

        for (PanellistProfile *ppanellist in panellistProfileArray)
        {
            panllistProfile.firstName = ppanellist.FirstName;
            panllistProfile.lastName = ppanellist.LastName;
            panllistProfile.email = ppanellist.Email;
            panllistProfile.postalCode = ppanellist.PostalCode;
            panllistProfile.mediaID = ppanellist.MediaID.description;
            panllistProfile.gender = ppanellist.Gender;
            panllistProfile.address1 = ppanellist.Address1;
            panllistProfile.address2 = ppanellist.Address2;
            panllistProfile.mobileNumber = ppanellist.MobileNumber;
            panllistProfile.title = ppanellist.Title;
            panllistProfile.DOB = [NSString stringFromDate:ppanellist.DOB];
        }
        return panllistProfile;
    }
}

-(void)saveCountry:(NSString*)name withStd:(NSString*)std
{
    @synchronized (self) {
        CountryFactory *countryFactory = [[CountryFactory alloc] init];
        Country *country = [[Country alloc] init];

        country.CountryID = [NSNumber numberWithInt:123];
        country.Name = name;
        country.CountryCode = @"";
        country.Std = std;
        country.Gmt = [NSString stringToDate:@"12-12-2012"];
        country.CreditRate = [NSNumber numberWithInt:1];
        country.IsDeleted = [NSNumber numberWithInt:1];
        [countryFactory Save:country];
    }
}

-(OPGCountry*)getCountry
{
    @synchronized (self) {
        CountryFactory *countryFactory = [[CountryFactory alloc] init];
        NSArray *countryArray=(NSArray*)[countryFactory FindAllObjects];
        OPGCountry *country = [OPGCountry new];

        for (Country *countryDBObject in countryArray)
        {
            country.countryID = countryDBObject.CountryID;
            country.name = countryDBObject.Name;
            country.countryCode = countryDBObject.CountryCode;
            country.std = countryDBObject.Std;
            country.gmt = [NSString stringFromDate:countryDBObject.Gmt];
            country.creditRate = countryDBObject.CreditRate;
            country.isDeleted = countryDBObject.IsDeleted;
        }
        return country;
    }
}

-(void)updateSurvey:(NSNumber *)surveyID withStatus:(NSString *)status withDownloadStatus:(NSNumber*)downloadStatus {
    @synchronized (self) {
        SurveyFactory *surveyFactory=[[SurveyFactory alloc]init];
        Survey *survey = (Survey*)[surveyFactory FindObject:surveyID];
        survey.Status = status;
        if (![downloadStatus isEqualToNumber:@99]) {
            survey.Occurences = downloadStatus;
        }
        [surveyFactory Save:survey];
    }
}

-(void)updateOfflineCount:(NSString *)surveyRef withDownloadStatus:(NSNumber *)downloadStatus {
    @synchronized (self) {
        SurveyFactory *surveyFactory=[[SurveyFactory alloc]init];
        NSArray *surveyArray = (NSArray*)[surveyFactory FindByDescription:surveyRef];
        if(surveyArray.count > 0 )
        {
            Survey *survey = surveyArray.firstObject;
            survey.Occurences = downloadStatus;
            [surveyFactory Save:survey];
        }
    }
}

-(void)updatePanellistProfile:(OPGPanellistProfile*)profileDetails
{
    @synchronized (self) {
        PanellistProfileFactory *panelPanellistFactory=[[PanellistProfileFactory alloc]init];
        NSArray *array=(NSArray*)[panelPanellistFactory FindAllObjects];
        PanellistProfile *dbProfile;
        if (array.count>0)
        {
            dbProfile=[array objectAtIndex:0];
            dbProfile.FirstName = profileDetails.firstName;                     //can update only name, media ID here because country is in other table
            dbProfile.MediaID = profileDetails.mediaID;
            [panelPanellistFactory Save:dbProfile];
        }
    }
}

-(void)updateCountry:(NSString*)name withStd:(NSString*)std
{
    @synchronized (self) {
        CountryFactory *countryFactory = [[CountryFactory alloc] init];
        NSArray *array=(NSArray*)[countryFactory FindAllObjects];
        Country *country;
        if (array.count>0)
        {
            country = [array objectAtIndex:0];
            country.Name = name;
            country.Std = std;
            [countryFactory Save:country];
        }
    }
}

#pragma mark - dB methods for Notifications
-(void)saveNotifications:(NSDictionary*)payload
{
    @synchronized (self)
    {
        NSDictionary* dictReceived = [payload valueForKey:@"aps"];
        if (dictReceived != nil) {
            AppNotification *appNotification = [AppNotification new];
            appNotification.Title = [[payload valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            appNotification.Body = [[dictReceived objectForKey:@"alert"]stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            appNotification.LastUpdated = [NSString stringToDate:[NSString stringFromDate:[NSDate date]]];
            appNotification.IsRead = @0;
            AppNotificationFactory *appNotificationFactory = [AppNotificationFactory new];
            [appNotificationFactory Save:appNotification];
        }
        else {
            [self saveLocalNotifications:payload];
        }
    }
}

-(void)saveLocalNotifications:(NSDictionary *)info
{
    @synchronized (self) {
        AppNotification* notification = [AppNotification new];
        // save notification only if there is a valid title
        if ([info valueForKey:@"title"] != nil && ![[info valueForKey:@"title"]  isEqual: @""]) {
            notification.Title = [info valueForKey:@"title"];
            notification.Body = [info valueForKey:@"body"];
            if ([info objectForKey:@"LastUpdated"])
            {
                notification.LastUpdated =[NSString stringToDate:[NSString stringFromDate:[info objectForKey:@"LastUpdated"]]] ;
            }
            else
            {
                notification.LastUpdated = [NSString stringToDate:[NSString stringFromDate:[NSDate date]]];
            }
            if ([info objectForKey:@"IsRead"])
            {
                notification.IsRead = [info objectForKey:@"IsRead"];
            }
            else
            {
                notification.IsRead = @0;
            }
            AppNotificationFactory *notificationFactory = [AppNotificationFactory new];
            [notificationFactory Save:notification];
        }
    }
}


-(void)deleteNotifications:(NSNumber *)notificationID
{
    @synchronized (self) {
    AppNotificationFactory* appNotificationFactory = [AppNotificationFactory new];
    AppNotification  *appNotification = (AppNotification*)[appNotificationFactory FindObject:notificationID];
    [appNotificationFactory Delete:appNotification];
    }
}

-(NSArray*)loadNotifications
{
    @synchronized (self) {
    AppNotificationFactory* lAppNotificationFactory = [AppNotificationFactory new];
    NSArray* lArrNotifications = (NSArray*)[lAppNotificationFactory FindAllObjects];
    NSMutableArray* arrNotifications = [NSMutableArray new];
    NSError *error = nil;
    
    for (AppNotification* lAppNotification in lArrNotifications) {
        NSMutableDictionary* lDictNotifications = [NSMutableDictionary new];
        
        [lDictNotifications setValue:lAppNotification.Title forKey:@"Title"];
        [lDictNotifications setValue:lAppNotification.Body forKey:@"Body"];
        [lDictNotifications setValue:[NSString getUTCFormateDate:lAppNotification.LastUpdated] forKey:@"LastUpdated"];
        [lDictNotifications setValue:lAppNotification.Type forKey:@"Type"];
        [lDictNotifications setValue:lAppNotification.IsRead forKey:@"IsRead"];
        [lDictNotifications setValue:lAppNotification.AppNotificationID forKey:@"AppNotificationID"];
        [arrNotifications addObject:lDictNotifications];
    }
    return [[arrNotifications reverseObjectEnumerator] allObjects];
    }
}

-(void)updateNotifications:(NSNumber *)notificationID
{
    @synchronized (self) {
    AppNotificationFactory *appNotificationFactory = [AppNotificationFactory new];
    AppNotification  *appNotification = (AppNotification*)[appNotificationFactory FindObject:notificationID];
    appNotification.IsNew = FALSE;
    appNotification.IsRead = [NSNumber numberWithInt:1];
    [appNotificationFactory Save:appNotification];
    }
}

#pragma mark - dB methods for GeoFencing
-(void)saveGeoFenceSurveys:(OPGGeofenceSurvey*)geoFencedSurveys {
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory=[[GeofenceSurveyFactory alloc]init];
        GeofenceSurvey *survey = [[GeofenceSurvey alloc]init];
        survey.Address = geoFencedSurveys.address;
        survey.AddressID = geoFencedSurveys.addressID;
        survey.SurveyID = geoFencedSurveys.surveyID;
        survey.SurveyReference = geoFencedSurveys.surveyReference;
        // add survey name missed in PROM
        survey.SurveyName = geoFencedSurveys.surveyName;
        survey.Latitude = geoFencedSurveys.latitude;
        survey.Longitude = geoFencedSurveys.longitude;
        survey.GeoCode = geoFencedSurveys.geocode;
        survey.CreatedDate = [NSString stringToDate:[geoFencedSurveys createdDate]];
        survey.LastUpdatedDate = [NSString stringToDate:[geoFencedSurveys lastUpdatedDate]];
        survey.Range = geoFencedSurveys.range;
        survey.IsEntered = [NSNumber numberWithInt:[geoFencedSurveys.isDeleted intValue]];
        survey.Distance = geoFencedSurveys.distance;
        [surveyFactory Save:survey];
    }
}

-(NSArray *)getAllGeoFenceSurveys {
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory = [[GeofenceSurveyFactory alloc]init];
        NSArray* geoFencedSurveys = (NSArray*)[surveyFactory FindAllObjects];
        NSMutableArray *mArray=[[NSMutableArray alloc]init];
        for (GeofenceSurvey *survey in geoFencedSurveys ) {

            if (survey) {
                // TODO: add geofencingID to OPGMSGeoFencingModel class
                OPGGeofenceSurvey *opgsurvey = [OPGGeofenceSurvey new];
                opgsurvey.address = survey.Address;
                opgsurvey.addressID = survey.AddressID;
                opgsurvey.surveyID = survey.SurveyID;
                opgsurvey.surveyReference = survey.SurveyReference;
                opgsurvey.latitude = survey.Latitude;
                opgsurvey.longitude = survey.Longitude;
                opgsurvey.geocode = survey.GeoCode;
                opgsurvey.range = survey.Range;
                opgsurvey.surveyName = survey.SurveyName;
                opgsurvey.isDeleted = [NSNumber numberWithInt:[survey.IsEntered intValue]];
                opgsurvey.distance = survey.Distance;
                opgsurvey.createdDate = @"New";//[NSString stringFromDate:survey.CreatedDate];
                opgsurvey.lastUpdatedDate = [NSString stringFromDate:survey.LastUpdatedDate];

                [mArray addObject:opgsurvey];
            }
        }
        return mArray;
    }
}

-(OPGGeofenceSurvey *)getGeofenceSurvey:(NSNumber *)surveyID {
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory = [[GeofenceSurveyFactory alloc]init];
        GeofenceSurvey  *survey = (GeofenceSurvey*)[surveyFactory FindObject:surveyID];
        OPGGeofenceSurvey *opgsurvey = [OPGGeofenceSurvey new];
        opgsurvey.address = survey.Address;
        opgsurvey.addressID = survey.AddressID;
        opgsurvey.surveyID = survey.SurveyID;
        opgsurvey.surveyName = survey.SurveyName;
        opgsurvey.surveyReference = survey.SurveyReference;
        opgsurvey.latitude = survey.Latitude;
        opgsurvey.longitude = survey.Longitude;
        opgsurvey.geocode = survey.GeoCode;
        opgsurvey.range = survey.Range;
        opgsurvey.isDeleted = survey.IsEntered;
        opgsurvey.distance = survey.Distance;
        opgsurvey.createdDate = [NSString stringFromDate:survey.CreatedDate];
        opgsurvey.lastUpdatedDate = [NSString stringFromDate:survey.LastUpdatedDate];
        return opgsurvey;
    }
}

-(void)updateGeoFenceSurvey:(NSNumber *)geoFenceID withSurveyReference:(NSString *)surveyReference withStatus:(NSNumber *)isEntered {
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory = [[GeofenceSurveyFactory alloc]init];
        GeofenceSurvey* geoSurvey;
        // for a particular address, get all the surveys

        NSArray  *surveyArray = (NSArray*)[surveyFactory FindByAddressID:geoFenceID];
        for (GeofenceSurvey *survey in surveyArray) {
            // among the surveys, find if your survey is there. then update it
            if ([surveyReference isEqualToString:survey.SurveyReference]) {
                geoSurvey = survey;
                if (geoSurvey != nil) {
                    geoSurvey.IsEntered = [NSNumber numberWithInt:[isEntered intValue]];
                    //NSLog(@"Survey updated in DB with status %@", geoSurvey.IsEntered);
                    [surveyFactory Save:geoSurvey];
                }
            }
        }
        
    }
}

-(void)deleteGeoFenceSurvey:(NSNumber*)geoFencedSurveyID {
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory = [[GeofenceSurveyFactory alloc]init];
        NSArray  *surveyArray = (NSArray*)[surveyFactory FindBySurveyID:geoFencedSurveyID];  // surveyID is used
        GeofenceSurvey* survey = surveyArray.firstObject;
        [surveyFactory Delete:survey];
    }
}

-(void)deleteGeoFenceTable{
    @synchronized (self) {
        GeofenceSurveyFactory *surveyFactory = [[GeofenceSurveyFactory alloc]init];
        NSArray* geoFencedSurveys = (NSArray*)[surveyFactory FindAllObjects];
        for (GeofenceSurvey *survey in geoFencedSurveys ) {
            [surveyFactory Delete:survey];
        }
    }
}

@end
