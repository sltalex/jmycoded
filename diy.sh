#!/usr/bin/env bash
## Author:SuperManito
#2021081203
##############################  作  者  昵  称  （必填）  ##############################
# 使用空格隔开
author_list="sltalex"
##############################  作  者  脚  本  地  址  URL  （必填）  ##############################
# 例如：https://raw.sevencdn.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）
## 目前使用本人收集的脚本库项目用于代替 CDN 加速
scripts_base_url_1=https://cdn.jsdelivr.net/gh/sltalex/jmycoded@master/
#scripts_base_url_2=https://ghproxy.com/https://github.com/Youthsongs/QuanX/blob/main/scripts/

##############################  作  者  脚  本  名  称  （必填）  ##############################
# 将相应作者的脚本填写到以下变量中
my_scripts_list_1="jd_jxmc.js jx_sign.js jd_bean_sign.js jd_xl.js jd_ryhxj.js jd_nzmh.js jd_cfd.js jd_cfd_loop.js jd_cfd_cashOut.js jd_bean_sign.js jd_blueCoin.js jd_speed_redpocke.js jd_ddnc_farmpark.js jd_zooElecsport.js sign_graphics_validate.js gua_doge.js gua_doge.js gua_carnivalcity.js jd_wsdlb.js jd_ppdz.js jd_qjd.py jd_try.js jd_sendBeans.js jd_jddj_bean.js jd_jddj_fruit.js jd_jddj_fruit_collectWater.js jd_jddj_getPoints.js jd_jddj_plantBeans.js jd_all_bean_change.js jd_qqxing.js jd_lsj.js"
#my_scripts_list_2="jay_member_olb.js jd_party_night.jd jd_tcl.js jd_big_winner.js"

