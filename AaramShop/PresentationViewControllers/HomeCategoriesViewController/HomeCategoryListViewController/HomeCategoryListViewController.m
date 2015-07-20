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
#define kTableParentHeaderExpandedHeight            300 //
#define kTableParentCellHeight                      100


@interface HomeCategoryListViewController ()

@end

@implementation HomeCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrAllStores = [[NSMutableArray alloc]init];
    
    if (_storeModel)
    {
        [arrAllStores addObjectsFromArray:_storeModel.arrFavoriteStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrHomeStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrShoppingStores];
    }
    
    tblView.delegate = self;
    tblView.dataSource = self;
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
        return [arrAllStores count];//0;//[arrRecommendedStores count];
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
        if ([_storeModel.arrRecommendedStores count]>0)
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
        if ([_storeModel.arrRecommendedStores count]>0)
        {
            
            viewHeader = [[UIView alloc]init];
            
            if (isTableExpanded==NO)
            {
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderDefaultHeight);
                
//                tblView.scrollEnabled = YES;
//                tblRecommendedStore.userInteractionEnabled = NO;
                
            }
            else
            {
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderExpandedHeight);
                
//                tblView.scrollEnabled = NO;
//                tblRecommendedStore.userInteractionEnabled = YES;
            }
            
            
            tblRecommendedStore = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewHeader.frame.size.width, viewHeader.frame.size.height - 40)];
            
            tblRecommendedStore.delegate = self;
            tblRecommendedStore.dataSource = self;

            
            UIButton *btnExpandCollapse = [UIButton buttonWithType:UIButtonTypeCustom];
            btnExpandCollapse.frame = CGRectMake(0, (viewHeader.frame.size.height-40), viewHeader.frame.size.width, 40);

            [btnExpandCollapse setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btnExpandCollapse setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            
            
            [btnExpandCollapse addTarget:self action:@selector(btnExpandCollapseClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            viewHeader.backgroundColor = [UIColor greenColor];
            tblRecommendedStore.backgroundColor = [UIColor brownColor];
            btnExpandCollapse.backgroundColor = [UIColor blueColor];
            
            
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
    }
    else
    {
        isTableExpanded = YES;
    }
    
    [tblView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableParentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblRecommendedStore)
    {
        
        //*
        
        static NSString *cellIdentifier = @"HomeCategoryListCell1";
        
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
        
       //*/
        
        
        
        /*
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        
        cell.textLabel.text = [NSString stringWithFormat:@"index = %ld",indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"abkhazia"];
        //*/
        
        
        
        
        
        
        
        
        
        
        
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

    /*
     
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


@end
