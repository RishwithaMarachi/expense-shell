a=10
while [ "$a" -eq 0 ];
do
    echo Hello world
    a=$(($a-1))
    sleep 1
done