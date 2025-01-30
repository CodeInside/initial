#!/bin/bash

export ACCOUNT_ROOT='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC82JhjGEivoVRW1J3P6wfyOyfV0WkG9QM4Z4elgolJz2CXVra+DVDf2X+PpJxXVh1H5gf+DQ10ikf322X3PCkBSOAUu53Be93g8xSvAcQitwunh6h3yqCTG0gcXbb3ygIh5fwyExtMly5lmPYlkJFZBj2yGJafOwPsDPGWruSbKzSfxPPs47JBNozNbp1Z88Dk70hlTTggTWUF6oNqew8pJA7lzhjfFKA1DGUzXxc6xR21mHFMjETX9tV41p88PZ65sFvi5rDWw66btzAMOhSiqlRTt3KjGvEW4ldBXQBjb/A5DyMPFOx+lMAozsCOc1lo8m5Ca+wD92gdvDlPHH6XSmYoaKQDmZ9Bh0Yo0qiKoWxITTa3OwOqTf6RHD/ivBRSSSvHCty57CrM1ftp2M7ABAswO1aQ26WgnvPcXj98am61rV2xdLPGPuwSsH+vwjpzxH4b9UaluGX5OyFz4t5sXtyyCEGTR9jSr5LzWaol93bjCXmuyN85w4TpL9Xh6QvUXiNyyJlRHoDLVleQ9arzIKrfXzhPUL4Q47X1GdWv0Wr1/BF8H+KxT3bBq9Jb+89l7N0EYhLS2Dq+oIqwNJiwGcKQQj5Z9b0cj29B+0ukMfLfa9VfQbQM9jvqNW73fzO8qPT5O59ZgAm8ubYL72+XA+zOB0/JanD6VHVHSJdRfQ== root@*.codeinside.ru'

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
