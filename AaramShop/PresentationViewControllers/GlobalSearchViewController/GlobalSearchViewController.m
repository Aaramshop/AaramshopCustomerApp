//
//  GlobalSearchViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 01/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchViewController.h"

@interface GlobalSearchViewController ()

@end

@implementation GlobalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setNavigationBar];
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
	[tblView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBar
{
	self.navigationController.navigationBarHidden = NO;
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
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
	titleView.text = @"Search";
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
	
	
	//    UIImage *imgCheckout = [UIImage imageNamed:@"doneBtn"];
	//    UIButton *btnCheckout = [UIButton buttonWithType:UIButtonTypeCustom];
	//    btnCheckout.bounds = CGRectMake( -10, 0, 75, 30);
	//    [btnCheckout setTitle:@"Checkout" forState:UIControlStateNormal];
	//    [btnCheckout.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
	//    [btnCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	//    [btnCheckout setBackgroundImage:imgCheckout forState:UIControlStateNormal];
	//    [btnCheckout addTarget:self action:@selector(btnCheckoutClicked) forControlEvents:UIControlEventTouchUpInside];
	//    UIBarButtonItem *barBtnCheckout = [[UIBarButtonItem alloc] initWithCustomView:btnCheckout];
	//
	//    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCheckout, nil];
	//    self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}

-(void)backButtonClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//	[arrSearchCustomers removeAllObjects];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.customer_name contains[c] %@",self.searchCustomer.text];
	
	NSArray *arrPredicate = [NSArray arrayWithObjects:predicate, nil];
	
	NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:arrPredicate];
	
	
//	NSArray *array = [self.arrCustomerData filteredArrayUsingPredicate:compoundPredicate];
//	arrSearchCustomers = [NSMutableArray arrayWithArray:array];
	
	
	if(self.searchCustomer.text.length>0)
		isSearching=YES;
	
	else
		isSearching=NO;
	
	[tblView reloadData];
	
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
	
	[self.searchCustomer resignFirstResponder];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.customer_name contains[c] %@",self.searchCustomer.text];
	
	NSArray *arrPredicate = [NSArray arrayWithObjects:predicate, nil];
	
	NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:arrPredicate];
	
//	[arrSearchCustomers removeAllObjects];
//	//    isLocalSearching=YES;
//	NSArray *arr = [self.arrCustomerData filteredArrayUsingPredicate:compoundPredicate];
//	
//	arrSearchCustomers = [NSMutableArray arrayWithArray:arr];
	
	if(self.searchCustomer.text.length>0)
		isSearching=YES;
	else
		isSearching=NO;
	[tblView reloadData];
	
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	//    isLocalSearching = YES;
	//    isKeyboardVisible = YES;
	[self.searchCustomer setShowsCancelButton:YES animated:YES];
	
//	if (!arrSearchCustomers) {
//		arrSearchCustomers = [NSMutableArray array];
//	}
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[self.searchCustomer setShowsCancelButton:NO animated:YES];
	//    isKeyboardVisible = NO;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	
	[self.searchCustomer resignFirstResponder];
	//    isKeyboardVisible = NO;
	//    if(searchBarFriends.text.length>0)
	//        isLocalSearching=YES;
	//
	//    //    else
	isSearching=NO;
	self.searchCustomer.text = @"";
	[tblView reloadData];
	
}


@end
