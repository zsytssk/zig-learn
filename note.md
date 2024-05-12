https://zig.guide/language-basics/errors

https://www.youtube.com/watch?v=4j7MkMc0sN0&list=PLtB7CL7EG7pCw7Xy1SQC53Gl8pI7aDg9t&index=9

@ques zig 怎么处理内存的

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

zig sentinel terminated arrays 有啥用？

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
