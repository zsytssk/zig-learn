- @todo
  - add layout | 自己改以下 layout
    - 加一个命令? | 加一个 log -> 看不到 log

## 2024-05-28 14:07:15

- @todo 找到自己能学习的地方

- @ques 其他的布局管理

- @ques river 有没有交流群

  - github discord stack?

- `rivertile/main.zig`

- @ques rivertile 是如何让外面使用的

- @ques structure

  - `Context` -> ?
  - `Output` -> ?
    - wl_output
    - main_location
    - main_count -> ?
    - main_ratio -> ?
    - layout

- @ques zig
  - `std.TailQueue`

```
zig-cache/o/ed1d7dc3615a5f6081dcb87d8ad76797/river_layout_v3_client.zig
river.LayoutManagerV3 -> @imp
river.LayoutV3 -> @imp
wayland.client.wl -> ?
wl.Output -> ?
wayland.client.river -> ?
river.LayoutV3.Event -> ?
```

- @ques rivertile main 函数什么时候运行的

- @ques 自己的 rivertile 如何替代默认的

- @ques river 默认的 log 存在哪里?

  - `nohup river > river.log 2>&1 &`
  - `nohup /home/zsy/.local/bin/river > /home/zsy/river.log 2>&1 &`
  - `https://forums.linuxmint.com/viewtopic.php?t=376983`
  - `tail -F river.log`

- @ques Output 修改了属性之后, 桌面布局就变化了 -> 有监听属性变化吗?
  - layoutListener 在哪调用的 -> river.LayoutV3

## 2024-05-27 13:13:43

- @ques 尝试其他 layout

- @ques 怎么我的 river 启动起来就出问题 -> wayland 没有启动
  - `zig build -Doptimize=ReleaseSafe -Dxwayland --prefix ~/.local install`
  - 可能是代码问题 -> 对比代码区别
  - ***
  - 可能是本地的 lib 有问题
  - 'missing x for display'
  - `--ozone-platform=wayland`
  - maybe some env setting problem

## 2024-05-27 13:13:27

https://www.gsp.com/cgi-bin/man.cgi?section=1&topic=RIVERCTL

restart
swap screen
max screen
waybar

## 2024-05-27 10:48:29

- build

  - wayland
  - wayland-protocols
  - wlroots
  - libevdev
  - pixman
  - xkbcommon -> libxkbcommon
  - pkg-config

- 这些需要安装吗?
- libwayland

```

unable to spawn the following command: ExitCodeFailure
pkg-config --variable=pkgdatadir wayland-protocols
error: the following build command failed with exit code 1:

```

```

```
