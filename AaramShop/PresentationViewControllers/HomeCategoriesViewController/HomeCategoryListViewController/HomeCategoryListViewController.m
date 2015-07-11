//
//  HomeCategoryListViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoryListViewController.h"

@interface HomeCategoryListViewController ()

@end

@implementation HomeCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrAllStores = [[NSMutableArray alloc]init];
    
    if (_homeCategoriesModel)
    {
        [arrAllStores addObjectsFromArray:_homeCategoriesModel.arrHome_stores];
//        [arrAllStores addObjectsFromArray:_homeCategoriesModel.arrShopping_store];
    }
    
    tblView.delegate = self;
    tblView.dataSource = self;
//    tblView.hidden = YES;
    
//    [self setTables];
}

-(void)setTables
{
    tblVwCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 337) style:UITableViewStyleGrouped];
    tblVwCategory.delegate = self;
    tblVwCategory.dataSource = self;
    tblVwCategory.alwaysBounceVertical = NO;
    tblVwCategory.backgroundView = nil;
    tblVwCategory.backgroundColor = [UIColor clearColor];
    tblVwCategory.sectionHeaderHeight = 0.0;
    tblVwCategory.sectionFooterHeight = 0.0;
    tblVwCategory.scrollEnabled = NO;
    
    tblStores = [[UITableView alloc]initWithFrame:CGRectMake(0, 337, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-337-49)];
    tblStores.delegate = self;
    tblStores.dataSource = self;
    tblStores.backgroundColor = [UIColor clearColor];
    tblStores.scrollEnabled = YES;
    tblStores.sectionHeaderHeight = 0.0;
    tblStores.sectionFooterHeight = 0.0;
    
    
    [self.view addSubview:tblStores];
//    [self.view addSubview:viewTable];
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
//    if (_homeCategoriesModel && [_homeCategoriesModel.arrRecommended_stores count]>0)
//    {
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAllStores count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // if array recommended store > 0
    return 20;
    //else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView ;

    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 20)];
    secView.backgroundColor = [UIColor redColor];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20)];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont fontWithName:kRobotoMedium size:18];
    lbl.text = @"Recommended stores";
    [secView addSubview:lbl];
    
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    CGFloat rowHeight = 0.0;
    if (tableView == tblVwCategory) {
        if (indexPath.section == 1) {
            StoreModel *objStoreModel = nil;
            objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
            
            CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
            
            if (size.height < 20) {
                rowHeight = 83;
            }
            else
                rowHeight = size.height+63;
        }
        else if (indexPath.section == 0)
            rowHeight = 0;
    }
    else if (tableView == tblStores) {
        
        StoreModel *objStoreModel = nil;
        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
        
        CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
        
        if (size.height < 20) {
            rowHeight = 80;
        }
        else
            rowHeight = size.height+60;
    }
    
    return rowHeight;
    //*/
    
    return 80;
}

//-(StoreModel *)getObjectOfStoreForRecommendedStoresForIndexPath:(NSIndexPath *)IndexPath
//{
//    StoreModel *objStoreModel = nil;
//    if (self.mainCategoryIndex != 0 && arrRecommendedStores.count>0) {
//        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
//        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
//        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
//    }
//    else
//        objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:IndexPath.row];
//    return objStoreModel;
//    
//}

//-(StoreModel*)getObjectOfStoreForOtherStoreForIndexPath:(NSIndexPath *)IndexPath
//{
//    StoreModel *objStoreModel = nil;
//    
//    if (self.mainCategoryIndex !=0) {
//        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
//        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
//        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
//        
//        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
//        
//    }
//    else
//        objStoreModel = [arrSubCategoryMyStores objectAtIndex:IndexPath.row];
//    
//    return objStoreModel;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    HomeCategoryListCell *cell = (HomeCategoryListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeCategoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
    
//    cell.selectedCategory = self.mainCategoryIndex;
    cell.delegate=self;
    
//    StoreModel *objStoreModel = nil;
    
//    HomeCategoriesModel *objStoreModel = nil;
    HomeStoreModel *objStoreModel = nil;
    
