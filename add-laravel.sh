#!/bin/bash
#################################
# 用來新增 Laravel 專案           #
# Used to add a Laravel project #
#################################

# tw:
# 	取得輸入參數
# 		projectName => Laravel 專案的資料夾名稱
# 		gitPath     => 選擇性，專案的 git 路徑，
# 					   如果有指定會用 git clone 複製專案，
# 					   如果沒指定則會用 laravel new 建立專案。
# en:
# 	Get input parameters
# 		projectName => Laravel project folder name
# 		gitPath 	=> selective, project git path,
# 					   If there is a designation, copy the project with git clone.
# 					   If not specified, the project will be created with laravel new.
projectName=$1
gitPath=$2

# tw:
# 	預設參數
# 		wwwPath    => docker 容器內網頁的預設路徑
# 		nginxAlias => nginx alias 網站的設定檔
# en:
# 	Preset parameter
# 		wwwPath    => The default path of the web page in the docker container
# 		nginxAlias => Nginx alias website configuration file
wwwPath=/var/www/html
nginxAlias=/etc/nginx/alias

# tw: 如果沒有設定專案資料夾名稱，離開
# en: If the project folder name is not set, leave
if ! [[ -n "${projectName}" ]]; then
	echo "Please enter the project name"
	exit
fi

# tw: 取得目前的 docker 服務
# en: Get the current docker service
phpService=(`docker ps --format "table {{.Names}}" | grep php`)
nginxService=(`docker ps --format "table {{.Names}}" | grep nginx`)

# tw:
# 	composer 建立 laravel 專案
# 	或 git clone 下載 laravel 專案
# en:
# 	composer builds laravel project
# 	Or git clone download laravel project
for php in "${phpService[@]}"; do
	# tw: 判斷有沒有網頁預設資料夾
	# en: Determine if there is a web page preset path
	if ! [[ `docker exec ${php} ls -a ${wwwPath} | grep '\.\.'` = ".." ]]; then
		echo "Skip ${php}"
		continue
	fi

	# tw: 判斷有沒有這個 Laravel 專案
	# en: Determine if there is any Laravel project
	if [[ `docker exec ${php} find ${wwwPath} -name ${projectName} -type d` = "${wwwPath}/${projectName}" ]]; then
		echo "The project '${projectName}' already exists"
		break
	fi

	# tw: 建立 Laravel 專案
	# en: Create a Laravel project
	isGitClone=false
	if ! [[ -n "${gitPath}" ]]; then
		#docker exec -i ${php} bash -c "cd ${wwwPath} && laravel new ${projectName}"
		docker exec ${php} composer create-project --prefer-dist laravel/laravel ${wwwPath}/${projectName}
	else
		isGitClone=true
		docker exec ${php} git clone ${gitPath} ${projectName}
	fi

	# tw: 設定 Laravel 資料夾權限
	# en: Set Laravel folder permissions
	if [[ `docker exec ${php} ls -a ${wwwPath}/${projectName}/artisan` = "${wwwPath}/${projectName}/artisan" ]]; then
		docker exec ${php} bash -c "chmod -R 757 ${wwwPath}/${projectName}"
		docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && chown -R \$USER:www-data storage"
		docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && chown -R \$USER:www-data bootstrap/cache"
		docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && chmod -R 775 storage"
		docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && chmod -R 775 bootstrap/cache"
		# tw: 如果是透過 git clone 下載，重新建立專案
		# en: If you download via git clone, re-create the project.
		if $isGitClone; then
			docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && composer install"
			docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && cp .env.example .env"
			docker exec ${php} bash -c "cd ${wwwPath}/${projectName} && php artisan key:generate"
		fi
	fi

	# tw: 判斷有沒有成功建立專案
	# en: Determine if there is a successful project
	if ! [[ `docker exec ${php} ls -a ${wwwPath}/${projectName} | grep '\.\.'` = ".." ]]; then
		echo "Failed to create a new project"
		exit
	else
		break
	fi
done

# tw: 建立 nginx web 站點設定檔
# en: Create an nginx web site profile
for nginx in "${nginxService[@]}"; do
	docker exec ${nginx} cp ${nginxAlias}/default ${nginxAlias}/${projectName}.conf
	docker exec ${nginx} sed -i "s#\$path#$wwwPath#g"     ${nginxAlias}/${projectName}.conf
	docker exec ${nginx} sed -i "s#\$name#$projectName#g" ${nginxAlias}/${projectName}.conf
	docker exec ${nginx} chmod 777 ${nginxAlias}/${projectName}.conf
	docker exec ${nginx} nginx -s reload
	break
done
