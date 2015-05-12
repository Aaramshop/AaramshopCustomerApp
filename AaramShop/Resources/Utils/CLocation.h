//
//  CLocation.h
//  SocialParty
//
//  Created by Shakir Approutes on 03/06/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CLocation : NSObject
@property(nonatomic,assign)CLLocationCoordinate2D Coordinates;
@property(nonatomic,strong)NSString * LocationName;
@property(nonatomic,strong)NSString * UserName;
@property(nonatomic,assign) BOOL isSelf ;


@end
