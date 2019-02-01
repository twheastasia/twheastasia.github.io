#!/bin/bash
git checkout dev
git add .
git commit -m 'update to dev'
git push
#hexo generate && hexo deploy
