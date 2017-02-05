hwNum=$1

if [ -e "./HW$hwNum" ]; then
  echo "./HW$hwNum: Already exists"
  exit
fi

cp -r "./Template" "./HW$hwNum"
mv "./HW$hwNum/hw1.tex" "./HW$hwNum/hw$hwNum.tex"

if [ -e "./HW$hwNum/out/" ]; then
  rm -r "./HW$hwNum/out/"
fi
