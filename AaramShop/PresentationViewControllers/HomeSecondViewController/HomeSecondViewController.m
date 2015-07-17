//
//  HomeSecondViewController.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeSecondViewController.h"
#import "CategoryModel.h"
#import "ProductsModel.h"
#import "SubCategoryModel.h"
#import "PaymentViewController.h"

@interface HomeSecondViewController ()
{
    AppDelegate *appDeleg;
    BOOL isSelected;
    NSString *strSelectedCategoryName;
    NSString *strSelectedCategoryId;
    NSString *strSelectedSubCategoryId;
    NSString *strTotalPrice;
    NSString *strSearchTxt;
    NSMutableArray *arrOnlySubCategoryPicker;
    BOOL isSearching;

}
@end

@implementation HomeSecondViewController
@synthesize mainCategoryIndexPicker,strStore_Id,aaramShop_ConnectionManager,strStore_CategoryName,strStoreImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelected = NO;
    strSearchTxt = @"";
    strTotalPrice = @"0";
    isSearching=NO;
    appDeleg = (AppDelegate *)APP_DELEGATE;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tblVwCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49-64) style:UITableViewStyleGrouped];
    tblVwCategory.delegate = self;
    tblVwCategory.dataSource = self;
    tblVwCategory.backgroundView = nil;
    tblVwCategory.backgroundColor = [UIColor clearColor];
    tblVwCategory.sectionHeaderHeight = 0.0;
    tblVwCategory.sectionFooterHeight = 0.0;
    tblVwCategory.alwaysBounceVertical = NO;
    [self.view addSubview:tblVwCategory];

    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    self.mainCategoryIndexPicker = 0;
    
    arrGetStoreProductCategories = [[NSMutableArray alloc]init];
    arrGetStoreProducts = [[NSMutableArray alloc]init];
    arrGetStoreProductSubCategory = [[NSMutableArray alloc]init];
    arrSearchGetStoreProducts = [[NSMutableArray alloc]init];
    arrOnlySubCategoryPicker = [[NSMutableArray alloc]init];
    
    [self setUpNavigationBar];
    
    [self createDataToGetStoreProductCategories];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    isViewActive = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    isViewActive = NO;
    [super viewWillDisappear:YES];
}



