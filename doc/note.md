https://zig.guide/language-basics/errors

https://www.youtube.com/watch?v=whjDH-LKA2s

- 疗养

## 2024-05-27 10:45:32

- @todo 对比 rivercarro 看改了哪些内容
- 看看 river 的其他模块 -> riverctl

### 记忆

- @qeus @alignOf

- @ques memory align 是什么?

- @intCast @as @truncate

- @intCast allocator

### task

```
pub fn getAutoEqlFn(comptime K: type, comptime Context: type) (fn (Context, K, K) bool) {
    return struct {
        fn eql(ctx: Context, a: K, b: K) bool {
            _ = ctx;
            return meta.eql(a, b);
        }
    }.eql;
}
```

- struct

  - Globals > .control + .seat

- @ques setListener

- @ques 怎么创建一个 `[][]u8`

- @ques comptime return fn

- @ques riverctl 就那一点代码 怎么实现功能的

- `const bytes align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };`

  - 类型对齐是干嘛的

- @ques `main-location-cycle` 之后页面的布局怎么就改变了

  - cfgs 修改之后 又触发了其他的函数运行?

- @ques layout_demand.pushViewDimensions 怎么不需要传 app id 之类的东西

  - pushViewDimensions -> marshal -> wl_proxy_marshal_array

- @ques 也许需要去学习下 wayland 的接口

### end

- @ques vscode shortcut previous edit location

- @ques `mem.tokenize(u8, mem.span(ev.command), " ");`

  - `mem.tokenize` 分割字符串
  - `mem.span` 将 c 字符串转换成 slice(有 len)

- @ques `wayland` 的调用都是 c 代码吗?

  - 怎么和 wayland 交互

- @ques `union(enum)`

  - union enum union(enum)

- @ques @ptrCast 是什么

- @ques zig comptime 能用在什么地方?

- @ques zig 怎么修改 string

`[*:0]const u8` diff `[:0]const u8` -> `*` 是指针的意思吗?

- @ques zig 中如何解指针

## 2024-05-25 11:13:32

- @ques zig build cc file

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
