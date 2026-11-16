# 欲蓝财务 · 插件开发模板

这是 **GitHub 模板仓库（Template repository）**。点仓库右上角绿色的 **`Use this template` → `Create a new repository`**，就能一键创建一个结构一模一样的插件仓库，然后按下面改内容即可。

> 不知道怎么给系统「加新功能」？先看文档站的 [功能自定义 · 学习路线](https://doc.yulancloud.us.ci/developer/custom)（10 篇教程）。**插件不是另一套框架**，它就是按那套教程做出来的功能，打包成一个 zip 而已。

## 目录结构

```
my-plugin/
├── plugin.json      ← 插件元数据（市场页读它展示，必填）
├── INSTALL.md       ← 给小白看的安装步骤（必填，越细越好）
├── README.md        ← 本文件，插件介绍与开发说明
├── assets/
│   └── icon.svg     ← 插件图标（可选，也可以用外链）
├── files/           ← 要「新增」到商城项目的文件，路径相对项目根目录
│   └── public/plugins/hello/index.html
└── patches/         ← 需要「合并进已有核心文件」的代码片段与说明（可选）
    └── README.md
```

### `files/` 和 `patches/` 的区别

| 目录 | 用途 | 安装方式 |
| --- | --- | --- |
| `files/` | 全新文件，不覆盖任何现有文件 | 整目录复制进项目对应位置即可，**最安全** |
| `patches/` | 必须改 `public/api/index.php`、`bin/migrate.php`、`config/config.php` 等已有文件时 | 在 `INSTALL.md` 里写清楚「打开哪个文件、找到哪一行、粘贴哪段」，让用户手工合并 |

**优先只用 `files/`**。示例插件 `hello` 就是零侵入：新增一个独立页面，不改任何核心文件、不建表、不用跑迁移，装上访问 `/plugins/hello/` 就能看到效果。适合让用户第一次练手。

需要建表 / 加接口 / 加后台菜单的进阶插件，请照着开发者教程 05–09 做，并把每一步合并操作写进 `INSTALL.md`。

## 开发流程

1. 点 `Use this template` 建自己的仓库，克隆到本地。
2. 改 `plugin.json`（`id` 用小写英文+连字符，全市场唯一；`version` 用语义化版本）。
3. 在 `files/` 下按项目根目录的相对路径放文件。例如要新增 `public/assets/notice.js`，就放 `files/public/assets/notice.js`。
4. 把安装步骤写进 `INSTALL.md`，**至少包含**：备份、复制文件、是否要跑迁移、是否要 bump 版本号、怎么验证、怎么卸载。
5. 本地装一遍：拿一套干净的 v1.1.0 解压，按 `INSTALL.md` 从头走一遍，确认能用。
6. 打包：`./pack.sh`（生成 `<id>-v<version>.zip`）。
7. 把 zip 上传到**你自己的 GitHub 仓库**（推荐用 Release 资产，也可以直接提交进仓库用 raw 链接）。注意链接必须是公开可直链的。
8. 去 [插件市场](https://yulancloud.us.ci/market/) 点 **「上传插件」**，填提交表单；审核通过后会合并进索引仓库的 `plugins.json`，市场页自动出现。

## 提交前自查

- [ ] `plugin.json` 是合法 JSON，`id` 没和现有插件重复
- [ ] `INSTALL.md` 按「小白第一次装」的标准写，没跳步
- [ ] 包里没有 `data/shop.sqlite`、`config/config.php`、密钥、`.git/` 等敏感内容
- [ ] 没覆盖核心文件却没在 `INSTALL.md` 里说明
- [ ] 改动 `?v=` 相关文件的话，`INSTALL.md` 里写了要 bump 版本号
- [ ] 代码里没有远程上报、外链脚本、挖矿等任何不该有的东西
- [ ] 已在干净的 v1.1.0 上实测安装、卸载、回滚

## 相关链接

- [插件市场](https://yulancloud.us.ci/market/)
- [如何安装插件（小白教程）](https://doc.yulancloud.us.ci/plugins/install)
- [如何上传插件到市场](https://doc.yulancloud.us.ci/plugins/submit)
- [插件索引仓库](https://github.com/yulancloud/plugins)
- [功能自定义教程（怎么加新功能）](https://doc.yulancloud.us.ci/developer/custom)
