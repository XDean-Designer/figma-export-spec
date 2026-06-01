# Figma → HTML 导出还原度规范（Cursor Agent 版）

> **版本** 1.1.0 · **结构化数据** 见同目录 `rules.json` · **人类可读界面** 见 `index.html`

## Cursor 如何使用

1. 在对话中 `@rules.json` 或 `@RULES.md`（推荐同时 `@index.html`）
2. 提供 Figma 文件链接或说明当前选中的 Frame
3. 使用下方 **Agent 提示词模板** 发起审计与修正

## Agent 提示词模板

```
请读取 @rules.json，对当前 Figma 页面执行导出 HTML 前的合规审计。

步骤：
1. 用 get_metadata / use_figma 获取页面结构
2. 逐条检查 priority=must 的 rules
3. 输出违规清单：ruleId、节点名、当前值、期望值
4. 经我确认后，用 figma-use 按 fix 字段自动修正
5. 修正后用 audit.pluginHint 复检
6. 全部 must 通过后告知可试导出

约束：只改 Figma 结构，不改 HTML；所有容器优先 Auto Layout；间距对齐 4px 模数。
```

## 目标

| 项 | 值 |
|---|---|
| 画布 | 390×844px（宽固定，高可延展） |
| 还原目标 | 主要区块偏差 ≤ **2px** |
| 不保证 | 跨浏览器字体、动效、混合模式、绝对定位布局 |

## Design Tokens（速查）

### 间距（4px 模数）

| Token | 值 |
|---|---|
| 页面左右边距 | 16px |
| 模块间距 | 16px |
| 卡片内边距 | 16px |
| 图文间距 | 8px |
| 列表行上下 | 12px |
| ¥ 与数字 | 4px |

### 固定高度

| 组件 | 高度 |
|---|---|
| PageTitleBar | 44px |
| Button | 48px（max-width 370px） |
| SearchBar | 36px |

### 圆角

| 场景 | 值 |
|---|---|
| 卡片 | 12px |
| 输入框 | 8px |
| 标签 | 4px |
| 按钮 | 4 / 8 / 12 / 16 四档之一 |

### 颜色

| 用途 | Hex |
|---|---|
| 页面背景 | `#F7F7F7` |
| 卡片白底 | `#FFFFFF` |
| 主色 | `#F32F41` |
| 标题文字 | `#333333` |
| 次要文字 | `#929292` |
| 边框/分割 | `#D7D7D5` |
| 禁用/占位 | `#EDEDED` |

### 字体

| 用途 | 字体 |
|---|---|
| UI（Apple） | PingFang SC |
| UI（Windows/HTML） | Source Han Sans SC |
| 金额数字 | TCloudNumber Bold |

## Must 级规则索引（22 条）

| ID | 类别 | 标题 |
|---|---|---|
| RULE-001 | canvas | 根画板宽度 390px，无设备外壳 |
| RULE-002 | canvas | 状态栏 390×44 + 底部 390×39 占位 |
| RULE-003 | canvas | 页面背景 #F7F7F7 |
| RULE-004 | canvas | 禁止横向溢出 |
| RULE-005 | layout | 所有容器 Auto Layout |
| RULE-006 | layout | 禁止主体绝对定位 |
| RULE-007 | layout | 删除隐藏废弃图层 |
| RULE-008 | layout | Tab 与卡片禁止负间距层叠 |
| RULE-009 | spacing | 4px 模数整数 |
| RULE-010 | spacing | 边距与模块间距 16px |
| RULE-011 | spacing | 标题栏 44px / 按钮 48px |
| RULE-012 | spacing | 按钮 max-width 370px |
| RULE-013 | typography | 文本必须为 Text 图层 |
| RULE-014 | typography | 行高字间距明确数值 |
| RULE-015 | typography | 金额 TCloudNumber + ¥ gap 4px |
| RULE-016 | typography | 禁止字符代替图标 |
| RULE-017 | color | 无阴影无渐变 |
| RULE-018 | color | 白底卡片无描边 |
| RULE-020 | color | 无混合模式与复杂模糊 |
| RULE-021 | component | 使用组件库实例 |
| RULE-022 | asset | SVG 图标无 emoji |
| RULE-025~028 | acceptance | 试点导出与验收 |

完整字段（figmaAction、audit.pluginHint、fix、htmlMapping）见 `rules.json`。

## 反模式（出现即优先修复）

1. **AP-01** Group + 绝对定位 eyeball 对齐 → 改 Frame + Auto Layout
2. **AP-02** 小数 px → 四舍五入到 4 的倍数
3. **AP-03** 文字转曲 → 重建 Text 层
4. **AP-04** Tab 负间距叠卡片 → 纵向布局 gap 16
5. **AP-07** Frame 宽 >390 → 限宽或改 FILL

## Figma MCP 修正优先级

```
layout (RULE-005/006) → canvas (RULE-001~004) → spacing (RULE-009~012)
→ typography (RULE-013~016) → color (RULE-017/018/020) → component (RULE-021~024)
→ acceptance (RULE-025~028)
```

## 组件 → HTML 映射

| Figma | HTML |
|---|---|
| PageTitleBar | `<header>` + chevron-left + 标题 + 操作 |
| Button | `<button>` flex 居中，h=48 |
| PageTabs | `<nav>` 等分 tab + 底部指示条 |
| 列表行 | flex row：图标 + 内容 + chevron-right |
