# patches/ · 需要合并进核心文件时放这里

**能只用 `files/` 就别用这个目录。** 覆盖或插入核心文件是插件最容易出问题的地方。

## 什么时候必须用

| 想加的东西 | 要动的文件 | 参考教程 |
| --- | --- | --- |
| 一个只读 / 写入接口 | `public/api/index.php` | [03 基础 API](https://doc.yulancloud.us.ci/developer/custom/api) |
| 一张新表 / 新字段 | `database/schema.sql` + `bin/migrate.php` | [04 数据库与迁移](https://doc.yulancloud.us.ci/developer/custom/database) |
| 后台业务逻辑 | `src/YourService.php` + `public/api/index.php` | [06 后台管理扩展](https://doc.yulancloud.us.ci/developer/custom/admin) |
| 一个后台菜单页 | `public/admin/index.html` + `public/admin/assets/views.js` | [06 后台管理扩展](https://doc.yulancloud.us.ci/developer/custom/admin) |
| 一条限流规则 | `config/config.php` 的 `rate_limit` | [05 实战](https://doc.yulancloud.us.ci/developer/custom/first-feature) |

## 怎么写

1. 这里放**片段文件**，命名如 `api-index.snippet.php`、`migrate.snippet.php`，只含要新增的代码。
2. 每个片段顶部用注释写明：目标文件、插入位置（哪个函数 / 哪一行之后）、是否需要幂等判断。
3. 在 `INSTALL.md` 第 ④ 步里，逐个片段写清楚「打开 X 文件 → 搜 Y → 在它下面粘贴 Z」，并附上粘贴后的样子。
4. 片段里凡是 `CREATE TABLE`、`ALTER TABLE`、`INSERT` 配置，一律加 `IF NOT EXISTS` / 存在性判断，防止用户重复安装时炸库。

## 绝对不要做

- 不要把整个 `public/api/index.php`、`config/config.php` 放进 `files/` 直接覆盖 —— 用户一旦升级系统或装了别的插件，就会被你的旧版本覆盖掉。
- 不要在包里附带 `data/shop.sqlite` 或 `config/config.php` 的真实内容。
- 不要在片段里写 `exit`、`die`、远程请求、外链脚本。
