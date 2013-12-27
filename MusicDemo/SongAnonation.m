//
//  SongAnonation.m
//  MusicDemo
//
//  Created by 6006 on 13-11-29.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "SongAnonation.h"

@implementation SongAnonation
-(void)dealloc
{
    [_title release];
    [_subtitle release];
    [super dealloc];
}

@end
