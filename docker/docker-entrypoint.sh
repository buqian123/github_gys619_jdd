#!/bin/bash
set -e

config=$dir_root/config
. file_config=$config/config.sh

echo -e "======================1. 检测配置文件========================\n"
if [ -s ${dir_root}/config/crontab.list ]
then
  echo -e "检测到config配置目录下存在crontab.list，自动导入定时任务...\n"
  crontab ${dir_root}/config/crontab.list
  echo -e "成功添加定时任务...\n"
else
  echo -e "检测到config配置目录下不存在crontab.list或存在但文件为空，从示例文件复制一份用于初始化...\n"
  cp -fv ${dir_root}/sample/crontab.list.sample ${JD_DIR}/config/crontab.list
  echo
  crontab ${dir_root}/config/crontab.list
  echo -e "成功添加定时任务...\n"
fi

if [ ! -s ${dir_root}/config/config.sh ]; then
  echo -e "检测到config配置目录下不存在config.sh，从示例文件复制一份用于初始化...\n"
  cp -fv ${dir_root}/sample/config.sh.sample ${JD_DIR}/config/config.sh
  echo
fi

if [ ! -d "${dir_root}/log/" ]; then
  echo -e "检测到log文件夹不存在，创建文件夹...\n"
  mkdir -p ${dir_root}/log
  echo
fi

crond -f >/dev/null

exec "$@"
