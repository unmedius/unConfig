function cd
    z $argv
    ls
end


function gacp
    git add .
    echo "Enter a commit message:"
    read user_message
    git commit -m "$user_message"
    git push origin main
end
