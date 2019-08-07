i1-new-php
==========

###### tags: `php` `laravel` `bash`

上方為中文說明  
Chinese description above  

下方英文說明為 Google 翻譯  
The English description below is Google Translate  

專案說明
---
配合 docker-compose 建立 php 的開發測試環境  
使用以下腳本可快速建立 NginX + PHP + MariaDB 開發環境  

可搭配其他 docker-compose 專案  
比如預設搭配以 docker-compose 建立的 Hadoop Hive 專案  

然後以 Laravel 測試 PHP 連接 Hive  
可以有多個 Laravel 專案  
提供了幫助建立專案的腳本 *add-laravel.sh*  

使用說明
---
先修改 *projects-list.sh* 檔案要啟動的專案清單  
預設是 Hadoop Hive + LNMP  
如果不要 Hadoop Hive 可以將其註解掉  
```bash
declare -A projects
#projects[service-hive]=https://github.com/q0015300153/service-hive.git
projects[service-lnmp]=https://github.com/q0015300153/service-lnmp.git
```

>如果該專案資料夾已存在，或有同名資料夾，將不會新增或下載專案 ，如果要重新下載請刪除該資料夾，或使用其他的名稱  

預設會下載 test-hive 這個 Laravel 專案  
用於測試 PHP 連線 Hadoop Hive 的連接方案  
如果不需要可以將其註解掉  
```bash
declare -A laravels
#laravels[test-hive]=https://github.com/q0015300153/test-hive.git
```

>如果該專案資料夾已存在，或有同名資料夾，將不會新增或下載 Laravel，如果要重新下載請刪除該資料夾，或使用其他的名稱  

#### 然後執行啟動
```bash
sh docker-run.sh
```

成功之後開啟 http://localhost/  
可以看見 `phpinfo();` 的結果  

#### 新增 Laravel 專案
```bash
sh add-laravel.sh new-project
```

成功之後開啟 http://localhost/new-project/  
可以看見 Laravel 的首頁

#### 停止所有服務
```bash
sh docker-stop.sh
```

檔案說明
---
*projects-list.sh*  
指定要啟動哪些專案  
採用 key - value 的方式紀錄要啟動的專案  
　　key   -> 是專案的資料夾名稱  
　　value -> 是專案的 git 路徑，可以為空  

*docker-up.sh*  
用於啟動選擇的專案  
修改 **projects-list.sh** 裡面的 **projects** 變數來設定要啟動的 docker-compose 專案  
修改 **projects-list.sh** 裡面的 **laravels** 變數來設定要下載的 Laravel 專案  

預設會以 **docker-compose up** 執行  
也可以輸入參數來改變執行指令  
如：`sh docker-up.sh build`  

*docker-stop.sh*  
用於停止選擇的專案  
修改 **projects-list.sh** 裡面的 **projects** 變數來設定要啟動的 docker-compose 專案  

*remove-all.sh*  
移除所有 docker 資源  
**警告!謹慎使用!**

*add-laravel.sh*  
用來新增 Laravel 專案  
新增專案語法 `sh add-laravel.sh [專案名稱]`  
```bash
sh add-laravel.sh test-hive
```

git clone 專案語法 `sh add-laravel.sh [專案名稱] [git 網址]`  
```bash
sh add-laravel.sh test-hive https://github.com/q0015300153/test-hive.git
```

會自動建立 NginX 的 alias 檔案  
新增完後可連接 `http://localhost/[專案名稱]` 來開啟 Laravel 網頁  
```
http://localhost/test-hive
```

- - -

Project description
---
Create a php development test environment with docker-compose  
Use the following script to quickly build an NginX + PHP + MariaDB development environment  

Can be used with other docker-compose projects  
For example, the default Hadoop Hive project built with docker-compose  

Then test the PHP connection with Laravel Hive  
Can have multiple Laravel projects  
Provides scripts to help build projects *add-laravel.sh*  

Instructions for use
---
First modify the *projects-list.sh* file to start the project list  
The default is Hadoop Hive + LNMP  
If you don't want Hadoop Hive, you can annotate it.  
```bash
declare -A projects
#projects[service-hive]=https://github.com/q0015300153/service-hive.git
projects[service-lnmp]=https://github.com/q0015300153/service-lnmp.git
```
>If the project folder already exists or has a folder with the same name, the project will not be added or downloaded. If you want to re-download, please delete the folder or use another name.

The test will be downloaded test-hive this Laravel project  
Connection scheme for testing PHP connection Hadoop Hive  
If you don't need it, you can annotate it  
```bash
declare -A laravels
#laravels[test-hive]=https://github.com/q0015300153/test-hive.git
```
>If the project folder already exists or has a folder with the same name, Laravel will not be added or downloaded. If you want to re-download, please delete the folder or use another name.  

#### Then execute the startup
```bash
sh docker-run.sh
```

Open http://localhost/ after success  
You can see the result of `phpinfo();`  

#### Add Laravel project
```bash
sh add-laravel.sh new-project
```

Open http://localhost/new-project/ after success  
You can see Laravel's homepage.

#### Stop all services
```bash
sh docker-stop.sh
```

File description
---
*projects-list.sh*  
Specify which projects to launch  
Record the project to be started by using key - value  
　　key   -> Is the folder name of the project  
　　value -> Is the git path of the project, can be empty  

*docker-up.sh*  
Project for launching the selection  
Modify the **projects** variable in **projects-list.sh** to set the docker-compose project to be launched.  
Modify the **laravels** variable in **projects-list.sh** to set the Laravel project to download  

The default will be executed with **docker-compose up**  
You can also enter parameters to change the execution instructions.  
Ex：`sh docker-up.sh build`  

*docker-stop.sh*  
Project to stop selection  
Modify the **projects** variable in **projects-list.sh** to set the docker-compose project to be launched.  

*remove-all.sh*  
Remove all docker resources  
**Warning! Use with caution!**  

*add-laravel.sh*  
Used to add a Laravel project  
Add project grammar `sh add-laravel.sh [Project name]`  
```bash
sh add-laravel.sh test-hive
```

Git clone project syntax `sh add-laravel.sh [Project name] [git 網址]`  
```bash
sh add-laravel.sh test-hive https://github.com/q0015300153/test-hive.git
```

Will automatically create an alias file for NginX  
Connected after adding `http://localhost/[Project name]` to open the Laravel webpage
```
http://localhost/test-hive
```