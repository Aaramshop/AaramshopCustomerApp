//
//  CMPayment.m
//  AaramShop
//
//  Created by AppRoutes on 22/04/16.
//  Copyright © 2016 Approutes. All rights reserved.
//

#import "CMPayment.h"

@implementation CMPayment

//-(CMPayment*)dataDictionary:(NSMutableDictionary*)dic
//{
//    CMPayment* cmPayment=[[CMPayment alloc]init];
//    cmPayment.pamentDataDic=dic;
//    return cmPayment;
//}


//+(CMPayment *) cmpayment
//{
//    @synchronized (self) {
//        if(cmpayment == nil)
//        {
//            cmpayment=[[CMPayment alloc]init];
//        }
//    }
//}
-(NSMutableDictionary*)pamentDataDic
{
    if(_pamentDataDic==nil)
    {
        _pamentDataDic=[[NSMutableDictionary alloc]init];
        
    }
    return _pamentDataDic;
}
@end
