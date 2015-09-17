//
//  ChatViewController.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 25/05/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "ChatViewController.h"

#define kCustomerSupportId                  @"1400721"

@interface ChatViewController ()
{
    NSMutableArray *arrCustomerSupport;
	AppDelegate *appDelegate;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideBar = [Utils createLeftBarWithDelegate:self];
	appDelegate = APP_DELEGATE;

    self.arrCustomers = [[NSMutableArray alloc]init];
    arrCustomerSupport = [[NSMutableArray alloc]init];
    UIFont *font = [UIFont fontWithName:kRobotoRegular size:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segChatSelection setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"ChatList"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setUpNavigationBar];
    gCXMPPController._messageDelegate = self;
    [self reloadTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - fetch controller
- (void)fetchedResultsController
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1])
    {
        return;
    }
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                              inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"streamBareJidStr LIKE[c] %@",[[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects: sortDescriptor, nil]];
    
    NSError *error= nil;
    if(!self.arrCustomers)
        self.arrCustomers = [[NSMutableArray alloc] init];
    [self.arrCustomers removeAllObjects];
    if(!arrCustomerSupport)
        arrCustomerSupport = [[NSMutableArray alloc] init];
    [arrCustomerSupport removeAllObjects];
	if(appDelegate.objStoreModel==nil)
	{
		self.arrCustomers = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
	}
	else
	{
		NSMutableArray *array = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bareJidStr contains[cd] %@",appDelegate.objStoreModel.chat_username];
		NSArray *arr = [array filteredArrayUsingPredicate:predicate];
		if([arr count]>0)
		{
			[self.arrCustomers addObject:[arr objectAtIndex:0]];
		}
	}
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.bareJidStr contains[cd] %@",kCustomerSupportId];
    
    
    NSArray *arr = [self.arrCustomers filteredArrayUsingPredicate:pred];
    
    if([arr count]>0)
    {
        [arrCustomerSupport addObject:[arr objectAtIndex:0]];
        [self.arrCustomers removeObject:[arr objectAtIndex:0]];
    }
    
    
