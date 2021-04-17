#!/bin/bash
. /lib/functions.sh
. /usr/share/openclash/openclash_ps.sh
. /usr/share/openclash/ruby.sh

status=$(unify_ps_status "openclash.sh")
[ "$status" -gt 3 ] && exit 0

START_LOG="/tmp/openclash_start.log"
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="/tmp/openclash.log"
CFG_FILE="/tmp/config.yaml"
CRON_FILE="/etc/crontabs/root"
CONFIG_PATH=$(uci get openclash.config.config_path 2>/dev/null)
servers_update=$(uci get openclash.config.servers_update 2>/dev/null)
dns_port=$(uci get openclash.config.dns_port 2>/dev/null)
enable_redirect_dns=$(uci get openclash.config.enable_redirect_dns 2>/dev/null)
disable_masq_cache=$(uci get openclash.config.disable_masq_cache 2>/dev/null)
if_restart=0
only_download=0

urlencode() {
   local data
   if [ "$#" -eq 1 ]; then
      data=$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")
      if [ ! -z "$data" ]; then
         echo "$(echo ${data##/?} |sed 's/\//%2f/g' |sed 's/:/%3a/g' |sed 's/?/%3f/g' |sed 's/(/%28/g' |sed 's/)/%29/g' |sed 's/\^/%5e/g' |sed 's/=/%3d/g' |sed 's/|/%7c/g')"
      fi
   fi
}

kill_watchdog() {
   watchdog_pids=$(unify_ps_pids "openclash_watchdog.sh")
   for watchdog_pid in $watchdog_pids; do
      kill -9 "$watchdog_pid" >/dev/null 2>&1
   done
}

config_download()
{
if [ -n "$subscribe_url_param" ]; then
   if [ -n "$c_address" ]; then
      curl -sL --connect-timeout 10 --retry 2 "$c_address""$subscribe_url_param" -o "$CFG_FILE" >/dev/null 2>&1
   else
      curl -sL --connect-timeout 10 --retry 2 https://openclash.gg/sub"$subscribe_url_param" -o "$CFG_FILE" >/dev/null 2>&1
      if [ "$?" -ne 0 ]; then
         curl -sL --connect-timeout 10 --retry 2 http://127.0.0.1:25500/sub"$subscribe_url_param" -o "$CFG_FILE" >/dev/null 2>&1
      fi
   fi
else
   curl -sL --connect-timeout 10 --retry 2 --user-agent "clash" "$subscribe_url" -o "$CFG_FILE" >/dev/null 2>&1
fi
}

config_cus_up()
{
	if [ -z "$CONFIG_PATH" ]; then
	    CONFIG_PATH="/etc/openclash/config/$(ls -lt /etc/openclash/config/ | grep -E '.yaml|.yml' | head -n 1 |awk '{print $9}')"
	    uci set openclash.config.config_path="$CONFIG_PATH"
      uci commit openclash
	fi
	if [ -z "$subscribe_url_param" ]; then
	   if [ "$servers_update" -eq 1 ] || [ ! -z "$keyword" ] || [ ! -z "$ex_keyword" ]; then
	      echo "配置文件【$name】替换成功，开始挑选节点..." > $START_LOG
	      uci set openclash.config.config_update_path="/etc/openclash/config/$name.yaml"
	      uci set openclash.config.servers_if_update=1
	      uci commit openclash
	      /usr/share/openclash/yml_groups_get.sh
	      uci set openclash.config.servers_if_update=1
	      uci commit openclash
	      /usr/share/openclash/yml_groups_set.sh
	      if [ "$CONFIG_FILE" == "$CONFIG_PATH" ]; then
	         if_restart=1
	      fi
	      echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
	      echo "配置文件【$name】更新成功！" > $START_LOG
	      sleep 3
	      echo "" > $START_LOG
	   elif [ "$CONFIG_FILE" == "$CONFIG_PATH" ]; then
        echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
        echo "配置文件【$name】更新成功！" > $START_LOG
        sleep 3
        if_restart=1
     else
        echo "配置文件【$name】更新成功！" > $START_LOG
        echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
        sleep 3
        echo "" > $START_LOG
     fi
  else
     if [ "$CONFIG_FILE" == "$CONFIG_PATH" ]; then
        echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
        echo "配置文件【$name】更新成功！" > $START_LOG
        sleep 3
        if_restart=1
     else
        echo "配置文件【$name】更新成功！" > $START_LOG
        echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
        sleep 3
        echo "" >$START_LOG
     fi
  fi
  
  rm -rf /tmp/Proxy_Group 2>/dev/null
}

