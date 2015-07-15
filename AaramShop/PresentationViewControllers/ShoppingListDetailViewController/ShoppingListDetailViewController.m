//
//  ShoppingListDetailViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListDetailViewController.h"
#import "ShoppingListAddMoreViewController.h"

#define kTableHeader1Height    40
#define kTableHeader2Height    70
#define kTableHeader2ButtonWidhtHeight   44
#define kTableCellHeight    70


@interface ShoppingListDetailViewController ()

@end

@implementation ShoppingListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrProductList = [[NSMutableArray alloc]init];
    [self setNavigationBar];
    
    tblView.backgroundColor = [UIColor whiteColor];
    
    isStoreSelected = NO; // temp

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
    titleView.text = @"Monthly family grocery"; //temp
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
    
    UIImage *imgCopy = [UIImage imageNamed:@"copyIcon.png"];
    UIButton *btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCopy.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnCopy setImage:imgCopy forState:UIControlStateNormal];
    [btnCopy addTarget:self action:@selector(btnCopyClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnCopy = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
    
    //
    UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnSearch setImage:imgSearch forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
//    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnSearch,barBtnCopy, nil];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnSearch, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnCopyClicked
{
    
}

-(void)btnSearchClicked
{
    
}




#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isStoreSelected==YES)
    {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (isStoreSelected==YES)
            {
                return kTableHeader1Height;
            }
            else
            {
                return kTableHeader2Height;
            }
        }
            break;
        case 1:
        {
            return kTableHeader2Height;
        }
            break;
            
        default:
            return CGFLOAT_MIN;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (isStoreSelected==YES)
            {
                return [self viewForHeader1];
            }
            else
            {
                return [self viewForHeader2];
            }
        }
            break;
        case 1:
        {
            return [self viewForHeader2];
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;//arrProductList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
//    static NSString *CellIdentifier = @"shopppingListCell";
//    ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if(cell == nil)
//    {
//        cell = [[ShoppingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    //	cell.indexPath = indexPath;
//    //	cell.delegateFoodList = self;
//    //
//    //	[cell updateFoodListCell:arrProductsModel];
//    
//    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Design for Table Header View
-(UIView *)viewForHeader1
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableHeader1Height)];
    
    //
    UILabel *lblTotalAmount = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, view.frame.size.height)];
    lblTotalAmount.font = [UIFont fontWithName:kRobotoRegular size:14];
    lblTotalAmount.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    lblTotalAmount.text = @"Total Amount";
    
    
    
    //
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40), 0, 40, 40);
    btnDone.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    [btnDone setImage:[UIImage imageNamed:@"shoppingListSideArrow"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    NSString *strRupee = @"\u20B9";
    NSString *strAmount = @"1500";
    
    //
    UILabel *lblTotalAmountValue = [[UILabel alloc]initWithFrame:CGRectMake((btnDone.frame.origin.x - 120), 0, 100, view.frame.size.height)];
    lblTotalAmountValue.font = [UIFont fontWithName:kRobotoBold size:16];
    lblTotalAmountValue.textColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
    lblTotalAmountValue.textAlignment = NSTextAlignmentRight;
    lblTotalAmountValue.text = [NSString stringWithFormat:@"%@ %@",strRupee,strAmount];
    
    

    [view addSubview:lblTotalAmount];
    [view addSubview:lblTotalAmountValue];
    [view addSubview:btnDone];
    
    return view;
}

-(UIView *)viewForHeader2
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableHeader2Height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    imgBackground.image = [UIImage imageNamed:@"shoppingListCoverImage.png"];
    
    
    double button_Y = (view.frame.size.height - kTableHeader2ButtonWidhtHeight)/2;
    
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(30, button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnShare setImage:[UIImage imageNamed:@"shoppingListShareCircle"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(btnShareClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake((view.frame.size.width - kTableHeader2ButtonWidhtHeight)/2, button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnAdd setImage:[UIImage imageNamed:@"shoppingListAddCircle"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnCalender = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCalender.frame = CGRectMake((view.frame.size.width - (kTableHeader2ButtonWidhtHeight + 30)), button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnCalender setImage:[UIImage imageNamed:@"shoppingListCalenderCircle"] forState:UIControlStateNormal];
    [btnCalender addTarget:self action:@selector(btnCalenderClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:imgBackground];
    
    [view addSubview:btnShare];
    [view addSubview:btnAdd];
    [view addSubview:btnCalender];
    
    
    return view;

}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}





#pragma mark - Button Methods

-(void)btnDoneClicked
{
    
}

-(void)btnShareClicked
{
    
}

-(void)btnAddClicked
{
    ShoppingListAddMoreViewController *shoppingListAddMore = (ShoppingListAddMoreViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListAddMore"];
    
    [self.navigationController pushViewController:shoppingListAddMore animated:YES];
}

-(void)btnCalenderClicked
{
    [Utils showAlertView:kAlertTitle message:@"Do you want to set automatic purchase of this list?" delegate:self cancelButtonTitle:kAlertBtnNO otherButtonTitles:kAlertBtnYES];
}

-(IBAction)actionChooseStore:(id)sender
{
    
}


#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        // navigate to calender screen.
    }
}

@end
