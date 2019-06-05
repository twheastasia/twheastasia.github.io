#!/bin/bash
./node_modules/.bin/hexo generate && ./node_modules/.bin/hexo deploy
git pull
git add .
git commit -m 'update to dev'
git push
