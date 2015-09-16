//
//  Global.h
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/4/21.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#ifndef shennong_produce_Global_h
#define shennong_produce_Global_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <Mapkit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "httpEX.h"
#import "jsonEX.h"

//IOS Version
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//UI IPAD,IPHONE
#define UI_IS_IPAD      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//IPHONE
#define IPHONE4_SCREEN_WIDTH    320
#define UI_IS_IPHONE4   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations

#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width

//Map
static CLLocationCoordinate2D TaiwanCenter          = {23.5832,120.5825};
static CLLocationCoordinate2D KcgR16                = {22.68801596,120.3095473};
static MKCoordinateSpan AllMap                      = {3.50f, 3.50f};
//static MKCoordinateSpan NearbyMap                   = {0.005f, 0.005f};
static MKCoordinateSpan NearbyMap                   = {0.2f, 0.2f};
static double dbShortDistance                       = 30.0;

//static NSString *sIconRed       = @"Circle_Red.png";
//static NSString *sIconOrange    = @"Circle_Orange.png";

static NSString *cOK                    = @"確定";

@interface Global: NSObject
{
    NSMutableDictionary *dGlobal;
}

@property NSMutableDictionary *dGlobal;
-(void)createData;
@end

#endif