config_su_check()
{
   echo "配置文件下载成功，检查是否有更新..." > $START_LOG
   sed -i 's/!<str> //g' "$CFG_FILE" >/dev/null 2>&1
   if [ -f "$CONFIG_FILE" ]; then
      cmp -s "$BACKPACK_FILE" "$CFG_FILE"
      if [ "$?" -ne 0 ]; then
         echo "配置文件【$name】有更新，开始替换..." > $START_LOG
         cp "$CFG_FILE" "$BACKPACK_FILE"
         #保留规则部分
         if [ "$servers_update" -eq 1 ]; then
              ruby -ryaml -E UTF-8 -e "
               Value = YAML.load_file('$CONFIG_FILE');
               Value_1 = YAML.load_file('$CFG_FILE');
               if Value.key?('rules') or Value.key?('script') or Value.key?('rule-providers') then
                  if Value.key?('rules') then
                     Value_1['rules'] = Value['rules']
                  elsif Value.key?('script') then
                     Value_1['script'] = Value['script']
                  elsif Value.key?('rule-providers') then
                     Value_1['rule-providers'] = Value['rule-providers']
                  end;
                  File.open('$CFG_FILE','w') {|f| YAML.dump(Value_1, f)};
               end;
            " 2>/dev/null
         fi
         mv "$CFG_FILE" "$CONFIG_FILE" 2>/dev/null
         if [ "$only_download" -eq 0 ]; then
            config_cus_up
         else
            echo "配置文件【$name】更新成功！" > $START_LOG
            echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
            sleep 3
            echo "" > $START_LOG
         fi
      else
         echo "配置文件【$name】没有任何更新，停止继续操作..." > $START_LOG
         rm -rf "$CFG_FILE"
         echo "${LOGTIME} Updated Config【$name】 No Change, Do Nothing" >> $LOG_FILE
         sleep 5
         echo "" > $START_LOG
      fi
   else
      echo "配置文件下载成功，本地没有配置文件，开始创建 ..." > $START_LOG
      mv "$CFG_FILE" "$CONFIG_FILE" 2>/dev/null
      cp "$CONFIG_FILE" "$BACKPACK_FILE"
      if [ "$only_download" -eq 0 ]; then
         config_cus_up
      else
         echo "配置文件【$name】更新成功！" >$START_LOG
         echo "${LOGTIME} Config 【$name】 Update Successful" >> $LOG_FILE
         sleep 3
         echo "" > $START_LOG
      fi
   fi
}

config_error()
{
   echo "配置文件【$name】下载失败，请检查网络或稍后再试！" > $START_LOG
   echo "${LOGTIME} Error: Config 【$name】Update Error" >> $LOG_FILE
   rm -rf "$CFG_FILE" 2>/dev/null
   sleep 5
   echo "" > $START_LOG
}

change_dns()
{
   if pidof clash >/dev/null; then
      if [ "$enable_redirect_dns" -ne 0 ]; then
         uci del dhcp.@dnsmasq[-1].server >/dev/null 2>&1
         uci add_list dhcp.@dnsmasq[0].server=127.0.0.1#"$dns_port" >/dev/null 2>&1
         uci delete dhcp.@dnsmasq[0].resolvfile >/dev/null 2>&1
         uci set dhcp.@dnsmasq[0].noresolv=1 >/dev/null 2>&1
         [ "$disable_masq_cache" -eq 1 ] && {
            uci set dhcp.@dnsmasq[0].cachesize=0 >/dev/null 2>&1
         }
         uci commit dhcp
         /etc/init.d/dnsmasq restart >/dev/null 2>&1
      fi
      iptables -t nat -I OUTPUT -j openclash_output >/dev/null 2>&1
      iptables -t mangle -I OUTPUT -j openclash_output >/dev/null 2>&1
      nohup /usr/share/openclash/openclash_watchdog.sh &
   fi
}

