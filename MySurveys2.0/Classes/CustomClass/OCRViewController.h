//
//  OCRViewController.h
//  MySurveys2.0
//
//  Created by Manjunath on 08/02/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>


// Protocol definition starts here
@protocol ScanTextDelegate <NSObject>
@required
- (void)processCompleted:(NSString*)recognizedText;
@end


@interface OCRViewController : UIViewController<G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {
   id <ScanTextDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@end

