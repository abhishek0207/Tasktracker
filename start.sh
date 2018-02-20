export PORT=5102

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
