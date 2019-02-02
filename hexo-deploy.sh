#!/bin/bash
hexo generate && hexo deploy
git pull
git add .
git commit -m 'update to dev'
git push
