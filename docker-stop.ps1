################################################################
# 用來停止指定資料夾的 docker-compose 服務                       #
# The docker-compose service used to stop the specified folder #
################################################################

# tw: 設定要停止的服務
# en: Set the service to start
Import-module "$PSScriptRoot\projects-list.ps1" -Force

# tw: 整理要停止的專案
# en: Organize the project to stop
$list = @()
foreach ($name in $projects.keys) {
    $list+= $name
}

# tw: 取得要停止的服務設定檔 docker-compose.yml
# en: Get the service profile to stop docker-compose.yml
$ymls = @()
foreach ($i in $list) {
    $ymls+= (Get-Childitem –Path "$i/docker-compose.yml").fullname
}

# tw: 執行 docker-compose stop
# en: Execute docker-compose stop
$thisPath = $PWD
if ($args.Count -eq 0) {
    foreach ($yml in $ymls) {
        cd (Split-Path -Path $yml)
        docker-compose -f (Split-Path -Path $yml -Leaf) stop
        cd $thisPath
    }
}
