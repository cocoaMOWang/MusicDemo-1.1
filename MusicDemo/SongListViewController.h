//
//  SongListViewController.h
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;
typedef void (^Block_play)(Music* song);
@interface SongListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    Block_play block_play;
}
@property(retain,nonatomic)NSArray* songsArray;
@property(retain,nonatomic)UITableView* tableView;

-(void)setBlock:(Block_play)aBlock;
@end
