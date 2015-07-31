//
//  SearchStoresViewController.m
//  AaramShop
//
//  Created by Approutes on 24/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "SearchStoresViewController.h"

#define notificationStatusBarTouched	@"StatusBarTouched"
#define kProducts						@"products"


@interface SearchStoresViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
}
@end

@implementation SearchStoresViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    appDel = (AppDelegate *)APP_DELEGATE;
    
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate=self;
    
    viewStatus = VIEW_STATUS_NOT_POPPED;
    
    
    [searchBarMain becomeFirstResponder];
    
    toolbarbackground = [[UIToolbar alloc] initWithFrame:self.view.frame];
    toolbarbackground.barStyle = UIBarStyleBlack;
    [toolbarbackground setAlpha:0.0];
    
    
    pageNumber = 0;
    totalNoOfPages = 0;
    isLoading = NO;
    [self.view insertSubview:toolbarbackground atIndex:0];
    
    
    tblViewSearch.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.01f)];
    tblViewSearch.sectionFooterHeight=0.01f;
    
    [tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, self.view.frame.size.height - 220 - 64 - 44)];
    
    if ([Utils isIPhone5]) {
        [tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, 568 - 220 - 64)];
    }else{
        [tblViewSearch setFrame:CGRectMake(tblViewSearch.frame.origin.x, tblViewSearch.frame.origin.y, 320, 480 - 220 - 64)];
    }
    
    [searchBarMain becomeFirstResponder];
    
    
    arrSearchResult = [NSMutableArray array];
    
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
    
    
    if (!activityIndicatorView) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setHidesWhenStopped:YES];
        activityIndicatorView.center = CGPointMake(self.view.center.x, 150);
        [self.view addSubview:activityIndicatorView];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear:animated];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         [viewSearchBarContainer setFrame:CGRectMake(0, 0, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height)];
         
         [toolbarbackground setAlpha:1.0];
         [tblViewSearch setAlpha:1.0];
     }completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHit) name:notificationStatusBarTouched object:nil];
    
    isSearchOn = NO;
    
    [self createDataToGetStoresList];

}


#pragma mark - Create Data To Get Stores List
-(void)createDataToGetStoresList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.longitude] forKey:kLongitude];

    [dict setObject:@"0" forKey:kPage_no];
    
    
//    [dict setObject:@"28.5136781" forKey:kLatitude]; //temp
//    [dict setObject:@"77.3769436" forKey:kLongitude]; //temp
    
    
    [self callWebserviceToGetHomeStoreBanner:dict];
}





-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationStatusBarTouched object:nil];
    [super viewWillDisappear:animated];
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
    
    viewStatus = VIEW_STATUS_POPPED;
    
    [searchBarMain resignFirstResponder];
    
    [self.view removeFromSuperview];
    
}
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
    for(int i = 0 ; i < [array count];i++)
    {
        ProductsModel *product = [array objectAtIndex:i];
        [arrSearchResult addObject:product];
    }
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
    BOOL wasArrayEmpty = NO;
    if ([arrSearchResult count]==0) {
        arrSearchResult=[[NSMutableArray alloc]init];
        wasArrayEmpty=YES;
    }
    for(int i = 0 ; i < [array count];i++)
    {
        ProductsModel *product = [array objectAtIndex:i];
        if (wasArrayEmpty) {
            [arrSearchResult addObject:product];
        }else
            [arrSearchResult insertObject:product atIndex:i];
    }
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
    for(int i = 0 ; i < [array count];i++)
    {
        ProductsModel *product = [array objectAtIndex:i];
        [arrSearchResult addObject:product];
    }
}


#pragma mark - UITableView Delegates & DataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    StoreModel *objStoreModel = [arrSearchResult objectAtIndex:indexPath.row];
    UILabel *lblStoreName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-56, 45)];
    lblStoreName.font = [UIFont fontWithName:kRobotoRegular size:16.0];
    lblStoreName.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    lblStoreName.text = objStoreModel.store_code;
    [cell.contentView addSubview:lblStoreName];
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreModel *objStoreModel = [arrSearchResult objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SearchStoresViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(openSearchedStores:)])
    {
        [self.delegate openSearchedStores:objStoreModel];
    }
    
    
    [self.view removeFromSuperview];
    
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    
    NSLog(@"%@",NSStringFromCGRect(viewSearchBarContainer.frame));
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         [viewSearchBarContainer setFrame:CGRectMake(0, -64, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height)];
         [toolbarbackground setAlpha:0.0];
         [tblViewSearch setAlpha:0.0];
         [tblViewSearch setSectionFooterHeight:0.01f];
         
         [self performSelector:@selector(dismissView) withObject:nil afterDelay:0.4];
         
         
     }completion:nil];
    
    
    
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
    if ([searchText length] >=3 ) {
        
        isSearchOn = YES;
        pageNumber = 0;
        [self callWebserviceToSearchText:searchText];
        
    }
    else if ([searchText length] ==0 )
    {
        isSearchOn = NO;
        pageNumber = 0;
        [self createDataToGetStoresList];
    }
    else{
        boolActivityIndicator = NO;
        [tblViewSearch setSectionFooterHeight:0.01f];
        [tblViewSearch setSectionHeaderHeight:0.01f];
        [tblViewSearch reloadData];
    }
    
}


-(void)callWebserviceToSearchText:(NSString *)searchText
{
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    [dict setObject:[NSString stringWithFormat:@"%ld",pageNumber] forKey:kPage_no];
    
    [dict setObject:searchText forKey:@"search_term"];
    
    
    
//    [dict setObject:@"28.5136781" forKey:kLatitude]; //temp
//    [dict setObject:@"77.3769436" forKey:kLongitude]; //temp

    
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }

    
    [aaramShop_ConnectionManager getDataForFunction:kURLSearchStores withInput:dict withCurrentTask:TASK_TO_SEARCH_HOME_STORE andDelegate:self ];

}



-(void)callWebserviceToGetHomeStoreBanner:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
 

    [aaramShop_ConnectionManager getDataForFunction:kGetHomeStoreBannerURL withInput:aDict withCurrentTask:TASK_TO_GET_HOME_STORE_BANNER andDelegate:self ];
}


-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_HOME_STORE_BANNER) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            totalNoOfPages = [[responseObject valueForKey:@"total_page"] intValue];
            
            [self parseHomeStoreResponseData:responseObject];
        }
        else
        {
            //  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_SEARCH_HOME_STORE) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            totalNoOfPages = [[responseObject valueForKey:@"total_page"] intValue];

            [self parseHomeStoreResponseData:responseObject];
        }
        else
        {
            //  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}


-(void)parseHomeStoreResponseData:(NSMutableDictionary *)responseObject
{
    if (pageNumber==0)
    {
        [arrSearchResult removeAllObjects];
    }

    NSArray *arrStores = [responseObject objectForKey:@"suggested_stores"];
    for (id obj in arrStores) {
        StoreModel *objStoreModel = [[StoreModel alloc]init];
        objStoreModel.store_code = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_code]];
        objStoreModel.store_distance = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_distance]];
        objStoreModel.store_id = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_id]];
        
        [arrSearchResult addObject:objStoreModel];
    }
    
    [tblViewSearch reloadData];
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
        
        if (isSearchOn)
        {
            [self callWebserviceToSearchText:searchBarMain.text];
        }
        else
        {
            [self createDataToGetStoresList];
        }
        
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
