//
//  ViewController.m
//  DemoApp
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import "ViewController.h"
#import "JRNLocalNotificationCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ( [self.tableView respondsToSelector:@selector(registerClass:forCellReuseIdentifier:)] ) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalNotification:)
                                                 name:JRNApplicationDidReceiveLocalNotification
                                               object:nil];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILocalNotification *)localNotificationAtIndexPath:(NSIndexPath *)indexPath
{
    return [[JRNLocalNotificationCenter defaultCenter] localNotifications][indexPath.row];
}

#pragma mark -
#pragma mark - Action

- (IBAction)editButtonTapped:(id)sender
{
    [self setEditing:!self.editing animated:YES];
}

- (IBAction)addButtonTapped:(id)sender
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:30.0]
                                                            forKey:@"test"
                                                         alertBody:@"This is JRNLocalNotificationCenter sample"
                                                       alertAction:@"Open"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"time": @"12"}
                                                        badgeCount:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1
                                                    repeatInterval:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark -
#pragma mark - Notification

- (void)didReceiveLocalNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - 
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        UILocalNotification *localNotification = [self localNotificationAtIndexPath:indexPath];
        [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotification:localNotification];
    }
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark -
#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *cellIdentifier = @"Cell";
    
    if ( [tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    
    UILocalNotification *localNotification = [self localNotificationAtIndexPath:indexPath];
    
    cell.textLabel.text = [localNotification.fireDate description];
    cell.detailTextLabel.text = [localNotification alertBody];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[JRNLocalNotificationCenter defaultCenter] localNotifications] count];
}



@end
