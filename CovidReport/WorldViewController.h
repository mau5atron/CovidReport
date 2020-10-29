//
//  ViewController.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 9/8/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> //apply for graphics stuff
#import "USStateDataTableViewController.h"

@interface WorldViewController : UIViewController {
	float deviceWidth;
	float deviceHeight;
}

// Properties
@property (weak, nonatomic) IBOutlet UIButton *getApiTokenBtnOutlet;
@property (weak, nonatomic) IBOutlet UITextView *termsOfServiceTextViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *acceptTermsPopupViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainerOutlet;
@property (retain, readonly) USStateDataTableViewController *stateDataTableViewControllerPtr;
@property (retain, strong) NSDictionary *stateDataDict;

// Actions
- (IBAction)getApiToken:(id)sender;

// action buttons for debugging
//- (IBAction)readFromPlist:(id)sender;
//- (IBAction)checkForValidToken:(id)sender;
//- (IBAction)teardownTermsPopup;
//- (IBAction)showTermsPopup;

// functions
- (NSString *)readSavedToken;
- (void)requestTos;
- (void)checkForValidTokenFunc;
- (void)buildTermsOfUsePopop;
- (void)getLatestUSCovidData;
//- (void)settingExampleThing:(NSString *)someStringAdded addingSecondNamedParam:(NSString *)someOtherString;
@end

