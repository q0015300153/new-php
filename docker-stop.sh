#!/bin/bash
################################################################
# 用來停止指定資料夾的 docker-compose 服務                         #
# The docker-compose service used to stop the specified folder #
################################################################

# tw: 設定要停止的服務
# en: Set the service to start
. $(dirname "$0")/projects-list.sh

# tw: 整理要停止的專案
# en: Organize the project to stop
list=()
for name in "${!projects[@]}"; do
	list+=(${name})
done

# tw: 取得要停止的服務設定檔 docker-compose.yml
# en: Get the service profile to stop docker-compose.yml
ymls=()
for i in "${list[@]}"; do
	ymls+=(`find ./${i} -type f -name 'docker-compose.yml'`)
done

# tw: 執行 docker-compose stop
# en: Execute docker-compose stop
thisPath=$(cd `dirname $0`; pwd)
if [ $# -eq 0 ]; then
    for yml in "${ymls[@]}"; do
    	cd `dirname "${yml}"`
    	docker-compose -f `basename "${yml}"` stop
    	cd ${thisPath}
    done
fi
