//
//  CurrencyPlugin.m
//  MySurveys2.0
//
//  Created by Chinthan on 18/01/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

#import "CurrencyPlugin.h"
#import "MySurveys2_0-Swift.h"

@implementation CurrencyPlugin

-(void)callcurrency:(OPGInvokedUrlCommand*)command{
    @try {
        callBackID=command.callbackId;
        currencyValue = [command argumentAtIndex:0];
        [self processRequest];

    }
    @catch(NSException *exception) {
        [self errorCallBack:@" Error Occurred " withcallbackId:command.callbackId];
    }
}

-(void)processRequest {
    dispatch_async(dispatch_get_main_queue(), ^{
        // If a popover is already open, close it; we only want one at a time.
        NSLog(@"self.viewController %@",self.viewController);
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"CurrencyVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        CurrenyViewController *rootViewController = [vc.viewControllers firstObject];
        rootViewController.delegate =  self;
        rootViewController.currencyVal = currencyValue;
        
        [self.viewController presentViewController:vc animated:YES completion:nil];
        
    });
    
}

- (void)currencyProcessCompleted:(NSString*)currency {
    NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:currency ,@"value", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:ldict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self successCallBack:jsonStr withcallbackId:callBackID];
}

@end
