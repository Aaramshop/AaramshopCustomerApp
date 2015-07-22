//
//  CreateNewShoppingListViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CreateNewShoppingListViewController.h"

#define kTableCellHeight    70


@interface CreateNewShoppingListViewController ()

@end

@implementation CreateNewShoppingListViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = APP_DELEGATE;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrProductList = [[NSMutableArray alloc]init];
    [self setNavigationBar];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;

    
    tblView.backgroundColor = [UIColor whiteColor];
    txtShoppingListName.layer.cornerRadius = 5.0;
    txtShoppingListName.clipsToBounds = YES;
    txtShoppingListName.layer.borderColor = [UIColor grayColor].CGColor;
    txtShoppingListName.layer.borderWidth = 0.6;
    
    txtShoppingListName.textAlignment = NSTextAlignmentCenter;
    txtShoppingListName.returnKeyType = UIReturnKeyDone;


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
    titleView.text = @"Create Shopping List";
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
    [self.view endEditing:YES];
    
   __block NSString *strProductID = @"";
   __block NSString *strQuantity = @"";
    
    
    [arrProductList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ProductsModel *productModel = [arrProductList objectAtIndex:idx];
        if ([productModel.quantity integerValue]>0)
        {
            strProductID = [NSString stringWithFormat:@"%@,%@",strProductID,productModel.product_id];
            
            strQuantity = [NSString stringWithFormat:@"%@,%@",strQuantity,productModel.quantity];
        }
    }];
    
    if ([strProductID hasPrefix:@","])
    {
        strProductID = [strProductID substringFromIndex:1];
    }
    
    if ([strQuantity hasPrefix:@","])
    {
        strQuantity = [strQuantity substringFromIndex:1];
    }
    
    
    
    
    if ([txtShoppingListName.text length]==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Enter Shopping List Title" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    else if ([strProductID length]==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Add Product(s)" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    else
    {
        NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
        
        [dict setObject:txtShoppingListName.text forKey:@"shoppingListName"];
        
        [dict setObject:strProductID forKey:@"productId"];
        [dict setObject:strQuantity forKey:@"quantity"];
        
        [self callWebServiceToCreateShoppingList:dict];
    }
    
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
    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];
    
    int counter = [productModel.quantity intValue];
    
    counter++;
    
    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)removeProduct:(NSIndexPath *)indexPath
{
    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];

    int counter = [productModel.quantity intValue];
    counter--;
    
    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}





#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    txtShoppingListName.text = textField.text;
    
    txtShoppingListName.text = [txtShoppingListName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Call Webservice

-(void)callWebServiceToCreateShoppingList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLCreateShoppingList withInput:aDict withCurrentTask:TASK_TO_CREATE_SHOPPING_LIST andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void) responseReceived:(id)responseObject
{
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_CREATE_SHOPPING_LIST:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
        }
            break;
            
        default:
            break;
    }
    
}


-(void)doSearch
{
    searchViewController = (SearchViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController" ];
    [searchViewController setDelegate:self];
    
    [appDel.window addSubview:searchViewController.view];
    
}

-(void)removeSearchViewFromParentView{
    [searchViewController.view removeFromSuperview];
}





-(void)openSearchedUserPrroductFor:(ProductsModel *)product
{
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"product_sku_id like[cd]  %@",product.product_sku_id];
    
    NSArray *aFilteredObjects = [arrProductList filteredArrayUsingPredicate: aPredicate];
    
    if (aFilteredObjects && aFilteredObjects.count > 0) {
        //already exist
        [Utils showAlertView:kAlertTitle message:@"This Product is already being added " delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else{
        //add new product
        
        product.quantity = @"1";
        
        [arrProductList insertObject:product atIndex:0];
        
    }
    
    [tblView reloadData];
    
}


-(void)addProductIfNeeded:(NSDictionary *)inDic{
    
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"product_sku_id like[cd]  %@",[inDic objectForKey: @"product_sku_id"]];
    
    NSArray *aFilteredObjects = [arrProductList filteredArrayUsingPredicate: aPredicate];
    
    if (aFilteredObjects && aFilteredObjects.count > 0) {
        //already exist
        [Utils showAlertView:kAlertTitle message:@"This Product is already being added " delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else{
        //add new product
        [arrProductList insertObject:inDic atIndex:0];

    }
    
    [tblView reloadData];
    
}


-(IBAction)actionSearch:(id)sender
{
    [self doSearch];
}

@end
