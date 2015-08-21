//
//  InviteFriendsViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 08/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "FacebookLoginClass.h"
#import <FacebookSDK/FBRequestConnection.h>

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	appDeleg = APP_DELEGATE;
	viewFBMessage =  [[[NSBundle mainBundle] loadNibNamed:@"FacebookView" owner:self options:nil] firstObject];
	tvFBMessage = (UITextView *)[viewFBMessage viewWithTag:102];
	tvFBMessage.delegate = self;
	UIButton *cancel = (UIButton *)[viewFBMessage viewWithTag:100];
	[cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *done = (UIButton *)[viewFBMessage viewWithTag:101];
	[done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	
	UIImageView *imgView = (UIImageView *)[viewFBMessage viewWithTag:103];
	[imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_320 ],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]] placeholderImage:[UIImage imageNamed:@"chatDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		//<#code#>
	}];
	[self setNavigationBar];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	totalNoOfPages = 0;
	fbPage_no = @"0";
	isLoading = NO;
	tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//	[self pushToFacebookApp];
	//	[btnFacebook setExclusiveTouch:YES];
	
	
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	[self pushToFacebookApp];
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
-(void)setNavigationBar
{
	
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 150, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.text = @"Share with Facebook";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	
	UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBack.bounds = CGRectMake( 0, 0, 30, 30 );
	[btnBack setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
	[btnBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *batBtnBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
	
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:batBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
}
- (void)backButtonClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrFBUsers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"InviteFriendCell";
	InviteFriendsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if(cell == nil)
	{
		cell = (InviteFriendsTableCell *)[[InviteFriendsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.indexPath = indexPath;
	cell.delegateInvite = self;
	[cell updateInviteFriendCellWithData:[arrFBUsers objectAtIndex:indexPath.row]];
	
	return cell;
	
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view;
	if ([arrFBUsers count]==0) {
		return nil;
	}else{
		view=[[UIView alloc]initWithFrame:CGRectMake(0, -10, 320, 44)];
		[view setBackgroundColor:[UIColor clearColor]];
		[view setTag:111112];
		UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		[activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		activitIndicator.tag=111111;
		[activitIndicator setCenter:view.center];
		[view addSubview:activitIndicator];
		
		return view;
	}
}
#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrFBUsers.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
	
}

#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
	UIView *view=[tblView viewWithTag:111112];
	UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
	
	if (show) {
		[activity startAnimating];
	}else
		[activity stopAnimating];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - cell delegate
- (void)sendInvite:(NSString *)userId
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   tvFBMessage.text,@"message",userId,@"tags",[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_320 ],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]],@"picture",@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=964132113&mt=8",@"link",
								   [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookLocation"],@"place",
								   nil];
	
	[FBRequestConnection startWithGraphPath:@"me/feed"
								 parameters:params
								 HTTPMethod:@"POST"
						  completionHandler:^(FBRequestConnection *connection,
											  id result,
											  NSError *error)
	 {
		 [Utils stopActivityIndicatorInView:self.view];
		 if (error)
		 {
			 [Utils showAlertView:kAlertTitle message:@"Some problem occured. Please try again." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			 //             [tblView reloadData];
		 }
		 else
		 {
			 [Utils showAlertView:kAlertTitle message:@"Invitation sent successfully." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			 //             [tblView reloadData];
		 }
	 }];
}
-(void)btnInviteClicked:(NSIndexPath *)indexPath isFromFacebook:(BOOL)userType
{
	if (userType==YES)
	{
		NSMutableDictionary *dic = [arrFBUsers objectAtIndex:indexPath.row];
		NSString *userIds = [dic objectForKey:kUserId];
		if([Utils isInternetAvailable])
		{
			selectedFBId = userIds;
			[viewFBMessage setFrame:appDeleg.window.bounds];
			[appDeleg.window addSubview:viewFBMessage];
			[tvFBMessage becomeFirstResponder];
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
		
	}
}
//-(void)btnInviteClicked:(NSIndexPath *)indexPath
//{
//	NSMutableDictionary *dic = [arrFBUsers objectAtIndex:indexPath.row];
//	NSString *userIds = [dic objectForKey:kUserId];
//	if([Utils isInternetAvailable])
//	{
//		selectedFBId = userIds;
//		[viewFBMessage setFrame:appDeleg.window.bounds];
//		[appDeleg.window addSubview:viewFBMessage];
//		[tvFBMessage becomeFirstResponder];
//	}
//	else
//	{
//		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//	}
//}
-(void)pushToFacebookApp
{
	if (![Utils isInternetAvailable])
	{
		[Utils showAlertView:kAlertTitle message:@"Check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		return;
	}
	
	FacebookLoginClass *facebookLoginClass = [[FacebookLoginClass alloc] init];
	[facebookLoginClass facebookLoginMethod];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self selector: @selector(FacebookUserInformation:) name:@"NotifyFetchedFacebookInformation" object:nil];
}
#pragma mark - Retrieving Facebook information..
-(void)FacebookUserInformation:(NSNotification *)inNotification
{
	if ([[inNotification name] isEqualToString: @"NotifyFetchedFacebookInformation"])
	{
		NSMutableDictionary *dict = [inNotification object];
		if ([dict count]>0)
		{
			[self getFBFriends];
		}
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotifyFetchedFacebookInformation" object:nil];
	}
}
-(void)calledPullUp
{
	if(![[NSUserDefaults standardUserDefaults] valueForKey:kFBAccessToken])
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
	else
	{
		[self getFBFriends];
	}
}
- (void)getFBFriends
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kFBAccessToken] forKey:kAccessToken];
	[dict setValue:fbPage_no forKey:kPage_no];
	[self callWebServiceToGetFacebookFriends:dict];
}
- (void)callWebServiceToGetFacebookFriends:(NSMutableDictionary *)dict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		
		isLoading = NO;
		
		[self showFooterLoadMoreActivityIndicator:NO];
		
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetFBFriends withInput:dict withCurrentTask:TASK_GET_FB_FRIENDS andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	
	[AppManager stopStatusbarActivityIndicator];
	
	
	if (aaramShop_ConnectionManager.currentTask == TASK_GET_FB_FRIENDS)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			NSLog(@"%@",responseObject);
			[self parseFBFriends:[responseObject valueForKey:@"fb_data"]];
			fbPage_no = [responseObject objectForKey:@"page_no"];
		}
		else
		{
			tblView.hidden = NO;
		}
	}
}
- (void)parseFBFriends:(id)response
{
	if(!arrFBUsers)
	{
		arrFBUsers = [[NSMutableArray alloc]init];
	}
	if([fbPage_no isEqualToString:@"0"])
	{
		[arrFBUsers removeAllObjects];
	}
	for(NSDictionary *dict in response)
	{
		NSMutableDictionary *FBuser = [[NSMutableDictionary alloc]init];
		[FBuser setObject:[dict objectForKey:@"fb_id"] forKey:kUserId];
		[FBuser setObject:[dict objectForKey:@"fb_image_url"] forKey:@"profilePic"];
		[FBuser setObject:[dict objectForKey:@"fb_name"] forKey:@"username"];
		//        fbPage_no =
		[arrFBUsers addObject:FBuser];
	}
	if([arrFBUsers count]>0)
	{
		tblView.hidden = NO;
		[tblView reloadData];
	}
}
- (void)didFailWithError:(NSError *)error
{
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([textView.text length]==400)
	{
		if([text isEqualToString:@""])
			return YES;
		else
			return NO;
	}
	return YES;
}

#pragma mark - Facebook View methods
- (void)cancel
{
	[viewFBMessage removeFromSuperview];
}
- (void)done
{
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(sendInvite:) withObject:selectedFBId afterDelay:0.1];
	[viewFBMessage removeFromSuperview];
}
@end
