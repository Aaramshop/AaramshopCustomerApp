//
//  CMOrderHist.h
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMOrderHist : NSObject

//{
//	"customer_id": "26",
//	"store_id": "9227",
//	"store_name": "cba",
//	"store_mobile": "3435454665",
//	"store_address": "asjksdlkj",
//	"store_locality": "jlljasjlsad23948",
//	"store_city": "jlasljlasd",
//	"store_state": "jlksadjlk",
//	"store_pincode": "894298424",
//	"store_latitude": "0.000000",
//	"store_longitude": "0.000000",
//	"store_image": "http://52.74.220.25/uploaded_files/aaramshop/320x320/C1435565650.png",
//	"customer_image": "http://52.74.220.25/uploaded_files/user/320x320/J1435653015.png",
//	"customer_name": "Joy Sharma",
//	"customer_latitude": "0.000000",
//	"customer_longitude": "0.000000",
//	"customer_addresss": "gfg",
//	"product_pending": 0,
//	"customer_locality": "gh",
//	"customer_city": "bn",
//	"customer_state": "b",
//	"customer_pincode": "654545",
//	"quantity": 3,
//	"total_cart_value": "102.00",
//	"delivery_time": 1435642200,
//	"order_time": 1435658370,
//	"order_id": "19",
//	"customer_mobile": "9999614234",
//	"delivery_status": "Packed",
//	"delivery_slot": "10AM to 11AM",
//	"udhaar_value": "0.00",
//	"payment_mode": "Cash on Delivery",
//	"store_chatUserName": "14355656504013",
//	"store_email": "cba@gmail.com",
//	"deliveryboy_name": "",
//	"deliveryboy_mobile": "",
//	"packed_timing": 1234548090,
//	"dispached_timing": 0,
//	"delivered_timing": 0,
//	"isDispached": 0,
//	"isPacked": 1
//}

//@property (nonatomic,strong) NSString *customer_id;
////@property (nonatomic,strong) NSString *chat_username;
//@property (nonatomic,strong) NSString *store_id;
//@property (nonatomic,strong) NSString *store_name;
//@property (nonatomic,strong) NSString *store_mobile;
//@property (nonatomic,strong) NSString *store_address;
//@property (nonatomic,strong) NSString *store_locality;
//@property (nonatomic,strong) NSString *store_city;
//@property (nonatomic,strong) NSString *store_state;
//@property (nonatomic,strong) NSString *store_pincode;
//@property (nonatomic,strong) NSString *store_latitude;
//@property (nonatomic,strong) NSString *store_longitude;
//@property (nonatomic,strong) NSString *store_image;
//@property (nonatomic,strong) NSString *quantity;
//@property (nonatomic,strong) NSString *total_cart_value;
//@property (nonatomic,strong) NSString *delivery_time;
//@property (nonatomic,strong) NSString *order_time;
//@property (nonatomic,strong) NSString *order_date;
//@property (nonatomic,strong) NSString *order_id;
//@property (nonatomic,strong) NSString *customer_mobile;
//@property (nonatomic,strong) NSString *delivery_status;
//@property (nonatomic,strong) NSString *delivery_slot;
//@property (nonatomic,strong) NSString *payment_mode;
//@property (nonatomic,strong) NSString *store_chatUserName;
//@property (nonatomic,strong) NSString *store_email;
//@property (nonatomic,strong) NSString *packed_timing;
//@property (nonatomic,strong) NSString *dispached_timing;
//@property (nonatomic,strong) NSString *delivered_timing;
//@property (nonatomic,strong) NSString *customer_latitude;
//@property (nonatomic,strong) NSString *customer_longitude;
//@property (nonatomic,strong) NSString *deliveryboy_name;

//@end

@property (nonatomic,strong) NSString *customer_addresss;
@property (nonatomic,strong) NSString *customer_city;
@property (nonatomic,strong) NSString *customer_id;
@property (nonatomic,strong) NSString *customer_image;
@property (nonatomic,strong) NSString *customer_latitude;
@property (nonatomic,strong) NSString *customer_locality;
@property (nonatomic,strong) NSString *customer_longitude;
@property (nonatomic,strong) NSString *customer_name;
@property (nonatomic,strong) NSString *customer_pincode;
@property (nonatomic,strong) NSString *customer_state;
@property (nonatomic,strong) NSString *delivered_timing;
@property (nonatomic,strong) NSString *delivery_slot;
@property (nonatomic,strong) NSString *delivery_status;
@property (nonatomic,strong) NSString *delivery_time;
@property (nonatomic,strong) NSString *deliveryboy_mobile;
@property (nonatomic,strong) NSString *deliveryboy_name;
@property (nonatomic,strong) NSString *dispached_timing;
@property (nonatomic,strong) NSString *isDispached;
@property (nonatomic,strong) NSString *isPacked;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *order_time;
@property (nonatomic,strong) NSString *packed_timing;
@property (nonatomic,strong) NSString *payment_mode;
@property (nonatomic,strong) NSString *product_pending;
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *store_address;
@property (nonatomic,strong) NSString *store_chatUserName;
@property (nonatomic,strong) NSString *store_city;
@property (nonatomic,strong) NSString *store_email;
@property (nonatomic,strong) NSString *store_id;
@property (nonatomic,strong) NSString *store_image;
@property (nonatomic,strong) NSString *store_latitude;
@property (nonatomic,strong) NSString *store_locality;
@property (nonatomic,strong) NSString *store_longitude;
@property (nonatomic,strong) NSString *store_mobile;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *store_pincode;
@property (nonatomic,strong) NSString *store_state;
@property (nonatomic,strong) NSString *total_cart_value;
@property (nonatomic,strong) NSString *total_udhaar;
@property (nonatomic,strong) NSString *udhaar_value;

@property (nonatomic,strong) NSString *order_date;

@end

