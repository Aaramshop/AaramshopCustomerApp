//
//  SearchViewController.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 02/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "SearchViewController.h"

#define ssNotificationStatusBarTouched	@"StatusBarTouched"
#define kProducts						@"products"



@interface SearchViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
}
@end

@implementation SearchViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate=self;
    
    viewStatus = VIEW_STATUS_NOT_POPPED;
    
    
    [searchBarMain becomeFirstResponder];
    
    toolbarbackground = [[UIToolbar alloc] initWithFrame:self.view.frame];
    toolbarbackground.barStyle = UIBarStyleDefault;
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
	if ([self.delegate respondsToSelector:@selector(removeSearchViewFromParentView)]) {
		        [self.delegate removeSearchViewFromParentView];
		    }
	
//    [self.view removeFromSuperview];
	
}
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	[arrSearchResult removeAllObjects];
	[arrSearchResult addObjectsFromArray:array];
//    for(int i = 0 ; i < [array count];i++)
//    {
//        ProductsModel *product = [array objectAtIndex:i];
//        [arrSearchResult addObject:product];
//    }
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

- (NSMutableArray *)parseData:(id)data{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if([data count]>0)
    {
        for(int i =0 ; i < [data count] ; i++)
        {
            NSDictionary *dict = [data objectAtIndex:i];
            ProductsModel *product = [[ProductsModel alloc] init];
            
            product.category_id			=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"category_id"]];
            product.product_id				=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"product_id"]];
            product.product_image		=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"product_image"]];
            product.product_name		=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"product_name"]];
			product.isStoreProduct		=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"isStoreProduct"]];
            product.product_price		=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"product_price"]];
            product.product_sku_id		=	[NSString stringWithFormat:@"%@",	[dict objectForKey:@"product_sku_id"]];
            product.sub_category_id	= [NSString stringWithFormat:@"%@",	[dict objectForKey:@"sub_category_id"]];
//            product.quantity = @"0";
            product.strCount = @"0";

            
            totalNoOfPages = [[dict objectForKey:kTotal_page] intValue];
            
            [array addObject:product];
        }
        
    }
    return array;
    
}
#pragma mark - UITableView Delegates & DataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchCell";
    
    
    SearchTableCell *searchCell = (SearchTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (searchCell == nil) {
        searchCell = [[SearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }

    [searchCell updateDetailsFor:[arrSearchResult objectAtIndex:indexPath.row]];
    
    
    return searchCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductsModel *product = [arrSearchResult objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SearchViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(openSearchedUserPrroductFor:)])
    {
        [self.delegate openSearchedUserPrroductFor:product];
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
    
    
//    NSLog(@"%@",NSStringFromCGRect(viewSearchBarContainer.frame));
//    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^
//     {
//         [viewSearchBarContainer setFrame:CGRectMake(0, -64, viewSearchBarContainer.frame.size.width, viewSearchBarContainer.frame.size.height)];
//         [toolbarbackground setAlpha:0.0];
//         [tblViewSearch setAlpha:0.0];
//         [tblViewSearch setSectionFooterHeight:0.01f];
//         
//         [self performSelector:@selector(dismissView) withObject:nil afterDelay:0.4];
//         
//         
//     }completion:nil];
    
    
    
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
    if ([searchText length] >=3 ) {
        
        pageNumber = 0;
        
        [self callWebServiceFor:kProducts withSearchString:searchText];
        
    }else{
        boolActivityIndicator = NO;
        [tblViewSearch setSectionFooterHeight:0.01f];
        [tblViewSearch setSectionHeaderHeight:0.01f];
        [tblViewSearch reloadData];
    }
    
}

-(void)callWebServiceFor:(NSString *)serviceType withSearchString:(NSString *)searchString{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    if(!self.store)
	{
		[dict setObject:@"0" forKey:kStore_id];
	}
	else
	{
		[dict setObject:self.store.store_id forKey:kStore_id];
	}
    [dict setObject:searchString forKey:kSearch_term];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:kPage_no];
    
    [self performSelector:@selector(callWebservicesToGetProducts:) withObject:dict afterDelay:0.1];
}
- (void)callWebservicesToGetProducts:(NSMutableDictionary *)aDict
{
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:KURLSerachStoreProducts withInput:aDict withCurrentTask:TASK_TO_SEARCH_STORE_PRODUCTS andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
    isLoading = NO;
    if (viewStatus == VIEW_STATUS_POPPED) {
        return;
    }
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_TO_SEARCH_STORE_PRODUCTS)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            if(pageNumber==0)
            {
                [self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:kProducts]]];
                
            }
            else
            {
                [self appendDataForPullUp:[self parseData:[responseObject objectForKey:kProducts]]];
            }
            [tblViewSearch reloadData];
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
    if(totalNoOfPages>pageNumber)
    {
        pageNumber++;
        [self callWebServiceFor:kProducts withSearchString:searchBarMain.text];
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
