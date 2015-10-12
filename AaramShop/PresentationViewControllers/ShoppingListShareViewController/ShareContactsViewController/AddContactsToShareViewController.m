//
//  ShareContactsViewController.m
//  AaramShop
//
//  Created by Approutes on 29/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddContactsToShareViewController.h"

#import "AddcontactsToShareCell.h"

#define kTableCellHeight    58



@interface AddContactsToShareViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation AddContactsToShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBar];
    
    tblContacts.backgroundColor = [UIColor whiteColor];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;

    arrFilteredContactsData = [[NSMutableArray alloc]init];
    arrContactsData = [[NSMutableArray alloc]init];
    
    
    [searchbar setShowsScopeBar:NO];
    [searchbar sizeToFit];
    
    
    [self.searchDisplayController.searchResultsTableView registerClass:[AddContactsToShareCell class] forCellReuseIdentifier:@"AddContactsToShareCell"];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"ShareShoppingListContacts"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    [self performSelector:@selector(fetchContactsFromDevice) withObject:nil afterDelay:0.2];

}


-(void)fetchContactsFromDevice
{
    arrContactsData = [AppManager getAllContacts].mutableCopy;
    
    [AppManager stopStatusbarActivityIndicator];
    
    [tblContacts reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Navigation
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
//    titleView.text = @"Share";
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
    
    //
    UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.bounds = CGRectMake( -10, 0, 50, 30);
    [doneBtn setTitle:@"Share" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imgDone forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnShareClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnDone, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;

    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnShareClicked
{
    if ([arrContactsData count]>0)
    {
        [self callWebServiceToShareShoppingList];
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Choose contact to share" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
}




#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearching)
    {
        return arrFilteredContactsData.count;
    }
    
    return arrContactsData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;

    CellIdentifier = @"AddContactsToShareCell";

    AddContactsToShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[AddContactsToShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegateContactList = self;
    cell.indexPath = indexPath;
    
    if(isSearching)
    {
        [cell updateContactsListCell:[arrFilteredContactsData objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell updateContactsListCell:[arrContactsData objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectContact:indexPath];

}


#pragma mark - Add contacts to share cell delegate

-(void)selectContact:(NSIndexPath *)indexPath
{
    ContactsData *contactsData;
    
    if (isSearching)
    {
        contactsData = [arrFilteredContactsData objectAtIndex:indexPath.row];
        
        isSearching=NO;
        searchbar.text = @"";
        [searchbar resignFirstResponder];
        [tblContacts reloadData];
    }
    else
    {
        contactsData = [arrContactsData objectAtIndex:indexPath.row];
    }
    
    if ([contactsData.isSelected integerValue]==0)
    {
        contactsData.isSelected = @"1";
    }
    else
    {
        contactsData.isSelected = @"0";
        
    }
    
    [tblContacts reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - Call Web Service To Share Shopping List
-(void)callWebServiceToShareShoppingList
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableDictionary *aDict = [Utils setPredefindValueForWebservice];
    
    NSMutableArray *arrTempMobile = [[NSMutableArray alloc]init];
    
    [arrContactsData enumerateObjectsUsingBlock:^(ContactsData *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.isSelected integerValue]==1)
        {
            
            if (obj.numbers && [obj.numbers count]>0)
            {
                NSString *strNumer = [obj.numbers objectAtIndex:0];
                
                NSString * strippedNumber = [strNumer stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strNumer length])];
                
                [arrTempMobile addObject:strippedNumber];
            }
            
            
        }
    }];
    
    
    NSString *strMobiles = [arrTempMobile componentsJoinedByString:@","];
    
    [aDict setObject:_strShoppingListId forKey:@"shoppingListId"];
    [aDict setObject:strMobiles forKey:@"mobile_no"];
    
    
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
    
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kURLShareShoppingList withInput:aDict withCurrentTask:TASK_TO_SHARE_SHOPPING_LIST andDelegate:self ];
}


- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_SHARE_SHOPPING_LIST)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [Utils showAlertView:kAlertTitle message:[responseObject valueForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject valueForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    
}


- (void)didFailWithError:(NSError *)error
{
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


#pragma mark - Search bar delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [arrFilteredContactsData removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@",searchBar.text];
    
    NSArray *arrPredicate = [NSArray arrayWithObjects:predicate, nil];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:arrPredicate];
    
    
    NSArray *array = [arrContactsData filteredArrayUsingPredicate:compoundPredicate];
    arrFilteredContactsData = [NSMutableArray arrayWithArray:array];
    
    
    if(searchBar.text.length>0)
        isSearching=YES;
    
    else
        isSearching=NO;
    
    [tblContacts reloadData];
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    
    [searchbar resignFirstResponder];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@",searchbar.text];
    
    NSArray *arrPredicate = [NSArray arrayWithObjects:predicate, nil];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:arrPredicate];
    
    [arrFilteredContactsData removeAllObjects];
    //    isLocalSearching=YES;
    NSArray *arr = [arrContactsData filteredArrayUsingPredicate:compoundPredicate];
    
    arrFilteredContactsData = [NSMutableArray arrayWithArray:arr];
    
    if(searchbar.text.length>0)
        isSearching=YES;
    else
        isSearching=NO;
    [tblContacts reloadData];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //    isLocalSearching = YES;
    //    isKeyboardVisible = YES;
    [searchbar setShowsCancelButton:YES animated:YES];
    
    if (!arrFilteredContactsData) {
        arrFilteredContactsData = [[NSMutableArray alloc]init];
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBa
{
    [searchbar setShowsCancelButton:NO animated:YES];
    //    isKeyboardVisible = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    
    [searchbar resignFirstResponder];
    //    isKeyboardVisible = NO;
    //    if(searchBarFriends.text.length>0)
    //        isLocalSearching=YES;
    //
    //    //    else
    isSearching=NO;
    searchbar.text = @"";
    [tblContacts reloadData];
    
}


@end
