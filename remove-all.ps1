###############################
# 移除所有 docker 資源         #
# 警告!謹慎使用!               #
# Remove all docker resources #
# Warning! Use with caution!  #
###############################

docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker rmi -f $(docker images -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)