//    if (tableView == tblVwCategory) {
//        cell.backgroundColor = [UIColor whiteColor];
//        objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
//        cell.isRecommendedStore = YES;
//        
//    }
//    else if (tableView == tblStores) {
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
//        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
    
    objStoreModel = [arrAllStores objectAtIndex:indexPath.row];

    
//    }
    cell.objStoreModel = objStoreModel;
    
    cell.indexPath=indexPath;
    [cell updateCellWithData:objStoreModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
     StoreModel *objStoreModel = nil;
     if (mainCategoryIndex != 0)
     {
     if (tableView == tblStores)
     objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
     
     else if (tableView == tblVwCategory)
     //            objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
     
     objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
     
     }
     else
     {
     if (tableView == tblStores)
     //            objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
     objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
     
     else if (tableView == tblVwCategory)
     //            objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
     objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
     
     }
     
     homeSecondVwController.strStore_Id = objStoreModel.store_id;
     homeSecondVwController.strStoreImage = objStoreModel.store_image;
     homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
     [self.navigationController pushViewController:homeSecondVwController animated:YES];
     
     //*/
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

/*
#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 0;
    if (tableView == tblVwCategory) {
        sectionNum = 2;
    }
    else if (tableView == tblStores)
        sectionNum = 1;
    return sectionNum;;
}
-(NSInteger )getArrayCountForRecommendedStores
{
    NSInteger rowsNum = 0;
    if (self.mainCategoryIndex !=0 && arrRecommendedStores.count>0) {
        StoreModel *objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        rowsNum = arrTemp.count;
    }
    else
    {
        rowsNum = arrRecommendedStoresMyStores.count;
    }
    return  rowsNum;
}
-(NSInteger )getArrayCountForOtherStores
{
    NSInteger rowsNum = 0;
    if (self.mainCategoryIndex != 0) {
        StoreModel *objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
        rowsNum = arrTemp.count;
        
    }
    else
        rowsNum = arrSubCategoryMyStores.count;
    return rowsNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    if (tableView == tblVwCategory) {
        if (section == 1) {
            if (isRefreshing) {
                rowsNum = 0;
            }
            else
            {
                if (arrCategory.count>0) {
                    rowsNum = [self getArrayCountForRecommendedStores];
                }
                else
                    rowsNum = 0;
                
            }
        }
        else if (section == 0)
            rowsNum = 0;
    }
    else if (tableView == tblStores) {
        if (arrCategory.count>0) {
            if (isRefreshing) {
                rowsNum = 0;
            }
            else
            {
                rowsNum =  [self getArrayCountForOtherStores];
            }
        }
        else
            rowsNum = 0;
    }
    
    return rowsNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    if (tableView == tblVwCategory) {
        if (section == 0) {
            headerHeight = 234;
        }
        else if (section == 1){
            if (self.mainCategoryIndex !=0) {
                if (arrRecommendedStores.count == 0) {
                    headerHeight = 0;
                }
                else
                    headerHeight = 20;
            }
            else
            {
                if (arrRecommendedStoresMyStores.count == 0) {
                    headerHeight = 0;
                }
                else
                    headerHeight = 20;
            }
        }
    }
    else if (tableView == tblStores) {
        headerHeight = CGFLOAT_MIN;
    }
    
    return headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView ;
    if (tableView == tblVwCategory) {
        if (section == 0) {
            secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234)];
            secView.backgroundColor = [UIColor clearColor];
            [secView addSubview:objCategoryVwController.view];
        }
        else if (section == 1)
        {
            secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 20)];
            secView.backgroundColor = [UIColor redColor];
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20)];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont fontWithName:kRobotoMedium size:18];
            lbl.text = @"Recommended stores";
            [secView addSubview:lbl];
        }
    }
    else if (tableView == tblStores)
    {
        secView = nil;
    }
    return secView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    if (tableView == tblVwCategory) {
        if (indexPath.section == 1) {
            StoreModel *objStoreModel = nil;
            objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
            
            CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
            
            if (size.height < 20) {
                rowHeight = 83;
            }
            else
                rowHeight = size.height+63;
        }
        else if (indexPath.section == 0)
            rowHeight = 0;
    }
    else if (tableView == tblStores) {
        
        StoreModel *objStoreModel = nil;
        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
        
        CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
        
        if (size.height < 20) {
            rowHeight = 80;
        }
        else
            rowHeight = size.height+60;
    }
    
    return rowHeight;
}

-(StoreModel *)getObjectOfStoreForRecommendedStoresForIndexPath:(NSIndexPath *)IndexPath
{
    StoreModel *objStoreModel = nil;
    if (self.mainCategoryIndex != 0 && arrRecommendedStores.count>0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
    }
    else
        objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:IndexPath.row];
    return objStoreModel;
    
}

-(StoreModel*)getObjectOfStoreForOtherStoreForIndexPath:(NSIndexPath *)IndexPath
{
    StoreModel *objStoreModel = nil;
    
    if (self.mainCategoryIndex !=0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
        
        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
        
    }
    else
        objStoreModel = [arrSubCategoryMyStores objectAtIndex:IndexPath.row];
    
    return objStoreModel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
    
    cell.selectedCategory = self.mainCategoryIndex;
    cell.delegate=self;
    StoreModel *objStoreModel = nil;
    
    if (tableView == tblVwCategory) {
        cell.backgroundColor = [UIColor whiteColor];
        objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
        cell.isRecommendedStore = YES;
        
    }
    else if (tableView == tblStores) {
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
        
    }
    cell.objStoreModel = objStoreModel;
    
    cell.indexPath=indexPath;
    [cell updateCellWithData:objStoreModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //*
    
    HomeCategoriesViewController *homeCategories = (HomeCategoriesViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeCategoryViewScene"];
    [self.navigationController pushViewController:homeCategories animated:YES];
    
    //*/
    
    
    /*
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
     StoreModel *objStoreModel = nil;
     if (mainCategoryIndex != 0)
     {
     if (tableView == tblStores)
     objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
     
     else if (tableView == tblVwCategory)
     //            objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
     
     objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
     
     }
     else
     {
     if (tableView == tblStores)
     //            objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
     objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
     
     else if (tableView == tblVwCategory)
     //            objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
     objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
     
     }
     
     homeSecondVwController.strStore_Id = objStoreModel.store_id;
     homeSecondVwController.strStoreImage = objStoreModel.store_image;
     homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
     [self.navigationController pushViewController:homeSecondVwController animated:YES];
     
     ///
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)refreshSubCategoryData:(NSInteger)selectedCategory
{
    isRefreshing = YES;
    self.mainCategoryIndex = selectedCategory;
    [tblVwCategory reloadData];
    [tblStores reloadData];
    
    tblVwCategory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234);
    viewTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234);
    
    btnArrow.frame = CGRectMake(20, viewTable.frame.size.height-40, [UIScreen mainScreen].bounds.size.width-40, 50);
    
    imgVBg.frame = CGRectMake(0,viewTable.frame.size.height-78, [UIScreen mainScreen].bounds.size.width, 85);
    btnArrow.hidden = YES;
    imgVBg.hidden = YES;
    tblStores.frame = CGRectMake(0, 234,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(234+49));
    
    
    [self createDataToGetStoresFromCategories];
    
}

-(void)refreshBtnFavouriteStatus:(NSIndexPath *)indexPath
{
    [tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = nil;
    BOOL isHomeCell = NO;
    if([cell isKindOfClass:[HomeTableCell class]])
    {
        indexPath= [(UITableView *)tblStores indexPathForCell: cell];
        isHomeCell = YES;
    }
    else
    {
        indexPath= [(UITableView *)tblVwCategory indexPathForCell: cell];
        isHomeCell = NO;
    }
    StoreModel *objStoreModel = nil;
    
    switch (index) {
        case 0:
        {
            if(isHomeCell)
            {
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
            }
            else
            {
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
            }
            NSString *mobileNo = objStoreModel.store_mobile; //pendingOrder.mobile_no;
            
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
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
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
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
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
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
            }
            else
            {
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
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

//*/






@end