## 由于CDN代理无法实时更新文件内容，目前使用本人的脚本收集库以解决不能访问 Github 的问题  
##############################  随  机  函  数  ##############################
rand() {
    min=$1
    max=$(($2 - $min + 1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num % $max + $min))
}
cd ${ShellDir}
index=1
for author in $author_list; do
    echo -e "开始下载 $author 的活动脚本："
    echo -e ''
    # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
    eval scripts_list=\$my_scripts_list_${index}
    #echo $scripts_list
    eval url_list=\$scripts_base_url_${index}
    #echo $url_list
    for js in $scripts_list; do
    eval url=$url_list$js
    echo $url
    eval name=$js
    echo $name
    wget -q --no-check-certificate $url -O scripts/$name.new

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    # 随机添加个cron到crontab.list
    if [ $? -eq 0 ]; then
        mv -f scripts/$name.new scripts/$name

        echo -e "更新 $name 完成...\n"
        croname=$(echo "$name" | awk -F\. '{print $1}')
        script_date=$(cat scripts/$name | grep "http" | awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}' | sort | uniq | head -n 1)
        
        jq_name=${name::-3} #获取更细文件名字，不包含js扩展名
        if cat '/jd/config/crontab.list' | grep "$jq_name" > /dev/null
        #如原仓已有的文件，只更新文件，不更新定时器内容
        then
            echo "包含"
            echo $jq_name
        else
            echo "不包含"
            echo $jq_name
            if [ -z "${script_date}" ]; then
            cron_min=$(rand 1 59)
            cron_hour=$(rand 7 9)
            [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash jd $croname" ${ListCron}
            else
            [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${script_date} bash jd $croname" ${ListCron}
            fi
        fi
    else
        [ -f scripts/$name.new ] && rm -f scripts/$name.new
        echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
    done
    index=$(($index + 1))
done

##############################  删  除  失  效  的  活  动  脚  本  ##############################
## 删除旧版本失效的活动示例： rm -rf ${ScriptsDir}/jd_test.js
#rm -rf ${ScriptsDir}/jd_axc.js
#rm -rf ${ScriptsDir}/jd_shakeBean.js
#rm -rf ${ScriptsDir}/gua_opencard4.js
#rm -rf ${ScriptsDir}/gua_opencard5.js
#rm -rf ${ScriptsDir}/gua_opencard6.js
#rm -rf ${ScriptsDir}/gua_opencard7.js
#rm -rf ${ScriptsDir}/gua_opencard8.js
#rm -rf ${ScriptsDir}/gua_opencard9.js
#rm -rf ${ScriptsDir}/gua_opencard10.js
rm -rf ${ScriptsDir}/jd_cfd_loop.ts
#rm -rf ${ScriptsDir}/jd_enen.js
#rm -rf ${ScriptsDir}/jd_opencard_cool_summer.js
#rm -rf ${ScriptsDir}/jd_opencard_cool_summer2.js
#rm -rf ${ScriptsDir}/jd_opencard_Daddy.js
#rm -rf ${ScriptsDir}/jd_opencard_eat_open_opencard.js



##############################  修  正  定  时  任  务  ##############################
## 目前两个版本都做了软链接，但为了 Linux 旧版用户可以使用，继续将软链接更改为具体文件
## 注意两边修改内容区别在于中间内容"jd"、"${ShellDir}/jd.sh"
## 修正定时任务示例：sed -i "s|bash jd jd_test|bash ${ShellDir}/jd.sh test|g" ${ListCron}
##                 sed -i "s|bash jd jd_ceshi|bash ${ShellDir}/jd.sh ceshi|g" ${ListCron}
sed -i "s|bash jd jd_zooElecsport|bash ${ShellDir}/jd.sh jd_zooElecsport|g" ${ListCron}
sed -i "s|bash jd gua_carnivalcity.js|bash ${ShellDir}/jd.sh gua_carnivalcity.js|g" ${ListCron}
#sed -i "s|bash jd jd_superBrand|bash ${ShellDir}/jd.sh jd_superBrand|g" ${ListCron}
sed -i "s|bash jd jd_qqxing|bash ${ShellDir}/jd.sh jd_qqxing|g" ${ListCron}
sed -i "s|bash jd jd_all_bean_change|bash ${ShellDir}/jd.sh jd_all_bean_change|g" ${ListCron}
sed -i "s|bash jd jd_ddnc_farmpark|bash ${ShellDir}/jd.sh jd_ddnc_farmpark|g" ${ListCron}
sed -i "s|bash jd gua_doge|bash ${ShellDir}/jd.sh gua_doge|g" ${ListCron}
#sed -i "s|bash jd jd_zxry|bash ${ShellDir}/jd.sh jd_zxry|g" ${ListCron}
sed -i "s|bash jd jd_wsdlb|bash ${ShellDir}/jd.sh jd_wsdlb|g" ${ListCron}
sed -i "s|bash jd jd_lsj|bash ${ShellDir}/jd.sh jd_lsj|g" ${ListCron}
sed -i "s|bash jd jd_ppdz|bash ${ShellDir}/jd.sh jd_ppdz|g" ${ListCron}
sed -i "s|bash jd jd_jddj_bean|bash ${ShellDir}/jd.sh jd_jddj_bean|g" ${ListCron}
sed -i "s|bash jd jd_jddj_fruit|bash ${ShellDir}/jd.sh jd_jddj_fruit|g" ${ListCron}
sed -i "s|bash jd jd_jddj_fruit_collectWater|bash ${ShellDir}/jd.sh jd_jddj_fruit_collectWater|g" ${ListCron}
sed -i "s|bash jd jd_jddj_getPoints|bash ${ShellDir}/jd.sh jd_jddj_getPoints|g" ${ListCron}
sed -i "s|bash jd jd_jddj_plantBeans|bash ${ShellDir}/jd.sh jd_jddj_plantBeans|g" ${ListCron}
sed -i "s|bash jd jd_sendBeans|bash ${ShellDir}/jd.sh jd_sendBeans|g" ${ListCron}
sed -i "s|bash jd jd_try|bash ${ShellDir}/jd.sh jd_try|g" ${ListCron}
sed -i "s|bash jd jd_qjd|bash ${ShellDir}/jd.sh jd_qjd|g" ${ListCron}
#sed -i "s|bash jd gua_opencard4.js|bash ${ShellDir}/jd.sh gua_opencard4.js|g" ${ListCron}
#sed -i "s|bash jd gua_opencard5.js|bash ${ShellDir}/jd.sh gua_opencard5.js|g" ${ListCron}
sed -i "s|bash jd gua_opencard6.js|bash ${ShellDir}/jd.sh gua_opencard6.js|g" ${ListCron}
sed -i "s|bash jd gua_opencard7.js|bash ${ShellDir}/jd.sh gua_opencard7.js|g" ${ListCron}
sed -i "s|bash jd gua_opencard8.js|bash ${ShellDir}/jd.sh gua_opencard8.js|g" ${ListCron}
sed -i "s|bash jd gua_opencard9.js|bash ${ShellDir}/jd.sh gua_opencard9.js|g" ${ListCron}
sed -i "s|bash jd gua_opencard10.js|bash ${ShellDir}/jd.sh gua_opencard10.js|g" ${ListCron}