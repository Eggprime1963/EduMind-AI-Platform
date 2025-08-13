# Files to keep (essential for the application)
$keep_files = @(
    "pom.xml",
    "Dockerfile", 
    "docker-compose.yml",
    ".dockerignore",
    ".gitignore",
    ".railwayignore",
    "railway.json",
    "vercel.json",
    "README.md",
    "src",
    "target",
    "learning_management_main.sql",
    "notifications-table.sql",
    ".git",
    ".vscode",
    "nb-configuration.xml"
)

# Get all items in current directory
$all_items = Get-ChildItem -Force

# Remove items not in keep list
foreach ($item in $all_items) {
    if ($item.Name -notin $keep_files) {
        Write-Host "Removing: $($item.Name)"
        if ($item.PSIsContainer) {
            Remove-Item -Path $item.FullName -Recurse -Force
        } else {
            Remove-Item -Path $item.FullName -Force
        }
    }
}

Write-Host "Cleanup completed. Kept only essential files."
