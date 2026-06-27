# CN IP 规则合并

多源合并去重的中国大陆 IP 段列表（IPv4 + IPv6），每日自动更新。

## 固定下载链接

| 文件 | 说明 | 链接 |
|------|------|------|
| `cn_ipv4.txt` | 仅 IPv4 | `https://raw.githubusercontent.com/SSM-FX/CNIP-list/main/output/cn_ipv4.txt` |
| `cn_ipv6.txt` | 仅 IPv6 | `https://raw.githubusercontent.com/SSM-FX/CNIP-list/main/output/cn_ipv6.txt` |
| `cn.txt` | IPv4 + IPv6 合并 | `https://raw.githubusercontent.com/SSM-FX/CNIP-list/main/output/cn.txt` |


## 自动更新

通过 GitHub Actions 每日北京时间 08:00 自动拉取最新数据并合并去重，提交到仓库。
