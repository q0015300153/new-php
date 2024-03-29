########################################################
# 用來指定要啟動的 docker-compose 專案                    #
# 以及要下載的 Laravel 專案                               #
# Used to specify the docker-compose project to launch #
# And the Laravel project to download                  #
########################################################

# tw:
#   設定要啟動的 docker-compose 專案
#   key   -> 是專案的資料夾名稱
#   value -> 是專案的 git 路徑，可以為空
# en:
#   Set the docker-compose project to launch
#   key   -> is the folder name of the project
#   value -> is the git path of the project, can be empty
$projects = @{}
#$projects.add("service-hive", "https://github.com/q0015300153/service-hive.git")
$projects.add("service-lnmp", "https://github.com/q0015300153/service-lnmp.git")
#$projects.add("service-lamp", "")

# tw:
#   設定要下載的 Laravel 專案
#   key   -> 是專案的資料夾名稱
#   value -> 是專案的 git 路徑，可以為空
# en:
#   Set the Laravel project to download
#   key   -> is the folder name of the project
#   value -> is the git path of the project, can be empty
$laravels = @{}
#$laravels.add("test-hive", "https://github.com/q0015300153/test-hive.git")
$laravels.add("i1_home", "")