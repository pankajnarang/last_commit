set -o errexit
set -o nounset
set -o pipefail

main() {
    local repo_root
    local changed_files
    repo_root=$(git rev-parse --show-toplevel)
    echo $repo_root
    pushd "$repo_root" > /dev/null

    echo "Discovering changed files since last commit..."
    readarray -t changed_files <<< $(git diff --find-renames --name-only HEAD HEAD~1 | awk -F'/' '{print $1}' | uniq)

    if [[ -n "${changed_files[*]}" ]]; then
        echo "Changes detected"

        for files in "${changed_files[@]}"; do
            if [[ -d "$files" ]]; then
                echo "folderName=$files"
                echo "folderName=$files" >> $GITHUB_ENV
            else
                echo "Files '$files' is not a part of any service. Skipping it..."
            fi
        done
    else
        echo "Nothing to do. No file changes detected."
    fi

    popd > /dev/null
}

main "$@"
