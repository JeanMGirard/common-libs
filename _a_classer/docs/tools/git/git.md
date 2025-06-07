# Git

```bash
for d in ./*; do
  cd $d
  
  cd ../
done
```
```powershell
Get-ChildItem –Path "." -Directory -Exclude .* | Foreach-Object {
    cd $_.FullName
    git checkout master
    git pull
    cd ../
}
```


## Snippets


## Loops

```shell
for d in ./tks-*; do
  cd $d
  # Pull all
  # Replace remotes
  cd ../
done
```
```powershell
Get-ChildItem –Path "." -Directory -Exclude .* | Foreach-Object {
    cd $_.FullName
    
    cd ../
}
```

### Pull all branches, tags, etc

```shell
git add .
git stash
hub sync
git branch -r | grep -v '\->' | while read remote; do 
  git branch --track "${remote#origin/}" "$remote"
done
git fetch --all
git pull --all
```

### Replace remotes

```shell
if git remote get-url origin | grep -q "gonebig.com"; then 
  git remote set-url origin $(git remote get-url origin \
    | sed 's/gonebig.com:/gitlab.com:ticksmith-corp\//')
fi
```
```powershell
if ("$(git remote get-url origin)" -match "gonebig.com"){
  $origin=(git remote get-url origin)
  git remote set-url origin ($origin -replace 'gonebig.com:', 'gitlab.com:ticksmith-corp/')
}
```

### Remove file from history

```shell
git filter-branch --index-filter 'rm -f Resources\Video\%font%.ttf' -- --all
```


