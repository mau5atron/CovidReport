//
//  DrawPieChart.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/25/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawPieChart : UIView

// data properties
@property (nonatomic) double dataTotal;
@property (nonatomic) int positiveCases;
@property (nonatomic) int recoveredCases;
@property (nonatomic) int deathCases;

@property (weak, nonatomic) IBOutlet UIView *positiveColorViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *recoveredColorViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *deathsColorViewOutlet;

@end

NS_ASSUME_NONNULL_END
