//
//  AddHomeStoreViewController.m
//  AaramShop
//
//  Created by Riteshk Gupta on 03/04/17.
//  Copyright © 2017 Approutes. All rights reserved.
//

#import "AddHomeStoreViewController.h"
#import "HomeStoreViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface AddHomeStoreViewController (){
	NSArray *arr;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	NSUserDefaults *userDefaults;
	NSMutableArray *arrayOfName,*arrayOfImages;
    NSMutableArray *storeName,*storeImage,*storeArray;
    NSMutableDictionary *homeDict;
   // AddStoreTableViewCell *cell;
    NSInteger deleteIndex;
    BOOL showTable;
	NSString *storeId;
}

@end

@implementation AddHomeStoreViewController
@synthesize homeStoreLbl,addHomeStoreLbl;

- (void)viewDidLoad {
	[super viewDidLoad];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    //_tblView.hidden=YES;

	// Do any additional setup after loading the view.
	//_homeStoreLbl.textColor=[UIColor whiteColor];
	//homeStoreLbl.adjustsFontSizeToFitWidth=YES;
	//homeStoreLbl.backgroundColor=[UIColor clearColor];
	//self.tblView.delegate=self;
	//self.tblView.dataSource=self;
		appDel = APP_DELEGATE;
    //arr1=@[@"ju",@"huh",@"hef"];
    
    

    

    	//arr=@[@"adfg",@"wjhd"];
//	arrayOfName=[[NSMutableArray alloc]init];
//	arrayOfImages=[[NSMutableArray alloc]init];
//	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
//	aaramShop_ConnectionManager.delegate=self;
//	userDefaults = [NSUserDefaults standardUserDefaults];
//	arrayOfImages = [userDefaults objectForKey:@"store_name"];
//	arrayOfName = [userDefaults objectForKey:@"store_image"];
//	NSLog(@"user Defaault array %@ %@",arrayOfName,arrayOfImages);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	//[self.navigationController setNavigationBarHidden:YES];
	//[[self navigationController] setNavigationBarHidden:YES animated:YES];
	//_navigationView.backgroundColor=Rgb2UIColor(44, 44, 44);
	//_homeStoreLbl.text=@"Manage Home Store";
	//_homeStoreLbl.font=[UIFont fontWithName:kRobotoRegular size:15];
}
- (void)responseReceived:(id)responseObject
{
    //[self userInteraction:YES];
    [Utils stopActivityIndicatorInView:self.view];
    [AppManager stopStatusbarActivityIndicator];
    switch (aaramShop_ConnectionManager.currentTask) {
            
        case TASK_TO_GET_STORES:
        {
            
            if([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:kGet_store] forKey:kGet_store];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //[self parseData:[responseObject objectForKey:@"user_address"]];
                
                NSLog(@"response object %@",responseObject);
                NSLog(@"response object count is %lu",(unsigned long)[responseObject count]);
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
            storeName=[[NSMutableArray alloc]init];
            storeImage=[[NSMutableArray alloc]init];
            
            storeArray=[[NSMutableArray alloc]init];
            homeDict=[[NSMutableDictionary alloc]init];
            //for (int i=0; [responseObject count]; i++) {
            storeArray=[responseObject objectForKey:@"stores"];
            NSLog(@"Store Array is %@",storeArray);
            //			NSLog(@"dict %@",storeName);
            //			dict=[storeName objectAtIndex:0];
            //			NSLog(@"dict %@",dict);
            for (homeDict in storeArray ) {
                NSLog(@"Dictr %@",homeDict);
              //  for (NSInteger i=0; i<=[homeDict count]; i++) {
                    [storeName addObject:[homeDict objectForKey:@"store_name"]];
                    
                    [storeImage addObject:[homeDict objectForKey:@"store_image"]];
                    NSLog(@"Store Name %@",storeName);
				storeId=[homeDict objectForKey:@"store_id"];
				 NSLog(@"Store Id %@",storeId);
                //}
                }
            [_tblView reloadData];
            
        }
	
			break;
			///****
		case TASK_DELETE_STORE:
		{
			
			if ([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
				
				
				//AddressModel *addressListModel = [datasource objectAtIndex:deletedLocationListIndex];
				//AddressModel *addressListModel = [datasource objectAtIndex:deletedLocationListIndex];
				//[self removeShoppingListReminder:shoppingListModel.shoppingListId];
				
				[storeName removeObjectAtIndex:deleteIndex];
				[storeImage removeObjectAtIndex:deleteIndex];
				
				if (storeImage.count==0)
				{
					NSLog(@"Empty data in array");
				}
				
				[_tblView reloadData];
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
- (void)createDataToGetHomeStores
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
    int pageno = 0;
    
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
    
    
    //[self performSelector:@selector(callWebserviceToGetHomeStores:) withObject:dict];
    
    [aaramShop_ConnectionManager getDataForFunction:kGetHomeStoreURL withInput:dict withCurrentTask:TASK_TO_GET_STORES andDelegate:self];
    NSLog(@"Get User aDoct : %@",dict);
    NSLog(@"Dictionary Object count is %li",(unsigned long)[dict count]);

    [_tblView reloadData];

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
}

- (IBAction)backBtn:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self createDataToGetHomeStores];
	_tblView.hidden=NO;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)addHomeStoreBtn:(UIButton *)sender {
    //_tblView.hidden=NO;
    //[self createDataToGetHomeStores];
	HomeStoreViewController *homeStoreVwController = (HomeStoreViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeStoreScreen"];
	[self.navigationController pushViewController:homeStoreVwController animated:YES];
    
   // [_tblView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return storeName.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     AddStoreTableViewCell *cell1= [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    //UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell1 == nil)
    {
        cell1=[[AddStoreTableViewCell alloc]initWithFrame:CGRectZero];
    }
    //index=indexPath.row;
    
    NSLog(@"STore Name is %@",[storeName objectAtIndex:indexPath.row]);
  
    cell1.deleteStoreOut.tag=indexPath.row;
	cell1.indexPath1=indexPath;
	cell1.adelegate=self;
    
    //cell1.storeNameLbl.text=[storeName objectAtIndex:indexPath.row];

    
    //GCD Run
    //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[storeImage objectAtIndex:indexPath.row ]]];
    //GCD run the following line in between the above GCD in main thread
    //cell1.imageView.image = [UIImage imageWithData:imageData];
    //cell1.storeImgView.image=[UIImage imageWithData:imageData];
    //cell1.storeImgView.image=[UIImage imageWithData:imageData];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		// Download or get images here
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[storeImage objectAtIndex:indexPath.row ]]];
		UIImage *image=[[UIImage alloc]initWithData:imageData];
	 dispatch_async(dispatch_get_main_queue(), ^{
		 // Refresh image view here
		 cell1.storeImgView.image=image;
	 });
	});
	
	

