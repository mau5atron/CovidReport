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

// Actions
- (IBAction)getApiToken:(id)sender;

@end

