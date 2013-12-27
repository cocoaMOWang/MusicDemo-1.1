//
//  Music.h
//  player
//
//  Created by 6006 on 13-10-23.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property(retain,nonatomic)NSString* musicName;
@property(retain,nonatomic)NSString* musicIcon;
@property(retain,nonatomic)NSString* singer;
@property(assign,nonatomic)int musicId;
-(id)initWithName:(NSString*)_musicName andIcon:(NSString*)_musicIcon andSinger:(NSString*)_singer;
@end
