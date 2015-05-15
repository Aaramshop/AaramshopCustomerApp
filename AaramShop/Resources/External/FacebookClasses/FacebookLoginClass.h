//
//  FacebookLoginClass.h
//  Namy
//
//  Created by APPROUTES on 16/12/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookLoginClass : NSObject
@property(nonatomic,retain)NSMutableDictionary *dictFacebookUserinfo;

-(void)facebookLoginMethod;
@end
