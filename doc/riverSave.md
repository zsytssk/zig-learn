感觉这代码好复杂

## url

https://codeberg.org/river/river/src/branch/master/protocol/river-layout-v3.xml
https://codeberg.org/river/wiki
https://codeberg.org/river/wiki/src/branch/master/pages/Community-Layouts.md
https://github.com/zsytssk/river/blob/master/PACKAGING.md

https://github.com/zsytssk/river?tab=readme-ov-file

rivercarro https://sr.ht/~novakane/rivercarro/

## other

- @ques 怎么让系统默认运行我本地的 river

```
/usr/share/wayland-sessions/river.desktop
zig build -Doptimize=ReleaseSafe -Dxwayland --prefix ~/.local install
```

- @ques wayland desktop position
  - `/usr/share/wayland-sessions`

## ques

- @ques 能不能看到 river 的 log
- @ques river 能不能运行在一个测试的窗口中
- @ques 怎么和 wayland 交互

## rivertile

- 所有的外部接口

  - `wl.Output`
  - `layout.`
  - `wl.Registry` `wl.Registry.Event`
  - `river.LayoutV3.setListener`
  - wl.Display
  - river.LayoutManagerV3 | `river.LayoutV3` | `river.LayoutV3.Event`

- @ques `river.LayoutV3` 应该是 river 内部实现的接口

- options

  - main-location -> 主区域的位置
  - main-count -> 主区域的窗口数量?
  - main-ratio -> 主区域占整个窗口的大小

- @ques layout_demand 设置后计算布局
  - 怎么就能计算每一个窗口的位置和大小呢? 没有看到窗口 id 什么之类的
  - 是 ev.serial 吗
