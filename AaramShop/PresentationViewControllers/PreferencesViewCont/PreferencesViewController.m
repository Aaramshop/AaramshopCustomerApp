//
//  PreferencesViewController.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()
{
	
}
@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	preferencesModel = [[CMPreferences alloc] init];
	arrLocation = [[NSMutableArray alloc] init];
	strAddressCount = @"";

    [self setUpNavigationBar];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self createDataForPreferences];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	titleView.text = @"Preferences";
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




#pragma mark - UITableView Delegates & Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 3;
			break;
		case 1:
			return 1;
			break;
			
		default:
			return 0;
			break;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tempLabel=[[UILabel alloc]init];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor blackColor];
    [tempLabel setFont:[UIFont systemFontOfSize:15]];
    
    switch (section)
    {
        case 0:
            tempLabel.text =@"     Notification";
            
            break;
        case 1:
            tempLabel.text = @"    Locations";
            break;
    }
    return tempLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
			static NSString *cellIdentifier = @"NotificationCell";
			cell =[self createCellSwitch:cellIdentifier];
			UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:101];
			UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:102];
			UISwitch *cellSwitch = (UISwitch *)[cell.contentView viewWithTag:103];
			switch (indexPath.row) {
				case 0:
				{
					[cellSwitch addTarget:self action:@selector(setOffers:) forControlEvents:UIControlEventValueChanged];
					if([preferencesModel.offers_notification intValue]==1)
					{
						[cellSwitch setOn:YES];
					}
					else
					{
						[cellSwitch setOn:NO];
					}
					imgView.image = [UIImage imageNamed:@"preferencesOffersIcon"];
					lbl.text = @"Offers";
				}
					break;
					
				case 1:
				{
					[cellSwitch addTarget:self action:@selector(setDeliveryStatus:) forControlEvents:UIControlEventValueChanged];
					if([preferencesModel.delivery_status_notification intValue]==1)
					{
						[cellSwitch setOn:YES];
					}
					else
					{
						[cellSwitch setOn:NO];
					}
					imgView.image = [UIImage imageNamed:@"preferencesDeleveryStatusIcon"];
					lbl.text = @"Delivery Status";
				}
					break;
				case 2:
				{
					[cellSwitch addTarget:self action:@selector(setChat:) forControlEvents:UIControlEventValueChanged];
					if([preferencesModel.chat_notification intValue]==1)
					{
						[cellSwitch setOn:YES];
					}
					else
					{
						[cellSwitch setOn:NO];
					}
					imgView.image = [UIImage imageNamed:@"preferencesChatIcon"];
					lbl.text = @"Chat";
				}
					break;
				default:
					break;
			}
        }
            break;
            case 1:
        {
            static NSString *cellIdentifier = @"LocationCell";
            
            cell =[self createCell:cellIdentifier];
            UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:202];
			lbl.text = strAddressCount;
			
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
}
#pragma mark - Calling Cell
-(UITableViewCell*)createCellSwitch:(NSString*)cellIdentifier{
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(UITableViewCell*)createCell:(NSString*)cellIdentifier{
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}
#pragma mark - Delegate for switch state
-(void)getSwitchValue:(NSString *)switchBtnText indexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row)
            {
                if ([switchBtnText isEqualToString:@"ON"])
                {

                }
                else if ([switchBtnText isEqualToString:@"OFF"])
                {

                }
            }
            else
            {
//                [dicOnBoardingData setObject:switchBtnText forKey:[[dicDataKeys valueForKey:kOnBoardingUserInfo] objectAtIndex:indexPath.row]];
            }
        }
            break;
            
       
            
        default:
            break;
    }
}
- (IBAction)setDeliveryStatus:(id)sender
{
	UISwitch *deliverySwitch = (UISwitch *)sender;
	if([deliverySwitch isOn])
	{
		preferencesModel.delivery_status_notification = @"1";
	}
	else
	{
		preferencesModel.delivery_status_notification = @"0";
	}
}
- (IBAction)setOffers:(id)sender
{
	UISwitch *deliverySwitch = (UISwitch *)sender;
	if([deliverySwitch isOn])
	{
		preferencesModel.offers_notification = @"1";
	}
	else
	{
		preferencesModel.offers_notification = @"0";
	}
}
- (IBAction)setChat:(id)sender
{
	UISwitch *deliverySwitch = (UISwitch *)sender;
	if([deliverySwitch isOn])
	{
		preferencesModel.chat_notification = @"1";
	}
	else
	{
		preferencesModel.chat_notification = @"0";
	}
}
- (void)createDataForPreferences
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	
	[self performSelector:@selector(callWebserviceToGetPreferences:) withObject:dict];
}
#pragma mark - Call Webservice To Change Password
- (void)callWebserviceToGetPreferences:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{

		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetPreferences withInput:aDict withCurrentTask:TASK_TO_GET_PREFERENCES andDelegate:self];
}

- (void)responseReceived:(id)responseObject
{
	
	[AppManager stopStatusbarActivityIndicator];
	if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_PREFERENCES)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			
			preferencesModel.offers_notification = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"offers_notification"]];
			preferencesModel.delivery_status_notification = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"delivery_status_notification"]];
			preferencesModel.chat_notification = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"chat_notification"]];
			
			[tblView reloadData];
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
	if(!arrLocation)
	{
		arrLocation = [[NSMutableArray alloc] init];
	}
	[arrLocation removeAllObjects];
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			AddressModel *addressModel = [[AddressModel alloc] init];
			addressModel.user_address_id		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kUser_address_id]];
			addressModel.title						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kUser_address_title]];
			
			addressModel.address					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kAddress]];
			addressModel.state						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kState]];
			addressModel.city							=	[NSString stringWithFormat:@"%@",[dict objectForKey:kCity]];
			addressModel.locality					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kLocality]];
			addressModel.pincode					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kPincode]];
			[arrLocation addObject:addressModel];
		}
		
		strAddressCount =[NSString stringWithFormat:@"Manage Addresses (%ld)",(unsigned long)[data count]];
		
	}
	[tblView reloadData];
}
@end
