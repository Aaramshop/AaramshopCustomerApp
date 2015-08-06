//
//  AddLocationViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddLocationViewController.h"
#import "LocationEnterViewController.h"

@interface AddLocationViewController ()<AaramShop_ConnectionManager_Delegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation AddLocationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setUpNavigationBar];
	datasource = [[NSMutableArray alloc] init];
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self createDataToGetUserAddress];
}
#pragma mark Navigation
-(void)setUpNavigationBar
{
	
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 190, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 190, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.text = @"Manage Locations";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
	
}

-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnAddLoc:(id)sender {
	
//	locationAlert =  [self.storyboard instantiateViewControllerWithIdentifier :@"LocationAlertScreen"];
//	locationAlert.delegate = self;
//	CGRect locationAlertViewRect = [UIScreen mainScreen].bounds;
//	locationAlert.view.frame = locationAlertViewRect;
//	[[UIApplication sharedApplication].keyWindow addSubview:locationAlert.view];
    
    
    LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
    
    locationScreen.addAddressCompletion = ^(void)
    {
        self.navigationController.navigationBarHidden = NO;
    };
    
    [self.navigationController pushViewController:locationScreen animated:YES];
    
}

#pragma mark - UITableView Delegates & Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"LocationCell";
	
	LocationTableCell *cell = (LocationTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[LocationTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	AddressModel *cmAddressModel = [datasource objectAtIndex:indexPath.row];
	cell.indexPath=indexPath;
	[cell updateCellWithData: cmAddressModel];
	
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tblView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)createDataToGetUserAddress
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	
	[self performSelector:@selector(callWebserviceToGetUserAddress:) withObject:dict];
}
#pragma mark - Call Webservice To Change Password
- (void)callWebserviceToGetUserAddress:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetUserAddress withInput:aDict withCurrentTask:TASK_TO_GET_USER_ADDRESS andDelegate:self];
}

- (void)responseReceived:(id)responseObject
{
	
	[AppManager stopStatusbarActivityIndicator];
	if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_USER_ADDRESS)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			[[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:kUser_address] forKey:kUser_address];
			[[NSUserDefaults standardUserDefaults] synchronize];

			[self parseData:[responseObject objectForKey:@"user_address"]];
			
			
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
}
- (void)didFailWithError:(NSError *)error
{
	
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void)parseData:(id)data
{
	if(!datasource)
	{
		datasource = [[NSMutableArray alloc] init];
	}
	[datasource removeAllObjects];
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			AddressModel *addressModel	= [[AddressModel alloc] init];
			addressModel.user_address_id		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kUser_address_id]];
			addressModel.title						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kUser_address_title]];
			
			addressModel.address					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kAddress]];
			addressModel.state						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kState]];
			addressModel.city							=	[NSString stringWithFormat:@"%@",[dict objectForKey:kCity]];
			addressModel.locality					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kLocality]];
			addressModel.pincode					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kPincode]];
			[datasource addObject:addressModel];
		}
		
	}
	[tblView reloadData];
}
-(void)saveAddress
{
	[self createDataToGetUserAddress];
}
@end
