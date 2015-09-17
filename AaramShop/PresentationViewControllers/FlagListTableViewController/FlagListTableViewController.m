//
//  FlagListTableViewController.m
//  GuessThis
//
//  Created by Madhup Singh Yadav on 4/15/14.
//  Copyright (c) 2014 AppUs.in LLC. All rights reserved.
//

#import "FlagListTableViewController.h"
#import "CMCountryList.h"
#import "MobileEnterViewController.h"
@interface FlagListTableViewController ()

@end

@implementation FlagListTableViewController{
    NSArray *arrCountryList;
    NSMutableArray *arrCountryDisplaylist;
    BOOL isSearching;
    NSString *strSearchTxt;
}
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    isSearching = NO;
    strSearchTxt = @"";

    arrCountryList = [gAppManager getcountryList];
    arrCountryDisplaylist  = [[NSMutableArray alloc]init];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"CountryName"  ascending:YES];
    arrCountryList=[arrCountryList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    for(id subview in tblCountryList.subviews){
        if([subview isKindOfClass:[UITextField class]])
        {
            UITextField *searchFiled = (UITextField *) subview;
            if([searchFiled tag] == 123){
                searchFiled.placeholder = @"search";
            }
        }
    }
    [self setUpNavigationBar];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"Select Country"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark - setUpNavigationBar
-(void)setUpNavigationBar
{
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0,0, 150, 44);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"sketch-me_FREE-version" size:25];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Select your country";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.bounds = CGRectMake( 0, 0, 30, 30);
    
    [btnBack setImage:imgBack forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBackBtn, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [SVProgressHUD dismiss];
}

-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching){
        return [arrCountryDisplaylist count];
    }else{
        return [arrCountryList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIImageView *flagImage /*= [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 35)]*/;
    UILabel *flagCountryName /*= [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 35)]*/;

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        flagImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 35)];
        [flagImage setTag:101];
        [cell.contentView addSubview:flagImage];
        
        flagCountryName = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 35)];
        [flagCountryName setTag:102];
        flagCountryName.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:flagCountryName];
    }
    
    NSDictionary *flagDetail;
    if (isSearching){
        flagDetail = [arrCountryDisplaylist objectAtIndex:indexPath.row];
    }else{
        flagDetail = [arrCountryList objectAtIndex:indexPath.row];
    }
    
    NSString *countryName = [flagDetail objectForKey:@"CountryName"];
    NSString *flagImg = [flagDetail objectForKey:@"CountryFlag"];
    
    flagImage = (UIImageView *)[cell.contentView viewWithTag:101];
    [flagImage setImage:[UIImage imageNamed:flagImg]];
    
    flagCountryName = (UILabel *)[cell.contentView viewWithTag:102];
    flagCountryName.text = countryName;
    [flagCountryName setBackgroundColor:[UIColor whiteColor]];
    return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *flagDetail;
    if (isSearching){
        flagDetail = [arrCountryDisplaylist objectAtIndex:indexPath.row];
    }else{
        flagDetail = [arrCountryList objectAtIndex:indexPath.row];
    }
    
    CMCountryList *cmCountryList = [[CMCountryList alloc] init];
    cmCountryList.CountryFlag = [flagDetail objectForKey:@"CountryFlag"];
    cmCountryList.CountryCode = [flagDetail objectForKey:@"CountryCode"];
    cmCountryList.CountryName = [flagDetail objectForKey:@"CountryName"];
    
    if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(FlagListTableViewControllerDelegate)]  && [self.delegate respondsToSelector:@selector(updateCountryData:)]) {
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];

        [self.delegate updateCountryData:cmCountryList];
        [self.navigationController popViewControllerAnimated:YES];

    }

}

#pragma mark - search Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [searchCountry resignFirstResponder];
}

#pragma mark - Search Bar Delegates

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // called only once
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]==0)
    {
        isSearching =NO;
        [arrCountryDisplaylist removeAllObjects];
        [tblCountryList reloadData];
        return;
    }
    
    strSearchTxt = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    isSearching=YES;
    if ([strSearchTxt length]>0)
    {
        [arrCountryDisplaylist removeAllObjects];
        [tblCountryList reloadData];
        [self filterContentForSearchText:strSearchTxt];
        [tblCountryList reloadData];
    }
}



- (void)filterContentForSearchText:(NSString*)searchText {
    NSPredicate *resultPredicate;
        resultPredicate = [NSPredicate
                           predicateWithFormat:@"SELF['CountryName'] contains[cd] %@",
                           searchText];
    
    [arrCountryDisplaylist  addObjectsFromArray:[arrCountryList filteredArrayUsingPredicate:resultPredicate]] ;
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