//    for(int i = 0;i<[self.arrCustomers count];i++)
//    {
//        XMPPMessageArchiving_Contact_CoreDataObject *contact = [self.friends objectAtIndex:i];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.charUserName contains[cd] %@",[[contact.bareJidStr componentsSeparatedByString:@"@"] firstObject]];
//        NSArray *arr = [arrAllContacts filteredArrayUsingPredicate:predicate];
//        predicate = [NSPredicate predicateWithFormat:@"SELF.groupJid contains[cd] %@",[[contact.bareJidStr componentsSeparatedByString:@"@"] firstObject]];
//        NSArray *arrGroup = [arrAllGroups filteredArrayUsingPredicate:predicate];
//        
//        if([arr count]>0)
//        {
//            for(int i = 0 ; i<[arr count];i++)
//            {
//                Friends *fr = [arr objectAtIndex:i];
//                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:fr,@"value",fr.nickname,@"name",@"chat",@"type", nil];
//                [self.arrFriends addObject:dictionary];
//            }
//            //            [self.arrFriends addObjectsFromArray:arr];
//        }
//        else if([arrGroup count]>0)
//        {
//            for(Group *grup in arrGroup)
//            {
//                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:grup,@"value",grup.groupName,@"name",@"groupchat",@"type", nil];
//                
//                [self.arrFriends addObject:dictionary];
//                //                [self.arrFriends addObject:grup];
//            }
//        }
//        else
//        {
//            if([contact.bareJidStr rangeOfString:@"conference"].length==0)
//            {
//                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.friends objectAtIndex:i],@"value",[[contact.bareJidStr componentsSeparatedByString:@"@"] firstObject],@"name",@"other",@"type", nil];
//                [self.arrFriends addObject:dictionary];
//                newUser = YES;
//                
//                //                [self.arrFriends addObject:[self.friends objectAtIndex:i]];
//            }
//        }
//    }
//    if(newUser)
//    {
//        [self getFriendList];
//    }
    //    NSLog(@"Fetch Result Controller self.ArrFriends  : %@ ",self.arrFriends);
}
#pragma mark - Navigation Bar setup
-(void)setUpNavigationBar
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
	if(appDelegate.objStoreModel == nil)
	{
		titleView.text = @"Chats";
	}
	else
	{
		titleView.text = appDelegate.objStoreModel.store_name;
	}
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
	
	if(appDelegate.objStoreModel == nil)
	{
		UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
		sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
		[sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
		[sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
		
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}
	else
	{
		UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
		
		UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		backBtn.bounds = CGRectMake( -10, 0, 30, 30);
		
		[backBtn setImage:imgBack forState:UIControlStateNormal];
		[backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}
	UIView *rightContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 44)];
	[rightContainer setBackgroundColor:[UIColor clearColor]];
	UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
	UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake((rightContainer.frame.size.width - 26)/2, (rightContainer.frame.size.height - 26)/2, 26, 26);
	
	[btnCart setImage:imgCart forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[rightContainer addSubview:btnCart];
	
	UIButton *badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	badgeBtn.frame = CGRectMake(16, 5, 23, 23);
	[badgeBtn addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
	[badgeBtn setBackgroundImage:[UIImage imageNamed:@"addToCardNoBox"] forState:UIControlStateNormal];
	
	UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(badgeBtn.frame.origin.x+1	, 13, 20, 8)];
	lab.font = [UIFont fontWithName:kRobotoRegular size:9];
	[lab setTextAlignment:NSTextAlignmentCenter];
	[lab setTextColor:[UIColor whiteColor]];
	[lab setBackgroundColor:[UIColor clearColor]];
	NSInteger count = [AppManager getCountOfProductsInCart];
	if (count > 0) {
		gAppManager.intCount = count;
		if (count>99) {
			lab.text = @"99+";
		}
		else
			lab.text = [NSString stringWithFormat:@"%ld",(long)count];
		[rightContainer addSubview:badgeBtn];
		[rightContainer addSubview:lab];
	}
	
	UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
	
	
	UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.bounds = CGRectMake( 0, 0, 24, 24);
	
	[btnSearch setImage:imgSearch forState:UIControlStateNormal];
	[btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
	UIBarButtonItem* barBtnCart  = [[UIBarButtonItem alloc] initWithCustomView:rightContainer];
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,
							 barBtnSearch, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
-(void)btnCartClicked
{
	CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
	[self.navigationController pushViewController:cartView animated:YES];
	
}
-(void)btnSearchClicked
{
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];
}


- (void)btnBackClicked
{
	[appDelegate removeTabBarRetailer];
}
-(void)SideMenuClicked
{
	[self.sideBar show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if(appDelegate.objStoreModel == nil)
	{
		if(self.segChatSelection.selectedSegmentIndex ==0)
		{
			return 1;
		}
		else
		{
			return [self.arrCustomers count];
		}
	}
	else
	{
		if(self.segChatSelection.selectedSegmentIndex ==0)
		{
			return 1;
		}
		else
		{
			return 1;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cellChatList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    cell.textLabel.text = @"Customer Support";
//    cell.imageView.image = [UIImage imageNamed:@"homeScreenAaramShopLogo"];
    //  UIImageView *imgProfile=(UIImageView*)[ cell viewWithTag:1112];
    UIImageView *imgViewProfile = (UIImageView *)[cell.contentView viewWithTag:100];
    imgViewProfile.layer.cornerRadius = imgViewProfile.bounds.size.width/2;
    imgViewProfile.autoresizingMask = UIViewAutoresizingNone;
    imgViewProfile.clipsToBounds=YES;

    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblMessage = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblTime = (UILabel *)[cell.contentView viewWithTag:103];
    UIButton *btnMessageCounter = (UIButton *)[cell.contentView viewWithTag:104];
    btnMessageCounter.hidden = YES;
	
	if(appDelegate.objStoreModel == nil)
	{
		XMPPMessageArchiving_Contact_CoreDataObject *cont = nil;
		if(self.segChatSelection.selectedSegmentIndex == 0)
		{
			if([arrCustomerSupport count]>0)
			{
				cont = [arrCustomerSupport objectAtIndex:indexPath.row];
				lblMessage.text = cont.mostRecentMessageBody;
				lblTime.text = [Utils convertedDate:cont.mostRecentMessageTimestamp];
				NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
				if([arrMsg count]>0)
				{
					NSPredicate *predicate = nil;
					if([cont.bareJidStr rangeOfString:STRChatServerURL].length>0)
					{
						predicate = [NSPredicate predicateWithFormat:@"self = %@",cont.bareJidStr];
					}
					//            else
					//            {
					//                predicate = [NSPredicate predicateWithFormat:@"self = %@",[[NSString stringWithFormat:@"%@@%@",addFriends.charUserName,STRChatServerURL] lowercaseString]];
					//            }
					
					NSArray *aRecentArr = [arrMsg filteredArrayUsingPredicate:predicate];
					if([aRecentArr count]>0)
					{
						if([aRecentArr count]>99)
						{
							[btnMessageCounter setTitle:[NSString stringWithFormat:@"99+"] forState:UIControlStateNormal];
						}
						else
						{
							[btnMessageCounter setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[aRecentArr count]] forState:UIControlStateNormal];
						}
						btnMessageCounter.hidden = NO;
					}
					
				}
			}
			else
			{
				lblTime.text = @"";
				lblMessage.text = @"";
			}
			imgViewProfile.image = [UIImage imageNamed:@"chatAaramShopIcon"];
			lblName.text = @"Customer Support";
			
		}
		else
		{
			cont = [self.arrCustomers objectAtIndex:indexPath.row];
			[imgViewProfile sd_setImageWithURL:[NSURL URLWithString:cont.imgURL] placeholderImage:[UIImage imageNamed:@"chatDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				//
			}];
			lblName.text = cont.nickname;
			if(cont.mostRecentMessageBody.length> 0)
			{
				lblTime.text = [Utils convertedDate:cont.mostRecentMessageTimestamp];
				lblMessage.text = cont.mostRecentMessageBody;
			}

			NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
			if([arrMsg count]>0)
			{
				NSPredicate *predicate = nil;
				if([cont.bareJidStr rangeOfString:STRChatServerURL].length>0)
				{
					predicate = [NSPredicate predicateWithFormat:@"self = %@",cont.bareJidStr];
				}
	//            else
	//            {
	//                predicate = [NSPredicate predicateWithFormat:@"self = %@",[[NSString stringWithFormat:@"%@@%@",addFriends.charUserName,STRChatServerURL] lowercaseString]];
	//            }
				
				NSArray *aRecentArr = [arrMsg filteredArrayUsingPredicate:predicate];
				if([aRecentArr count]>0)
				{
					if([aRecentArr count]>99)
					{
						[btnMessageCounter setTitle:[NSString stringWithFormat:@"99+"] forState:UIControlStateNormal];
					}
					else
					{
						[btnMessageCounter setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[aRecentArr count]] forState:UIControlStateNormal];
					}
					btnMessageCounter.hidden = NO;
				}
				
			}
		}
	}
	else
	{
		if(self.segChatSelection.selectedSegmentIndex == 0)
		{
			XMPPMessageArchiving_Contact_CoreDataObject *cont = nil;
			if([arrCustomerSupport count]>0)
			{
				cont = [arrCustomerSupport objectAtIndex:indexPath.row];
				lblMessage.text = cont.mostRecentMessageBody;
				lblTime.text = [Utils convertedDate:cont.mostRecentMessageTimestamp];
				NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
				if([arrMsg count]>0)
				{
					NSPredicate *predicate = nil;
					if([cont.bareJidStr rangeOfString:STRChatServerURL].length>0)
					{
						predicate = [NSPredicate predicateWithFormat:@"self = %@",cont.bareJidStr];
					}
					//            else
					//            {
					//                predicate = [NSPredicate predicateWithFormat:@"self = %@",[[NSString stringWithFormat:@"%@@%@",addFriends.charUserName,STRChatServerURL] lowercaseString]];
					//            }
					
					NSArray *aRecentArr = [arrMsg filteredArrayUsingPredicate:predicate];
					if([aRecentArr count]>0)
					{
						if([aRecentArr count]>99)
						{
							[btnMessageCounter setTitle:[NSString stringWithFormat:@"99+"] forState:UIControlStateNormal];
						}
						else
						{
							[btnMessageCounter setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[aRecentArr count]] forState:UIControlStateNormal];
						}
						btnMessageCounter.hidden = NO;
					}
					
				}
			}
			else
			{
				lblTime.text = @"";
				lblMessage.text = @"";
			}
			imgViewProfile.image = [UIImage imageNamed:@"chatAaramShopIcon"];
			lblName.text = @"Customer Support";
			
		}
		else
		{
			XMPPMessageArchiving_Contact_CoreDataObject *cont = nil;
			if([self.arrCustomers count]>0)
			{
				cont = [self.arrCustomers objectAtIndex:indexPath.row];
			}

			[imgViewProfile sd_setImageWithURL:[NSURL URLWithString:appDelegate.objStoreModel.store_image] placeholderImage:[UIImage imageNamed:@"chatDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				//
			}];
			lblName.text = appDelegate.objStoreModel.store_name;
			if(cont.mostRecentMessageBody.length> 0)
			{
				lblTime.text = [Utils convertedDate:cont.mostRecentMessageTimestamp];
				lblMessage.text = cont.mostRecentMessageBody;
			}
			else
			{
				lblTime.text		=	@"";
				lblMessage.text	=	@"";
			}
			
			NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
			if([arrMsg count]>0)
			{
				NSPredicate *predicate = nil;
//				if([appDelegate.objStoreModel.chat_username rangeOfString:STRChatServerURL].length>0)
//				{
//					predicate = [NSPredicate predicateWithFormat:@"self = %@",appDelegate.objStoreModel.chat_username];
//				}
//				//            else
//				//            {
					predicate = [NSPredicate predicateWithFormat:@"self = %@",[[NSString stringWithFormat:@"%@@%@",appDelegate.objStoreModel.chat_username,STRChatServerURL] lowercaseString]];
				//            }
				
				NSArray *aRecentArr = [arrMsg filteredArrayUsingPredicate:predicate];
				if([aRecentArr count]>0)
				{
					if([aRecentArr count]>99)
					{
						[btnMessageCounter setTitle:[NSString stringWithFormat:@"99+"] forState:UIControlStateNormal];
					}
					else
					{
						[btnMessageCounter setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[aRecentArr count]] forState:UIControlStateNormal];
					}
					btnMessageCounter.hidden = NO;
				}
				
			}
		}
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *deleg = APP_DELEGATE;
    SMChatViewController *chatView = nil;
    if(self.segChatSelection.selectedSegmentIndex == 0)
    {
        chatView = [deleg createChatViewByChatUserNameIfNeeded:kCustomerSupportId];

        chatView.chatWithUser = [NSString stringWithFormat:@"%@@%@",kCustomerSupportId,STRChatServerURL];

        chatView.friendNameId = @"1";
        chatView.imageString = @"";
        chatView.userName = @"Customer Support";
    }
    else
    {
		if(appDelegate.objStoreModel == nil)
		{
			XMPPMessageArchiving_Contact_CoreDataObject *cont = [self.arrCustomers objectAtIndex:indexPath.row];
			chatView = [deleg createChatViewByChatUserNameIfNeeded:[[cont.bareJidStr componentsSeparatedByString:@"@"] firstObject]];
			chatView.chatWithUser =cont.bareJidStr;
			chatView.friendNameId = cont.userId;
			chatView.imageString = cont.imgURL;
			chatView.userName = cont.nickname;
		}
		else
		{
			chatView = [deleg createChatViewByChatUserNameIfNeeded:appDelegate.objStoreModel.chat_username];
			chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",appDelegate.objStoreModel.chat_username,STRChatServerURL];
			chatView.friendNameId = appDelegate.objStoreModel.store_id;
			chatView.imageString = appDelegate.objStoreModel.store_image;
			chatView.userName = appDelegate.objStoreModel.store_name;
		}
    }
   
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}
- (IBAction)sideBarLeft:(id)sender
{
    [self.sideBar show];
}

- (IBAction)selectionChange:(id)sender {
    [self.tViewChat reloadData];
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}
#pragma mark - XMPP delegate methods
- (void)updateSegmentBar
{
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER];
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER]];
    
    NSInteger supportChatCount = [countedSet countForObject:[NSString stringWithFormat:@"%@@%@",kCustomerSupportId,STRChatServerURL]];

    
    NSInteger customerChatCount = [arr count]-supportChatCount;
    [self.segChatSelection clearBadges];
    if(supportChatCount >0)
        [self.segChatSelection setBadgeNumber:supportChatCount forSegmentAtIndex:0];
    if(customerChatCount > 0)
        [self.segChatSelection setBadgeNumber:customerChatCount forSegmentAtIndex:1];
}
- (void)reloadTableView
{

	[self fetchedResultsController];
//    if([self.arrFriends count]>0)
//    {
//        [tblViewMessages setHidden:NO];
//    }
//    else
//    {
        //        [self.lblNoMatchFound setHidden:NO];
        //        [self.tblViewMessages setHidden:YES];
//    }
    [self.tViewChat reloadData];
    [Utils stopActivityIndicatorInView:self.view];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] count]==0)
    {
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:2] setBadgeValue:nil];
    }
    else
    {
        NSDictionary *uniq = [NSDictionary dictionaryWithObjects:[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] forKeys:[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER]];
        NSLog(@"%@", uniq.allKeys);

        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[ NSString stringWithFormat:@"%lu",(unsigned long)[uniq.allKeys count]]];
        
    }
    [self updateSegmentBar];
