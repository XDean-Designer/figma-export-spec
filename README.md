# Figma 导出 HTML 还原度规范

Figma 设计稿通过插件导出 HTML 前的结构与 Token 约束，支持 **Cursor Agent** 审计并调用 Figma MCP 自动修正。

## 在线访问

部署后访问：**https://xdean-designer.github.io/figma-export-spec/**

## 文件说明

| 文件 | 用途 |
|------|------|
| [index.html](./index.html) | 人类可读界面 + 交互检查清单 |
| [rules.json](./rules.json) | 机器可读规则（含 `figmaAction`、`audit.pluginHint`、`fix`） |
| [RULES.md](./RULES.md) | Markdown 速查，Cursor 中 `@` 引用 |

## Cursor 用法

```
@rules.json @RULES.md
请对 [Figma 链接] 执行导出 HTML 前的 must 规则审计，列出违规项后按 fix 字段修正。
```

## 本地部署

```powershell
.\deploy-github.ps1
```

需已安装 Git 并登录 GitHub CLI（`gh auth login`）。
