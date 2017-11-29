//
//  CaptureSignatureViewController.m
//  MySurveys2.0
//
//  Created by Chinthan on 10/11/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

#import "CaptureSignatureViewController.h"
#import <QuartzCore/QuartzCore.h>

#define USER_SIGNATURE_PATH  @"user_signature_path"


@interface CaptureSignatureViewController ()

@end

@implementation CaptureSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_SIGNATURE_PATH];
//    NSMutableArray *signPathArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [self.signatureView setPathArray:signPathArray];
//    [self.signatureView setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // your code
    }
}


-(IBAction)captureSign:(id)sender {
    //display an alert to capture the person's name
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    signedDate  = [dateFormatter stringFromDate:[NSDate date]];
//    if( signedDate != nil  && ![signedDate isEqualToString:@""])
//    {
//
//    }
    [self.signatureView captureSignature];
    [self startSampleProcess:@""];

}

-(IBAction)eraseSign:(id)sender {
    //display an alert to capture the person's name
    [self.signatureView erase];
}

-(IBAction)cancelSign:(id)sender {
    //display an alert to capture the person's name
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)startSampleProcess:(NSString*)text {
    UIImage *captureImage = [self.signatureView signatureImage:CGPointMake(self.signatureView.frame.origin.x+10 , self.signatureView.frame.size.height-25) text:text];
    [self.delegate processCompleted:captureImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
