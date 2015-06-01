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
{
    MobileEnterViewController *mobileEnterVC;
}
@end

@implementation FlagListTableViewController{
    NSArray *data;
    NSArray *displayData;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    mobileEnterVC = [[MobileEnterViewController alloc]init];
    NSString *path;
    
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:kLanguageKey] isEqualToString:@"English"]){
//        path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CountryList-spanish.plist"];
//    }
//    else //if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLanguageKey] isEqualToString:@"Spanish"])
//    {
        path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CountryList-english.plist"];
//    }
    
    data = [NSArray arrayWithContentsOfFile:path];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"CountryName"  ascending:YES];
    data=[data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    for(id subview in self.tableView.subviews){
        if([subview isKindOfClass:[UITextField class]])
        {
            UITextField *searchFiled = (UITextField *) subview;
            if([searchFiled tag] == 123){
                searchFiled.placeholder = @"search";
            }
        }
    }
    [self setUpNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [displayData count];
    }else{
        return [data count];
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
    if (tableView == self.searchDisplayController.searchResultsTableView){
        flagDetail = [displayData objectAtIndex:indexPath.row];
    }else{
        flagDetail = [data objectAtIndex:indexPath.row];
    }
    
    NSString *countryName = [flagDetail objectForKey:@"CountryName"];
    NSString *flagImg = [flagDetail objectForKey:@"CountryFlag"];
    
    flagImage = (UIImageView *)[cell.contentView viewWithTag:101];
    [flagImage setImage:[UIImage imageNamed:flagImg]];
    
    flagCountryName = (UILabel *)[cell.contentView viewWithTag:102];
    flagCountryName.text = countryName;
    [flagCountryName setBackgroundColor:[UIColor whiteColor]];
    // Configure the cell...
    return cell;
    
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *flagDetail;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        flagDetail = [displayData objectAtIndex:indexPath.row];
    }else{
        flagDetail = [data objectAtIndex:indexPath.row];
    }
    
    CMCountryList *cmCountryList = [[CMCountryList alloc] init];
    cmCountryList.flagName = [flagDetail objectForKey:@"CountryFlag"];
    cmCountryList.phoneCode = [flagDetail objectForKey:@"CountryCode"];
    cmCountryList.countryName = [flagDetail objectForKey:@"CountryName"];
    
    gAppManager.cmCountryList = cmCountryList;
//    backFromFlagList = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - search Delegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate;
        resultPredicate = [NSPredicate
                           predicateWithFormat:@"SELF['CountryName'] contains[cd] %@",
                           searchText];
    
    displayData = [data filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UITextField *searchField;
    UIView *topView = self.searchDisplayController.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            cancelButton = (UIButton*)subView;
        }else if ([subView isKindOfClass:[UITextField class]]){
            searchField = (UITextField *) subView;
            searchField.placeholder = @"search";
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    }
}
@end