-(void)createDataToGetStoreProductCategories
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    [dict setObject:strStore_Id forKey:kStore_id];
    [self callWebserviceTogetStoreProductCategories:dict];
}
-(void)callWebserviceTogetStoreProductCategories:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoreProductCategoriesURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCT_CATEGORIES andDelegate:self ];
}
-(void)createDataToGetStoreProductSubCategory:(NSString *)strCategoryId
{
    self.mainCategoryIndexPicker = 0;
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:strCategoryId forKey:kCategory_id];
    [self callWebserviceTogetStoreProductSubCategories:dict];
}
-(void)callWebserviceTogetStoreProductSubCategories:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kPOSTGetStoreProductSubCategoryURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCT_SUB_CATEGORIES andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (!isViewActive)
    {
        return;
    }
    
    
    if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCT_CATEGORIES) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseStoresCategoryData:responseObject];
        }
        else
        {
         //   [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCT_SUB_CATEGORIES) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseStoresSubCategoryCategoryData:responseObject];
        }
        else
        {
           // [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCTS) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseStoresProductsData:responseObject];
        }
        else
        {
          //  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }


}
-(void)parseStoresCategoryData:(id)responseObject
{
    NSArray *categories = [responseObject objectForKey:@"categories"];
    
    for (NSDictionary *dict in categories) {
        
        CategoryModel *objCategoryModel = [[CategoryModel alloc]init];
        objCategoryModel.category_banner = [NSString stringWithFormat:@"%@",[[dict objectForKey:kCategory_banner]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
        objCategoryModel.category_image = [NSString stringWithFormat:@"%@",[[dict objectForKey:kCategory_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objCategoryModel.category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_name]];
        
        [arrGetStoreProductCategories addObject:objCategoryModel];
    }
    if (arrGetStoreProductCategories.count>0) {
        CategoryModel *objCategoryModel = [arrGetStoreProductCategories objectAtIndex:0];
        strSelectedCategoryId = objCategoryModel.category_id;
    }
    
        rightCollectionVwContrllr = (RightCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"rightCollectionView"];
        rightCollectionVwContrllr.arrCategories = [[NSMutableArray alloc]init];
        self.automaticallyAdjustsScrollViewInsets = NO;
    
        rightCollectionVwContrllr.view.frame = CGRectMake(0, 93, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-93);
    rightCollectionVwContrllr.delegate=self;
    rightCollectionVwContrllr.strStore_Id= strStore_Id;
     [rightCollectionVwContrllr.arrCategories addObjectsFromArray:arrGetStoreProductCategories];
    isSelected = YES;
    [appDeleg.window addSubview:rightCollectionVwContrllr.view];
}
-(void)parseStoresSubCategoryCategoryData:(id)responseObject
{
    
    [arrOnlySubCategoryPicker removeAllObjects];

    NSArray *subCategories = [responseObject objectForKey:@"sub_categories"];
    
    if (subCategories.count>0) {
        
        NSDictionary *dict = [subCategories objectAtIndex:0];
        strSelectedSubCategoryId = [dict objectForKey:kSub_category_id];
    }
    for (NSDictionary *dict in subCategories) {
        if (arrGetStoreProductSubCategory.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ ",strSelectedCategoryId,[dict objectForKey:kSub_category_id]];
            NSArray *arrTemp ;
            
            arrTemp =[arrGetStoreProductSubCategory filteredArrayUsingPredicate:predicate];
            
            if (arrTemp.count == 0) {
                SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
                objSubCategoryModel.sub_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_name]];
                objSubCategoryModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
                objSubCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
                [arrGetStoreProductSubCategory addObject:objSubCategoryModel];

            }
        }
        
        else
        {
            for (NSDictionary *dict in subCategories) {

            SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
            objSubCategoryModel.sub_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_name]];
            objSubCategoryModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
            objSubCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];

            [arrGetStoreProductSubCategory addObject:objSubCategoryModel];

            }
        }
    }
    for (NSDictionary *dict in subCategories) {

        if (arrGetStoreProductSubCategory.count>0 && arrGetStoreProducts.count>0) {
            NSArray *arrProductsTemp = [dict objectForKey:@"products"];
            
            for (NSDictionary *dictProducts in arrProductsTemp) {
                
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ AND SELF.product_id MATCHES %@",strSelectedCategoryId, strSelectedSubCategoryId,[dictProducts objectForKey:kProduct_id]];
                NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate1];
                
                if (arrTemp.count == 0) {
                    ProductsModel *objProductsModel = [[ProductsModel alloc]init];
                    objProductsModel.category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kCategory_id]];
                    objProductsModel.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
                    objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
                    objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
                    objProductsModel.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
                    objProductsModel.sub_category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kSub_category_id]];
                    objProductsModel.strCount = @"0";
                    [arrGetStoreProducts addObject:objProductsModel];
                }
                
            }
        }
        else
        {
            NSArray *arrProductsTemp = [dict objectForKey:@"products"];

            for (NSDictionary *dictProducts in arrProductsTemp) {
                
                ProductsModel *objProductsModel = [[ProductsModel alloc]init];
                objProductsModel.category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kCategory_id]];
                objProductsModel.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
                objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
                objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
                objProductsModel.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
                objProductsModel.sub_category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kSub_category_id]];
                objProductsModel.strCount = @"0";
                [arrGetStoreProducts addObject:objProductsModel];
            }
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ ",strSelectedCategoryId];

    [arrOnlySubCategoryPicker addObjectsFromArray:[arrGetStoreProductSubCategory filteredArrayUsingPredicate:predicate]];
    
    tblVwCategory.hidden = NO;
    [tblVwCategory reloadData];
}
-(void)parseStoresProductsData:(NSDictionary *)responseObject
{
        NSArray *arrProductsTemp = [responseObject objectForKey:@"products"];
    for (NSDictionary *dictProducts in arrProductsTemp) {
        
        SubCategoryModel *objSubCategory = [arrOnlySubCategoryPicker objectAtIndex:self.mainCategoryIndexPicker];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ AND SELF.product_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id,[dictProducts objectForKey:kProduct_id]];
        NSArray *arrTemp ;
        if (isSearching) {
            arrTemp =[arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
        }
        else
        {
            arrTemp =[arrGetStoreProducts filteredArrayUsingPredicate:predicate];
        }
        if (arrTemp.count == 0) {
            
            ProductsModel *objProductsModel = [[ProductsModel alloc]init];
            objProductsModel.category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kCategory_id]];
            objProductsModel.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
            objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
            objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
            objProductsModel.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
            objProductsModel.sub_category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kSub_category_id]];
            objProductsModel.strCount = @"0";
            if (isSearching) {
                [arrSearchGetStoreProducts addObject:objProductsModel];
            }
            else
            {
                [arrGetStoreProducts addObject:objProductsModel];
            }
        }
    }
    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark Navigation

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
    titleView.numberOfLines = 0;
    titleView.text = strStore_CategoryName;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
    
    UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
    
    UIImage *imgFav = [UIImage imageNamed:@"homeDetailTabStarIcon.png"];

    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCart.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnCart setImage:imgCart forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnCart = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
    
    UIButton *btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFav.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnFav setImage:imgFav forState:UIControlStateNormal];
    [btnFav addTarget:self action:@selector(btnFavClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnFav = [[UIBarButtonItem alloc] initWithCustomView:btnFav];

    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnSearch setImage:imgSearch forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,barBtnSearch,barBtnFav, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        
        UIImage *image = [UIImage imageNamed:@"navigation.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}
-(void)btnBackClicked
{
    isViewActive = NO;
	[arrGetStoreProducts removeAllObjects];
    [rightCollectionVwContrllr.view removeFromSuperview];
//    [self.navigationController popViewControllerAnimated:YES];

	[appDeleg removeTabBarRetailer];
}
-(void)btnCartClicked{
}
-(void)btnFavClicked{
}
-(void)btnSearchClicked{
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}


#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger secNum = 0;
    if (arrGetStoreProducts.count >0) {
        secNum = 2;
    }
    else
        secNum = 1;
    return secNum;
}
-(ProductsModel *)getObjectOfProductForIndexPath:(NSIndexPath *)IndexPath
{
    ProductsModel *objProductsModel = nil;
    
    if (isSearching) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
        NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
        objProductsModel = [arrTemp objectAtIndex: IndexPath.row];

    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
        NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate];
        objProductsModel = [arrTemp objectAtIndex: IndexPath.row];

    }

    return objProductsModel;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    if (section == 0)
        rowsNum = 0;
    else if (section == 1)
    {
    rowsNum = [self getArrayCountForProducts];
    }
    
    return rowsNum;
}
-(NSInteger )getArrayCountForProducts
{
    NSInteger rowsNum = 0;
    if (isSearching)
    {
        if (arrGetStoreProductSubCategory.count>0 && arrSearchGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
            NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
            rowsNum = arrTemp.count;
        }
        else
            rowsNum = 0;
  
    }
    else
    {
        if (arrGetStoreProductSubCategory.count>0 && arrGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
            NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate];
            rowsNum = arrTemp.count;
        }
        else
            rowsNum = 0;

    }
    return  rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    if (section == 0) {
        headerHeight = 170;
    }
    else if (section == 1)
    {
        headerHeight = 82;
    }
    return headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *tempView = nil;
        
        tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CategoryView"
                                                         owner:self options:nil];
        UIView * secView = (UIView *)[objects objectAtIndex:0];
        UIView *smallview = (UIView*)[secView.subviews objectAtIndex:0];
        UIView *smallview1 = (UIView*)[smallview.subviews objectAtIndex:1];
        UIButton *btnCategory;

        if (!btnCategory) {
            for (UIButton *btn in smallview1.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btnCategory = (UIButton *)btn;
                }
            }

        }
        [btnCategory addTarget:self action:@selector(btnCategoryClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblCategory = (UILabel *)[smallview1 viewWithTag:1001];

        lblCategory.text = strSelectedCategoryName;
        if (isSelected)
            [btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrowBack.png"] forState:UIControlStateNormal];
        else
        [btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrow.png"] forState:UIControlStateNormal];
        
        UIImageView *imgVCategoryBanner = (UIImageView *)[secView viewWithTag:999];

        UIImageView *imgVPerson = (UIImageView *)[secView viewWithTag:1002];

        imgVPerson.layer.cornerRadius =  imgVPerson.frame.size.width / 2;
        imgVPerson.clipsToBounds = YES;

        UIImageView *imgVBg = (UIImageView *)[secView viewWithTag:1110];
        imgVBg.hidden = YES;
        if (arrOnlySubCategoryPicker.count>0) {

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@",strSelectedCategoryId];
            NSArray *arrTemp = [arrGetStoreProductCategories filteredArrayUsingPredicate:predicate];

            imgVBg.hidden = NO;
            if (arrTemp.count == 1) {
                CategoryModel *objCategoryModel = [arrTemp objectAtIndex:0];
                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[secView viewWithTag:998];
                [activity startAnimating];
                [imgVCategoryBanner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.category_banner]] placeholderImage:[UIImage imageNamed:@"homePageBannerImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        [activity stopAnimating];
                    }
                }];
                
                   [imgVPerson sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strStoreImage]] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 if (image) {
                 }
                 }];
                
            }

        }
        
        if (arrOnlySubCategoryPicker.count>0) {

            V8HorizontalPickerView *pickerViewOfCategory = (V8HorizontalPickerView *)[secView viewWithTag:23210];
            pickerViewOfCategory.currentSelectedIndex = self.mainCategoryIndexPicker;
            pickerViewOfCategory.delegate =self;
            pickerViewOfCategory.dataSource = self;
            pickerViewOfCategory.selectedTextColor = [UIColor whiteColor];
            pickerViewOfCategory.textColor   = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] colorWithAlphaComponent:0.75];
            pickerViewOfCategory.elementFont = [UIFont fontWithName:kRobotoMedium size:14.0];
            
            pickerViewOfCategory.selectionPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/3, 0);
            [pickerViewOfCategory scrollToElement:self.mainCategoryIndexPicker animated:YES];
  
        }
        [tempView addSubview:secView];
        return tempView;
    }
    else
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryView"
                                                         owner:self options:nil];
        UIView * secView = (UIView *)[objects objectAtIndex:0];
        UIView *secSubView1 = (UIView *)[secView viewWithTag:23237];
        
        UISearchBar *searchBarProducts = (UISearchBar *)[secSubView1 viewWithTag:102];
        searchBarProducts.delegate = self;
        
