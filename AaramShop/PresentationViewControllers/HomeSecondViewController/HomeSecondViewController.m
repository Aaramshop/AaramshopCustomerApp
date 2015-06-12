//
//  HomeSecondViewController.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeSecondViewController.h"
#import "SubCategoryModel.h"
#import "CategoryModel.h"
#import "HomeSecondCustomCell.h"
@interface HomeSecondViewController ()
{
    AppDelegate *appDeleg;
    BOOL isSelected;
}
@end

@implementation HomeSecondViewController
@synthesize arrSubCategory,arrListData,mainCategoryIndexPicker;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelected = NO;
    appDeleg = (AppDelegate *)APP_DELEGATE;
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    
    rightCollectionVwContrllr = (RightCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"rightCollectionView"];
    rightCollectionVwContrllr.arrCategories = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;

    mainCategoryIndexPicker = 1;
    arrListData = [[NSMutableArray alloc]init];
    arrSubCategory = [[NSMutableArray alloc]init];
    [self setUpNavigationView];
    [self fillCategoriesArray];

    [self fillSubCategoriesArray];
    
    rightCollectionVwContrllr.view.frame = CGRectMake(0, 93, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-93);
    [appDeleg.window addSubview:rightCollectionVwContrllr.view];
    rightCollectionVwContrllr.view.hidden = YES;
    [rightCollectionVwContrllr.arrCategories addObjectsFromArray:arrListData];

}
#pragma mark Navigation

-(void)setUpNavigationView
{
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    [navView setCustomNavigationLeftArrowImageWithImageName:@"menuIcon.png"];

    [navView.btnRight1 setImage:[UIImage imageNamed:@"addToCartIcon.png"] forState:UIControlStateNormal];

    [navView.btnRight2 setImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateNormal];
    
    [navView.btnRight3 setImage:[UIImage imageNamed:@"homeDetailTabStarIcon.png"] forState:UIControlStateNormal];


    navView.delegate=self;
    [self.view addSubview:navView];
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customNavigationRightButtonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        
    }
    else if (sender.tag == 2)
    {
        
    }
    else if (sender.tag == 3)
    {
        
    }
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}


-(void)fillCategoriesArray
{
    for (int z=0; z<5; z++) {
        CategoryModel *objCategoryModel = [[CategoryModel alloc]init];
        switch (z) {
            case 0:
            {
                objCategoryModel.strCategoryName = @"Energy Drinks";
                objCategoryModel.img = @"homeDetailsBeverageIconInactive.png";
            }
                break;
            case 1:
            {
                objCategoryModel.strCategoryName = @"Fruit Drinks";
                objCategoryModel.img = @"homeDetailsCoffeeIconInactive.png";
            }
                break;
                
            case 2:
            {
                objCategoryModel.strCategoryName = @"Milk Products";
                objCategoryModel.img = @"homeDetailsBeverageIconInactive.png";
            }
                break;
                
            case 3:
            {
                objCategoryModel.strCategoryName = @"Beers";
                objCategoryModel.img = @"homeDetailsBeverageIconInactive.png";
            }
                break;
                
            case 4:
            {
                objCategoryModel.strCategoryName = @"Cocktails";
                objCategoryModel.img = @"homeDetailsCoffeeIconInactive.png";
            }
                break;
                
        }
        [arrListData addObject:objCategoryModel];
    }
}
-(void)fillSubCategoriesArray
{
    for (int z=0; z<5; z++) {
        SubCategoryModel *objSubCategory = [[SubCategoryModel alloc]init];
        switch (z) {
            case 0:
            {
                objSubCategory.strCategoryName = @"Pineapple";
                objSubCategory.img = @"productOne.png";
                objSubCategory.count = @"6";
                objSubCategory.price = @"26";
            }
                break;
            case 1:
            {
                objSubCategory.strCategoryName = @"Drinkers";
                objSubCategory.img = @"productTwo.png";
                objSubCategory.count = @"2";
                objSubCategory.price = @"60";
            }
                break;
            case 2:
            {
                objSubCategory.strCategoryName = @"Coolio";
                objSubCategory.img = @"productOne.png";
                objSubCategory.count = @"2";
                objSubCategory.price = @"6";
            }
                break;
            case 3:
            {
                objSubCategory.strCategoryName = @"Coolio2";
                objSubCategory.img = @"productThree.png";
                objSubCategory.count = @"0";
                objSubCategory.price = @"6";
            }
                break;
            case 4:
            {
                objSubCategory.strCategoryName = @"Energy Drink";
                objSubCategory.img = @"productTwo.png";
                objSubCategory.count = @"2";
                objSubCategory.price = @"21";
            }
                break;

            default:
                break;
        }
        [arrSubCategory addObject:objSubCategory];
    }
}

#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    if (section == 0)
        rowsNum = 0;
    else if (section == 1)
        rowsNum = arrSubCategory.count;
    
    return rowsNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    if (section == 0) {
        headerHeight = 234;
    }
    else if (section == 1)
    {
        headerHeight = 41;
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
        
        if (isSelected)
            [btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrowBack.png"] forState:UIControlStateNormal];
        else
        [btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrow.png"] forState:UIControlStateNormal];
        
        
        V8HorizontalPickerView *pickerViewOfCategory = (V8HorizontalPickerView *)[secView viewWithTag:23210];
        pickerViewOfCategory.currentSelectedIndex = mainCategoryIndexPicker;
        pickerViewOfCategory.delegate =self;
        pickerViewOfCategory.dataSource = self;
        pickerViewOfCategory.selectedTextColor = [UIColor whiteColor];
        pickerViewOfCategory.textColor   = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] colorWithAlphaComponent:0.75];
        pickerViewOfCategory.elementFont = [UIFont fontWithName:kRobotoMedium size:14.0];
        
        pickerViewOfCategory.selectionPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/3, 0);
        [pickerViewOfCategory scrollToElement:mainCategoryIndexPicker animated:YES];
        [tempView addSubview:secView];
        return tempView;
    }
    else
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryView"
                                                         owner:self options:nil];
        UIView * secView = (UIView *)[objects objectAtIndex:0];
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        SubCategoryModel *objSubCategory = [arrSubCategory objectAtIndex: indexPath.row];
        cell.indexPath=indexPath;
        //    cell.delegate=self;
        //    [cell setRightUtilityButtons: [self leftButtons] WithButtonWidth:225];
        [cell updateCellWithSubCategory:objSubCategory];
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
    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        rightCollectionVwContrllr.view.hidden = !isSelected;
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
    NSInteger numberOfElements=0;
    numberOfElements = arrListData.count;
    return numberOfElements;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index
{
    CategoryModel *objCategory = [arrListData objectAtIndex:index];
    NSString *strValue = objCategory.strCategoryName;
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
        [tblVwCategory reloadData];
    }
    
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
