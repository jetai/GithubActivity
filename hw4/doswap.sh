#/bin/bash

new="$1"
function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}
function getimages {
    docker images $1 > /tmp/yy_xx
    docker ps > /tmp/yy
    if grep -w --quiet $new /tmp/yy;
    then
        echo "New image is already running"
        exit 1
    elif ! grep -w --quiet $1 /tmp/yy_xx;
    then
        echo "Image not Found"
        exit 1
    else
        if grep --quiet web1 /tmp/yy;then
            image_name="web2"
            old="web1"
            id=2
        else
            image_name="web1"
            old="web2"
            id=1
        fi
    fi
}
function start_new {
    echo "Starting your new container......"
    docker run --name $image_name --network ecs189_default -d -P  $new
}

if [[ -z "$new"  ]]; then
   printf '%s\n' "Please enter the name of the new image"
   printf '%s\n' "./doswap.sh [new]"
   exit 1
fi
getimages $new
sleep 2 && start_new

docker exec -it ecs189_proxy_1 chmod 777 /bin/swap$id.sh
docker exec -it ecs189_proxy_1 /bin/bash /bin/swap$id.sh
killitif $old

# Cleaning up
zoms=$(docker ps -qa --no-trunc --filter "status=exited")
if [[ "$zoms" != "" ]]; then
    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
fi
echo "SUCCESS YOUR APP IS READY TO GO! :)"