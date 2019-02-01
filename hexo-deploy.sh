#!/bin/bash
hexo generate && hexo deploy
git checkout dev
git add .
git commit -m 'update to dev'
git push
