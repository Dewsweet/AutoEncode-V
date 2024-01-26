@echo off
chcp 65001 > nul
mode con cols=60 lines=40 
setlocal enabledelayedexpansion

echo.
echo       *************************************************
echo       *              AutoEncoder v0.6                 *
echo       *            简易批处理视频编码脚本             *
echo       *                  By Dewsweet                  *
echo       *        虽然但是，还是图形操作界面用的多       *
echo       *************************************************
echo.

rem 拖入文件的路径
set input_file=%~1
rem 拖入文件的文件夹路径
set input_path=%~dp1
rem 文件命
set file_name=%~n1


rem 选择编码器

echo    [38;2;255;153;0m编码器选择:[m
echo.
echo               ffmpeg                1. x264
echo               2. x265               3. svt_av1
echo ************************************************************

set /p encoder_tool=选择需要使用的编码器：
for %%i in (ffmpeg ff mpeg fm f) do (
    if "%encoder_tool%"=="%%i" goto toffmpeg
)
for %%i in (1 x264 264 avc) do (
    if "%encoder_tool%"=="%%i" goto tox264
)
for %%i in (2 x265 265 hevc) do (
    if "%encoder_tool%"=="%%i" goto tox265
)
for %%i in (3 av1 svtav1 svt_av1) do (
    if "%encoder_tool%"=="%%i" goto toav1
)

:: ----------------------------------编码器选择----------------------------------
:toffmpeg
    echo ============================================================
    echo                         [38;2;68;157;68m# ffmpeg[m
    echo.
    echo    [38;2;255;153;0m用ffmpeg 干嘛:[m

    echo 1. 查看文件信息
    echo 2. 转换视频封装格式(支持多文件)
    echo 3. 视频文件抽流
    echo 4. 媒体文件混流
    echo 5. 媒体重编码

    set /p ffmpegto=选择需要实现的功能:
    if "%ffmpegto%"=="1" goto ffmpeg1
    if "%ffmpegto%"=="2" goto ffmpeg2
    if "%ffmpegto%"=="3" goto ffmpeg3
    if "%ffmpegto%"=="4" goto ffmpeg4
    if "%ffmpegto%"=="5" goto ffmpeg5

    ::功能选择
    :ffmpeg1
        echo ============================================================
        echo #ffmpeg
        echo 查看文件信息
        ffmpeg -i "%input_file%" -hide_banner 
        pause
        exit

    :ffmpeg2
        echo ============================================================
        echo #ffmpeg
        echo 转换封装格式

        echo 本功能主要是转换封装格式 内部媒体编码不会有任何改变

        echo 若你需要转换视频编码格式 可在下确认
        echo.
        
        set /p IsTransCoding=是否转码(Y,N):

        if /i "!IsTransCoding!"=="y" (
            goto TransCoding
        ) else (
            goto NoTransCoding
        )

        :TransCoding
        set /p container=转成什么(mkv mp4 mov avi wmv rmvb flv):
        echo 选择视频编码格式：
        echo 1. AVC
        echo 2. AVC(NV显卡加速)
        echo 3. HEVC
        echo 4. HEVC(NV显卡加速)
        echo 5. AV1
        set /p codec=输入数字选择视频编码格式:
        if "!codec!"=="1" (
            for %%i in (%*) do (
                set "input_file=%%i"
                set "file_name=%%~ni" 
                ffmpeg -y -i "!input_file!" -c:v libx264 -c:a copy -c:s copy "!file_name!.!container!"
            )
        )
        if "!codec!"=="2" (
            for %%i in (%*) do (
                set "input_file=%%i"
                set "file_name=%%~ni" 
                ffmpeg -y -i "!input_file!" -c:v h264_nvenc -c:a copy -c:s copy "!file_name!.!container!"
            )
        )
        if "!codec!"=="3" (
            for %%i in (%*) do (
                set "input_file=%%i"
                set "file_name=%%~ni" 
                ffmpeg -y -i "!input_file!" -c:v libx265 -c:a copy -c:s copy "!file_name!.!container!"
            )
        )  
        if "!codec!"=="4" (
            for %%i in (%*) do (
                set "input_file=%%i"
                set "file_name=%%~ni" 
                ffmpeg -y -i "!input_file!" -c:v hevc_nvenc -c:a copy -c:s copy "!file_name!.!container!"
            )
        )
        if "!codec!"=="5" (
            for %%i in (%*) do (
                set "input_file=%%i"
                set "file_name=%%~ni" 
                ffmpeg -y -i "!input_file!" -c:v libsvtav1 -c:a copy -c:s copy "!file_name!.!container!"
            )
        )
        pause
        exit

        :NoTransCoding
        set /p container=转成什么(mkv mp4 mov avi wmv rmvb flv):
        for %%i in (%*) do (
            set "input_file=%%i"
            set "file_name=%%~ni"  
            ffmpeg -y -i "!input_file!" -c copy "!file_name!.!container!" 
        )
        pause
        exit


    :ffmpeg3
        echo ============================================================
        echo #ffmpeg
        echo 抽流
        set ext=
        set "matched=false"

        for /f "delims=," %%i in ('ffmpeg -i "!input_file!" -hide_banner 2^>^&1 ^| findstr "Stream" ') do echo %%i

        set /p tracker=选择你要抽取的轨道:

        for /f "tokens=4 delims=, " %%a in ('ffmpeg -i "!input_file!" -hide_banner 2^>^&1 ^| findstr "#0:!tracker!" ') do set "ext=%%a"

        echo 你选择的轨道的媒体格式为:!ext!
        if "!ext!"=="av1" set "ext=ivf"

        for %%b in (hevc h265 avc h264 av1 ivf aac flac wav ac3 opus mp3 ass srt) do (
            if "!ext!"=="%%b" (
                set "matched=ture"
                ffmpeg -i "!input_file!" -map 0:!tracker! -c copy output.!ext!
            )
        )

        if not "!matched!"=="ture" (
            set /p next=输入自定义扩展名:
            ffmpeg -i "!input_file!" -map 0:!tracker! -c copy output.!next!
        )

        set /p retrun=是否需要再次执行(y,n)
        if "%retrun%"=="y" goto ffmpeg3
        exit

    :ffmpeg4
        echo ============================================================
        echo #ffmpeg
        echo 封装

        set "IsSwitch=false"
        set "inputFiles="
        set "InputSub="       

        set /p container=选择封装格式(mkv mp4):
        if /i "%container%"=="mkv" (
            goto muxmkv 
        ) else (
            goto muxvideo
        )

        :muxmkv
        echo muxmkv
        echo 你将要封装的文件如下:

        for %%a in (%*) do (
            echo %%a
            set "InputJudge=%%~xa"
            if /i "!InputJudge!"==".ivf" (
                set "IsSwitch=ture"
                set "inputFiles=!InputFiles! -i "%%a""
            ) else if "!IsSwitch!"=="ture" (
                set "inputFiles=!InputFiles! -i "%%a""
            ) else (
                set "InputFiles=!InputFiles! "%%a""
            )
        )
        if "!IsSwitch!"=="ture" (
            echo ffmpeg !inputFiles! -c copy output_mux.!container!
        ) else (
            mkvmerge -o output_mux.mkv !InputFiles!
        )
        pause
        exit

        :muxvideo
        echo mux!container!
        echo 你将要封装的文件如下:

        for %%a in (%*) do (
            echo %%a
            set "InputJudge=%%~xa"
            for %%b in (.hevc .h265 .avc .h264 .ivf) do (
                if /i "!InputJudge!"=="%%b" (
                ffmpeg -i "%%a" -c copy "%%~na_cache.mp4" >nul 2>nul
                set "InputFiles=!InputFiles! -i "%%~dpna_cache.mp4""
                set "IsSwitch=true"
                )
            )
            for %%b in (.ass .srt) do (
                if /i "!InputJudge!"=="%%b" (
                    set "InputSub=!InputSub! -vf subtitles="%%~nxa""
                    set "IsSwitch=true"
                )
            )
            if not "!IsSwitch!"=="true" (
                set "inputFiles=!inputFiles! -i "%%a""
            )
            set "IsSwitch=false"

        )
        if defined InputSub (
            ffmpeg !inputFiles! !InputSub! output_mux.!container!
        ) else (
            ffmpeg !inputFiles! -c copy output_mux.!container!
        )
        for %%c in (*cache.mp4) do del "%%c"
        pause
        exit
    
    :ffmpeg5
        echo ============================================================
        echo #ffmpeg

        echo 简易体重编码

        echo 支持批量处理一次只能处理一种格式

        for %%a in (%*) do (
            echo %%a
            set "InputExt=%%~xa"
            for %%b in (.avc .h264 .264 .hevc .h265 .265 .lvf) do (
                if /i "!InputExt!"=="%%b" (
                    echo 你输入的是视频编码格式

                    echo 请选择需要需要转换媒体格式的编码器
                    echo.
                    echo HEVC/H.265 : libx265 / hevc_nvenc / hevc_qsv
                    echo AVC/H.264 : libx264 / h264_nvenc / h264_qsv
                    echo AV1 : libsvtav1 / libaom-av1 / av1_qsv
                goto tsvideo
                )

            )
            for %%c in (.wav .flac .mp3 .aac .opus .ape .ac3 .ogg) do (
                if /i "!InputExt!"=="%%c" (
                    echo 你输入的是音频编码格式

                    echo 请选择需要需要转换媒体格式的编码器:
                    echo.
                    echo FLAC : flac
                    echo OPUS : libopus
                    echo MP3 : libmp3lame
                    echo AAC : libfdk_aac / aac
                    echo AC3 : ac3  / ac3_fixed
                    goto tsaudio
                )
            )
            for %%d in (.png .jpg .jpeg .bmp .webp .avif .heif .jxl .tiff .tif) do (
                if /i "!InputExt!"=="%%d" (
                    echo 你输入的是图片编码格式

                    echo ffmpeg转换图片并不是强项,多少有点问题

                    echo 请选择需要需要转换媒体格式的编码器:
                    echo.
                    echo PNG : png
                    echo JPG2000 : jpeg2000
                    echo WEBP : libwebp
                    echo AVIF : libsvtav1
                    echo JXL : libjxl
                    goto tspicture
                )
            )
        )

        :tsvideo
        set /p codec=请输入编码器名称:

        for %%i in (hevc h.265 265 libx265 hevc_nvenc hevc_qsv) do (
            if /i "!codec!"=="%%i" set OutputExt=h264
        )
        for %%i in (avc h.264 264 libx264 h264_nvenc h264_qsv) do (
            if /i "!codec!"=="%%i" set OutputExt=h265
        )
        for %%i in (av1 libsvtav1 libaom-av1 av1_qsv) do (
            if /i "!codec!"=="%%i" set OutputExt=mp4
        )

        for %%a in (%*) do (
            ffmpeg -i "%%a" -c:v !codec! "%%~na_!codec!.!OutputExt!"
        )
        pause
        exit

        :tsaudio
        set /p codec=请输入编码器名称:
        for %%i in (flac aac ac3) do (
            if /i "!codec!"=="%%i" set OutputExt=!codec!
            )
        if /i "!codec!"=="libmp3lame" set OutputExt=mp3
        if /i "!codec!"=="libopus" set OutputExt=opus
        if /i "!codec!"=="libfdk_aac" set OutputExt=aac
        if /i "!codec!"=="ac3_fixed" set OutputExt=ac3

        for %%a in (%*) do (
            ffmpeg -i "%%a" -c:v !codec! "%%~na_!codec!.!OutputExt!"
        )
        pause
        exit

        :tspicture
        set /p codec=请输入编码器名称:

        if /i "!codec!"=="png" set OutputExt=png
        if /i "!codec!"=="jpeg2000" set OutputExt=jpg
        if /i "!codec!"=="libwebp" set OutputExt=webp
        if /i "!codec!"=="libsvtav1" set OutputExt=avif
        if /i "!codec!"=="libjxl" set OutputExt=jxl

        for %%a in (%*) do (
            ffmpeg -i "%%a" -c:v !codec! "%%~na_!codec!.!OutputExt!"
        )
        pause
        exit


:tox264
    echo ============================================
    echo # x264
    set ectool=x264
    set output_ext=.avc
    ::参数选择
        echo 1. 动画-Webrip
        echo 2. 动画-BDrip
        echo 3. 普通电影
        echo 4. 日常
        echo 5. 其他(存档)

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="1" set encoder_par=--preset veryslow --me umh --subme 9 --merange 32 --no-fast-pskip --weightb --keyint 240 --min-keyint 1 --bframes 10 --b-adapt 2 --ref 3 --rc-lookahead 70 --crf 21 --qcomp 0.7 --chroma-qp-offset -2 --aq-mode 3 --aq-strength 0.7 --deblock 0:-1 --psy-rd 0.6:0.15 --range tv --colorprim bt709

        if "%parameter%"=="2" set encoder_par=--preset veryslow --me tesa --subme 9 --merange 32 --no-fast-pskip --direct auto --weightb --keyint 240 --min-keyint 1 --bframes 8 --b-adapt 2 --ref 3 --rc-lookahead 72 --crf 17 --qcomp 0.7 --qpmin 9 --chroma-qp-offset -2 --aq-mode 3  --aq-strength 0.7 --trellis 2 --deblock -1:-1 --psy-rd 0.6:0.15 --range tv --colorprim bt709 --transfer bt709 --colormatrix bt709

        if "%parameter%"=="3" set encoder_par=--preset veryslow --me esa --subme 10 --merange 32 --no-fast-pskip --direct auto --weightb --keyint 300 --min-keyint 1 --bframes 12 --b-adapt 2 --ref 3 --rc-lookahead 90 --crf 19 --qcomp 0.7 --qpmin 8 --chroma-qp-offset -2 --aq-mode 3 --aq-strength 0.7 --trellis 2 --deblock -1:-1 --psy-rd 0.8:0.18 --fgo 12 

        if "%parameter%"=="4" set encoder_par=--preset veryslow --me umh --subme 9 --merange 24 --no-fast-pskip --direct auto --weightb --keyint 270 --min-keyint 5 --bframes 12 --b-adapt 2 --ref 6 --rc-lookahead 80 --crf 19 --qcomp 0.6 --qpmin 9 --chroma-qp-offset -2 --aq-mode 3  --aq-strength 0.8 --trellis 2 --deblock 0:-1 --psy-rd 0.7:0.15

        if "%parameter%"=="5" set encoder_par=--preset veryslow --me esa --subme 10 --merange 40 --no-fast-pskip --direct auto --weightb --keyint 70 --min-keyint 1 --bframes 12 --b-adapt 2 --ref 3 --crf 16 --tune grain --trellis 2 --fgo 15
    echo ============================================
    echo # x264开始压制
    %ectool% %encoder_par% --output "%input_path%\%file_name%%output_ext%" "%input_file%" 
    echo # 结束压制
    pause
    exit

:tox265
    echo ============================================
    echo # x265
    set ectool=x265
    set output_ext=.hevc
    ::参数选择
        echo 1. 通用
        echo 2. 动画-Webrip
        echo 3. 动画-BDrip
        echo 4. 4K电影
        echo 5. 其他(存档)

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="1" set encoder_par=--preset slower --ctu 32 --min-cu-size 16 --tu-intra-depth 3 --tu-inter-depth 3 --limit-tu 1 --rdpenalty 1 --me umh --subme 4 --merange 32 --weightb --ref 3 --max-merge 2 --early-skip --no-open-gop --keyint 300 --min-keyint 5 --fades --bframes 8 --b-adapt 2 --b-intra --crf 19 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --aq-mode 3 --aq-strength 0.7 --limit-modes --limit-refs 1 --rskip 1 --rc-lookahead 90 --tskip-fast --rect --amp --rd 3 --rdoq-level 1 --psy-rd 1.6 --limit-sao --deblock 0:-1 --allow-non-conformance

        if "%parameter%"=="2" set encoder_par=--preset slower --ctu 32 --min-cu-size 16 --tu-intra-depth 3 --tu-inter-depth 3 --limit-tu 3 --rskip 0 --me star --subme 5 --merange 32 --weightb --max-merge 3 --ref 5 --no-open-gop --keyint 240 --min-keyint 1 --fades --bframes 10 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 18 --qcomp 0.6 --cbqpoffs -2 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --hevc-aq --aq-strength 0.9 --qg-size 16 --rc-lookahead 80 --no-rect --no-amp  --rd 4 --psy-rdoq 0.5 --rdoq-level 2 --psy-rd 1.5 --no-sao --deblock 0:-1

        if "%parameter%"=="3" set encoder_par=--preset veryslow --ctu 32 --tu-intra-depth 4 --tu-inter-depth 4 --limit-tu 0 --rskip 0 --me star --subme 3 --merange 32 --weightb --max-merge 4 --ref 3 --no-open-gop --keyint 240 --min-keyint 1 --fades --bframes 8 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 16 --qcomp 0.6 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --hevc-aq --aq-strength 0.8 --qg-size 16 --rc-lookahead 80 --no-rect --no-amp --rd 5 --psy-rdoq 0.5 --rdoq-level 2 --psy-rd 1.5 --no-sao --deblock -1:-1 --colorprim bt709 --transfer bt709 --colormatrix bt709 --range limited

        if "%parameter%"=="4" set encoder_par=--preset veryslow --ctu 64 --tu-intra-depth 4 --tu-inter-depth 4 --limit-tu 0 --rskip 0 --me umh --subme 4 --merange 57 --weightb --max-merge 3 --ref 5 --no-open-gop --keyint 360 --min-keyint 3 --fades --bframes 12 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 21 --qcomp 0.6 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.5 --aq-mode 4 --aq-strength 1.2 --qg-size 16 --rc-lookahead 72 --no-rect --no-amp --rd 3 --rdoq-level 2 --psy-rd 2.2 --limit-sao --deblock 0:-1 

        if "%parameter%"=="5" set encoder_par=--preset slower --ctu 32 --me star --subme 4 --merange 48 --max-merge 4 --early-skip --no-open-gop --keyint 220 --min-keyint 1 --ref 3 --fades --bframes 7 --b-adapt 2 --b-intra --crf 17 --cbqpoffs -3 --crqpoffs -2 --rd 3 --limit-modes --limit-refs 1 --rskip 1 --rc-lookahead 90 --splitrd-skip --deblock -1:-1 --tune grain
    echo ============================================
    echo # x265开始压制

    for /f %%a in ('ffprobe -v error -select_streams v^:0 -show_entries stream^=nb_frames -of default^=noprint_wrappers^=1^:nokey^=1 "%input_file%" ') do set in_frames=%%a

    ffmpeg -i "%input_file%" -an -pix_fmt yuv420p -f yuv4mpegpipe -strict unofficial - | %ectool% --frames %in_frames% --y4m %encoder_par% --output "%input_path%\%file_name%%output_ext%" - log.txt
    echo # 结束压制
    pause
    exit

:toav1
    echo ============================================
    echo # svt_av1
    set ectool=svtav1
    set output_ext=.ivf
    ::参数选择
        echo 1. 通用
        echo 2. 动画-BDrip

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="1" set encoder_par=--preset 4 --rc 0 --qp 30 --max-qp 55 --min-qp 8 --crf 23 --aq-mode 2 --keyint 300 --irefresh-type 2 --scd 1 --lookahead 80 --scm 2 --enable-tpl-la 1

        if "%parameter%"=="2" set encoder_par=--preset 3 --rc 0 --qp 25 --max-qp 50 --crf17 --aq-mode 2 --keyint 240 --irefresh-type 2 --scd 1 --lookahead 80 --scm 1 --enable-tpl-la 1

    echo ============================================
    echo # AV1开始压制
    ffmpeg -i "%input_file%" -an -pix_fmt yuv420p -f yuv4mpegpipe -strict unofficial - | %ectool% %encoder_par%  -b "%input_path%\%file_name%%output_ext%" -i stdin 
    echo # 结束压制
    pause
    exit




