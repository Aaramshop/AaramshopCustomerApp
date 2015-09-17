//
//  PaymentModeViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentModeViewController.h"

@interface PaymentModeViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation PaymentModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    [self setUpNavigationBar];
    [tblView reloadData];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"PaymentMode"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getPaymentModes];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    titleView.text = @"Accepted Payment Mode";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
}
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return arrPaymentMode.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else
        return 48;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 48)];
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(16, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 32, 21)];
    lblName.text = @"Choose Payment mode";
    
    [secView addSubview:lblName];
    return secView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"AmountCell";
            TotalAmtTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[TotalAmtTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.indexPath = indexPath;
            
            tableCell = cell;
        }
            break;
            case 1:
        {
            static NSString *cellIdentifier = @"PaymentCell";
            PaymentModeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[PaymentModeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            CMPaymentMode *cmPayment = [arrPaymentMode objectAtIndex:indexPath.row];

            cell.indexPath = indexPath;

            [cell updatePaymentModeCell:cmPayment];
            tableCell = cell;

        }
            break;
            
        default:
            break;
    }
    return tableCell;
}

#pragma mark - Web service Methods
- (void)getPaymentModes
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
//    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
    //    [dict setObject:@"3" forKey:kStore_id];
    
    [self performSelector:@selector(callWebServiceToGetPaymentMode:) withObject:dict afterDelay:0.1];
}
-(void)callWebServiceToGetPaymentMode:(NSMutableDictionary *)aDic
{
    if (![Utils isInternetAvailable])
    {
        //        [Utils stopActivityIndicatorInView:self.view];
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kPaymentModeURL withInput:aDic withCurrentTask:TASK_USER_PAYMENTMODE andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_USER_PAYMENTMODE)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [self parseData:[responseObject objectForKey:kPayment_modes]];
        }
    }
}
- (void)didFailWithError:(NSError *)error
{
    //    [Utils stopActivityIndicatorInView:self.view];
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - Parsing Data
- (void)parseData:(id)data
{
    if (!arrPaymentMode) {
        arrPaymentMode = [[NSMutableArray alloc] init];
    }
    [arrPaymentMode removeAllObjects];
    if([data count]>0)
    {
        
        for(int i =0 ; i < [data count] ; i++)
        {
            NSDictionary *dict = [data objectAtIndex:i];
            CMPaymentMode *mode = [[CMPaymentMode alloc] init];
            mode.mode_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kPaymentMode_Id]];
            mode.name = [NSString stringWithFormat:@"%@",[dict objectForKey:kPaymentMode_Name]];
            [arrPaymentMode addObject:mode];
        }
        [tblView reloadData];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
