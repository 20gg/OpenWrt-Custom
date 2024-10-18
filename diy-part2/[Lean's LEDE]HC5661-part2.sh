#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

#=========================================
# Sys config modification
#=========================================
echo '修改网关地址'
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# echo '修改时区'
# sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

echo '修改机器名称'
sed -i 's/OpenWrt/STEAM/g' package/base-files/files/bin/config_generate

target_inf() {
    #=========================================
    # Target System
    #=========================================
    cat << EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7620=y
CONFIG_TARGET_ramips_mt7620_DEVICE_hiwifi_hc5661=y
EOF
}

config_clean() {
    #=========================================
    # Stripping options
    #=========================================
    cat << EOF
CONFIG_STRIP_KERNEL_EXPORTS=y
# CONFIG_USE_MKLIBS=y
EOF
    #=========================================
    # Remove defaults Apps
    #=========================================
    cat << EOF
# ----------luci-app-ssr-plus
# CONFIG_PACKAGE_luci-app-ssr-plus is not set
# ----------luci-app-diskman
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs is not set
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk is not set
# ----------luci-app-rclone
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-webui is not set
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-ng is not set
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_fuse-utils is not set
EOF
}

config_basic() {
    config_clean
    #=========================================
    # 基础包和应用
    #=========================================
    cat << EOF
# ----------extra packages-automount
CONFIG_PACKAGE_automount=y
# ----------extra packages-ipv6helper
CONFIG_PACKAGE_ipv6helper=y
# ----------Utilities-Disc-cfdisk&fdisk
CONFIG_PACKAGE_cfdisk=y
CONFIG_PACKAGE_fdisk=y
# ----------Utilities-Filesystem-e2fsprogs
CONFIG_PACKAGE_e2fsprogs=y
# ----------Utilities-usbutils
CONFIG_PACKAGE_usbutils=y
# ----------Utilities-jq
CONFIG_PACKAGE_jq=y
# ----------Utilities-coreutils-base64
CONFIG_PACKAGE_coreutils-base64=y
# ----------Kernel modules-USB Support-kmod-usb3
CONFIG_DEFAULT_kmod-usb3=y
# ----------luci-app-hd-idle
CONFIG_PACKAGE_luci-app-hd-idle=y
# ----------luci-app-cifsd
CONFIG_PACKAGE_luci-app-cifsd=y
# ----------luci-app-commands
CONFIG_PACKAGE_luci-app-commands=y
# ----------luci-app-qos
CONFIG_PACKAGE_luci-app-qos=m
# ----------luci-app-eqos
CONFIG_PACKAGE_luci-app-eqos=m
# ----------luci-app-sqm
CONFIG_PACKAGE_luci-app-sqm=m
# ----------luci-app-ttyd
CONFIG_PACKAGE_luci-app-ttyd=y
# ----------luci-app-wrtbwmon
CONFIG_PACKAGE_luci-app-wrtbwmon=m
# ----------luci-theme-argon
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-theme-argonne=m
CONFIG_PACKAGE_luci-app-argonne-config=m
# ----------luci-app-webadmin
CONFIG_PACKAGE_luci-app-webadmin=y
EOF
}

config_func() {
    config_basic
    #=========================================
    # 功能包
    #=========================================
    cat << EOF
# ----------luci-app-aria2
CONFIG_PACKAGE_luci-app-aria2=m
# ----------luci-app-VPNs
CONFIG_PACKAGE_luci-app-nps=m
CONFIG_PACKAGE_luci-app-frpc=m
CONFIG_PACKAGE_luci-app-n2n_v2=m
CONFIG_PACKAGE_luci-app-zerotier=m
# ----------luci-app-openclash
CONFIG_PACKAGE_luci-app-openclash=m
# ----------network-firewall-ip6tables-ip6tables-mod-nat
# CONFIG_PACKAGE_ip6tables-mod-nat=y
# ----------luci-app-transmission
CONFIG_PACKAGE_luci-app-transmission=m
# ----------luci-app-watchcat
CONFIG_PACKAGE_luci-app-watchcat=y
# ----------luci-app-v2ray-server
CONFIG_PACKAGE_luci-app-v2ray-server=m
EOF
}

config_test() {
    config_func
    #=========================================
    # 测试域
    #=========================================
    cat << EOF
CONFIG_PACKAGE_luci-app-verysync=m
EOF
}

#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑上面写配置区块内容↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
#--------------------------------------------------------------------------------
#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓下面写配置编写逻辑↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

# 重新制作.config文件
echo -e '\n=====================路径检查======================='
echo -n '[diy-part2.sh]当前表显路径：' && pwd
echo -n '[diy-part2.sh]当前物理路径：' && pwd -P
rm -fv ./.config*

target_inf >> .config
# 根据输入参数增加内容
if [[ $1 == clean* ]]; then
    echo "[洁净配置] 仅该型号的默认功能"
     >> .config
elif [[ $1 == basic* ]]; then
    echo "[基本配置] 包含一些基础增强"
    config_basic >> .config
elif [[ $1 == test* ]]; then
    echo "[测试配置] 包含所有功能，外加测试包"
    config_test >> .config
else
    echo "[全功能配置] 包含常用的所有功能、插件"
    config_func >> .config
fi

# 移除行首的空格和制表符
sed -i 's/^[ \t]*//g' .config

# make defconfig
# diff .config default.config --color
# diff的返回值1会导致github actions出错，用这个来盖过去
echo "=====================已生成 .config 文件，diy-part2.sh 结束====================="
