//
//  AaramShop_ConnectionManager.h
//  AaramShop
//
//  Created by Approutes on 17/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum
{
	TASK_LOGIN,
	TASK_ENTER_MOBILE_NUMBER,
	TASK_ENTER_LOCATION,
	TASK_VERIFY_MOBILE,
	TASK_RESEND_OTP,
	TASK_FORGOT_PASSWORD,
	TASK_UPDATE_ADDRESS,
	TASK_TO_GET_HOME_STORE_BANNER,
	TASK_TO_GET_HOME_STORE,
	TASK_TO_GET_HOME_STORE_DETAILS,
	TASK_TO_MAKE_HOME_STORE,
	TASK_TO_GET_STORES,
	TASK_TO_GET_STORES_FROM_CATEGORIES_ID,
	TASK_TO_GET_STORES_PAGINATION,
	TASK_GET_STORE_PRODUCT_CATEGORIES,
	TASK_GET_STORE_PRODUCT_SUB_CATEGORIES,
	TASK_GET_PAYMENT_PAGE_DATA,
	TASK_SEARCH_STORE_PRODUCT_CATEGORY,
	TASK_GET_STORE_PRODUCTS,
	TASK_TO_GET_ORDER_HISTORY,
	TASK_GET_DELIVERY_SLOTS,
	TASK_CHECKOUT,
	TASK_USER_PAYMENTMODE,
	TASK_GET_USER_ADDRESS,
	TASK_TO_GET_OFFERS,
	TASK_TO_CHANGE_PASSWORD,
	TASK_TO_SEND_ORDER_STATUS,
	TASK_TO_UPDATE_USER,
	TASK_TO_SEARCH_STORE_PRODUCTS,
	TASK_TO_CREATE_SHOPPING_LIST,
	TASK_TO_GET_PREFERENCES,
	TASK_TO_GET_USER_ADDRESS,
	TASK_TO_GET_SHOPPING_LIST,
	TASK_TO_DELETE_SHOPPING_LIST,
	TASK_TO_GET_SHOPPING_LIST_PRODUCTS,
	TASK_TO_UPDATE_SHOPPING_LIST,
	TASK_TO_GET_SHOPPING_STORE_LIST,
	TASK_TO_SET_SHOPPING_LIST_REMINDER,
	TASK_GET_WALLET,
	TASK_GET_WALLET_POINTS,
	TASK_TO_GET_AARAM_POINTS,
	TASK_TO_GET_BONUS_POINTS,
	TASK_TO_GET_BRAND_POINTS,
	TASK_TO_GET_MONEY,
	TASK_TO_GET_SHOPPING_LIST_PRODUCTS_FROM_SELECTED_STORE,
	TASK_TO_GET_BROADCAST,
	TASK_TO_GET_COUPONS,
	TASK_TO_SEARCH_HOME_STORE,
	TASK_TO_MAK_FAVORITE,
	TASK_GET_MINIMUM_ORDER_VALUE,
	TASK_VALIDATE_COUPON,
	TASK_TO_SHARE_SHOPPING_LIST,
	TASK_TO_GET_SHOPPING_LIST_SHARE_WITH,
	TASK_TO_GET_WALLET_OFFER,
	TASK_TO_SAVE_PREFERENCES,
	TASK_GET_COMBO_DETAILS,
	TASK_TO_GET_GLOBAL_SEARCH_RESULT,
    TASK_TO_SEND_USER_REVIEW,
    TASK_TO_REMOVE_SHOPPING_LIST_REMINDER,
	TASK_GET_FB_FRIENDS,
	TASK_TO_LOGOUT,
    TASK_GET_ORDER_DETAIL,
    TASK_TO_SEARCH_HOME_STORE_PRODUCTS,
    TASK_TO_UPDATE_PRODUCT_FROM_ORDER_ID,
    TASK_TO_REORDER_PRODUCTS,
	TASK_JIOMONEY_ORDERCOMPLETE,
    TASK_DELETE_ADDRESS,
	TASK_DELETE_STORE,
	TASK_TO_MAK_STORE_FAVORITE,
    
}CURRENT_TASK;

@protocol AaramShop_ConnectionManager_Delegate <NSObject>

@optional
-(void) didFailWithError:(NSError *)error;
-(void) responseReceived:(id)responseObject;

@end
@interface AaramShop_ConnectionManager : NSObject
{
	CURRENT_TASK currentTask;
	NSURLSessionDataTask* task;
}
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic,assign) CURRENT_TASK currentTask;
@property(nonatomic,weak) id<AaramShop_ConnectionManager_Delegate> delegate;

-(BOOL) getDataForFunction : (NSString *) functionName withInput: (NSMutableDictionary *) aDict withCurrentTask : (CURRENT_TASK) inputTask andDelegate : (id)inputDelegate;

-(BOOL) getDataForFunction:(NSString *)functionName withInput:(NSMutableDictionary *)aDict withCurrentTask:(CURRENT_TASK)inputTask Delegate:(id)inputDelegate andMultipartData:(NSData *)data withMediaKey:(NSString *)imageKey;

-(void)failureBlockCalled:(NSError *)error;

@end
