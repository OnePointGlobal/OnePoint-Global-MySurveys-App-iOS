//
//  OCRViewController.m
//  MySurveys2.0
//
//  Created by Manjunath on 08/02/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

#import "OCRViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OCRViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation OCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    self.textView.editable = YES;
    self.textView.text = NSLocalizedString(@"Enter Scanned Text", comment: "");
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self openCamera];
    self.spinner.color = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self.spinner startAnimating];
    if (image != nil) {
        [self readImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) openCamera {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) readImage: (UIImage*) image {
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;

    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        tesseract.image = [image g8_blackAndWhite];
        BOOL didRecognizeText = [tesseract recognize];

        dispatch_async(dispatch_get_main_queue(), ^{
        //return to main queue
        if (didRecognizeText)
        {
            NSLog(@"%@", tesseract.recognizedText);
            self.textView.textColor = [UIColor blackColor];
            self.textView.text = tesseract.recognizedText;
            [self.spinner stopAnimating];
            return;
        }
        NSLog(@"Text Recognition Failed");
    });
    });
}

- (IBAction)okBtnPressed:(id)sender {
    if ([self.textView.text isEqualToString:NSLocalizedString(@"Enter Scanned Text", comment: "")]) {
        [self.delegate processCompleted:@""];
    }
    else {
         [self.delegate processCompleted:self.textView.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshBtnPressed:(id)sender {
    self.textView.text = NSLocalizedString(@"Enter Scanned Text", comment: "");
    self.textView.textColor = [UIColor lightGrayColor];
    [self openCamera];
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:NSLocalizedString(@"Enter Scanned Text", comment: "")]) {
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
}
@end
