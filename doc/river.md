https://codeberg.org/river/river/src/branch/master/protocol/river-layout-v3.xml
https://codeberg.org/river/wiki
https://codeberg.org/river/wiki/src/branch/master/pages/Community-Layouts.md
https://github.com/zsytssk/river/blob/master/PACKAGING.md

https://github.com/zsytssk/river?tab=readme-ov-file

- @todo
  - add layout | 自己改以下 layout

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
