//
//  SignatureView.h
//  MySurveys2.0
//
//  Created by Chinthan on 10/11/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignatureViewDelegate <NSObject>
    @required
- (void)shakeCompleted;
    @end

@interface SignatureView : UIView {
    CGPoint previousPoint;
    UIBezierPath *signPath;
    NSArray *backgroundLines;
}
    @property (weak, nonatomic) IBOutlet UILabel * _Nullable signLabel;
    @property (nonatomic, strong, nonnull) NSMutableArray *pathArray;
    @property (nonatomic, strong, nullable) UIColor *lineColor;
    @property (nonatomic) CGFloat lineWidth;
    @property (nonatomic, readonly) BOOL signatureExists;
- (void)captureSignature;
- (void)erase;
- (UIImage*_Nullable)signatureImage:(CGPoint)position text:(NSString*_Nullable)text;
    
    @end

