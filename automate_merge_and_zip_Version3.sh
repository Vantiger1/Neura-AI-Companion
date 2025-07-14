#!/bin/bash

# --- Configuration ---
declare -A repos=(
  ["Vantiger1/Neura-Companion"]="Neura-Companion"
  ["Vantiger1/Neura-AI-Companion"]="Neura-AI-Companion"
  ["Vantiger1/Neura-Companion-v1-0-8"]="Neura-Companion-v1-0-8"
  ["Vantiger1/Neura-Companion-ver.1.8.0"]="Neura-Companion-ver.1.8.0"
  ["Vantiger1/neuro-companion-ver.1.0.1"]="neuro-companion-ver.1.0.1"
  ["Vantiger1/Neura-Companion-ver1.0.0"]="Neura-Companion-ver1.0.0"
  ["Vantiger-Construction/Neura-AI-Companion"]="Neura-AI-Companion-Construction"
  ["Vantiger-Construction/Neura-AI-Companion1"]="Neura-AI-Companion1-Construction"
  ["Vantiger1/NeuraCompanion_ForTesting_1"]="NeuraCompanion_ForTesting_1"
  ["Vantiger-Construction/Neura-Companion-Ver.-1.5"]="Neura-Companion-Ver.-1.5-Construction"
)

declare -A descs=(
  ["Vantiger1/Neura-Companion"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger1/Neura-AI-Companion"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger1/Neura-Companion-v1-0-8"]="Files for Neura."
  ["Vantiger1/Neura-Companion-ver.1.8.0"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger1/neuro-companion-ver.1.0.1"]=""
  ["Vantiger1/Neura-Companion-ver1.0.0"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger-Construction/Neura-AI-Companion"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger-Construction/Neura-AI-Companion1"]="This is the first of its kind A. I. to help with life in general. Still have some work to do and code will be put together soon."
  ["Vantiger1/NeuraCompanion_ForTesting_1"]=""
  ["Vantiger-Construction/Neura-Companion-Ver.-1.5"]="Neura Companion is a one stop shop for everything about you. It is the app that will make you a better you."
)

declare -A langs=(
  ["Vantiger1/Neura-Companion"]="Dart (68.3%), HTML (31.7%)"
  ["Vantiger1/Neura-AI-Companion"]="Dart (88.2%), Batchfile (9.9%), Other (1.9%)"
  ["Vantiger1/Neura-Companion-v1-0-8"]="Dart (85.5%), Batchfile (10.7%), Shell (3.8%)"
  ["Vantiger1/Neura-Companion-ver.1.8.0"]="Dart (72.7%), Batchfile (27%), HTML (0.3%)"
  ["Vantiger1/neuro-companion-ver.1.0.1"]="CMake (47.8%), C++ (26.2%), Dart (9.2%), Nix (6.4%), HTML (6.2%), C (3.6%), Kotlin (0.6%)"
  ["Vantiger1/Neura-Companion-ver1.0.0"]="HTML (99.1%), Other (0.9%)"
  ["Vantiger-Construction/Neura-AI-Companion"]="Dart (88.2%), Batchfile (9.9%), Other (1.9%)"
  ["Vantiger-Construction/Neura-AI-Companion1"]="Dart (87.6%), Batchfile (10.4%), Other (2%)"
  ["Vantiger1/NeuraCompanion_ForTesting_1"]="Dart (100%)"
  ["Vantiger-Construction/Neura-Companion-Ver.-1.5"]="(Unknown)"
)

MERGED_DIR="Neura-Companion-Merged"
mkdir -p "$MERGED_DIR"

echo "Starting clone and merge..."

for repo in "${!repos[@]}"; do
  folder="${repos[$repo]}"
  echo "Cloning $repo ..."
  git clone --depth 1 "https://github.com/$repo.git" "$folder-tmp"

  mkdir -p "$MERGED_DIR/$folder"
  rsync -a --exclude=".git" --exclude=".github" "$folder-tmp/" "$MERGED_DIR/$folder/"

  # Create README_ORIGIN.md in subfolder
  cat > "$MERGED_DIR/$folder/README_ORIGIN.md" <<EOF
# $folder

**Original Repository:** $repo  
**Description:** ${descs[$repo]}  
**Languages:** ${langs[$repo]}

---
*This folder contains the full contents of the original repository, organized for clarity.*
EOF

  # Clean up
  rm -rf "$folder-tmp"
done

echo "Creating zip file..."
zip -r "${MERGED_DIR}.zip" "$MERGED_DIR"

echo "Done. Your zip file is: ${MERGED_DIR}.zip"