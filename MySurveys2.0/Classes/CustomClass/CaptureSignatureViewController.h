//
//  CaptureSignatureViewController.h
//  MySurveys2.0
//
//  Created by Chinthan on 10/11/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"


// Protocol definition starts here
@protocol CaptureSignatureViewDelegate <NSObject>
@required
- (void)processCompleted:(UIImage*)signImage;
@end


@interface CaptureSignatureViewController : UIViewController {
    // Delegate to respond back
    id <CaptureSignatureViewDelegate> _delegate;
    NSString *userName, *signedDate;
}

@property (nonatomic,strong) id delegate;
-(void)startSampleProcess:(NSString*)text;
// Instance method

@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
- (IBAction)captureSign:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@end
