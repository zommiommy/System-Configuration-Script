#!/bin/bash

DIR=$(dirname "$(realpath $0)")

sudo mkdir /dockers
sudo chmod 777 /dockers

cp $DIR/* /dockers

bash $(find $DIR -iname build.sh)