
@echo off

:: Navigate to your project directory
cd /d "path\to\neura-companion"

:: Create LICENSE file
echo MIT License> LICENSE
echo.>> LICENSE
echo Copyright (c) 2025 Steven VanTiger>> LICENSE
echo.>> LICENSE
echo Permission is hereby granted, free of charge, to any person obtaining a copy>> LICENSE
echo of this software and associated documentation files (the "Software"), to deal>> LICENSE
echo in the Software without restriction, including without limitation the rights>> LICENSE
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell>> LICENSE
echo copies of the Software, and to permit persons to whom the Software is>> LICENSE
echo furnished to do so, subject to the following conditions:>> LICENSE
echo.>> LICENSE
echo The above copyright notice and this permission notice shall be included in all>> LICENSE
echo copies or substantial portions of the Software.>> LICENSE
echo.>> LICENSE
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR>> LICENSE
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,>> LICENSE
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE>> LICENSE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER>> LICENSE
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,>> LICENSE
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE>> LICENSE
echo SOFTWARE.>> LICENSE

:: Update README.md
echo.>> README.md
echo ## License>> README.md
echo Neura Companion is licensed under the [MIT License](LICENSE).>> README.md
echo Copyright © 2025 Steven VanTiger.>> README.md

:: Note: Git commands must be executed manually from Git Bash or terminal.
echo Please run the following git commands manually:>> setup_instructions.txt
echo git add LICENSE README.md>> setup_instructions.txt
echo git commit -m "Add MIT License and update README with license details">> setup_instructions.txt
echo git push origin main>> setup_instructions.txt

echo Done! Check LICENSE and README.md files.
pause
