#!/bin/bash
cd "$(dirname "$0")"

git init
git add .
git commit -m "🚀 Initial commit of Neura AI Companion"
git branch -M main
git remote add origin https://github.com/Vantiger1/Neura-AI-Companion.git
git push -u origin main

echo "✅ Neura has been successfully pushed to GitHub!"