commit_info=$1
if [ -z "$1" ]
then
   echo "place input commit_info:"   
   read commit_info
fi
echo "bake theme_setting"
cp -f themes/hexo-theme-next/_config.yml theme_setting_bak

echo ""
hexo clean
hexo d -g

echo "back all file to github"
git status
git add .
git commit -m ${commit_info}
git push origin master
