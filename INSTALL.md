# 安装说明 · 我的插件

> 这份文件是给**第一次装插件的人**看的。请把下面每一步都写清楚，不要跳步。
> 参考写法见示例插件 `hello`：[hello-world 的安装说明](https://github.com/yulancloud/plugins/blob/main/packages/hello-world-v1.0.0.zip)（zip 内同名文件）。

## 适用版本

- 系统版本：v1.1.0 及以上（`/api/health` 的 `build` 为 `20261115a`）
- PHP：≥ 8.1

## ① 备份（一定要做）

在网站根目录执行：

```bash
cp -r config config.bak-$(date +%Y%m%d-%H%M)
cp data/shop.sqlite data/shop.sqlite.bak-$(date +%Y%m%d-%H%M)
```

用面板的话，直接把整个网站目录打包下载一份到本机。**装插件出问题，靠这份备份还原。**

## ② 解压插件包

把 `my-plugin-v1.0.0.zip` 解压，会看到 `plugin.json`、`INSTALL.md` 和 `files/` 目录。

## ③ 复制文件

把 `files/` 里的内容按原来的目录结构复制到网站根目录：

```bash
cp -r files/* /你的网站根目录/
```

> `files/` 下的路径都是相对**项目根目录**（`public/` 的上一级）写的，复制时不要多套一层目录。
> 如果插件有 `patches/`，请按下面 ④ 手工合并；没有就跳过 ④。

## ④ 合并需要修改的已有文件（本示例插件不需要）

按插件实际情况，逐条写清楚「打开哪个文件 → 找到哪段 → 在前面/后面粘贴什么」。
涉及建表时，同时说明要改 `database/schema.sql` 与 `bin/migrate.php`（见开发者教程 04）。

## ⑤ 跑数据库迁移（只在插件建表 / 加字段时需要）

```bash
php bin/migrate.php
```

只是新增静态文件的插件（如 hello 示例）**不需要**这一步。

## ⑥ 更新静态资源版本号（只在改了已有 HTML 里的 JS/CSS 引用时需要）

把全站 HTML 里 `?v=20261115a` 统一换成新值（例如 `?v=20261115b`），否则浏览器和 CDN 会继续用旧文件，表现是「我改了但没变化」。

## ⑦ 验证

1. 打开 `/api/health`，应返回 JSON 且状态正常。
2. 访问插件新增的页面 / 功能，确认效果出现。
3. 登录后台随便点几项，确认原功能没被影响。

## ⑧ 卸载 / 回滚

- 卸载：删除第 ③ 步复制进去的文件，撤销第 ④ 步的合并，恢复 `?v=` 版本号。
- 回滚：把第 ① 步的备份覆盖回去即可。
- 如果跑过迁移，`data/shop.sqlite` 已经改了，用备份的 sqlite 文件还原。

## 常见问题

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 文件传上去了但页面没变化 | 没 bump `?v=` / CDN 缓存 | 清浏览器缓存并刷新 CDN |
| 打开新页面 404 | 运行目录没指向 `public/`，或伪静态没配 | 看 [部署总览](https://doc.yulancloud.us.ci/deploy) |
| 后台报「服务暂时不可用」 | 合并代码写错 | 看 [部署与迁移故障](https://doc.yulancloud.us.ci/troubleshoot/deploy)，真实报错在浏览器 Network 响应体里 |
