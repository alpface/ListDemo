//
//  main.m
//  ListDemo
//
//  Created by xiaoyuan on 2019/1/9.
//  Copyright © 2019 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface Person : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *name;
- (instancetype)initWithAge:(int)age name:(NSString *)name;
- (void)run;
- (void)runWithValue:(NSNumber *)value;
@end

void testObjctElements()
{
    Person *p1 = [[Person alloc] initWithAge:10 name:@"tom"];
    Person *p2  = [[Person alloc] initWithAge:15 name:@"yebo"];
    Person *p3  = [[Person alloc] initWithAge:16 name:@"iris"];
    List *l = [[List alloc] init];
    [l addObject:p1];
    [l addObject:p2];
    [l insertObject:p3 atIndex:0];
    [l enumerateObjectsUsingBlock:^(Person *  _Nonnull p, NSUInteger idx, BOOL * _Nonnull stop) {
        if (p.age > 15) {
            *stop = YES;
        }
        NSLog(@"Person.age=%d, Person.age=%@", p.age, p.name);
    }];
    [l makeObjectsPerform:@selector(run)];
    
    NSInteger indexOfP3 = [l indexOfObject:p3];
    if (indexOfP3 != NSNotFound) {
        NSLog(@"indexOfP3 = %ld", indexOfP3);
    }
    
    [l makeObjectsPerform:@selector(runWithValue:) with:@100000];
}

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

    
    NSLog(@"________");
    
    List *l1 = [[List alloc] initWithCapacity:18];
    [l1 addObjectsFromList:l];
    [l1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    NSLog(@"________");
    [l1 replaceObjectAtIndex:3 withObject:@100000];
    [l1 replaceObjectAtIndex:1 withObject:@900000];
    [l1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        test();
        testObjctElements();
    }
    return 0;
}

@implementation Person

- (instancetype)initWithAge:(int)age name:(NSString *)name {
    if (self = [super init]) {
        _age = age;
        _name = name;
    }
    return self;
}

- (void)run {
    NSLog(@"%@ is running", self.name);
}

- (void)runWithValue:(NSNumber *)value {
    NSLog(@"%@ is running , value:%@", self.name, value);
}
@end
