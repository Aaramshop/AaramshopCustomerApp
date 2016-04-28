//
//  CMPayment.h
//  AaramShop
//
//  Created by AppRoutes on 22/04/16.
//  Copyright © 2016 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPayment : NSObject

//+(CMPayment*) cmpayment;

//@property (strong, nonatomic)NSString *totalAmount;
//@property (strong, nonatomic)NSString *total_discount;
//@property (strong, nonatomic)NSString *payment_mode_id;
//@property (strong, nonatomic)NSString *product_prices;
//@property (strong, nonatomic)NSString *product_qtys;
//@property (strong, nonatomic)NSString *store_id;
//@property (strong, nonatomic)NSString *userId;
//
//@property (strong, nonatomic)NSString *deviceId;
//
//@property (strong, nonatomic)NSString *ip_address;
//
//@property (strong, nonatomic)NSString *product_sku_ids;
//@property (strong, nonatomic)NSString *delivery_date;
@property (strong,nonatomic)NSMutableDictionary *pamentDataDic;


//
//-(CMPayment*)dataDictionary:(NSMutableDictionary*)dic;


@end
