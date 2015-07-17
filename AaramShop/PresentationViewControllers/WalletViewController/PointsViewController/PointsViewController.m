//
//  PointsViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PointsViewController.h"

@interface PointsViewController ()

@end

@implementation PointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case eAaramPoints:
			return arrTemp.count;
			break;
		case eBonusPoints:
			return arrTemp.count;
			break;
		case eBrandPoints:
			return arrTemp.count;
			break;
		default:
			break;
	}
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//	[self secView];
	lblPointsName.text	=	@"";


	UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 52)];
	secView.backgroundColor = [UIColor whiteColor];
	UILabel *lblSeprator = [[ UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
	lblSeprator.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
	
	lblPointsName = [[UILabel alloc] initWithFrame:CGRectMake(16, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 32, 21)];
	lblPointsName.font = [UIFont fontWithName:kRobotoRegular size:14];
	lblPointsName.textColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1.0f];
	lblPointsName.textAlignment = NSTextAlignmentLeft;
	
	UIImage *imgPlus = [UIImage imageNamed:@"addBtnCircle"];
	UIImage *imgMinus = [UIImage imageNamed:@"minusBtnCircle"];
	
	UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	plusBtn.frame = CGRectMake(16, (secView.frame.size.height - 20)/2, [[UIScreen mainScreen] bounds].size.width - 32, 20);
	plusBtn.tag = 100;
	if(selectedPointsType == eAaramPoints || selectedPointsType == eBrandPoints || selectedPointsType == eBonusPoints)
	{
		[plusBtn setImage:imgMinus forState:UIControlStateNormal];
	}
	else
	{
		[plusBtn setImage:imgPlus forState:UIControlStateNormal];
	}
	//					[plusBtn setImage:imgMinus forState:UIControlStateSelected];
	[plusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -268)];
	[plusBtn addTarget:self action:@selector(expandTable:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(plusBtn.frame.size.width - 50, (secView.frame.size.height - 21)/2, 100, 21)];
	
	lblAmount.textColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:101/255.0f alpha:1.0f];
	lblAmount.text = [NSString stringWithFormat:@"%@",strPoints];
	lblAmount.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
	UILabel *lblSeprator2 = [[ UILabel alloc] initWithFrame:CGRectMake(0, secView.frame.size.height - 1, [[UIScreen mainScreen] bounds].size.width, 1)];
	lblSeprator2.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
	[secView addSubview:lblSeprator];
	
	[secView addSubview:lblPointsName];
	[secView addSubview:plusBtn];
	[secView addSubview:lblAmount];
	[secView addSubview:lblSeprator2];
	

}

@end
