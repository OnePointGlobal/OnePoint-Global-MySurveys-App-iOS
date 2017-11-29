//
//  SignaturePlugin.h
//  MySurveys2.0
//
//  Created by Chinthan on 10/11/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//
#import "RootPlugin.h"

#import <Foundation/Foundation.h>

@interface SignaturePlugin : RootPlugin
{
    NSMutableDictionary *callInfo;
    NSString *actionName;
    BOOL callBack;
    BOOL terminatePage;
    NSString *callBackID;
    BOOL NoSurvey;
}

-(void)callsignature:(OPGInvokedUrlCommand*)command;

@end

