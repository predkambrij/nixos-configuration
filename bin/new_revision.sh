
date > /tmp/new_rev_last_run 

rev=`wget -q  -S --output-document - http://nixos.org/channels/nixos-unstable/ 2>&1 | grep Location | awk -F '/' '{print $6}' | awk -F '.' '{print $3}'`

cur_dir=$(pwd)
old_rev_loc="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/old_revision" 
cd $cur_dir # go back where we started 
old_rev=$(cat $old_rev_loc)

if [ "$rev" != "$old_rev" ] && [ "$rev" != "" ]; then 
    message="$(date) current rev: $rev old rev: $old_rev"  
    echo "$rev" > "$old_rev_loc" 
    message="$message"$'\nsaved new state' 
    echo "$message"

    
    mail_message=$'Subject: New unstable release\n'
    mail_message="$mail_message""$message"$'\n'

    cd /home/lojze/newhacks/nnixmy/pkgs/nixpkgs
    git_change_tree=$(git log --graph --decorate=full  --name-status "$old_rev".."$rev")

    mail_message="$mail_message"$'\n\n'
    mail_message="$mail_message"$"$git_change_tree\n"

    echo 
    echo "Message sent:"
    echo "$mail_message"  
    echo "$mail_message" | sendmail lojze.blatnik@gmail.com 
fi


exit 0 



