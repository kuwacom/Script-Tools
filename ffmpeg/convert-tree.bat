@echo off
setlocal enabledelayedexpansion

set "input_directory=./input"
set "output_directory=./output"
set "output_extension=.mp4"

echo "Select processing method:"
echo "1. CPU"
echo "2. GPU"

set /p choice="Enter choice (1 or 2): "
if %choice% equ 1 (
    set "encoder=h264"
) else (
    set "encoder=h264_nvenc"
)

for %%A in ("%input_directory%") do set "input_full_path=%%~fA"
for %%A in ("%output_directory%") do set "output_full_path=%%~fA"

for /r "%input_directory%" %%F in (*.*) do (
    set "input_file=%%F"
    set "input_file_name=%%~nF"
    set "input_file_path=%%~dpF"
    set "output_inner_path=!input_file_path:%input_full_path%\=!"
    
    if not exist "!output_full_path!\!output_inner_path!" (
        mkdir "!output_full_path!\!output_inner_path!"
        echo Created directory:!output_full_path!\!output_inner_path!
    ) else (
        echo Already exists directory: !output_full_path!\!output_inner_path!
    )

    echo Export !output_extension!: !output_full_path!\!output_inner_path!!input_file_name!!output_extension!
    ffmpeg -i "!input_file!" -c:v "!encoder!" -c:a aac -strict experimental -b:a 192k -y "!output_full_path!\!output_inner_path!!input_file_name!!output_extension!"
)
endlocal