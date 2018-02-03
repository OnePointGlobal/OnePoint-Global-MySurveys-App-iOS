//
//  SignaturePlugin.m
//  MySurveys2.0
//
//  Created by Chinthan on 10/11/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

#import "SignaturePlugin.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "CaptureSignatureViewController.h"

@implementation SignaturePlugin
-(void)callsignature:(OPGInvokedUrlCommand*)command{
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
        UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"SignatureVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        CaptureSignatureViewController *rootViewController = [vc.viewControllers firstObject];
        rootViewController.delegate =  self;
        
        [self.viewController presentViewController:vc animated:YES completion:nil];
        
    });
    
    //    LAContext *myContext = [[LAContext alloc] init];
    //    NSError *authError = nil;
    //    NSString *myLocalizedReasonString = @"Used for quick and secure access to the test app";
    //
    //    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
    //        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
    //                  localizedReason:myLocalizedReasonString
    //                            reply:^(BOOL success, NSError *error) {
    //                                if (success) {
    //                                    // User authenticated successfully, take appropriate action
    //                                } else {
    //                                    // User did not authenticate successfully, look at error and take appropriate action
    //                                }
    //                            }];
    //    } else {
    //        // Could not evaluate policy; look at authError and present an appropriate message to user
    //    }
    
}

- (NSString*)tempFilePath:(NSString*)extension
{
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
    NSFileManager* fileMgr = [[NSFileManager alloc] init]; // recommended by Apple (vs [NSFileManager defaultManager]) to be threadsafe
    NSString* filePath;
    // generate unique file name
    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/cdv_signature_%03d.%@", docsPath, i++, extension];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    return filePath;
}

- (NSString*)resultForImage:(UIImage *)img {
    @autoreleasepool {
        NSString* result = nil;
        UIImage* image = img;
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                if (data) {
                    NSString* extension =  @"png";
                    NSString* filePath = [self tempFilePath:extension];
                    NSError* err = nil;
                    
                    // save file
                    if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                        result = [err localizedDescription]; //[OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                    } else {
                        result = [[NSURL fileURLWithPath:filePath] absoluteString]; //[OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[self urlTransformer:[NSURL fileURLWithPath:filePath]] absoluteString]];
                    }
                }
        return result;
    }
}


- (void)processCompleted:(UIImage*)signImage {
    NSString *result = [self resultForImage:signImage];
    NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:result ,@"path", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:ldict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self successCallBack:jsonStr withcallbackId:callBackID];
    //[self errorCallBack:@" Error Occurred " withcallbackId:callBackID];

}



@end
