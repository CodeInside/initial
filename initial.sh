#!/bin/bash

export ACCOUNT_ROOT='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCQ5cNQLSpIjAN3RV7+FVs8+KJEqIz1+zAV7VHXeaA9/ZrYmZYlaF9BBPGv/0PKE4T6dorAukbrimEXq+W/7Kqp6AJMBC8fFL2p4KbEAVXi++627IZsALbRwDGTazGow+IoT/UzY33CZa9eJwVYa+4cwq2dS85+S/phvxjSHSz8rmcf2DYun0km9jenKpggGFjnJSDqqB3pLjgGsoM8D7ed641BX8OZdjX1k8G81pyOY4uEYuy3EKjr3ONJ91kI5cqGYIp5a4pXoYxhcii4Q/PDyO0q2bBLq7YaC5vuB+Xjh6dPG71F56sVVxirOpKJKsTou5y8BtKObTM1SVENgJTle6avH1zYngXsSLfoC6+oJE8PSjewHt5tJW26eK/GkwtADkGw4LVj5tx1IOkmFRty9JDyiR7O3Gdr4ifZWhpa+ahBZb/1lnn9Ugeqyo2lKhJzXc+mRl+yDG54TFHGG8QVxgcL86uyJowT58Xr4X4Yvkmo7E8uS/2+mm26cjLpzO3rB/difn8XmY20JBVuTDbGD2AQopOxblzhtTvCbwrnJbHn6fpA5xygvdj8A4IjcXr75YrjG7iGkY7YdmDGNPD6Sfc55m+LZ8rASAbPmN5viN9FDqcD2SwOC6ZkDe45xsr/M1OgZACaT48DwTx+ermVUulh99qXtCgF1/qz8Yiu/Q== root@*.codeinside.ru'

#######

export ACCOUNT_MAINTENANCE='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCUF3gJmi8wwAAxKR7NPe+PBYlLkGFot757Fza/VP/ZKEWFLIT60weqZ9xDacDIa+WksPCJP6cYKxzC6Y1IwOaMDhn56mPlXu4yH4HSm2aJb2CM895PWpgm0+yqtDGtCgUIbfoXkAahX08Gq2XGGvqf1tb6d/ACxzck90EOAU5lXLXwpJ9G7/pjAx1i4m1N8NHHgkZJYQ5VaNLIYR0Smlr09eMrcMHODI3ysWj+jec/S88J3NaqQq4QOIWzUYPvUG9sEE2NGE7Dti+PPYTy9kylC3oz8vlK6ZZFzyNmVk7C9orLM4xx3GubxgPeaJAAtFdnTr4CZKCw4sKq5v6Jl7TnthAi3iaLPPinxDhBeAN8fr0BRQot1vO0UuRxatgiaFfmlsjdBm5q8RFCk30rcDf2FWjF9IHlQB5DQ406GqhW6pUh1Z/wSFKBs9IPLNnlqtASxxgbV6mMB1Gxn8R4tRWCMJ2zuB9m0OAoqpfJxJvJYzLiAxnPIeSwKwgbu2ZniFrz4GLAd5vbi7zE77Kbs8P2tslpSWz4om+vsgZiCqI56Rgfy8Z5grdEDQo0iltIU9DJW3vgMFmXhgGeAvizjFWN//m9sLy3HflUBrWzZ6y1HZV1eNW2rv34RvXKMttIHf4gbohEF4CBBnnal+Kv1chwdHIjjlzOCTZjwQX2v7Xynw== maintenance@*.codeinside.ru'
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
useradd --system -d "${MAINTENANCE_HOME}" -m -g nogroup -s /bin/bash -c "Maintenance account" -N maintenance 2> /dev/null
mkdir -p "${MAINTENANCE_HOME}/.ssh"
echo "${ACCOUNT_MAINTENANCE}" > "${MAINTENANCE_HOME}/.ssh/authorized_keys"
chown -R maintenance:nogroup "${MAINTENANCE_HOME}"
chmod -R 0700 "${MAINTENANCE_HOME}"
chmod 0600 "${MAINTENANCE_HOME}/.ssh/authorized_keys"
if [[ -n "$(which restorecon)" ]]; then restorecon -Rv "${MAINTENANCE_HOME}/.ssh"; fi
#chattr +i "${MAINTENANCE_HOME}/.ssh/authorized_keys"

if [[ -z "$(which sudo)" ]]; then (apt-get update -y && apt-get install sudo -y); fi
chattr -i /etc/sudoers.d/maintenance 2> /dev/null
echo 'maintenance  ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/maintenance
#chattr +i /etc/sudoers.d/maintenance

#################################################

echo "Done!"
