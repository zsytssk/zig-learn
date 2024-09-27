- @ques zig sentinel terminated arrays 有啥用？
- @ques zig slice 能 push 吗
- @ques 是干嘛的 [Atomic](https://www.youtube.com/watch?v=grMBeLJw7DM&list=PLtB7CL7EG7pCw7Xy1SQC53Gl8pI7aDg9t&index=44)

## build

```
http
https://github.com/karlseguin/http.zig

websocket
https://github.com/karlseguin/websocket.zig
```

## 依赖数据结构

这样就可以处理程序中的内存依赖的问题

- `->` 是依赖的意思
- a -> b -> c
  - 如果 a 减 1, b 和 c 自动减一
  - 如果 c 有一个属性, a 就自动有一个属性; c 去掉那个属性 a 同时也去掉

## ques

zig 如何让 struct 支持 `==` `!=`

`[2]u8` vs `const [2]u8` vs `*const [2]u8` vs `[*]const u8`

`[*]u8` 和 `*[?]u8` 区别，为什么第二个可以访问`.len` 第一个却不行

## 编译 c 文件

https://www.reddit.com/r/Zig/comments/1cjtcc9/zig_013_fail_to_build_c_file/

## 2024-05-30 10:45:31

- `@typeInfo` 类型的细节信息

```
const fields = @typeInfo(Point).Struct.fields;

  inline for (fields) |field| {
      std.debug.print("{s}:{any}\n", .{ field.name, field.type });
  }
```

- `@TypeOf` 获得某个值的类型

- `@typeName` 类型信息转换成字符串
- `@Type` 是 `@typeInfo` 的反函数, 可以用 build.type 构建类型

- `inline for(list)` list 的类型必须是 comptime-known

- `@field(result_flags, flag.name)` -> 通过字符串修改 struct 属性

## comptime

```zig
const a: []const u8 = comptime flags_type: {
    var a: []const u8 = &.{ 1, 2, 3 };
    a = a ++ .{ 4, 5, 6 };
    break :flags_type a;
};
std.debug.print("{any}", .{a});
```

## opaque

https://zig.guide/language-basics/opaque/

opaque 是用来做不在 zig 中的对象等做申明类型的, 就像 ts 文件给和他交互的 js 文件写的类型一样

## std.mem

- `mem.tokenize` 分割字符串
- `mem.span` 将 c 字符串转换成 slice(有 len)

## other

- @ques `@intCast` `@truncate`
  - 都是转换 int 类型, @intCast 超过范围会报错, @truncate 会删除超过的部分
