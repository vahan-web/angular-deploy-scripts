[[ $1 = '' ]] && BRANCH="master" || BRANCH=$0

SSH_KEY_PATH="key.pem"
SERVER="root@172.31.7.111"
DEST_FOLDER="/var/www/vahan.com/html"
PARAMS="BRANCH=\"$BRANCH\" DEST_FOLDER=\"$DEST_FOLDER\""

echo ===================================================
echo Autodeploy server
echo selected branch $BRANCH
chmod 400 $SSH_KEY_PATH
echo ===================================================
echo Connecting to remote server...
ssh -i $SSH_KEY_PATH $SERVER $PARAMS 'bash -i'  <<-'ENDSSH'
    #Connected

    cd $DEST_FOLDER


    rm -rf node_modules/

    yum install npm

    pm2 stop app_name
    pm2 start app_name
    pm2 save
    pm2 list

    rsync -avzhe ssh --progress /home/vahan root@172.31.7.111:/var/www/vahan.com/html
    exit
ENDSSH