field_name_check()
{
   #检查field名称（不兼容旧写法）
   ruby -ryaml -E UTF-8 -e "
      Value = YAML.load_file('$CFG_FILE');
      if Value.key?('Proxy') or Value.key?('Proxy Group') or Value.key?('Rule') or Value.key?('rule-provider') then
         if Value.key?('Proxy') then
            Value['proxies'] = Value['Proxy']
            Value.delete('Proxy')
            puts '${LOGTIME} Warning: Proxy is no longer used. Auto replaced by proxies.'
         elsif Value.key?('Proxy Group') then
            Value['proxy-groups'] = Value['Proxy Group']
            Value.delete('Proxy Group')
            puts '${LOGTIME} Warning: Proxy Group is no longer used. Auto replaced by proxy-groups.'
         elsif Value.key?('Rule') then
            Value['rules'] = Value['Rule']
            Value.delete('Rule')
            puts '${LOGTIME} Warning: Rule is no longer used. Auto replaced by rules.'
         elsif Value.key?('rule-provider') then
            Value['rule-providers'] = Value['rule-provider']
            Value.delete('rule-provider')
             puts '${LOGTIME} Warning: rule-provider is no longer used. Auto replaced by rule-providers.'
         end;
         File.open('$CFG_FILE','w') {|f| YAML.dump(Value, f)};
      end;
   " 2>/dev/null >> $LOG_FILE
}

config_download_direct()
{
   if pidof clash >/dev/null; then
      
      kill_watchdog

      uci del_list dhcp.@dnsmasq[0].server=127.0.0.1#"$dns_port" >/dev/null 2>&1
      if [ -s "/tmp/resolv.conf.d/resolv.conf.auto" ] && [ -n "$(grep "nameserver" /tmp/resolv.conf.d/resolv.conf.auto)" ]; then
         uci set dhcp.@dnsmasq[0].resolvfile=/tmp/resolv.conf.d/resolv.conf.auto >/dev/null 2>&1
      elif [ -s "/tmp/resolv.conf.auto" ] && [ -n "$(grep "nameserver" /tmp/resolv.conf.auto)" ]; then
         uci set dhcp.@dnsmasq[0].resolvfile=/tmp/resolv.conf.auto >/dev/null 2>&1
      else
         rm -rf /tmp/resolv.conf.auto 2>/dev/null
         touch /tmp/resolv.conf.auto 2>/dev/null
         cat >> "/tmp/resolv.conf.auto" <<-EOF
# Interface lan
nameserver 114.114.114.114
nameserver 119.29.29.29
EOF
         uci set dhcp.@dnsmasq[0].resolvfile=/tmp/resolv.conf.auto >/dev/null 2>&1
      fi
      uci set dhcp.@dnsmasq[0].noresolv=0 >/dev/null 2>&1
      uci delete dhcp.@dnsmasq[0].cachesize >/dev/null 2>&1
      uci commit dhcp
      /etc/init.d/dnsmasq restart >/dev/null 2>&1
      
      iptables -t nat -D OUTPUT -j openclash_output >/dev/null 2>&1
      iptables -t mangle -D OUTPUT -j openclash_output >/dev/null 2>&1
      sleep 3

      config_download
      
      if [ "$?" -eq 0 ] && [ -s "$CFG_FILE" ]; then
         ruby -ryaml -E UTF-8 -e "
         begin
         YAML.load_file('$CFG_FILE');
         rescue Exception => e
         puts '${LOGTIME} Error: Unable To Parse Config File ' + e.message
         system 'rm -rf ${CFG_FILE} 2>/dev/null'
         end
         " 2>/dev/null >> $LOG_FILE
         if [ $? -ne 0 ]; then
            echo "${LOGTIME} Error: Ruby Works Abnormally, Please Check The Ruby Library Depends!" >> $LOG_FILE
            echo "Ruby依赖异常，无法校验配置文件，请确认ruby依赖工作正常后重试！" > $START_LOG
            sleep 3
            only_download=1
            change_dns
            config_su_check
         elif [ ! -f "$CFG_FILE" ]; then
            echo "配置文件格式校验失败..." > $START_LOG
            sleep 3
            change_dns
            config_error
         elif ! "$(ruby_read "$CFG_FILE" ".key?('proxies')")" && ! "$(ruby_read "$CFG_FILE" ".key?('proxy-providers')")" ; then
            field_name_check
            if ! "$(ruby_read "$CFG_FILE" ".key?('proxies')")" && ! "$(ruby_read "$CFG_FILE" ".key?('proxy-providers')")" ; then
               echo "${LOGTIME} Error: Updated Config 【$name】 Has No Proxy Field, Update Exit..." >> $LOG_FILE
               echo "配置文件节点部分校验失败..." > $START_LOG
               sleep 3
               change_dns
               config_error
            else
               change_dns
               config_su_check
            fi
         else
            change_dns
            config_su_check
         fi
      else
         change_dns
         config_error
      fi
   else
      config_error
   fi
}