//        searchBarProducts.frame = CGRectMake(9, 4, [UIScreen mainScreen].bounds.size.width-18, 33);
//        UITextField *searchField;
//        
//        for (UIView *subView in searchBarProducts.subviews){
//            for (UIView *ndLeveSubView in subView.subviews){
//                if ([ndLeveSubView isKindOfClass:[UITextField class]])
//                {
//                    searchField = (UITextField *)ndLeveSubView;
//                    break;
//                }
//            }
//        }
//        searchField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
//        if(searchField == nil) {
//            searchField.textColor = [UIColor blackColor];
//            [searchField setBackground: [UIImage imageNamed:@"searchBox.png"]];
//            [searchField setBorderStyle:UITextBorderStyleNone];
//        }
        [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f]];
//        [searchBarProducts setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        searchBarProducts.placeholder = @"Search";
        searchBarProducts.text = strSearchTxt;
        
        if (strSearchTxt.length>0) {
            [searchBarProducts becomeFirstResponder];
        }
        
        UIView *secSubView2 = (UIView *)[secView viewWithTag:23235];
        
        UIButton *btn = (UIButton *)[secSubView2 viewWithTag:101];
        UILabel *lblPrice = (UILabel *)[secSubView2 viewWithTag:100];
        lblPrice.text =strTotalPrice;
        [btn addTarget:self action:@selector(btnGoToCheckOutScreen) forControlEvents:UIControlEventTouchUpInside];
        
        return secView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    if (indexPath.section == 0) {
        rowHeight = 0.0;
    }
    else
    {
        ProductsModel *objProductsModel = nil;
        objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
        CGSize size= [Utils getLabelSizeByText:objProductsModel.product_name font:[UIFont fontWithName:kRobotoRegular size:16.0f] andConstraintWith:[UIScreen mainScreen].bounds.size.width-175];
        if (size.height<24) {
            rowHeight = 68.0;
        }
        else
            
        rowHeight = 44+size.height;

    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell ;
    
    if (indexPath.section == 1) {
        HomeSecondCustomCell *cell = (HomeSecondCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[HomeSecondCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.delegate=self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ProductsModel *objProductsModel = nil;
        objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
        cell.indexPath=indexPath;
        cell.objProductsModelMain = objProductsModel;
        [cell updateCellWithSubCategory:objProductsModel];
        return cell;

    }
    else
    {
        return cell;

    }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)updateTableAtIndexPath:(NSIndexPath *)inIndexPath
{
    [tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)addedValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
    int priceValue = [strTotalPrice intValue];
    priceValue+=[strPrice intValue];
    strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)minusValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
    int priceValue = [strTotalPrice intValue];
    priceValue-=[strPrice intValue];
    strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath;
//    for (UICollectionViewCell *cell in [collectionViewCategory visibleCells])
//    {
//        indexPath = [collectionViewCategory indexPathForCell:cell];
//    }
//    if (self.mainCategoryIndex != indexPath.row)
//    {
//        self.mainCategoryIndex = indexPath.row;
//        if (self.delegate && [self.delegate conformsToProtocol:@protocol(CategoryViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(refreshSubCategoryData)])
//        {
//            [self.delegate refreshSubCategoryData];
//        }
//    }
}
-(void)btnCategoryClick
{
    isSelected = !isSelected;
    if (isSelected) {
        if (strSelectedCategoryId.length>0) {
            [appDeleg.window addSubview:rightCollectionVwContrllr.view];
        }
    }
    else
        [rightCollectionVwContrllr.view removeFromSuperview];
    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)btnGoToCheckOutScreen
{
    if ([strTotalPrice isEqualToString:@"0"]) {
        [Utils showAlertView:kAlertTitle message:@"Please select Products to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
    PaymentViewController *paymentScreen = (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewScene"];
    paymentScreen.strStore_Id = strStore_Id;
        paymentScreen.strTotalPrice = strTotalPrice;
        NSMutableArray *arrSelectedProducts = [[NSMutableArray alloc]init];
        for (ProductsModel *objProduct in arrGetStoreProducts) {
            
            if (objProduct.strCount.length>0) {
                [arrSelectedProducts addObject:objProduct];
            }
        }
        paymentScreen.arrSelectedProducts = [[NSMutableArray alloc]init];
        paymentScreen.arrSelectedProducts = arrSelectedProducts;
    [self.navigationController pushViewController:paymentScreen animated:YES];
    }
}
#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
    NSInteger numberOfElements=0;
    numberOfElements = arrOnlySubCategoryPicker.count;
    return numberOfElements;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index
{
    SubCategoryModel *objSubCategoryModel = [arrOnlySubCategoryPicker objectAtIndex:index];
    NSString *strValue = objSubCategoryModel.sub_category_name;
    return strValue;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index
{
    NSInteger widthValue=0;
    widthValue=[UIScreen mainScreen].bounds.size.width/3;
    return widthValue ;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    
    if (self.mainCategoryIndexPicker != index) {
        self.mainCategoryIndexPicker = index;
        [self createDataToGetStoreProducts];
    }
    
}

-(void)selectCategory:(NSDictionary *)dict
{
    strSelectedCategoryName = [dict objectForKey:kCategory_name];
    strSelectedCategoryId = [dict objectForKey:kCategory_id];
    isSelected = NO;
    tblVwCategory.hidden = YES;
    [self createDataToGetStoreProductSubCategory:strSelectedCategoryId];
}

-(void)createDataToGetStoreProducts
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:strSelectedCategoryId forKey:kCategory_id];
    
   SubCategoryModel *objSubCategory = [arrOnlySubCategoryPicker objectAtIndex:self.mainCategoryIndexPicker];
    [dict setObject:objSubCategory.sub_category_id forKey:kSub_category_id];
    
    strSelectedSubCategoryId = objSubCategory.sub_category_id;
    [dict setObject:@"0" forKey:@"page_no"];
    [self callWebserviceToGetStoreProducts:dict];
}
-(void)callWebserviceToGetStoreProducts:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kPOSTGetStoreProductsURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCTS andDelegate:self ];
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
        strSearchTxt = searchText;
        isSearching =NO;
        [arrSearchGetStoreProducts removeAllObjects];
        [tblVwCategory reloadData];
        return;
    }
    
//    strSearchTxt = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strSearchTxt = searchText;
    isSearching=YES;
    if ([searchText length]>0)
    {
        [arrSearchGetStoreProducts removeAllObjects];
//        [tblVwCategory reloadData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.product_name contains[cd] %@",strSearchTxt];
        [arrSearchGetStoreProducts addObjectsFromArray:[arrGetStoreProducts filteredArrayUsingPredicate:predicate]];
        [tblVwCategory reloadData];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [searchBarCategory resignFirstResponder];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
