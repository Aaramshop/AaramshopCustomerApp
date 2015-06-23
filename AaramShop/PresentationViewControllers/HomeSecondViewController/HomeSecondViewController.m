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


@interface HomeSecondViewController ()
{
    AppDelegate *appDeleg;
    BOOL isSelected;
    NSString *strSelectedCategoryName;
    NSString *strSelectedCategoryId;
    NSString *strTotalPrice;
    NSString *strSearchTxt;
    BOOL isSearching;

}
@end

@implementation HomeSecondViewController
@synthesize mainCategoryIndexPicker,strStore_Id,aaramShop_ConnectionManager,strStore_CategoryName;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelected = NO;
    strSearchTxt = @"";
    isSearching=NO;
    appDeleg = (AppDelegate *)APP_DELEGATE;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tblVwCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49) style:UITableViewStyleGrouped];
    tblVwCategory.delegate = self;
    tblVwCategory.dataSource = self;
    tblVwCategory.backgroundView = nil;
    tblVwCategory.backgroundColor = [UIColor clearColor];
    tblVwCategory.sectionHeaderHeight = 0.0;
    tblVwCategory.sectionFooterHeight = 0.0;
    [self.view addSubview:tblVwCategory];

    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    mainCategoryIndexPicker = 0;
    
    arrGetStoreProductCategories = [[NSMutableArray alloc]init];
    arrGetStoreProducts = [[NSMutableArray alloc]init];
    arrGetStoreProductSubCategory = [[NSMutableArray alloc]init];
    arrSearchGetStoreProducts = [[NSMutableArray alloc]init];

    [self setUpNavigationBar];
    
    [self createDataToGetStoreProductCategories];

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
    NSArray *subCategories = [responseObject objectForKey:@"sub_categories"];
    
    for (NSDictionary *dict in subCategories) {
        
        SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
        objSubCategoryModel.sub_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_name]];
        objSubCategoryModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
        
        
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
        
        [arrGetStoreProductSubCategory addObject:objSubCategoryModel];
    }
    [tblVwCategory reloadData];
}
-(void)parseStoresProductsData:(NSDictionary *)responseObject
{
        NSArray *arrProductsTemp = [responseObject objectForKey:@"products"];
    for (NSDictionary *dictProducts in arrProductsTemp) {
        
        SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
        
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
    titleView.text = strStore_CategoryName;
    titleView.adjustsFontSizeToFitWidth = YES;
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
    [rightCollectionVwContrllr.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
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
        SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id];
        NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
        objProductsModel = [arrTemp objectAtIndex: IndexPath.row];

    }
    else
    {
        SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id];
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
            
            SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id];
            NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
            rowsNum = arrTemp.count;
        }
        else
            rowsNum = 0;
  
    }
    else
    {
        if (arrGetStoreProductSubCategory.count>0 && arrGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
            
            SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id];
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
        headerHeight = 234;
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
        
        tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234)];
        
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
        
        if (arrGetStoreProductCategories.count>0) {

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@",strSelectedCategoryId];
            NSArray *arrTemp = [arrGetStoreProductCategories filteredArrayUsingPredicate:predicate];
            if (arrTemp.count == 1) {
                CategoryModel *objCategoryModel = [arrTemp objectAtIndex:0];
                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[secView viewWithTag:998];
                [activity startAnimating];
                [imgVCategoryBanner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.category_banner]] placeholderImage:[UIImage imageNamed:@"homePageBannerImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        [activity stopAnimating];
                    }
                }];
                
                /*   [imgVPerson sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreData.store_image]] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 if (image) {
                 }
                 }];
                 */
            }

        }
        
        if (arrGetStoreProductSubCategory.count>0) {
            V8HorizontalPickerView *pickerViewOfCategory = (V8HorizontalPickerView *)[secView viewWithTag:23210];
            pickerViewOfCategory.currentSelectedIndex = mainCategoryIndexPicker;
            pickerViewOfCategory.delegate =self;
            pickerViewOfCategory.dataSource = self;
            pickerViewOfCategory.selectedTextColor = [UIColor whiteColor];
            pickerViewOfCategory.textColor   = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] colorWithAlphaComponent:0.75];
            pickerViewOfCategory.elementFont = [UIFont fontWithName:kRobotoMedium size:14.0];
            
            pickerViewOfCategory.selectionPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/3, 0);
            [pickerViewOfCategory scrollToElement:mainCategoryIndexPicker animated:YES];
  
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
        
        searchBarProducts.frame = CGRectMake(9, 4, [UIScreen mainScreen].bounds.size.width-18, 33);
        UITextField *searchField;
        
        for (UIView *subView in searchBarProducts.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                if ([ndLeveSubView isKindOfClass:[UITextField class]])
                {
                    searchField = (UITextField *)ndLeveSubView;
                    break;
                }
            }
        }
        searchField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
        if(!(searchField == nil)) {
            searchField.textColor = [UIColor blackColor];
            [searchField setBackground: [UIImage imageNamed:@"searchBox.png"]];
            [searchField setBorderStyle:UITextBorderStyleNone];
        }
        
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
        rowHeight = 68.0;
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
        [self createDataToGetStoreProductSubCategory:strSelectedCategoryId];
        [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        [appDeleg.window addSubview:rightCollectionVwContrllr.view];
    }
    else
        [rightCollectionVwContrllr.view removeFromSuperview];
}

-(void)btnGoToCheckOutScreen
{
    
}
#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
    NSInteger numberOfElements=0;
    numberOfElements = arrGetStoreProductSubCategory.count;
    return numberOfElements;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index
{
    SubCategoryModel *objSubCategoryModel = [arrGetStoreProductSubCategory objectAtIndex:index];
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
    
    if (mainCategoryIndexPicker != index) {
        mainCategoryIndexPicker = index;
        [self createDataToGetStoreProducts];
    }
    
}

-(void)selectCategory:(NSDictionary *)dict
{
    strSelectedCategoryName = [dict objectForKey:kCategory_name];
    strSelectedCategoryId = [dict objectForKey:kCategory_id];
    isSelected = NO;
    [arrGetStoreProducts removeAllObjects];
    [arrGetStoreProductSubCategory removeAllObjects];
    [tblVwCategory reloadData];
    
    [self createDataToGetStoreProductSubCategory:strSelectedCategoryId];
}

-(void)createDataToGetStoreProducts
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:strSelectedCategoryId forKey:kCategory_id];
   SubCategoryModel *objSubCategory = [arrGetStoreProductSubCategory objectAtIndex:self.mainCategoryIndexPicker];
    [dict setObject:objSubCategory.sub_category_id forKey:kSub_category_id];
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
    if ([strSearchTxt length]>0)
    {
        [arrSearchGetStoreProducts removeAllObjects];
        [tblVwCategory reloadData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.product_name contains[cd] %@",strSearchTxt];
        [arrSearchGetStoreProducts addObjectsFromArray:[arrGetStoreProducts filteredArrayUsingPredicate:predicate]];
        [tblVwCategory reloadData];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // [searchBarCategory resignFirstResponder];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
