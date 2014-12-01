//
//  ViewController.m
//  test-gcd
//
//  Created by Zhn on 1/12/2014.
//  Copyright (c) 2014 Zhn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPriorityRezult;
@property (weak, nonatomic) IBOutlet UILabel *labelCustomQueueRezult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self testPriority];
            break;
        case 1:
            [self testCustomQueue];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) testPriority
{
    static BOOL m_testPriorityFlag;
    m_testPriorityFlag = NO;
    
    __block NSInteger _idxHigh = 0;
    __block NSInteger _idxLow = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        _idxHigh = 0;
        for (; _idxHigh<100 && !m_testPriorityFlag; _idxHigh++) {
            NSLog(@"yup");
        }
        m_testPriorityFlag = YES;
        NSLog(@"high priority queue, #%@", @(_idxHigh));
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.labelPriorityRezult.text = [NSString stringWithFormat:@"low:%@, high:%@", @(_idxLow),  @(_idxHigh)];
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (; _idxLow<100 && !m_testPriorityFlag; _idxLow++) {
            NSLog(@"yup");
        }
        m_testPriorityFlag = YES;
        NSLog(@"low priority queue, #%@", @(_idxLow));
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.labelPriorityRezult.text = [NSString stringWithFormat:@"low:%@, high:%@", @(_idxLow),  @(_idxHigh)];
        });
    });
}

- (void) testCustomQueue
{
    static BOOL m_testCustomQueue;
    m_testCustomQueue = NO;
    
    __block NSInteger _idx1 = 0;
    __block NSInteger _idx2 = 0;
    dispatch_queue_t _queue1 = dispatch_queue_create("com.test-gcd.first", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t _queue2 = dispatch_queue_create("com.test-gcd.second", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(_queue1, ^{
        _idx1 = 0;
        for (; _idx1<100 && !m_testCustomQueue; _idx1++) {
            NSLog(@"yup");
        }
        m_testCustomQueue = YES;
        NSLog(@"high priority queue, #%@", @(_idx1));
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.labelCustomQueueRezult.text = [NSString stringWithFormat:@"first:%@, second:%@", @(_idx2),  @(_idx1)];
        });
    });
    dispatch_async(_queue2, ^{
        for (; _idx2<100 && !m_testCustomQueue; _idx2++) {
            NSLog(@"yup");
        }
        m_testCustomQueue = YES;
        NSLog(@"low priority queue, #%@", @(_idx2));
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.labelCustomQueueRezult.text = [NSString stringWithFormat:@"first:%@, second:%@", @(_idx2),  @(_idx1)];
        });
    });
}

@end
