//
//  ViewController.h
//  kcg
//
//  Created by Lee, Chia-Pei on 2015/9/3.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

static NSString *annotationViewReuseIdentifier      = @"annotationViewReuseIdentifier";
static NSString *CurrentLocation                    = @"Current Location";

/*
country:新北市,id:65000
country:臺北市,id:63000
country:桃園縣,id:10003
country:臺中市,id:66000
country:臺南市,id:67000
country:高雄市,id:64000
*/
/*
country:基隆市,id:10017
country:新竹縣,id:10004
country:新竹市,id:10018
country:苗栗縣,id:10005
country:彰化縣,id:10007
country:南投縣,id:10008
country:雲林縣,id:10009
country:嘉義縣,id:10010
country:嘉義市,id:10020
country:屏東縣,id:10013
country:宜蘭縣,id:10002
country:花蓮縣,id:10015
country:臺東縣,id:10014
country:澎湖縣,id:10016
country:連江縣,id:09007
country:金門縣,id:09020
*/

@interface MapViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    IBOutlet MKMapView      *thisMap;
    IBOutlet UITableView    *thisTableView;
    IBOutlet UIButton       *bChoose;
    NSDictionary            *dAllTaiwan;
    NSMutableArray          *allPoint;
    
    NSMutableArray          *tableArray;
}

-(IBAction)bChoose_Action:(id)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

