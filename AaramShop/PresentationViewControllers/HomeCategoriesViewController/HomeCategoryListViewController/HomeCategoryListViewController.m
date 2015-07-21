//
//  HomeCategoryListViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoryListViewController.h"

#define kTableRecommendedHeaderTitleHeight          23
#define kTableParentHeaderDefaultHeight             115
#define kTableParentHeaderExpandedHeight            260
#define kTableParentCellHeight                      100


@interface HomeCategoryListViewController ()

@end

@implementation HomeCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrAllStores = [[NSMutableArray alloc]init];
    arrRecommendedStores = [[NSMutableArray alloc]init];
    
    if (_storeModel)
    {
        [arrAllStores addObjectsFromArray:_storeModel.arrFavoriteStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrHomeStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrShoppingStores];
        
        [arrRecommendedStores addObjectsFromArray:_storeModel.arrRecommendedStores];
        
        //        [arrRecommendedStores addObjectsFromArray:_storeModel.arrRecommendedStores];
        //        [arrRecommendedStores addObjectsFromArray:_storeModel.arrRecommendedStores];
        
    }
    
    tblStores.delegate = self;
    tblStores.dataSource = self;
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//*
#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblRecommendedStore)
    {
        return [arrRecommendedStores count];
    }
    else
    {
        return [arrAllStores count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==tblRecommendedStore)
    {
        return kTableRecommendedHeaderTitleHeight; // text - recommended stores height.
    }
    else
    {
        if ([arrRecommendedStores count]>0)
        {
            if (isTableExpanded==YES)
            {
                return kTableParentHeaderExpandedHeight;
            }
            return kTableParentHeaderDefaultHeight;
        }
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *viewHeader;
    
    if (tableView==tblRecommendedStore)
    {
        viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableRecommendedHeaderTitleHeight)];
        viewHeader.backgroundColor = [UIColor redColor];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, kTableRecommendedHeaderTitleHeight)];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:kRobotoMedium size:18];
        lbl.text = @"Recommended stores";
        [viewHeader addSubview:lbl];
    }
    else
    {
        if ([arrRecommendedStores count]>0)
        {
            
            viewHeader = [[UIView alloc]init];
            viewHeader.backgroundColor = [UIColor whiteColor];
            
            tblRecommendedStore = [[UITableView alloc]init];
            
            tblRecommendedStore.bounces = NO;
            tblRecommendedStore.backgroundColor = [UIColor whiteColor];
            tblRecommendedStore.delegate = self;
            tblRecommendedStore.dataSource = self;
            
            
            if (!btnExpandCollapse)
            {
                btnExpandCollapse = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            
            
            ////
            [btnExpandCollapse setImage:[UIImage imageNamed:@"homeScreenArrowBox.png"] forState:UIControlStateNormal];
            [btnExpandCollapse setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateSelected];
            ////
            
            [btnExpandCollapse addTarget:self action:@selector(btnExpandCollapseClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isTableExpanded==NO)
            {
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderDefaultHeight);
                tblRecommendedStore.frame = CGRectMake(0, 0, viewHeader.frame.size.width, viewHeader.frame.size.height - 0);
                
                [btnExpandCollapse setImageEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
            }
            else
            {
                
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderExpandedHeight);
                tblRecommendedStore.frame = CGRectMake(0, 0, viewHeader.frame.size.width, viewHeader.frame.size.height - 30);
                
                [btnExpandCollapse setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
            }
            
            btnExpandCollapse.frame = CGRectMake(0, (viewHeader.frame.size.height-30), viewHeader.frame.size.width, 40);
            
            
            //            btnExpandCollapse.backgroundColor = [UIColor blueColor];
            //            btnExpandCollapse.alpha = 0.4;
            
            
            [viewHeader addSubview:tblRecommendedStore];
            [viewHeader addSubview:btnExpandCollapse];
            
        }
        
    }
    
    return viewHeader;
    
}


-(void)btnExpandCollapseClicked:(UIButton *)sender
{
    if (isTableExpanded == YES)
    {
        isTableExpanded = NO;
        btnExpandCollapse.selected = NO;
    }
    else
    {
        isTableExpanded = YES;
        btnExpandCollapse.selected = YES;
    }
    
    [tblStores reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableParentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblRecommendedStore)
    {
        
        RecommendedStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedStoreCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"RecommendedStoreCell" bundle:nil] forCellReuseIdentifier:@"RecommendedStoreCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedStoreCell"];
        }
        
        [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
        
        cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
        
        StoreModel *objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        cell.delegate=self;
        
        [cell updateCellWithData:objStoreModel];
        
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"HomeCategoryListCell";
        
        HomeCategoryListCell *cell = (HomeCategoryListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[HomeCategoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
        
        
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
        
        StoreModel *objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        cell.delegate=self;
        
        [cell updateCellWithData:objStoreModel];
        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
    
    StoreModel *objStoreModel = nil;
    
    if (tableView == tblStores)
    {
        objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
    }
    else
    {
        objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
    }

    homeSecondVwController.strStore_Id = objStoreModel.store_id;
    homeSecondVwController.strStoreImage = objStoreModel.store_image;
    homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
    [self.navigationController pushViewController:homeSecondVwController animated:YES];
    
}


#pragma mark - Custom Methods for SwipeCell

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableAttributedString * call = [[NSMutableAttributedString alloc] initWithString:@"Call"];
    NSMutableAttributedString * chat = [[NSMutableAttributedString alloc] initWithString:@"Chat"];
    NSMutableAttributedString * shop = [[NSMutableAttributedString alloc] initWithString:@"Shop"];
    
    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreCallIcon"] attributedTitle: call ];
    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreChatIcon"] attributedTitle: chat ];
    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreShopIcon"] attributedTitle: shop ];
    
    
    return leftUtilityButtons;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = nil;
    BOOL isHomeCell = NO;
    if([cell isKindOfClass:[HomeCategoryListCell class]])
    {
        indexPath= [(UITableView *)tblStores indexPathForCell: cell];
        isHomeCell = YES;
    }
    else
    {
        indexPath= [(UITableView *)tblRecommendedStore indexPathForCell: cell];
        isHomeCell = NO;
    }
    StoreModel *objStoreModel = nil;
    
    switch (index) {
        case 0:
        {
            if(isHomeCell)
            {
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
            }
            else
            {
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
            }
            
            NSString *mobileNo = objStoreModel.store_mobile;
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",mobileNo]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else
            {
                [Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
            
        }
            break;
        case 1:
        {
            if(isHomeCell)
            {
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
                
                AppDelegate *deleg = APP_DELEGATE;
                SMChatViewController *chatView = nil;
                chatView = [deleg createChatViewByChatUserNameIfNeeded:objStoreModel.chat_username];
                chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",objStoreModel.chat_username,STRChatServerURL];
                chatView.friendNameId = objStoreModel.store_id;
                chatView.imageString = objStoreModel.store_image;
                chatView.userName = objStoreModel.store_name;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatView animated:YES];
            }
            else
            {
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                
                AppDelegate *deleg = APP_DELEGATE;
                SMChatViewController *chatView = nil;
                chatView = [deleg createChatViewByChatUserNameIfNeeded:objStoreModel.chat_username];
                chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",objStoreModel.chat_username,STRChatServerURL];
                chatView.friendNameId = objStoreModel.store_id;
                chatView.imageString = objStoreModel.store_image;
                chatView.userName = objStoreModel.store_name;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatView animated:YES];
                
            }
        }
            break;
        case 2:
        {
            if(isHomeCell)
            {
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
            }
            else
            {
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
            }
            
            HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
            homeSecondVwController.strStore_Id = objStoreModel.store_id;
            homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
            [self.navigationController pushViewController:homeSecondVwController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


@end
