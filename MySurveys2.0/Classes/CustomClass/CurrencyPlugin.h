//
//  CurrencyPlugin.h
//  MySurveys2.0
//
//  Created by Chinthan on 18/01/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//
#import "RootPlugin.h"

#import <Foundation/Foundation.h>

@interface CurrencyPlugin : RootPlugin
{
    NSMutableDictionary *callInfo;
    NSString *actionName;
    BOOL callBack;
    BOOL terminatePage;
    NSString *callBackID;
    BOOL NoSurvey;
    NSString* currencyValue;

}

-(void)callcurrency:(OPGInvokedUrlCommand*)command;

@end



