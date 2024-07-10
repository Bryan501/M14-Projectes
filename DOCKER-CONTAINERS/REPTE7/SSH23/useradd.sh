#! /bin/bash

for user in unix01 unix02 unix03 unix04 unix05
do
    useradd -m $user
    echo $user:$user | chpasswd
done

