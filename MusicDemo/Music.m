//
//  Music.m
//  player
//
//  Created by 6006 on 13-10-23.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "Music.h"

@implementation Music

@synthesize musicIcon,musicName,singer;
-(id)initWithName:(NSString*)_musicName andIcon:(NSString*)_musicIcon andSinger:(NSString*)_singer
{
    self = [super init];
    if (self) {
        self.musicName = _musicName;
        self.musicIcon = _musicIcon;
        self.singer = _singer;
    }
    return self;
}
@end
