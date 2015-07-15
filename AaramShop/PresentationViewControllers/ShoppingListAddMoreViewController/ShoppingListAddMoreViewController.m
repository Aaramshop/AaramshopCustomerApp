//
//  ShoppingListAddMoreViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListAddMoreViewController.h"

#define kTableCellHeight    70


@interface ShoppingListAddMoreViewController ()

@end

@implementation ShoppingListAddMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrProductList = [[NSMutableArray alloc]init];
    [self setNavigationBar];
    
    tblView.backgroundColor = [UIColor whiteColor];
    
    [self initializeData];

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


-(void)initializeData
{
    NSDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"abkhazia",@"image",@"Product 1",@"name",@"0",@"quantity", nil];
    
    NSDictionary *dic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"adygea",@"image",@"Product 2",@"name",@"0",@"quantity", nil];
    
    NSDictionary *dic3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ajaria",@"image",@"Product 3",@"name",@"0",@"quantity", nil];
    
    NSDictionary *dic4 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"alderney",@"image",@"Product 4",@"name",@"0",@"quantity", nil];
    
    
    [arrProductList addObject:dic1];
    [arrProductList addObject:dic2];
    [arrProductList addObject:dic3];
    [arrProductList addObject:dic4];
    
    [arrProductList addObject:dic1];
    [arrProductList addObject:dic2];
    [arrProductList addObject:dic3];
    [arrProductList addObject:dic4];
    
    [arrProductList addObject:dic1];
    [arrProductList addObject:dic2];
    [arrProductList addObject:dic3];
    [arrProductList addObject:dic4];
    
    [arrProductList addObject:dic1];
    [arrProductList addObject:dic2];
    [arrProductList addObject:dic3];
    [arrProductList addObject:dic4];
    
    [arrProductList addObject:dic1];
    [arrProductList addObject:dic2];
    [arrProductList addObject:dic3];
    [arrProductList addObject:dic4];
    
    
    [tblView reloadData];
}



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
    titleView.text = @"Add more product";
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
    

    UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.bounds = CGRectMake( -10, 0, 50, 30);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imgDone forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnDone, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnDoneClicked
{

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
    return arrProductList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingListDetailCell";
    ShoppingListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ShoppingListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    [cell updateCell:[arrProductList objectAtIndex:indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
    int counter = [[[arrProductList objectAtIndex:indexPath.row] objectForKey:@"quantity"] intValue];
    
    counter++;
    
    [[arrProductList objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",counter] forKey:@"quantity"];
    
    
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)removeProduct:(NSIndexPath *)indexPath
{
    int counter = [[[arrProductList objectAtIndex:indexPath.row] objectForKey:@"quantity"] intValue];
    counter--;
    
    [[arrProductList objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",counter] forKey:@"quantity"];
    
    
    
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
