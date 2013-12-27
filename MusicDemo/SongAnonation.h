//
//  SongAnonation.h
//  MusicDemo
//
//  Created by 6006 on 13-11-29.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface SongAnonation :NSObject<MKAnnotation>
//@property(retain,nonatomic)UIButton* leftBtn;
//@property(retain,nonatomic)UIButton* rightBtn;
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* subtitle;
@property(assign,nonatomic)CLLocationCoordinate2D coordinate;
@end
