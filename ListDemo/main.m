//
//  main.m
//  ListDemo
//
//  Created by xiaoyuan on 2019/1/9.
//  Copyright © 2019 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

void test()
{
    List *l = [[List alloc] initWithCapacity:10];
    [l addObject:@10];
    [l addObject:@20];
    [l addObject:@30];
    
    [l enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    NSLog(@"________");
    
    [l insertObject:@100 atIndex:0];
    [l insertObject:@200 atIndex:0];
    
    [l enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    NSLog(@"________");
    [l addObject:@40];
    [l addObjectIfAbsent:@20];
    [l enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    NSLog(@"________");
    [l removeObject:@100];
    [l enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];

    
    NSLog(@"%@", l);
    
    List *l1 = [[List alloc] initWithCapacity:18];
   
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        test();
    }
    return 0;
}
