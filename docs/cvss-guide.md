# CVSS 评分和威胁等级指南

## CVSS 评分说明

CVSS (Common Vulnerability Scoring System) 是评估漏洞严重程度的标准化评分系统。

### CVSS 分数范围

- **0.0 - 3.9**: 低危 (Low)
- **4.0 - 6.9**: 中危 (Medium)
- **7.0 - 8.9**: 高危 (High)
- **9.0 - 10.0**: 严重 (Critical)

### CVSS 向量说明

CVSS 向量格式：`CVSS:版本/AV:攻击向量/AC:攻击复杂度/PR:权限要求/UI:用户交互/S:作用域/C:机密性/I:完整性/A:可用性`

**示例**：`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`

- AV:N = 网络攻击（Network）
- AC:L = 低复杂度（Low）
- PR:N = 无需权限（None）
- UI:N = 无需用户交互（None）
- S:U = 作用域不变（Unchanged）
- C:H = 机密性影响高（High）
- I:H = 完整性影响高（High）
- A:H = 可用性影响高（High）

## 威胁等级说明

威胁等级是对漏洞严重程度的简化描述：

- **严重 (Critical)**: CVSS 9.0-10.0，需要立即修复
- **高危 (High)**: CVSS 7.0-8.9，应尽快修复
- **中危 (Medium)**: CVSS 4.0-6.9，建议修复
- **低危 (Low)**: CVSS 0.0-3.9，可选择性修复

## 配置文件示例

```yaml
name: 漏洞名称
title: 漏洞标题
severity: 高危漏洞 # 显示文本
severity_level: high # 内部等级标识
threat_level: 高危 # 威胁等级（严重/高危/中危/低危）
cvss_score: 7.5 # CVSS 分数（0.0-10.0）
cvss_vector: CVSS:3.1/... # CVSS 向量（可选）
cve: CVE-2016-6802 # CVE 编号（可选）
```

## 如何获取 CVSS 评分

1. **官方 CVE 数据库**

   - MITRE CVE: https://cve.mitre.org/
   - NVD (National Vulnerability Database): https://nvd.nist.gov/

2. **CVSS 计算器**

   - NVD CVSS Calculator: https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator

3. **安全公告**
   - 厂商安全公告通常包含 CVSS 评分
   - OWASP Top 10 等标准参考

## 注意事项

- CVSS 评分是动态的，可能随时间和环境变化
- 不同版本（CVSS v2.0, v3.0, v3.1）的评分可能不同
- 建议使用最新的 CVSS 3.1 版本
- 威胁等级应该与 CVSS 分数保持一致
