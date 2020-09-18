//
//  ViewController.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 9/8/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h> apply for graphics stuff

@interface WorldViewController : UIViewController

// Properties
@property (weak, nonatomic) IBOutlet UIButton *getApiTokenBtnOutlet;
@property (weak, nonatomic) IBOutlet UIView *acceptTermsPopupViewOutlet;


// Actions
- (IBAction)getApiToken:(id)sender;
- (IBAction)readFromPlist:(id)sender;
- (NSString *)readSavedToken;
- (NSMutableDictionary *)requestTos;
@end

