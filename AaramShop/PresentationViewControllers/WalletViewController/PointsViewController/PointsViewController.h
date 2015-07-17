//
//  PointsViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
	eAaramPoints = 0,
	eBonusPoints,
	eBrandPoints,
	eSelectedPointsTypeNone
}enSectionType;

@interface PointsViewController : UIViewController
{
	enSectionType selectedPointsType;
	NSMutableArray *arrTemp;
	NSString *strPoints;
	UILabel *lblPointsName;
}
@end
