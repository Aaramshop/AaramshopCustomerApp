//
//  GlobalSearchViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 01/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchViewController.h"

@interface GlobalSearchViewController ()<
AaramShop_ConnectionManager_Delegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end


@implementation GlobalSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super  viewWillAppear:animated];
    
    lblMessage.hidden = YES;
    
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
	 {
		 [viewSearchBarContainer setFrame:CGRectMake(0, 0, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height)];
		 
		 [toolbarbackground setAlpha:1.0];
		 [tblViewSearch setAlpha:1.0];
	 }completion:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHit) name:ssNotificationStatusBarTouched object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ssNotificationStatusBarTouched object:nil];
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate=self;
	allSections = [[NSMutableArray alloc] init];
	appDel = APP_DELEGATE;
	
	[allSections addObject:@"stores"];
	[allSections addObject:@"products"];
	viewStatus = VIEW_STATUS_NOT_POPPED;
	
	
	[searchBarMain becomeFirstResponder];
	
	toolbarbackground = [[UIToolbar alloc] initWithFrame:self.view.frame];
	toolbarbackground.barStyle = UIBarStyleDefault;
	[toolbarbackground setAlpha:0.0];
	
	
	pageNumber = 0;
	totalNoOfPages = 0;
	isLoading = NO;
	[self.view insertSubview:toolbarbackground atIndex:0];
	
	
	[tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, self.view.frame.size.height - 220 - 64 - 44)];
	
	if ([Utils isIPhone5]) {
		[tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, 568 - 220 - 64)];
	}else{
		[tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, 480 - 220 - 64)];
	}
	
	[searchBarMain becomeFirstResponder];
	

	arrSearchResult = [[NSMutableArray alloc] init];
	
	[viewSearchBarContainer setFrame:CGRectMake(0, -64, 320, 64)];
	
	[tblViewSearch setAlpha:0.0];
	
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillAppear)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
	
	
	
	[UIView beginAnimations:@"HAnimation" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	
	[viewSearchBarContainer setFrame:CGRectMake(0, 0, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height-1)];
	
	[toolbarbackground setAlpha:1.0];
	[tblViewSearch setAlpha:1.0];
	
	[UIView commitAnimations];
	
	if (!activityIndicatorView) {
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityIndicatorView setHidesWhenStopped:YES];
		activityIndicatorView.center = CGPointMake(self.view.center.x, 150);
		[self.view addSubview:activityIndicatorView];
	}
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"GlobalSearch"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)updateViewWhenAppears{
	[searchBarMain becomeFirstResponder];
}

