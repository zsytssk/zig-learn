https://zig.guide/language-basics/errors

https://www.youtube.com/watch?v=OQLZxserr70&list=PLtB7CL7EG7pCw7Xy1SQC53Gl8pI7aDg9t&index=34
https://codeberg.org/dude_the_builder/zig_in_depth

## 2024-05-19 15:08:43

- @ques zig 如何实现多态 == 基类 + 子类扩展

- @ques zig type 区别

## 2024-05-18 16:10:04

- @ques zig 怎么处理内存的
  - 比如循环引用

## 2024-05-15 11:37:33

- @ques `inline for ...` inline 是什么意思

  - comptime + inline for 可以让这段代码在编译的时候运行？

- @ques `u8` 如何转换成 character

`const hello = "Hello, World!";` hello 的类型 `*const [13:0]u8`

## 2024-05-14 16:11:12

- @ques noreturn 和 void 的区别

## 2024-05-13 13:34:20

- @ques slice 和 array 的区别

- `[5]u8` `*[5]u8` 和 `[]const u8` 的区别
- `A sentinel terminate slice` 是什么

- @ques `*item` 为什么可以使用在`&array`上

```zig
var array = [_]u8{ 0, 1, 2, 3, 4, 5 };
for (&array) |*item| {
    item.* += 1;
}
```

## 2024-05-12 15:02:28

```zig
// @ques d_ptr.len为什么会报错
 var array = [_]u8{ 1, 2, 3, 4, 5 };
    var d_ptr: [*]u8 = &array;
    d_ptr[1] += 1;
    print("d_ptr: {*}, array:{any}, len:{any} \n", .{ d_ptr, @TypeOf(d_ptr), d_ptr.len });
```

## 2024-05-12 11:35:59

```zig
// @ques 有没有办法不是enum,实现typeName
const Number = union {
    int: u8,
    float: f64,
    fn typeName(self: Number) []const u8 {
        if (self == .int) {
            return "int";
        }
        return "float";
    }
};

```

## 2024-05-11 11:54:17

```zig
// *c 后 c 为什么是 *const u8@10d8868，不应该是 u8 吗
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const a: u8 = 1;
    const b: ?*const u8 = &a;
    print("value: {any}\n", .{b});

    if (b) |*c| {
        print("value: {}, refer: {}\n", .{ c, c.* });
    }
    if (b) |c| {
        print("value: {}, refer: {}\n", .{ c, c.* });
    }
}
```

## 2024-05-07 11:17:25

- @ques zig sentinel terminated arrays 有啥用？

```zig
这里的`.a`是什么意思
SomeStrut {
  .a = 1
}
```

zig 如何处理 string
`.{}` 这个是什么意思
zig 能不能像 rust macro 一样处理多个参数？
zig string ++ int `std.debug.print("{any}:{any}", .{chr}, .{i});`
