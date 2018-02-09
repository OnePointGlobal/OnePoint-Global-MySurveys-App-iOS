//
//  OCRPlugin.h
//  MySurveys2.0
//
//  Created by Manjunath on 08/02/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

#import "RootPlugin.h"
#import <Foundation/Foundation.h>
#import "OCRViewController.h"

@interface OCRPlugin : RootPlugin<ScanTextDelegate> {
    NSMutableDictionary *callInfo;
    BOOL callBack;
    NSString *callBackID;
}
-(void)scanText:(OPGInvokedUrlCommand*)command;
@end