//    if([[[AppManager sharedManager].notifyDict allKeys] count]>0)
//    {
//        Friends *friend = [[Database database] getFriend:nil :[[[[AppManager sharedManager].notifyDict objectForKey:@"alert"] componentsSeparatedByString:@":"] firstObject]];
//        if(friend)
//        {
//            [self selectedUser:friend];
//            [AppManager sharedManager].notifyDict = nil;
//        }
//        else
//        {
//            Group *grup = [[Database database] fetchGroupWithGroupName:[[[[AppManager sharedManager].notifyDict objectForKey:@"alert"] componentsSeparatedByString:@":"] firstObject]];
//            NSLog(@"Alert : %@",[[[[AppManager sharedManager].notifyDict objectForKey:@"alert"] componentsSeparatedByString:@":"] firstObject]);
//            NSLog(@"Group : %@",grup);
//            if(grup)
//            {
//                NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:grup.groupJid,kJid,grup.groupName,kGroupName,grup.groupId,kGroupId, nil];
//                [self openGroupChat:dict];
//                [AppManager sharedManager].notifyDict = nil;
//            }
//        }
//        
//    }
    
}
- (void)newMessageReceived:(NSDictionary *)messageContent
{
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.4 ];
    //    if([[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] count]==0)
    //    {
    //        [[[[[APP_DELEGATE tabBarController] tabBar] items]
    //          objectAtIndex:3] setBadgeValue:nil];
    //    }
    //    else
    //    {
    //        NSDictionary *uniq = [NSDictionary dictionaryWithObjects:[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] forKeys:[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER]];
    //        NSLog(@"%@", uniq.allKeys);
    //        [[[[[APP_DELEGATE tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[ NSString stringWithFormat:@"%d",[uniq.allKeys count]]];
    //    }
    
}
- (void)newGroupMessageReceived:(NSDictionary *)messageContent
{
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.4 ];
    
}
- (void)newPrivateMessageReceived:(NSDictionary *)messageContent{
    
}
- (void)isDelivered:(NSDictionary *)messageContent
{
    
}
- (void)userPresence:(NSDictionary *)presence
{
//    [self reloadTableView];
}
- (void)ReceiveIQ:(XMPPIQ *)IQ
{
    
}
- (void)StopAudioRecorder
{
    
}
//27-1-14 displayed
- (void)isDisplayed:(NSDictionary *)messageContent
{
    
}
@end
