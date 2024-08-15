function git_auto
    git add .
    echo "Enter a commit message:"
    read user_message
    git commit -m "$user_message"
    git commit -m "clean stuff"
end

