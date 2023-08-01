#!/bin/bash

# Array of all files to commit
files=($(find . -type f -not -path "*/\.*" | grep -v "node_modules" | grep -v "package-lock.json" | grep -v "pnpm-lock.yaml" | sort))

# Start date: August 1, 2023
start_date="2023-08-01"
# End date: September 30, 2023
end_date="2023-09-30"

# Convert dates to seconds since epoch
start_seconds=$(date -j -f "%Y-%m-%d" "$start_date" "+%s")
end_seconds=$(date -j -f "%Y-%m-%d" "$end_date" "+%s")

# Initialize git if not already
if [ ! -d ".git" ]; then
    git init
fi

# Loop through files and create commits
for file in "${files[@]}"; do
    # Generate random date between start and end
    random_seconds=$((RANDOM % (end_seconds - start_seconds) + start_seconds))
    commit_date=$(date -r $random_seconds "+%Y-%m-%d %H:%M:%S")
    
    # Random number of commits for this file (1-4)
    num_commits=$((RANDOM % 4 + 1))
    
    for ((i=1; i<=num_commits; i++)); do
        # Add and commit the file
        git add "$file"
        GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "Add $(basename "$file") - $(date -j -f "%Y-%m-%d %H:%M:%S" "$commit_date" "+%B %d, %Y %H:%M")"
        
        # Randomly decide if we should skip some days
        if [ $((RANDOM % 3)) -eq 0 ]; then
            # Skip 1-3 days
            skip_days=$((RANDOM % 3 + 1))
            random_seconds=$((random_seconds + skip_days * 86400))
            commit_date=$(date -r $random_seconds "+%Y-%m-%d %H:%M:%S")
        fi
    done
done 