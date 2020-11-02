//
//  DrawPieChart.m
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/25/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import "DrawPieChart.h"

@implementation DrawPieChart
@synthesize dataTotal;
@synthesize positiveCases;
@synthesize recoveredCases;
@synthesize deathCases;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// make sure the container's bounds can be clipped
	self.layer.masksToBounds = TRUE;
	self.layer.cornerRadius = 8.0f;
	// saving dimensions of the piechart container
	double containerWidth = self.layer.bounds.size.width;
	double containerHeight = self.layer.bounds.size.height;

	NSArray *stateData = @[@(positiveCases), @(recoveredCases), @(deathCases)];
	__block CGContextRef viewContextRef = UIGraphicsGetCurrentContext();
	__block CGPoint center = CGPointMake(containerWidth - 100, containerHeight / 2);
	__block CGFloat radius = containerHeight / 2.3f;
	__block CGFloat startAngle = 0.0f;
	__block UIColor *currentColor;
	
	[stateData enumerateObjectsUsingBlock:^( NSNumber * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop ){
		// create path
		// 723 needs to be all of our values combined ie 123 + 144 + 456
		//CGFloat endAngle = (obj.floatValue / 723) * (M_PI) * 2 + startAngle;
		CGFloat endAngle = (obj.floatValue / self->dataTotal) * (M_PI) * 2 + startAngle;
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:TRUE];
		[circlePath addLineToPoint:center];

		// add path
		CGContextAddPath(viewContextRef, circlePath.CGPath);

		// random colors
		//UIColor *currentColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0 ) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
		
		
		// this sets the cell color legend
		switch (index) {
			case 0:
				currentColor = [UIColor colorWithRed:(179.0f/255.0f) green:(66.0f/255.0f) blue:(245.0f/255.0f) alpha:1.0f];
				self.positiveColorViewOutlet.backgroundColor = currentColor;
				self.positiveColorViewOutlet.layer.cornerRadius = 10.0f;
				break;
			case 1:
				currentColor = [UIColor colorWithRed:(60.0f/255.0f) green:(168.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
				self.recoveredColorViewOutlet.backgroundColor = currentColor;
				self.recoveredColorViewOutlet.layer.cornerRadius = 10.0f;
				break;
			case 2:
				currentColor = [UIColor colorWithRed:(168.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
				self.deathsColorViewOutlet.backgroundColor = currentColor;
				self.deathsColorViewOutlet.layer.cornerRadius = 10.0f;
				break;
			default:
				break;
		}

		// set pie section fill color
		[currentColor setFill];

		// render the pie :)
		CGContextDrawPath(viewContextRef, kCGPathFill);

		// reset angle
		startAngle = endAngle;
	}];
}

@end
