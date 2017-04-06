//
//  HomeCategoryListCell.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoryListCell.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "StoreModel.h"
#import "HomeCategoriesViewController.h"
@implementation HomeCategoryListCell
@synthesize indexPath,selectedCategory,isRecommendedStore,aaramShop_ConnectionManager,strStore_Id;

- (void)awakeFromNib
{
    // Initialization code
    appDeleg=APP_DELEGATE;
     
    imgStore.layer.cornerRadius = imgStore.frame.size.width/2.0;
    imgStore.clipsToBounds=YES;
    
    imgHomeIcon.image = [UIImage imageNamed:@"homeScreenHomeIconRed"];
    
    UIImage *imgStarIcon = [UIImage imageNamed:@"starIconInactive"];
    imgRating1.image = imgStarIcon;
    imgRating2.image = imgStarIcon;
    imgRating3.image = imgStarIcon;
    imgRating4.image = imgStarIcon;
    imgRating5.image = imgStarIcon;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self makeFav];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    //[self getStoreId];
    appDeleg = APP_DELEGATE;
    //home.strStore_Id = _objStoreModel.store_id;
    //StoreModel *objStore1 = [[StoreModel alloc]init];
    //objStore1.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)updateCellWithData:(StoreModel*)objStoreData
{
    
    if ([objStoreData.is_home_store isEqualToString:@"1"])
    {
        imgHomeIcon.hidden = NO;
    }
    else
        imgHomeIcon.hidden = YES;
    
    
    NSString *strStoreCategoryIcon = [NSString stringWithFormat:@"%@",objStoreData.store_category_icon];
    NSURL *urlStoreCategoryIcon = [NSURL URLWithString:strStoreCategoryIcon];
    
    [imgCategoryTypeIcon sd_setImageWithURL:urlStoreCategoryIcon placeholderImage:[UIImage imageNamed:@"homeChocklateIcon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    
    ////
    NSString *strStoreImage = [NSString stringWithFormat:@"%@",objStoreData.store_image];
    NSURL *urlStoreImage = [NSURL URLWithString:strStoreImage];
    
    [imgStore sd_setImageWithURL:urlStoreImage placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    
    ////
    lblCategoryName.text =objStoreData.store_category_name;
    
    
    ////
    if ([objStoreData.is_open isEqualToString:@"1"])
    {
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconOpen.png"];
    }
    else
    {
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconClose.png"];
        
    }
    
    
    ////
    lblStoreName.text =objStoreData.store_name;
    
    
    ////
    // rating images ...
    if ([objStoreData.store_rating integerValue]>0)
    {
        //        viewRating.hidden = NO;
        
        UIImage *imgStarIcon = [UIImage imageNamed:@"homeStarRedIcon"];
        
        switch ([objStoreData.store_rating integerValue])
        {
            case 1:
            {
                imgRating1.image = imgStarIcon;
                
            }
                break;
            case 2:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                
            }
                break;
            case 3:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                
            }
                break;
            case 4:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                imgRating4.image = imgStarIcon;
                
            }
                break;
            case 5:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                imgRating4.image = imgStarIcon;
                imgRating5.image = imgStarIcon;
                
            }
                break;
                
            default:
                break;
        }
    }    ////
    
    
    ////
    [btnDistance setTitle:objStoreData.store_distance forState:UIControlStateNormal];
    
    
    
    ////
    if ([objStoreData.home_delivey isEqualToString:@"1"]) {
        [btnDeliveryType setHidden:NO];
    }
    else
    {
        [btnDeliveryType setHidden:YES];
    }
    
    
    ////
    if ([objStoreData.total_orders isEqualToString:@"0"]) {
        
        [btnTotalOrders setHidden:YES];
    }
    else
    {
        [btnTotalOrders setHidden:NO];
        
        [btnTotalOrders setTitle:[NSString stringWithFormat:@"%@ Times",objStoreData.total_orders] forState:UIControlStateNormal];
    }
    
    
    if ([objStoreData.is_favorite isEqualToString:@"1"])
    {
        _imgIsFavourite.image = [UIImage imageNamed:@"favourateIcon"];
      
        
    }
    else
    {
        _imgIsFavourite.image = [UIImage imageNamed:@"homeStarIconInactive"];
        //NSLog(@"jojjo");
    }
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hideUtilityButtonsAnimated:YES];
}


-(void)makeFav
{
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
	singleTap.numberOfTapsRequired = 1;
	[_imgIsFavourite setUserInteractionEnabled:YES];
	[_imgIsFavourite addGestureRecognizer:singleTap];
	
	
}

-(void)tapDetected
{
	NSLog(@"single Tap on imageview");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
													message:@"Do you Want to set Store as a favourate?"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Yes", nil];
	
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [alertView cancelButtonIndex])
    {
		
	}
    else
    {
		//[Utils stopActivityIndicatorInView:self.view];
		[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
		//[Utils stopActivityIndicatorInView:self.view];
		//[Utils startActivityIndicatorInView:self.view withMessage:nil];
		if([Utils isInternetAvailable])
		{
			
			if (self.delegates && [self.delegates conformsToProtocol:@protocol(MakeFavouriteDelegate)] && [self.delegates respondsToSelector:@selector(makeStoreFovourite:)])
			{
				
				[self.delegates makeStoreFovourite:indexPath.row];
				
			}

			
			NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
			[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
			//[dict setObject:appDeleg.objStoreModel.store_id forKey:kStore_id];
			//[dict setObject:strStore_Id forKey:kStore_id];
			//NSLog(@"storeid : %@",[dict objectForKey:kStore_id]);
			//			NSString *strid=    appDeleg.objStoreModel.store_id;
			//			NSLog(@"storeid : %@",strid);
			
			
			[aaramShop_ConnectionManager getDataForFunction:kURLMakeFavorite withInput:dict withCurrentTask:TASK_TO_MAK_FAVORITE andDelegate:self];
		}
		else
		{
			[AppManager stopStatusbarActivityIndicator];
			
			[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			return;
			
		}
		
	}
}


/*
 if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationListCellDelegate)] && [self.delegate respondsToSelector:@selector(deleteLocationList:)])
 {
 [self.delegate deleteLocationList:_indexPath.row];
 
 }
 
*/
@end
