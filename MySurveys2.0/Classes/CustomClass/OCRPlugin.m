//
//  OCRPlugin.m
//  MySurveys2.0
//
//  Created by Manjunath on 08/02/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

#import "OCRPlugin.h"
#import "OCRViewController.h"

@implementation OCRPlugin
-(void)scanText:(OPGInvokedUrlCommand*)command
{
    @try {
        callBackID=command.callbackId;
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
        UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"OCR_VC"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        OCRViewController *rootViewController = [vc.viewControllers firstObject];
        rootViewController.delegate =  self;
        [self.viewController presentViewController:vc animated:YES completion:nil];

    });
}

-(void)processCompleted:(NSString*)recognizedText {
    if (recognizedText.length >0) {
        NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:recognizedText ,@"text", nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:ldict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self successCallBack:jsonStr withcallbackId:callBackID];
    }
    else {
        NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Error occurred when scanning the text" ,@"text", nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:ldict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self errorCallBack:jsonStr withcallbackId:callBackID];
    }
}
@end
