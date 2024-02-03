@echo off
chcp 65001 > nul
title AutoEncode-V
setlocal enabledelayedexpansion

echo 初始化中......
ping 127.0.0.1 -n 2 > nul
mode con cols=60 lines=40 

rem ===================================信息打印==========================================
:sloop
cls
echo.
echo       *************************************************
echo       *              AutoEncode-V v1.0.1              *
echo       *                  By Dewsweet                  *
echo       *            简易批处理视频编码脚本             *
echo       *        虽然但是 还是图形操作界面用的多        *
echo       *************************************************
echo.

echo    [38;2;255;153;0m使用说明:[m
echo.
echo            1. 将需要处理的视频文件拖到本程序上
echo            2. 根据程序的文字提示选择相应的功能

echo            3. 等待程序处理完毕

echo            4. 根据提示关闭程序
echo.


echo    [38;2;255;153;0m注意事项:[m
echo.
echo            本程序只是简易的Wiodows批处理脚本

echo            核心功能都是由 ffmpeg 这样的开源媒体处理软件

echo            以及 x264 x265 svt_av1 这些开源视频编码器实现
echo.

echo    [38;2;255;153;0m编码器选择:[m
echo.
echo             0. [38;2;68;157;68mffmpeg(转码 抽流 封装)[m  
echo             1. [38;2;0;191;255mx264(压制)[m              
echo             2. [38;2;0;94;214mx265(压制)[m                 
echo             3. [38;2;188;32;92msvt_av1(压制)[m
echo.


rem ===================================变量初始化========================================

set input=%~1
set input_path=%~dp1
set input_name=%~n1
set input_ext=%~x1
set "output_ext="
set "IsSwitch=false"

echo ************************************************************
set /p encoder_tool=选择功能(输入名称或数字 并回车):
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

rem ==================================ffmepg 功能========================================
:toffmpeg
    cls
    echo.
    echo                         [38;2;68;157;68m# FFmpeg[m
    echo.
    echo    ****************************************************
    echo          [38;2;68;157;68mFFmpeg[m 是一个开源的音视频处理软件
    
    echo          可以做到你能想象到的对音视频的任何处理

    echo          包括但不限于转码、封装、抽流、压制、剪辑、合并

    echo          是数媒人在无数个濒临崩溃的夜晚中的量身利器
    echo    ****************************************************
    echo.

    echo    ====================================================
    echo    [38;2;255;153;0m功能说明:[m
    echo.
    echo          每个功能选项后面都有较详细的解释
    echo.

    echo          转封装：更改文件扩展名

    echo          重编码：转换文件编码格式

    echo          抽流：抽取视频文件的某一轨道

    echo          混流：将一堆文件封装成视频

    echo.
    echo          ^* ：支持批量处理

    echo          ^+ ：支持多个文件

    echo          ^& ：支持重复处理
    echo    ====================================================

    echo    [38;2;255;153;0m用 ffmpeg 干嘛:[m
    echo.
    echo             1. 查看文件信息
    echo             2. 转换视频封装格式 ^*+
    echo             3. 媒体文件重编码 ^*+
    echo             4. 视频文件抽流 ^&
    echo             5. 媒体文件混流 ^+
    echo.
    echo             [38;2;0;65;5m更多功能正在思考中……[m

    echo             [38;2;255;124;3m输入 0 返回编码器选择界面[m
    echo.

    echo ************************************************************
    set /p ffmpegto=选择功能(输入名称或数字 并回车):
    if "%ffmpegto%"=="1" goto ffmpeg1
    if "%ffmpegto%"=="2" goto ffmpeg2
    if "%ffmpegto%"=="3" goto ffmpeg3
    if "%ffmpegto%"=="4" goto ffmpeg4
    if "%ffmpegto%"=="5" goto ffmpeg5
    if "%ffmpegto%"=="0" goto sloop

    ::功能选择
    :ffmpeg1
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo =======================查看文件信息=========================
        echo.
        echo       查询媒体文件各轨道的具体信息，并输出到info.txt中
        echo.
        echo                     ···3秒后开始执行···
        ping 127.0.0.1 -n 4 >nul

        ffmpeg -i "%input%" -hide_banner 2>&1 | tee info.txt
        @REM start "" info.txt
        exit

    :ffmpeg2
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo =====================转换视频封装格式=======================
        echo.
        echo    [38;2;255;153;0m功能说明:[m
        echo.
        echo           本功能主要是转换视频的扩展名 
     
        echo           本质是复制 不会对视频编码格式进行转码
     
        echo           但也提供了基本转码的功能
             
        echo           可在下面确认是否转码
        echo.
        echo           由于每种封装对封装内容的要求不同

        echo           [38;2;255;68;68m不保证每种封装格式都能转换成功[m
        echo.   
        echo ************************************************************
        set /p IsTransCoding=是否转码(是:Y 否:N):
        echo.

        if /i "!IsTransCoding!"=="y" (
            goto TransCoding
        ) else (
            goto NoTransCoding
        )

        :TransCoding
        
        set /p container=转成什么(mkv mp4 mov avi wmv rmvb flv):
        echo.
        echo 选择视频编码格式：
        echo.
        echo                [38;2;0;191;255m1. AVC[m
        echo                [38;2;0;191;255m2. AVC[m [38;2;118;185;0m(NV显卡加速)[m
        echo                [38;2;52;152;219m3. HEVC[m
        echo                [38;2;52;152;219m4. HEVC[m [38;2;118;185;0m(NV显卡加速)[m
        echo                [38;2;188;32;92m5. AV1[m
        echo.
        set /p codec=输入数字选择视频编码格式:
        if "!codec!"=="1" (
            for %%i in (%*) do (
                set "input=%%i"
                set "input_name=%%~ni" 
                ffmpeg -y -vsync 0 -hwaccel auto -i !input! -c:v libx264 -preset veryslow -crf 19 -c:a aac -b:a 320k -c:s copy "!input_name!.!container!"
            )
        )
        if "!codec!"=="2" (
            for %%i in (%*) do (
                set "input=%%i"
                set "input_name=%%~ni" 
                ffmpeg -y -vsync 0 -hwaccel auto -i !input! -c:v h264_nvenc -preset slow -crf 17 -c:a aac -b:a 320k -c:s copy "!input_name!.!container!"
            )
        )
        if "!codec!"=="3" (
            for %%i in (%*) do (
                set "input=%%i"
                set "input_name=%%~ni" 
                ffmpeg -y -vsync 0 -hwaccel auto -i !input! -c:v libx265 -preset slower -crf 23 -c:a aac -b:a 320k -c:s copy "!input_name!.!container!"
            )
        )  
        if "!codec!"=="4" (
            for %%i in (%*) do (
                set "input=%%i"
                set "input_name=%%~ni" 
                ffmpeg -y -vsync 0 -hwaccel auto -i !input! -c:v hevc_nvenc -preset slow -crf 21 -c:a aac -b:a 320k -c:s copy "!input_name!.!container!"
            )
        )
        if "!codec!"=="5" (
            for %%i in (%*) do (
                set "input=%%i"
                set "input_name=%%~ni" 
                ffmpeg -y -vsync 0 -hwaccel auto -i !input! -c:v libsvtav1 -preset 4 -crf 23 -c:a copy -c:s copy "!input_name!.!container!"
            )
        )
        echo.
        echo ============================================================
        echo # 转码结束

        echo # 按任意键关闭命令行窗口
        pause > nul
        exit

        :NoTransCoding
        set /p container=转成什么(mkv mp4 mov avi wmv rmvb flv):
        for %%i in (%*) do (
            set "input=%%i"
            set "input_name=%%~ni"  
            ffmpeg -y -i !input! -c copy "!input_name!.!container!" 
        )
        echo.
        echo ============================================================
        echo # 转码结束
        
        echo # 按任意键关闭命令行窗口
        pause > nul
        exit


    :ffmpeg3
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo ======================媒体文件重编码========================
        echo.
        echo    [38;2;255;153;0m功能说明:[m
        echo.
        echo        本功能主要是重编码媒体文件 支持批量处理
     
        echo        支持的文件类型主要有视频编码格式、音频、图片以及字幕

        echo        但批量一次只能处理一种格式 
        
        echo        此功能重合量巨大,追求质量请自行编写参数

        echo.
        echo ============================================================
        echo.

        ::判断文件类型
        for %%a in (%*) do (
            set "InputExt=%%~xa"
            for %%b in (.avc .h264 .264 .hevc .h265 .265 .ivf) do (
                if /i "!InputExt!"=="%%b" (
                    echo 你输入的是视频编码格式
                    set "IsSwitch=true"

                    echo 选择转换格式使用的编码器:
                    echo.
                    echo          HEVC/H.265 : libx265 / hevc_nvenc / hevc_qsv
                    echo          AVC/H.264  : libx264 / h264_nvenc / h264_qsv
                    echo          AV1 : libsvtav1 / libaom-av1 / av1_qsv
                goto tsvideo
                )

            )
            for %%c in (.wav .flac .mp3 .aac .opus .ape .ac3 .ogg) do (
                if /i "!InputExt!"=="%%c" (
                    echo 你输入的是音频格式
                    set "IsSwitch=true"

                    echo 选择转换格式使用的编码器:
                    echo.
                    echo                FLAC : flac
                    echo                OPUS : libopus
                    echo                WAV  : wav
                    echo                MP3  : libmp3lame
                    echo                AAC  : libfdk_aac / aac
                    echo                AC3  : ac3  / ac3_fixed
                    echo                OGG  : libvorbis
                    goto tsaudio
                )
            )
            for %%d in (.png .jpg .jpeg .bmp .webp .avif .heif .jxl .tiff .tif) do (
                if /i "!InputExt!"=="%%d" (
                    echo 你输入的是图片格式
                    set "IsSwitch=true"

                    echo ffmpeg转换图片并不是强项,多少有点问题

                    echo 选择转换格式使用的编码器:
                    echo.
                    echo                PNG : png
                    echo                JPEG : jpg
                    echo                JPEG2000 : jpeg2000
                    echo                WEBP : libwebp
                    echo                AVIF : libsvtav1
                    echo                JXL : libjxl
                    goto tspictrue
                )
            )
            for %%e in (.ass .srt .vtt .lrc) do (
                if /i "!InputExt!"=="%%e" (
                    echo 你输入的是字幕格式
                    set "IsSwitch=true"

                    echo 选择转换格式使用的编码器:
                    echo.
                    echo                ASS : ass
                    echo                SRT : srt
                    echo                WEBVTT : vtt
                    echo                Lyric : lrc
                    goto tssub
                )
            )
            if /i "!IsSwitch!"=="false" (
                echo # 你输入的并非常见的媒体格式

                echo # 请自行处理
                
                echo 按任意键关闭命令行窗口
                pause > nul
                exit
            )
        )

        :tsvideo
            echo.
            echo ============================================================
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
                ffmpeg -i %%a -c:v !codec! "%%~na_!codec!.!OutputExt!" >nul 2>nul
            )
            echo # 重编码结束

            echo # 按任意键关闭命令行窗口
            pause > nul
            exit

        :tsaudio
            echo.
            echo ============================================================
            set /p codec=请输入编码器名称:
            for %%i in (flac aac ac3) do (
                if /i "!codec!"=="%%i" set "OutputExt=!codec!"
                )
            if /i "!codec!"=="libmp3lame" set OutputExt=mp3
            if /i "!codec!"=="libopus" set OutputExt=opus
            if /i "!codec!"=="libfdk_aac" set OutputExt=aac
            if /i "!codec!"=="ac3_fixed" set OutputExt=ac3
            if /i "!codec!"=="libvorbis" set OutputExt=ogg
            if /i "!codec!"=="wav" (
                set OutputExt=wav
                for %%i in (%*) do (
                    ffmpeg -if %%a "%%~na_!codec!.!OutputExt!" >nul 2>nul
                )
                 echo # 重编码结束

                echo # 按任意键关闭命令行窗口
                pause > nul
                exit
            )


            for %%a in (%*) do (
                ffmpeg -i %%a -c:v !codec! "%%~na_!codec!.!OutputExt!" >nul 2>nul
            )
            echo # 重编码结束

            echo # 按任意键关闭命令行窗口
            pause > nul
            exit

        :tspictrue
            echo.
            echo ============================================================
            set /p codec=请输入编码器名称:

            if /i "!codec!"=="jpg" (
                set OutputExt=jpg
                for %%a in (%*) do (
                    ffmpeg -i %%a -q 5 "%%~na_!codec!.!OutputExt!" >nul 2>nul
                )
                echo # 重编码结束

                echo # 按任意键关闭命令行窗口
                pause > nul
                exit
            ) 
            if /i "!codec!"=="png" set OutputExt=png
            if /i "!codec!"=="jpeg2000" set OutputExt=jpg
            if /i "!codec!"=="libwebp" set OutputExt=webp
            if /i "!codec!"=="libsvtav1" set OutputExt=avif
            if /i "!codec!"=="libjxl" set OutputExt=jxl

            for %%a in (%*) do (
                ffmpeg -i %%a -c:v !codec! "%%~na_!codec!.!OutputExt!" >nul 2>nul
            )
            echo # 重编码结束

            echo # 按任意键关闭命令行窗口
            pause > nul
            exit
        
        :tssub
            echo.
            echo ============================================================
            set /p codec=请输入编码器名称:

            for %%i in (vtt ass srt lrc) do (
                if /i "!codec!"=="%%i" set "OutputExt=!codec!"
            )
            for %%a in (%*) do (
                ffmpeg -i %%a "%%~na_!codec!.!OutputExt!" >nul 2>nul
            )
            echo # 重编码结束

            echo # 按任意键关闭命令行窗口
            pause > nul
            exit


    :ffmpeg4
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo =======================视频文件抽流=========================
        echo.
        echo    [38;2;255;153;0m功能说明:[m
        echo.
        echo           本功能是指定抽取一个视频文件中所选择的轨道
     
        echo           对多轨道视频文件可重复抽流
     
        echo           因此不支持批量文件的特点轨道抽取
        echo.
        echo           [38;2;255;68;68m不支持对 BD 和 DVD 之类的原盘文件的复杂抽流[m

        echo           请使用 [38;2;147;255;122meac3to[m 进行对“原盘”文件的抽流
        echo.
        echo ============================================================
        echo # 按任意键继续
        pause > nul

        :ff3return
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo =======================视频文件抽流=========================
        echo 该文件所含轨道如下:
        echo.

        for /f "delims=," %%i in ('ffmpeg -i "!input!" -hide_banner 2^>^&1 ^| findstr "Stream" ') do echo %%i

        echo.
        echo ============================================================
        set /p tracker=选择要抽取的轨道(输入数字并回车):

        rem 获取ffmpeg下的媒体编码格式
        for /f "tokens=4 delims=, " %%a in ('ffmpeg -i "!input!" -hide_banner 2^>^&1 ^| findstr "#0:!tracker!" ') do set "output_ext=%%a"

        echo.
        echo 你选择轨道的媒体格式为:!output_ext!
        if "!output_ext!"=="av1" set "output_ext=ivf"

        for %%b in (hevc h265 avc h264 av1 ivf aac flac wav ac3 opus mp3 ass srt) do (
            if "!output_ext!"=="%%b" (
                set "IsSwitch=true"
                ffmpeg -i "!input!" -map 0:!tracker! -c copy "!input_name!_tracker-!tracker!.!output_ext!" >nul 2>nul 
            )
        )

        if not "!IsSwitch!"=="true" (
            echo 非常见媒体编码格式
            echo.
            set /p output_ext=请自己判断并输入扩展名:
            ffmpeg -i "!input!" -map 0:!tracker! -c copy "!input_name!_tracker-!tracker!.!output_ext!" >nul 2>nul
        )

        echo.
        set /p retrun=是否需要再次执行(是:Y 否:N)
        set "IsSwitch=false"
        if /i "%retrun%"=="y" goto ff3return
        exit

    :ffmpeg5
        cls
        echo.
        echo                          [38;2;68;157;68m# FFmpeg[m
        echo.
        echo =======================媒体文件混流=========================
        echo.
        echo    [38;2;255;153;0m功能说明:[m
        echo.
        echo         本功能是将一堆媒体文件封装为制定的封装格式
     
        echo         每个封装格式对封装内容都有要求
     
        echo         不保证每种封装格式都能封装成功
        
        echo         建议只封装常用的 mkv 和 mp4

        echo         字幕在非 mkv 下封装 视频会被重编码

        echo         复杂封装(字体、章节、其他附件)上 [38;2;118;130;200mmkvtoolnixgui[m 吧
        echo.
        echo ============================================================
        echo.

        set "inputFiles="
        set "InputSub="       

        set /p container=选择封装格式(mkv mp4):
        echo.
        if /i "%container%"=="mkv" (
            goto muxmkv 
        ) else (
            goto muxvideo
        )

        :muxmkv
        echo ============================================================
        echo # muxmkv
        echo                    ···3秒后开始封装···
        echo.
        ping 127.0.0.1 -n 4 >nul
        for %%a in (%*) do (
            set "InputJudge=%%~xa"
            if /i "!InputJudge!"==".ivf" (
                set "IsSwitch=true"
                goto muxmkvlvf
            ) else (
                set "InputFiles=!InputFiles! %%a"
            )
        )
        if not "!IsSwitch!"=="true" (
            mkvmerge -o output_mux.mkv !InputFiles! >nul 2>nul
            echo # 封装结束

            echo # 按任意键关闭命令行窗口
            pause > nul
            exit
        )

        :muxmkvlvf
        for %%a in (%*) do (
            set "InputFiles_lvf=!InputFiles_lvf! -i %%a" 
        )
        ffmpeg !InputFiles_lvf! -c copy output_mux.!container! >nul 2>nul
        echo # 封装结束

        echo # 按任意键关闭命令行窗口
        pause > nul
        exit

        :muxvideo
        echo ============================================================
        echo # mux!container!
        echo                    ···3秒后开始封装···
        echo.
        ping 127.0.0.1 -n 4>nul

        for %%a in (%*) do (
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
            ffmpeg !inputFiles! !InputSub! -c:v libx264 -x264-params "me=umh:subme=10:merange=48:fast-pskip=0:direct=auto:weightb=1:keyint=250:min-keyint=5:bframes=12:b-adapt=2:ref=3:rc-lookahead=90:crf=19:qpmin=9:chroma-qp-offset=-2:aqmode=3:aq-strength=0.7:trellis=2:deblock=0:-1:psy-rd=0.7:0.14:nr=4" output_mux.!container! >nul 2>nul
        ) else (
            ffmpeg !inputFiles! -c copy output_mux.!container! >nul 2>nul
        )
        for %%c in (*cache.mp4) do del "%%c" >nul 2>nul
        echo # 封装结束

        echo # 按任意键关闭命令行窗口
        pause > nul
        exit
    
    


:tox264
    cls
    echo.
    echo                          [38;2;0;191;255m# x264[m
    echo.
    echo =======================x264 视频编码========================
    echo.
    echo    [38;2;255;153;0m参数选择:[m
    echo.
    echo            1. 动画-WebRip
    echo            2. 动画-BDRip
    echo            3. 普通电影
    echo            4. 日常
    echo            5. 其他(存档)

    echo.
    echo            [38;2;0;65;5m更多预设正在思考中……[m

    echo            [38;2;255;124;3m输入 0 返回编码器选择界面[m
    echo.

    echo ============================================================
    echo.

    set ectool=x264
    set output_ext=.avc

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="0" goto sloop
        if "%parameter%"=="1" set encoder_par=--preset veryslow --me umh --subme 9 --merange 32 --no-fast-pskip --weightb --keyint 240 --min-keyint 1 --bframes 10 --b-adapt 2 --ref 3 --rc-lookahead 70 --crf 21 --qcomp 0.7 --chroma-qp-offset -2 --aq-mode 3 --aq-strength 0.7 --deblock 0:-1 --psy-rd 0.6:0.15 --range tv --colorprim bt709

        if "%parameter%"=="2" set encoder_par=--preset veryslow --me tesa --subme 9 --merange 32 --no-fast-pskip --direct auto --weightb --keyint 240 --min-keyint 1 --bframes 8 --b-adapt 2 --ref 3 --rc-lookahead 72 --crf 17 --qcomp 0.7 --qpmin 9 --chroma-qp-offset -2 --aq-mode 3  --aq-strength 0.7 --trellis 2 --deblock -1:-1 --psy-rd 0.6:0.15 --range tv --colorprim bt709 --transfer bt709 --colormatrix bt709

        if "%parameter%"=="3" set encoder_par=--preset veryslow --me esa --subme 10 --merange 32 --no-fast-pskip --direct auto --weightb --keyint 300 --min-keyint 1 --bframes 12 --b-adapt 2 --ref 3 --rc-lookahead 90 --crf 19 --qcomp 0.7 --qpmin 8 --chroma-qp-offset -2 --aq-mode 3 --aq-strength 0.7 --trellis 2 --deblock -1:-1 --psy-rd 0.8:0.18 --fgo 12 

        if "%parameter%"=="4" set encoder_par=--preset veryslow --me umh --subme 9 --merange 24 --no-fast-pskip --direct auto --weightb --keyint 270 --min-keyint 5 --bframes 12 --b-adapt 2 --ref 6 --rc-lookahead 80 --crf 19 --qcomp 0.6 --qpmin 9 --chroma-qp-offset -2 --aq-mode 3  --aq-strength 0.8 --trellis 2 --deblock 0:-1 --psy-rd 0.7:0.15

        if "%parameter%"=="5" set encoder_par=--preset veryslow --me esa --subme 10 --merange 40 --no-fast-pskip --direct auto --weightb --keyint 70 --min-keyint 1 --bframes 12 --b-adapt 2 --ref 3 --crf 16 --tune grain --trellis 2 --fgo 15
    cls
    echo.
    echo                          [38;2;0;191;255m# x264[m
    echo ============================================================
    echo # x264开始压制
    %ectool% %encoder_par% --output "%input_path%%input_name%_encoded%output_ext%" "%input%" 2>&1 | tee log.txt
    cls
    echo.
    echo                          [38;2;0;191;255m# x264[m
    echo ============================================================
    echo # 结束压制
    echo.
    echo 已生成日志文件

    echo 按任意键关闭命令行窗口
    pause > nul
    exit

:tox265
    cls
    echo.
    echo                          [38;2;0;94;214m# x265[m
    echo.
    echo =======================x265 视频编码========================
    echo.
    echo    [38;2;255;153;0m参数选择:[m
    echo.
    echo            1. 通用
    echo            2. 动画-WebRip
    echo            3. 动画-BDRip
    echo            4. 4K电影
    echo            5. 其他(存档)

    echo.
    echo            [38;2;0;65;5m更多预设正在思考中……[m

    echo            [38;2;255;124;3m输入 0 返回编码器选择界面[m
    echo.

    echo ============================================================
    echo.

    set ectool=x265
    set output_ext=.hevc

        for %%a in (.avc .hevc .ivf .mkv .h265 .h264) do (
            if "!input_ext!"=="%%a" (
                ffmpeg -i "!input!" -map 0 -c copy -an "!input_path!!input_name!_cache.mp4" >nul 2>nul
                set "input=!input_path!!input_name!_cache.mp4"
            )
        )

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="0" goto sloop
        if "%parameter%"=="1" set encoder_par=--preset slower --ctu 32 --min-cu-size 16 --tu-intra-depth 3 --tu-inter-depth 3 --limit-tu 1 --rdpenalty 1 --me umh --subme 4 --merange 32 --weightb --ref 3 --max-merge 2 --early-skip --no-open-gop --keyint 300 --min-keyint 5 --fades --bframes 8 --b-adapt 2 --b-intra --crf 19 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --aq-mode 3 --aq-strength 0.7 --limit-modes --limit-refs 1 --rskip 1 --rc-lookahead 90 --tskip-fast --rect --amp --rd 3 --rdoq-level 1 --psy-rd 1.6 --limit-sao --deblock 0:-1 --allow-non-conformance

        if "%parameter%"=="2" set encoder_par=--preset slower --ctu 32 --min-cu-size 16 --tu-intra-depth 3 --tu-inter-depth 3 --limit-tu 3 --rskip 0 --me star --subme 5 --merange 32 --weightb --max-merge 3 --ref 5 --no-open-gop --keyint 240 --min-keyint 1 --fades --bframes 10 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 18 --qcomp 0.6 --cbqpoffs -2 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --hevc-aq --aq-strength 0.9 --qg-size 16 --rc-lookahead 80 --no-rect --no-amp  --rd 4 --psy-rdoq 0.5 --rdoq-level 2 --psy-rd 1.5 --no-sao --deblock 0:-1

        if "%parameter%"=="3" set encoder_par=--preset veryslow --ctu 32 --tu-intra-depth 4 --tu-inter-depth 4 --limit-tu 0 --rskip 0 --me star --subme 3 --merange 32 --weightb --max-merge 4 --ref 3 --no-open-gop --keyint 240 --min-keyint 1 --fades --bframes 8 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 16 --qcomp 0.6 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.3 --hevc-aq --aq-strength 0.8 --qg-size 16 --rc-lookahead 80 --no-rect --no-amp --rd 5 --psy-rdoq 0.5 --rdoq-level 2 --psy-rd 1.5 --no-sao --deblock -1:-1 --colorprim bt709 --transfer bt709 --colormatrix bt709 --range limited

        if "%parameter%"=="4" set encoder_par=--preset veryslow --ctu 64 --tu-intra-depth 4 --tu-inter-depth 4 --limit-tu 0 --rskip 0 --me umh --subme 4 --merange 57 --weightb --max-merge 3 --ref 5 --no-open-gop --keyint 360 --min-keyint 3 --fades --bframes 12 --b-adapt 2 --b-intra --no-strong-intra-smoothing --crf 21 --qcomp 0.6 --cbqpoffs -3 --crqpoffs -2 --ipratio 1.2 --pbratio 1.5 --aq-mode 4 --aq-strength 1.2 --qg-size 16 --rc-lookahead 72 --no-rect --no-amp --rd 3 --rdoq-level 2 --psy-rd 2.2 --limit-sao --deblock 0:-1 

        if "%parameter%"=="5" set encoder_par=--preset slower --ctu 32 --me star --subme 4 --merange 48 --max-merge 4 --early-skip --no-open-gop --keyint 220 --min-keyint 1 --ref 3 --fades --bframes 7 --b-adapt 2 --b-intra --crf 17 --cbqpoffs -3 --crqpoffs -2 --rd 3 --limit-modes --limit-refs 1 --rskip 1 --rc-lookahead 90 --splitrd-skip --deblock -1:-1 --tune grain
    cls
    echo.
    echo                          [38;2;0;94;214m# x265[m
    echo ============================================================
    echo # x265开始压制

    for /f %%a in ('ffprobe -v error -select_streams v^:0 -show_entries stream^=nb_frames -of default^=noprint_wrappers^=1^:nokey^=1 "%input%" ') do set in_frames=%%a

    ffmpeg -i "%input%" -an -map 0:v:0 -f yuv4mpegpipe -strict unofficial - | %ectool% --frames %in_frames% --y4m %encoder_par% --output "%input_path%%input_name%_encoded%output_ext%" - 2>&1 | tee log.txt
    cls
    echo.
    echo                          [38;2;0;94;214m# x265[m
    echo ============================================================
    echo # 结束压制
    echo.
    echo 已生成日志文件

    echo 按任意键关闭命令行窗口
    pause > nul
    exit

:toav1
    cls
    echo.
    echo                       [38;2;188;32;92m# svt_av1[m
    echo.
    echo =====================svt_av1 视频编码======================
    echo.
    echo    [38;2;255;153;0m参数选择:[m
    echo.
    echo            1. 通用

    echo            3. 动画-BDRip
    echo.
    echo            [38;2;0;65;5m更多预设正在思考中……[m

    echo            [38;2;255;124;3m输入 0 返回编码器选择界面[m
    echo.

    echo ============================================================
    echo.

    set ectool=svtav1
    set output_ext=.ivf

        for %%a in (.avc .hevc .ivf .mkv .h265 .h264) do (
            if "!input_ext!"=="%%a" (
                ffmpeg -i "!input!" -map 0 -c copy -an "!input_path!!input_name!_cache.mp4" >nul 2>nul
                set "input=!input_path!!input_name!_cache.mp4"
            )
        )

        set /p parameter=选择需要压制的参数：
        if "%parameter%"=="0" goto sloop
        if "%parameter%"=="1" set encoder_par=--preset 4 --rc 0 --qp 30 --max-qp 55 --min-qp 8 --crf 23 --aq-mode 2 --keyint 300 --irefresh-type 2 --scd 1 --lookahead 80 --scm 2 --enable-tpl-la 1

        if "%parameter%"=="2" set encoder_par=--preset 3 --rc 0 --qp 25 --max-qp 50 --crf17 --aq-mode 2 --keyint 240 --irefresh-type 2 --scd 1 --lookahead 80 --scm 1 --enable-tpl-la 1

    cls
    echo.
    echo                         [38;2;188;32;92m# svt_av1[m
    echo ============================================================
    echo # svt_av1开始压制
    ffmpeg -i "%input%" -an -f yuv4mpegpipe -strict unofficial - | %ectool% %encoder_par%  -b "%input_path%%input_name%_encoded%output_ext%" -i stdin 2>&1 | tee log.txt
    cls
    echo.
    echo                         [38;2;188;32;92m# svt_av1[m
    echo ============================================================
    echo # 结束压制
    echo.
    echo 已生成日志文件

    echo 按任意键关闭命令行窗口
    pause > nul
    exit