server_key_match()
{
	 local key_match key_word
	 
   if [ -n "$(echo "$1" |grep "^ \{0,\}$")" ] || [ -n "$(echo "$1" |grep "^\t\{0,\}$")" ]; then
	    return
   fi
	 
   if [ -n "$(echo "$1" |grep "&")" ]; then
      key_word=$(echo "$1" |sed 's/&/ /g')
	    for k in $key_word
	    do
	       if [ -z "$k" ]; then
	          continue
	       fi
	       k="(?=.*$k)"
	       key_match="$key_match$k"
	    done
	    key_match="^($key_match).*"
   else
	    if [ -n "$1" ]; then
	       key_match="($1)"
	    fi
   fi
   
   if [ "$2" = "keyword" ]; then
      if [ -z "$key_match_param" ]; then
         key_match_param="$key_match"
      else
         key_match_param="$key_match_param|$key_match"
      fi
   elif [ "$2" = "ex_keyword" ]; then
   	  if [ -z "$key_ex_match_param" ]; then
         key_ex_match_param="$key_match"
      else
         key_ex_match_param="$key_ex_match_param|$key_match"
      fi
   fi
}

sub_info_get()
{
   local section="$1" subscribe_url template_path subscribe_url_param template_path_encode key_match_param key_ex_match_param c_address 
   config_get_bool "enabled" "$section" "enabled" "1"
   config_get "name" "$section" "name" ""
   config_get "sub_convert" "$section" "sub_convert" ""
   config_get "address" "$section" "address" ""
   config_get "keyword" "$section" "keyword" ""
   config_get "ex_keyword" "$section" "ex_keyword" ""
   config_get "emoji" "$section" "emoji" ""
   config_get "udp" "$section" "udp" ""
   config_get "skip_cert_verify" "$section" "skip_cert_verify" ""
   config_get "sort" "$section" "sort" ""
   config_get "convert_address" "$section" "convert_address" ""
   config_get "template" "$section" "template" ""
   config_get "node_type" "$section" "node_type" ""
   config_get "custom_template_url" "$section" "custom_template_url" ""

   if [ "$enabled" -eq 0 ]; then
      return
   fi
   
   if [ -z "$address" ]; then
      return
   fi
   
   if [ -z "$name" ]; then
      name="config"
      CONFIG_FILE="/etc/openclash/config/config.yaml"
      BACKPACK_FILE="/etc/openclash/backup/config.yaml"
   else
      CONFIG_FILE="/etc/openclash/config/$name.yaml"
      BACKPACK_FILE="/etc/openclash/backup/$name.yaml"
   fi
   
   if [ "$sub_convert" -eq 0 ]; then
      subscribe_url=$address
   elif [ "$sub_convert" -eq 1 ] && [ -n "$template" ]; then
      subscribe_url=$(urlencode "$address")
      if [ "$template" != "0" ]; then
         template_path=$(grep "^$template," /usr/share/openclash/res/sub_ini.list |awk -F ',' '{print $3}' 2>/dev/null)
      else
         template_path=$custom_template_url
      fi
      if [ -n "$template_path" ]; then
         template_path_encode=$(urlencode "$template_path")
         if [ ! -z "$keyword" ] || [ ! -z "$ex_keyword" ]; then
      	   config_list_foreach "$section" "keyword" server_key_match "keyword"
      	   config_list_foreach "$section" "ex_keyword" server_key_match "ex_keyword"
      	   [ -n "$key_match_param" ] && key_match_param=$(urlencode "$key_match_param")
      	   [ -n "$key_ex_match_param" ] && key_ex_match_param=$(urlencode "$key_ex_match_param")
         fi
         subscribe_url_param="?target=clash&new_name=true&url=$subscribe_url&config=$template_path_encode&include=$key_match_param&exclude=$key_ex_match_param&emoji=$emoji&list=false&sort=$sort&udp=$udp&scv=$skip_cert_verify&append_type=$node_type&fdn=true"
         c_address="$convert_address"
      else
         subscribe_url=$address
      fi
   else
      subscribe_url=$address
   fi

   echo "开始更新配置文件【$name】..." > $START_LOG

   config_download

   if [ "$?" -eq 0 ] && [ -s "$CFG_FILE" ]; then
   	  ruby -ryaml -E UTF-8 -e "
      begin
      YAML.load_file('$CFG_FILE');
      rescue Exception => e
      puts '${LOGTIME} Error: Unable To Parse Config File ' + e.message
      system 'rm -rf ${CFG_FILE} 2>/dev/null'
      end
      " 2>/dev/null >> $LOG_FILE
      if [ $? -ne 0 ]; then
         echo "${LOGTIME} Error: Ruby Works Abnormally, Please Check The Ruby Library Depends!" >> $LOG_FILE
         echo "Ruby依赖异常，无法校验配置文件，请确认ruby依赖工作正常后重试！" > $START_LOG
         sleep 3
         only_download=1
         config_su_check
      elif [ ! -f "$CFG_FILE" ]; then
         echo "配置文件格式校验失败，尝试不使用代理下载配置文件..." > $START_LOG
         sleep 3
         config_download_direct
      elif ! "$(ruby_read "$CFG_FILE" ".key?('proxies')")" && ! "$(ruby_read "$CFG_FILE" ".key?('proxy-providers')")" ; then
         field_name_check
         if ! "$(ruby_read "$CFG_FILE" ".key?('proxies')")" && ! "$(ruby_read "$CFG_FILE" ".key?('proxy-providers')")" ; then
            echo "${LOGTIME} Error: Updated Config 【$name】 Has No Proxy Field" >> $LOG_FILE
            echo "配置文件节点部分校验失败，尝试不使用代理下载配置文件..." > $START_LOG
            sleep 3
            config_download_direct
         else
            config_su_check
         fi
      else
         config_su_check
      fi
   else
      echo "配置文件【$name】订阅失败，尝试不使用代理下载配置文件..." > $START_LOG
      echo "${LOGTIME} Error: Config 【$name】 Download Faild" >> $LOG_FILE
      config_download_direct
   fi
}

#分别获取订阅信息进行处理
config_load "openclash"
config_foreach sub_info_get "config_subscribe"
uci delete openclash.config.config_update_path >/dev/null 2>&1
uci commit openclash

if [ "$if_restart" -eq 1 ]; then
   /etc/init.d/openclash restart >/dev/null 2>&1 &
else
   sed -i '/openclash.sh/d' $CRON_FILE 2>/dev/null
   [ "$(uci get openclash.config.auto_update 2>/dev/null)" -eq 1 ] && [ "$(uci get openclash.config.config_auto_update_mode 2>/dev/null)" -ne 1 ] && echo "0 $(uci get openclash.config.auto_update_time 2>/dev/null) * * $(uci get openclash.config.config_update_week_time 2>/dev/null) /usr/share/openclash/openclash.sh" >> $CRON_FILE
   /etc/init.d/cron restart
fi