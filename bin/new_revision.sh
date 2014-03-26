
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
    
    subject=$"Subject: New unstable release (old:$old_rev cur:$rev)"$'\n'

    cd /home/lojze/newhacks/nnixmy/pkgs/nixpkgs
    git_change_tree=$(git log --graph --decorate=full  --name-status "$old_rev".."$rev")

    content="$message\n\n\n"$"$git_change_tree\n"

    send_to="To: lojze.blatnik@gmail.com\n";
    from="From: Auto Message <automessage@blatnik.org>\n";
    
    mail_message=$"$from$send_to$subject""Content-type:text/plain\n\n$content"
    echo -e "$mail_message"  
    echo -e "$mail_message" | sendmail -t -r automessage@blatnik.org 
fi


exit 0 



