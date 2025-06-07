# Permissions

## Users & Groups

### Apps used by your user

For anything that should not be used outside the scope of your user,
first create a GID & a UUID ranges of subordinates

```shell
UUID_STR=1100
UUID_END=1150
GID_STR=1100
GID_END=1150

sudo usermod $USER \
    --add-subgids ${GID_STR}-${GID_END} \
    --add-subuids ${UUID_STR}-${UUID_END}
```

```shell
GID=$(( $GID_STR + 1 ));

sudo groupadd -g $((GID++)) golang
sudo groupadd -g $((GID++)) node
sudo groupadd -g $((GID++)) ruby
sudo groupadd -g $((GID++)) terraform
```
