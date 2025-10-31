#!/bin/bash

export ACCOUNT_ROOT='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaZJA8N284AkaJFmiuYoAY15NskXREbvC9gI1pgJqI9HPRLo7q/gYJc2tUvbVciALimyxkg9IJWvWtXlqv/W/SJZoLtocFYbB0+sbdno8fA8rBQp3Y7rcR5HUQP27qV93gDL59ymdSVtZ4+/SABcnBIx5kfKkuDhBv0In456UiodfxLLZL/p/PrYR15KXOgB3pK8eAfSeLL+VEK+mEnMWNYCxKC8Ej7JByl+SixgBOSha4AKqB35mBRI1ORJ2yPfgSbdcTho+iOluA5fNCn/Vj3b278u18VN15wCm1A+YVcZ/kKukxwyh4jdStvE7QUZLNsMc30xM2gQjKKVeC8ayaeblohiugsYjJtlyuSUZ4nLlURKg/hBsK0PcGERLrCQwRJMSsSafwqvSCspEhjR37FMDMWmnkpHlclDnxifTDbVCWl7YpiWa3hVAI813zFEaLid+tmNcuQxGpWT9iCTMQl6DEtaTf8SB5r/nloSuFPjJvDrcNond44q+0AAfSjXmJ77yh9boG57pgXNHKcwDbCm1qiEgct464yRGwAaGld9Y6N9RCz1LVgQyp/EnckvetLIk/1CCOuoWQmqfu2Anp84C3xGe5636La6SlnUTJSAer/R35fvRnX3FfmayUymsfIQQ5lz8lM0LfihcVLd1rUsRPPVRahy8kjpWNsAUIRQ== root@codeinside.ru'

#######

export ACCOUNT_MAINTENANCE='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC92YYDoO2WemhAqz7pba6xU3yqpyWmG0N91NZiZwrrnR6R7dbsGVD7RBGSwmSQ3+x/FgWnlNbS5+xQK/BlGUDIaJ1pM4z3SQcpVV0UCszVCUW8u3v6gQVML/TrN+BJercy4G3gxIstLruKJQDHRLWL8GBZztHTwWVhb8sDqCLrdyLRAOD+w0+kWVK8W1a2zqx3l8CobK/B5/hje9uwJiag3pimp7BIZVCTVDA42FhCALYThfNf5Gr16pKmundMdINxFxOdSB0yAdvlADIOJviAfJSGwpL5uJ95vvLGs52f6IIyIHZaW6+dr9vztTqYzB3lPXGInTbIMsxXS/xgezqbxp0SNjv9Jsm2PvhZ5o3p3RPaj+vk9WDTCkHtXmcNIyOpVKX/fYHZpqitDilzaZHc+m4ayRturTkcUP0idKadvPB030S48mdI9RuZ9kEHPkTd3pTguatobVvvanBWaAefu4CY0ZsPH7ubgtDopXlBzMQpIWd0K57+0X0a2/WyuSiUuHd4fzg4S4XKzovqjR/viiKCy/iFqsECf37OwJGl/DhT9Ham1VsOIQYuvf0imPGsHrpmjJxjCIVP+y8y2wMqHXQ0FYNj1EVM3pWbUjrVL9NqQqIPq25Tr/aePvn6RePWs4ZObAnp7ivi3PskLsSGvqupHu3HsNfCLpGJQY/Giw== maintenance@codeinside.ru'
export MAINTENANCE_HOME='/home/maintenance'

#################################################

chattr -i /root/.ssh 2> /dev/null
chattr -i /root/.ssh/authorized_keys 2> /dev/null
rm -rf /root/* /root/.* 2> /dev/null
cp -rT /etc/skel /root
mkdir -p /root/.ssh
echo "${ACCOUNT_ROOT}" > /root/.ssh/authorized_keys
chown -R root:root /root
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
if [[ -n "$(which restorecon)" ]]; then restorecon -Rv /root/.ssh; fi
#chattr +i /root/.ssh/authorized_keys

#######

chattr -i "${MAINTENANCE_HOME}/.ssh" 2> /dev/null
chattr -i "${MAINTENANCE_HOME}/.ssh/authorized_keys" 2> /dev/null
userdel -rf maintenance 2> /dev/null
useradd --system -d "${MAINTENANCE_HOME}" -m -g nobody -s /bin/bash -c "Maintenance account" -N maintenance 2> /dev/null
mkdir -p "${MAINTENANCE_HOME}/.ssh"
echo "${ACCOUNT_MAINTENANCE}" > "${MAINTENANCE_HOME}/.ssh/authorized_keys"
chown -R maintenance:nobody "${MAINTENANCE_HOME}"
chmod -R 0700 "${MAINTENANCE_HOME}"
chmod 0600 "${MAINTENANCE_HOME}/.ssh/authorized_keys"
if [[ -n "$(which restorecon)" ]]; then restorecon -Rv "${MAINTENANCE_HOME}/.ssh"; fi
#chattr +i "${MAINTENANCE_HOME}/.ssh/authorized_keys"

if [[ -z "$(which sudo)" ]]; then (yum update -y && yum install sudo -y); fi
chattr -i /etc/sudoers.d/maintenance 2> /dev/null
echo 'maintenance  ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/maintenance
#chattr +i /etc/sudoers.d/maintenance

#################################################

echo "Done!"