#pragma mark- Custom Methods
-(void)dismissView{
	//    [self.navigationController popViewControllerAnimated:NO];
	
	viewStatus = VIEW_STATUS_POPPED;
	
	    if ([self.delegate respondsToSelector:@selector(removeSearchViewFromParentView)]) {
	        [self.delegate removeSearchViewFromParentView];
	    }
	[searchBarMain resignFirstResponder];
	
//	[self.view removeFromSuperview];
	
	
	//    [self removeFromParentViewController];
}
- (void)createDataForFirstTimeGet:(NSMutableArray*)array{
	if(!arrSearchResult)
	{
		arrSearchResult = [[NSMutableArray alloc] init];
	}
	[arrSearchResult removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		[arrSearchResult addObject:globalSearchModel];
	}
}
- (void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	if ([arrSearchResult count]==0) {
		arrSearchResult=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrSearchResult addObject:globalSearchModel];
		}else
			[arrSearchResult insertObject:globalSearchModel atIndex:i];
	}
}
- (void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		[arrSearchResult addObject:globalSearchModel];
	}
}
- (void)parseDataForGlobalSearch:(id)responseObject
{
	[tblViewSearch setHidden:NO];
	[lblMessage setHidden:YES];
	if (!dicSearchResult) {
		dicSearchResult = [[NSMutableDictionary alloc] init];
	}
	[dicSearchResult removeAllObjects];
	[arrSearchResult removeAllObjects];
	NSMutableArray *arrStores = [[NSMutableArray alloc] init];
	NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
		for(int i =0 ; i < [[responseObject objectForKey:@"stores"] count] ; i++)
		{
			NSDictionary *dict = [[responseObject objectForKey:@"stores"] objectAtIndex:i];
			CMGlobalSearch *globalSearchModel = [[CMGlobalSearch alloc] init];
			
			globalSearchModel.search_type = searchType;
			
			globalSearchModel.store_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
			globalSearchModel.store_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
			globalSearchModel.store_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];
			totalNoOfPages = [[dict objectForKey:kTotal_pages] intValue];
			
				[arrStores addObject:globalSearchModel];
			
		
		}
	[dicSearchResult setObject:[NSMutableArray arrayWithArray:arrStores] forKey:@"stores"];
	for(int i =0 ; i < [[responseObject objectForKey:@"products"] count] ; i++)
	{
		NSDictionary *dict = [[responseObject objectForKey:@"products"] objectAtIndex:i];
		CMGlobalSearch *globalSearchModel = [[CMGlobalSearch alloc] init];
		
		globalSearchModel.search_type = searchType;
		
		globalSearchModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
		globalSearchModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
		globalSearchModel.product_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
		globalSearchModel.product_sku_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
		globalSearchModel.product_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
		globalSearchModel.product_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
		globalSearchModel.product_price = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_price]];
		totalNoOfPages = [[dict objectForKey:kTotal_pages] intValue];
		
		[arrProducts addObject:globalSearchModel];
	}
	
	[dicSearchResult setObject:[NSMutableArray arrayWithArray:arrProducts] forKey:@"products"];
	
	[tblViewSearch reloadData];
}
- (NSMutableArray *)parseData:(id)data{
	
	NSMutableArray *array = [[NSMutableArray alloc]init];
	
	if([data count]>0)
	{
		[arrSearchResult removeAllObjects];
		[dicSearchResult removeAllObjects];
		[tblViewSearch setHidden:NO];
		[lblMessage setHidden:YES];
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CMGlobalSearch *globalSearchModel = [[CMGlobalSearch alloc] init];
			
			globalSearchModel.search_type = searchType;
			if ([searchType intValue] ==1) {
				globalSearchModel.store_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
				globalSearchModel.store_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
				globalSearchModel.store_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];
				totalNoOfPages = [[dict objectForKey:kTotal_pages] intValue];
				
				[array addObject:globalSearchModel];
			}
			else if ([searchType intValue] ==2)
			{
				globalSearchModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
				globalSearchModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
				globalSearchModel.product_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
				globalSearchModel.product_sku_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
				globalSearchModel.product_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
				globalSearchModel.product_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
				globalSearchModel.product_price = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_price]];
				totalNoOfPages = [[dict objectForKey:kTotal_pages] intValue];
				
				[array addObject:globalSearchModel];
			}
		}
		
	}
	else
	{
		[tblViewSearch setHidden:YES];
		[lblMessage setHidden:NO];
	}
	return array;
	
}
#pragma mark - UITableView Delegates & DataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([searchType intValue]== 3) {
		return allSections.count;
	}
	else if([searchType intValue]==2 || [searchType intValue] == 1)
		return 1;
	else
		return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *tempLabel=[[UILabel alloc]init];
	tempLabel.backgroundColor=[UIColor clearColor];
	[tempLabel setFont:[UIFont fontWithName:kRobotoRegular size:14]];
	
	tempLabel.textColor = [UIColor blackColor];
	
	switch (section) {
	case 0:
			if ([searchType intValue]== 2) {
				tempLabel.text = @" PRODUCTS";
			}
			else
				tempLabel.text =@"  STORES";
		 
			break;
	case 1:
		 tempLabel.text =@"  PRODUCTS";
			break;
	default:
			 tempLabel.text =@"";
			break;
	}
	return tempLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	 NSInteger toReturn = 0;
	if ([searchType intValue] ==3) {
		NSArray *sectionArr = [dicSearchResult objectForKey: [allSections  objectAtIndex: section]];
		
		if (sectionArr && sectionArr.count > 0)
		{
			toReturn = sectionArr.count;
		}
	}
	else
		toReturn = arrSearchResult.count;
	return toReturn;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[tableView setLayoutMargins:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"GlobalSearchCell";
	
	
	GlobalSearchTableCell *searchCell = (GlobalSearchTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (searchCell == nil) {
		searchCell = [[GlobalSearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
	}
	switch (indexPath.section) {
		case 0:
		{
			if ([searchType intValue] == 3) {
				arrSearchResult =[dicSearchResult objectForKey:[allSections objectAtIndex: indexPath.section]];
				CMGlobalSearch *globalSearchModel = [arrSearchResult objectAtIndex:indexPath.row];
				[searchCell updateCellWithData:globalSearchModel];
			}
            else{
                
                if (arrSearchResult.count > 0 && arrSearchResult.count >= indexPath.row)
                {
                    [searchCell updateCellWithData:[arrSearchResult objectAtIndex:indexPath.row]];
                }
            }
				
		}
			break;
		case 1:
		{
			if ([searchType intValue] == 3) {
				arrSearchResult =[dicSearchResult objectForKey:[allSections objectAtIndex: indexPath.section]];
				CMGlobalSearch *globalSearchModel = [arrSearchResult objectAtIndex:indexPath.row];
				[searchCell updateCellWithData:globalSearchModel];
			}
			else
				[searchCell updateCellWithData:[arrSearchResult objectAtIndex:indexPath.row]];
		}
			break;
	default:
			break;
	}
	
	//    searchCell.delegate = self;
//	CMGlobalSearch *globalSearchModel = ;
	
	
	
	return searchCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	CMGlobalSearch *globalSearchModel = nil;
	if([searchType intValue] == 3)
	{
		arrSearchResult =[dicSearchResult objectForKey:[allSections objectAtIndex: indexPath.section]];
		globalSearchModel = [arrSearchResult objectAtIndex:indexPath.row];
		if (globalSearchModel.store_id == nil) {
			if (self.delegate && [self.delegate conformsToProtocol:@protocol(GlobalSearchViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(openSearchedUserPrroductFor:)])
			{
				[self.delegate openSearchedUserPrroductFor:globalSearchModel];
			}
		}
		else
		{
			if (self.delegate && [self.delegate conformsToProtocol:@protocol(GlobalSearchViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(pushToAnotherView:)])
			{
				
				[self.delegate pushToAnotherView:globalSearchModel];
			}

		}
	}
	else if([searchType intValue] == 2)
	{
		if (!arrSearchResult) {
			arrSearchResult =[dicSearchResult objectForKey:[allSections objectAtIndex: indexPath.section]];
		}
		
		globalSearchModel = [arrSearchResult objectAtIndex:indexPath.row];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(GlobalSearchViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(openSearchedUserPrroductFor:)])
		{
			[self.delegate openSearchedUserPrroductFor:globalSearchModel];
		}
	}
	else
	{
		if (!arrSearchResult) {
			arrSearchResult =[dicSearchResult objectForKey:[allSections objectAtIndex: indexPath.section]];
		}
		globalSearchModel = [arrSearchResult objectAtIndex:indexPath.row];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(GlobalSearchViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(pushToAnotherView:)])
		{
			
			[self.delegate pushToAnotherView:globalSearchModel];
		}
	}
	
	[self.view removeFromSuperview];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view;
	if ([arrSearchResult count]==0) {
		[tableView setSectionFooterHeight:0.01f];
		return nil;
	}else{
		[tableView setSectionFooterHeight:44];
		
		view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
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
-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
	UIView *view=[tblViewSearch viewWithTag:111112];
	UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
	
	if (show) {
		[activity startAnimating];
	}else
		[activity stopAnimating];
}
#pragma mark- UISearchBar Delegates Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	
	[UIView beginAnimations:@"HAnimation" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[viewSearchBarContainer setFrame:CGRectMake(0, -64, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height-1)];
	[toolbarbackground setAlpha:0.0];
	[tblViewSearch setAlpha:0.0];
	[UIView commitAnimations];
	[tblViewSearch setSectionFooterHeight:0.01f];
	[self performSelector:@selector(dismissView) withObject:nil afterDelay:0.4];
	
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
	
	return YES;
	
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	
	
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[arrSearchResult removeAllObjects];
	if ([searchText length]>0) {
		
		pageNumber = 0;
		[self callWebServiceForGlobalSearch:searchText];
		
		
	}
	else{
		if([dicSearchResult count]>0)
		{
			[dicSearchResult removeAllObjects];
		}
		[arrSearchResult removeAllObjects];
		boolActivityIndicator = NO;
		[tblViewSearch setSectionFooterHeight:0.01f];
		[tblViewSearch setSectionHeaderHeight:0.01f];
		[tblViewSearch reloadData];
	}
	
}

-(void)callWebServiceForGlobalSearch: (NSString *)searchString{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:searchString forKey:kSearch_term];
	[dict setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:kPage_no];
	
	[self performSelector:@selector(callWebservicesToGetSearch:) withObject:dict afterDelay:0.1];
}
- (void)callWebservicesToGetSearch:(NSMutableDictionary *)aDict
{
    lblMessage.hidden = YES;
    
	if (![Utils isInternetAvailable])
	{
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	

	
	[aaramShop_ConnectionManager getDataForFunction:kURLGlobalSearch withInput:aDict withCurrentTask:TASK_TO_GET_GLOBAL_SEARCH_RESULT andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	if (viewStatus == VIEW_STATUS_POPPED) {
		return;
	}
	[AppManager stopStatusbarActivityIndicator];
	if(aaramShop_ConnectionManager.currentTask == TASK_TO_GET_GLOBAL_SEARCH_RESULT)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			if([[responseObject objectForKey:@"search_type"] intValue] == 1)
			{
				if(pageNumber==0)
				{
					searchType = @"1";
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"stores"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"stores"]]];
				}
				[tblViewSearch reloadData];
			}
			else if([[responseObject objectForKey:@"search_type"] intValue] == 2)
			{
				searchType = @"2";
				if(pageNumber==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"products"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"products"]]];
				}
				[tblViewSearch reloadData];
			}
			else if([[responseObject objectForKey:@"search_type"] intValue] == 3)
			{
				searchType = @"3";
				[self parseDataForGlobalSearch:responseObject];
			}
		}
		else
		{
            lblMessage.hidden = NO;
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
}
- (void)didFailWithError:(NSError *)error
{
	if (viewStatus == VIEW_STATUS_POPPED) {
		return;
	}
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && scrollView.contentOffset.y > 0){
		if (!isLoading)
		{
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
}
-(void)calledPullUp
{
	if(totalNoOfPages>pageNumber+1)
	{
		pageNumber++;
		[self callWebServiceForGlobalSearch:searchBarMain.text];
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
}
#pragma mark- Notification For Keyboard

-(void)keyboardWillAppear{
	
	isKeyboardVisible = YES;
	
}

-(void)keyboardWillHide{
	isKeyboardVisible = NO;
}

#pragma mark- Notification For StatusBar

- (void) statusBarHit {
	[tblViewSearch setContentOffset:CGPointZero animated:YES];
}

@end
