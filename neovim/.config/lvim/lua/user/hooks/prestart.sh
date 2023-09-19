if command -v nvm > /dev/null 2>&1; then
  nvm install 16
  nvm use 16
else
  echo "nvm not founded"

if command -v sdk > /dev/null 2>&1; then
  sdk install java 17.0.6-amzn
  sdk use java 17.0.6-amzn
else
  echo "nvm not founded"

  
