#!/bin/bash
##################################################################
# 用來啟動指定資料夾的 docker-compose 服務                         #
# The docker-compose service used to launch the specified folder #
##################################################################

# tw: 設定要啟動的服務
# en: Set the service to start
thisPath=$(cd `dirname $0`; pwd)
. $(dirname "$0")/projects-list.sh

# tw:
# 	整理要啟動的專案
# 	如果有 git 路徑，git clone 下來
# en:
# 	Organize the project to be launched
# 	If there is a git path, git clone download
list=()
for name in "${!projects[@]}"; do
	list+=(${name})
	if [[ ${projects[$name]} == *".git" ]]; then
		if ! [ -d "${name}" ]; then
			docker run -ti --rm -v ${thisPath}:/git alpine/git clone ${projects[$name]} ${name}
		fi
	fi
done

# tw:
# 	取得要啟動的服務設定檔 docker-compose.yml 與 init.sh
# 	init.sh 用於專案初始化
# en:
# 	Get the service profile to be launched docker-compose.yml and init.sh
# 	Init.sh for project initialization
ymls=()
init=()
for i in "${list[@]}"; do
	ymls+=(`find ./${i} -type f -name 'docker-compose.yml'`)
	init+=(`find ./${i} -type f -name 'init.sh'`)
done

# tw: 執行初始化
# en: Perform initialization
for script in "${init[@]}"; do
	cd   `dirname  "${script}"`
	bash `basename "${script}"`
	cd   ${thisPath}
done

# tw:
# 	執行 docker-compose，
# 	如果沒有輸入參數，
# 	預設執行 docker-compose up
# en:
# 	Execute docker-compose，
# 	if there is no input parameter,
# 	the default execution docker-compose up
if [ $# -eq 0 ]; then
    for yml in "${ymls[@]}"; do
    	cd `dirname "${yml}"`
    	docker-compose -f `basename "${yml}"` up -d --build
    	cd ${thisPath}
    done
else
	for yml in "${ymls[@]}"; do
    	cd `dirname "${yml}"`
    	docker-compose -f `basename "${yml}"` $@
    	cd ${thisPath}
    done
fi

# tw: 下載或新增 Laravel 專案
# en: Download or add a Laravel project
for name in "${!laravels[@]}"; do
	bash $(dirname "$0")/add-laravel.sh ${name} ${laravels[$name]}
done
