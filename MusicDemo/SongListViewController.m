//
//  SongListViewController.m
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "SongListViewController.h"
#import "Music.h"
@interface SongListViewController ()

@end

@implementation SongListViewController
-(void)dealloc
{
    [_songsArray release];
    [_tableView release];
    [super dealloc];
}
-(void)setBlock:(Block_play)aBlock
{
    if (block_play!=aBlock) {
        Block_release(block_play);
        block_play = Block_copy(aBlock);
    }
    
   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTableView];
    
}
-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 480-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor cyanColor];
    [self.view addSubview:_tableView];

}
-(UITableViewCell*)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentity = @"cell";
    UITableViewCell* cell = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentity];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity]autorelease];
    }
    Music* songtemp = [_songsArray objectAtIndex:indexPath.row];
    cell.textLabel.text =songtemp.singer;
    cell.detailTextLabel.text =songtemp.musicName;
    cell.imageView.image = [UIImage imageNamed:songtemp.musicIcon];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _songsArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (block_play) {
        block_play([_songsArray objectAtIndex:indexPath.row]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