//	dispatch_async(imageQueue_, ^{
//		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[storeImage objectAtIndex:indexPath.row ]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//			[[cell imageView] setImage:[UIImage imageWithData:imageData]];
//			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//		});
//							 });
	
	cell1.storeNameLbl.text=[storeName objectAtIndex:indexPath.row];
    return cell1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)deleteStoreList:(NSInteger)index{
    
    deleteIndex = index;
    //AddressModel *addressModel = [datasource objectAtIndex:deletedLocationListIndex];
    NSMutableDictionary *dic = [Utils setPredefindValueForWebservice];
    //NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    // [params setObject:address_id  forKey:kUser_address_id];
    //[dic setObject:addressModel.user_address_id forKey:@"user_address_id"];
	//StoreModel *objStore = [storeName objectAtIndex:deleteIndex];
	//[dic setObject:storeId forKey:@"store_Id"];
	[dic setObject:[NSString stringWithFormat:@"%@", storeId] forKey:kStore_id];
	NSLog(@"Store Dictionary Count %lu",(unsigned long)[dic count]);
    //[params setObject:userId  forKey:kUserId];
    
	
    //[params setObject:addressModel.user_address_id forKey:@"user_address_id"];
    
    [self callWebServiceToDeleteStoreList:dic];
	NSLog(@"Store Dictionary  %@",dic);
}
-(void)callWebServiceToDeleteStoreList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kDeleteHomeStoreURL withInput:aDict withCurrentTask:TASK_DELETE_STORE andDelegate:self ];
}




@end
