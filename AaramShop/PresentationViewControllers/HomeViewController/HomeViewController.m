//
//  HomeViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationEnterViewController.h"
#import "CategoryModel.h"
#import "HomeSecondViewController.h"
#import "HomeTableCell.h"
#import "SubCategoryModel.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize mainCategoryIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    self.rightSideBar = [Utils createRightBarWithDelegate:self];
    
    [self setUpNavigationView];
    objCategoryVwController = (CategoryViewController *) [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"categoryScreen"];

    objCategoryVwController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrSubCategory = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    
    self.mainCategoryIndex = 0;

    [self fillCategoryArray];

}
-(void)fillCategoryArray
{
    for (int z=0; z<4; z++) {
        CategoryModel *objCategoryModel = [[CategoryModel alloc]init];

        switch (z) {
            case 0:
            {
                objCategoryModel.strCategoryName = @"Food";
                objCategoryModel.img = @"homePageBannerImage";
            }
                break;
            case 1:
            {
                objCategoryModel.strCategoryName = @"Mazor";
                objCategoryModel.img = @"homePageBannerImageFour";
            }
                break;

            case 2:
            {
                objCategoryModel.strCategoryName = @"Milk Products";
                objCategoryModel.img = @"homePageBannerImageThree";
            }
                break;

            case 3:
            {
                objCategoryModel.strCategoryName = @"Check";
                objCategoryModel.img = @"homePageBannerImageTwo";
            }
                break;

            default:
                break;
        }
        [arrCategory addObject:objCategoryModel];
    }
    objCategoryVwController.arrCategory  = [[NSMutableArray alloc]init];
    [objCategoryVwController.arrCategory addObjectsFromArray:arrCategory];

    [self fillSubCategoryData];
    [tblVwCategory reloadData];
}
-(void)fillSubCategoryData
{
    for (int z=0; z<6; z++) {
        
        SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
        objSubCategoryModel.restaurantName = @"Smart Bazar";
        objSubCategoryModel.distance = @"13km";
        objSubCategoryModel.price = @"2times";
        objSubCategoryModel.strCategoryName = @"Chocolate & Sweets";
        
        switch (z) {
            case 0:
                objSubCategoryModel.img = @"imageOne";
                objSubCategoryModel.status = @"1";
                break;
        
            case 1:
                objSubCategoryModel.img = @"imageThree";
                objSubCategoryModel.status = @"1";
                break;

            case 2:
                objSubCategoryModel.img = @"imageOne";
                objSubCategoryModel.status = @"2";

                break;

            case 3:
                objSubCategoryModel.img = @"imageThree";
                objSubCategoryModel.status = @"1";

                break;

            case 4:
                objSubCategoryModel.img = @"imageOne";
                objSubCategoryModel.status = @"2";

                break;

            case 5:
                objSubCategoryModel.img = @"imageTwo";
                objSubCategoryModel.status = @"2";

                break;

            default:
                break;
        }
        [arrSubCategory addObject:objSubCategoryModel];
    }

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tblVwCategory reloadData];
}


#pragma mark Navigation

-(void)setUpNavigationView
{
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    [navView setCustomNavigationLeftArrowImageWithImageName:@"menuIcon.png"];
    [navView.btnRight2 setImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateNormal];

    [navView.btnRight1 setImage:[UIImage imageNamed:@"addToCartIcon.png"] forState:UIControlStateNormal];

     navView.delegate=self;
    [self.view addSubview:navView];
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.sideBar show];
}
-(void)customNavigationRightButtonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        
    }
    else if (sender.tag == 2)
    {
        
    }
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    rowsNum = arrSubCategory.count;
    return rowsNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    headerHeight = 234;
    return headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234)];
    secView.backgroundColor = [UIColor clearColor];
    [secView addSubview:objCategoryVwController.view];
    return secView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    rowHeight = 80.0;
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
        HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setRightUtilityButtons: [self leftButtons] WithButtonWidth:225];

    cell.selectedCategory = self.mainCategoryIndex;
    cell.delegate=self;
    cell.delegateHomeCell = self;
    SubCategoryModel *objSubCategory = [arrSubCategory objectAtIndex: indexPath.row];
    cell.objSubCategoryModel = objSubCategory;

    cell.indexPath=indexPath;
    [cell updateCellWithData:objSubCategory];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
    [self.navigationController pushViewController:homeSecondVwController animated:YES];
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

-(void)refreshSubCategoryData:(NSInteger)selectedCategory
{
    self.mainCategoryIndex = selectedCategory;
    [arrSubCategory removeAllObjects];
    [tblVwCategory reloadData];
    [self fillSubCategoryData];
    [tblVwCategory reloadData];

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
    switch (index) {
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chat"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shop"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }break;
            
    
            
            
        default:
            break;
    }
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
