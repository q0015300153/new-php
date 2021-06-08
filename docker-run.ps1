##################################################################
# 用來啟動指定資料夾的 docker-compose 服務                         #
# The docker-compose service used to launch the specified folder #
##################################################################

# tw: 設定要啟動的服務
# en: Set the service to start
$thisPath = $PWD
Import-module "$PSScriptRoot\projects-list.ps1" -Force

# tw:
#   整理要啟動的專案
#   如果有 git 路徑，git clone 下來
# en:
#   Organize the project to be launched
#   If there is a git path, git clone download
$list = @()
foreach ($name in $projects.keys) {
    $list+= $name
    if ($projects[$name] -like "*.git") {
        if (-not (Test-Path -Path $name)) {
            docker run -ti --rm -v $thisPath/:/git alpine/git clone $projects[$name] $name
        }
    }
}

# tw:
#   取得要啟動的服務設定檔 docker-compose.yml 與 init.sh
#   init.sh 用於專案初始化
# en:
#   Get the service profile to be launched docker-compose.yml and init.sh
#   Init.sh for project initialization
$ymls = @()
$init = @()
foreach ($i in $list) {
    $ymls+= (Get-Childitem –Path "$i/docker-compose.yml").fullname
    $init+= (Get-Childitem –Path "$i/init.ps1").fullname
}

# tw: 執行初始化
# en: Perform initialization
foreach ($script in $init) {
    cd             (Split-Path -Path $script)
    powershell.exe -executionpolicy bypass -File (Split-Path -Path $script -Leaf)
    cd             $thisPath
}

# tw:
#   執行 docker-compose，
#   如果沒有輸入參數，
#   預設執行 docker-compose up
# en:
#   Execute docker-compose，
#   if there is no input parameter,
#   the default execution docker-compose up
if ($args.Count -eq 0) {
    foreach ($yml in $ymls) {
        cd (Split-Path -Path $yml)
        docker-compose -f (Split-Path -Path $yml -Leaf) up -d --build
        cd $thisPath
    }
} else {
    foreach ($yml in $ymls) {
        cd (Split-Path -Path $yml)
        docker-compose -f (Split-Path -Path $yml -Leaf) "$args"
        cd $thisPath
    }
}

# tw: 下載或新增 Laravel 專案
# en: Download or add a Laravel project
foreach ($name in $laravels.keys) {
    powershell.exe -executionpolicy bypass -File "$PSScriptRoot\add-laravel.ps1" $name $laravels[$name]
}
