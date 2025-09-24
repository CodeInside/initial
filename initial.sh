#!/bin/bash

export ACCOUNT_ROOT='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9Ka6rSZcK6iD6Rcs2xoAvhi1rGmiJyXt/jcovQ7wexku2yBFMOG2MAyN111M+jCTfufF8hEPOEiwPSztq1W0EIua3zbkBXPIFTSW5TYvvSiGKv21KWLnarpC7mknosMqs0+saBt6jKgV4YvnEjMGuvEQPRyG0NwvZlqn9nIu820NuBr9UvN4WVTW9Z6BcFTVm4kw4Jka2nNo0nwdDqc5Ca0dD9wtwNzogvYTUf4Voxouk+aAk3854CN42YQElJME0HkZQD6kn4HVPCGNqgH5ls9497HIsDDfQv+J1TXk7S6EtdDufQsTIuUCfkWkbvzx/t2s95DqziSkIhyLbN755DsocSRLAggEluki9N+spKEo2Yv40iqDTayDDiSNb7Qg1rvkfh0QjJRuRMiJAbS0O5SBqTo1sv3S+mUVd1J0HJLSLTqz2sVBxqfD580qs6a0P8eEucuRHiG/jqhylJcqNSfb3hwCsG/jq5qAaS9yBdKmu6jXtHTFAU4f3lWj73H8rd49fB0t258fm74TOx73E93OSPPKo7Yl+lgZ1BZ0tE1gyHnW3nuVvSUrEDHoPXoEKzy8sgq5FUmJO151oKrMx0IC4UAzlc4/yilPNY1yss5JTC0+XlHgGLOm2dUtONuPs7DnuhVE+Gj50nZF4apSwLHB9CSNMjgcSgNC4GZR3dQ== root@codeinside.ru'

#######

export ACCOUNT_MAINTENANCE='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCZ1fchYwomRNYZiLcrp/TiWrw6I5+S9gXtAOsxGNnnsK/ADlS1JvPoyVca5C4EDwXbEuO0W+ujff5bvuhp/ZncKPapxRioUzcG5H0Gl6MFO1O6isfGveu52EoHBiaW5Zim5pG/ufz87fk/s2eoLUowqMWblXdTJbkbDYljIy0O1+R8fdf3j845+hOlYJOpwU6W6QzeQbKNz1HzVnWb/C5v+OYwDJ9fWeLOqC4EQPjc6gnOmeL9TX2bC3jnsmejyvRHHTb0XNSS4WfzuMGfugX7nLwhDxUJWn+al8TVMgaKMalLxrGJMZLD42Q3CTuFV+UKTzJXM5nGoVT+vrirGn/1WGVHVFSvpn/cU4WgEy6TDHqvzztfaJfWVu7h9ec8Jr7EzsZSBzZdFo11Hlb1Pfvsj7DYRP6ss9Kcd2ESPdAacAjr7m+qMjyThF+3nREQkuw4VpAj72Z1zEZlfNlzhLfdbMn+pZ//I9dL0Txj1P1ifLDWcuXM5H9sRytHR+Mhd7LvPsEgZ9fUbnH/jfcvA3jLGXlRZZC+8lHQubypXNP4Z0jGMbQdUHUlxcIf//6WiiPc8OJZ1cfeyaQI90K8EvnwJMWcJLCtA020dX9gLAfvETW4rMQI1PFZYv5YNO8IavbCYDA8qV9YBJjAl8KHEzwdRbTJCZ1J+c5aeVcU5ZhS8Q== maintenance@codeinside.ru'
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
