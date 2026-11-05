@echo off
title AI Hosts Blocker
setlocal EnableExtensions
chcp 65001 >nul

rem ============================================================
rem  AI HOSTS BLOCKER - блокировка ИИ-сервисов и популярной почты
rem ============================================================
rem  Как пользоваться (переключатель):
rem    1-й запуск  - добавляет блокировку в hosts
rem    повторный   - снимает блокировку
rem  Ручной режим (необязательно):
rem    block_ai_hosts.bat block    - заблокировать принудительно
rem    block_ai_hosts.bat unblock  - снять блокировку принудительно
rem ------------------------------------------------------------
rem  Блокируется 139 доменов:
rem    * ИИ-чаты: ChatGPT, Claude, Gemini, Copilot, Grok,
rem      DeepSeek, Perplexity, Qwen, Kimi, Character.AI, Meta AI
rem    * их API-эндпоинты (api.openai.com, api.anthropic.com и др.)
rem    * ИИ поисковиков: Gemini (Google), Copilot (Bing),
rem      Duck.ai (DuckDuckGo)
rem    * Яндекс-бот: Алиса (alice.yandex.ru и др.), YandexGPT API
rem    * Z.AI / GLM: chat.z.ai, api.z.ai, bigmodel.cn, chatglm.cn
rem    * Почта: Gmail, Outlook/Hotmail, Yahoo, Proton, iCloud, Zoho,
rem      Яндекс.Почта, Mail.ru (+bk/list/inbox), Rambler, Tuta,
rem      GMX, Fastmail, AOL, QQ, 163/126 - веб + SMTP/IMAP/POP
rem ------------------------------------------------------------
rem  Все добавленные строки помечены маркером #ai-blocker,
rem  поэтому удаляются только они, а чужие записи не трогаются.
rem ============================================================

set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "MARKER=#ai-blocker"
set "TOTAL=139"

rem ---------- проверка прав администратора + авто-запрос UAC ----------
if not exist "%HOSTS%" type nul > "%HOSTS%"
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Требуются права администратора. Запрашиваю через UAC...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    echo Если запрос UAC был отклонён - щёлкните файл правой кнопкой
    echo мыши и выберите "Запуск от имени администратора".
    pause
    exit /b 1
)
attrib -R "%HOSTS%" >nul 2>&1

rem ---------- выбор режима ----------
if /i "%~1"=="block"   goto BLOCK
if /i "%~1"=="unblock" goto UNBLOCK

set "CNT=0"
for /f %%A in ('findstr /C:"%MARKER%" "%HOSTS%" ^| find /C /V ""') do set "CNT=%%A"
if %CNT% GEQ %TOTAL% goto UNBLOCK
goto BLOCK


:BLOCK
echo.
echo ==================================================
echo   БЛОКИРОВКА ИИ И ПОЧТЫ ^(файл hosts^)
echo ==================================================
call :CLEAN
echo Добавляю записи вида 0.0.0.0 домен ...
>>"%HOSTS%" echo.
rem --- OpenAI / ChatGPT ---
for %%D in (
    openai.com
    www.openai.com
    chatgpt.com
    www.chatgpt.com
    chat.openai.com
    platform.openai.com
    api.openai.com
    auth.openai.com
    auth0.openai.com
    ab.chatgpt.com
    cdn.oaistatic.com
    files.oaiusercontent.com
    sora.com
    sora.chatgpt.com
    chatgpt.livekit.cloud
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Claude / Anthropic ---
for %%D in (
    claude.ai
    www.claude.ai
    claude.com
    www.claude.com
    anthropic.com
    www.anthropic.com
    console.anthropic.com
    api.anthropic.com
    claude.site
    claudeusercontent.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Google Gemini ---
for %%D in (
    gemini.google.com
    aistudio.google.com
    makersuite.google.com
    notebooklm.google.com
    ai.google.dev
    generativelanguage.googleapis.com
    cloudcode-pa.googleapis.com
    bard.google.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Microsoft Copilot ---
for %%D in (
    copilot.microsoft.com
    sydney.bing.com
    githubcopilot.com
    api.githubcopilot.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- xAI Grok ---
for %%D in (
    grok.com
    x.ai
    api.x.ai
    console.x.ai
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- DeepSeek ---
for %%D in (
    deepseek.com
    www.deepseek.com
    chat.deepseek.com
    platform.deepseek.com
    api.deepseek.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Perplexity ---
for %%D in (
    perplexity.ai
    www.perplexity.ai
    api.perplexity.ai
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Qwen / Alibaba ---
for %%D in (
    qwen.ai
    www.qwen.ai
    chat.qwen.ai
    tongyi.aliyun.com
    dashscope.aliyuncs.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Kimi / Moonshot ---
for %%D in (
    kimi.com
    www.kimi.com
    kimi.ai
    kimi.moonshot.cn
    moonshot.cn
    platform.moonshot.cn
    api.moonshot.cn
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Character.AI ---
for %%D in (
    character.ai
    www.character.ai
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Meta AI ---
for %%D in (
    meta.ai
    www.meta.ai
    api.llama.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Yandex AI / Alice ---
for %%D in (
    alice.yandex.ru
    alicebus.yandex.ru
    api.llm.yandex.net
    llm.api.cloud.yandex.net
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Z.AI / Zhipu (GLM) ---
for %%D in (
    z.ai
    www.z.ai
    chat.z.ai
    api.z.ai
    bigmodel.cn
    open.bigmodel.cn
    chatglm.cn
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Gmail ---
for %%D in (
    gmail.com
    www.gmail.com
    mail.google.com
    smtp.gmail.com
    imap.gmail.com
    pop.gmail.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Outlook / Hotmail ---
for %%D in (
    outlook.com
    www.outlook.com
    outlook.live.com
    hotmail.com
    www.hotmail.com
    outlook.office.com
    outlook.office365.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Yahoo Mail ---
for %%D in (
    mail.yahoo.com
    smtp.mail.yahoo.com
    imap.mail.yahoo.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Proton Mail ---
for %%D in (
    proton.me
    www.proton.me
    mail.proton.me
    protonmail.com
    www.protonmail.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- iCloud Mail ---
for %%D in (
    icloud.com
    www.icloud.com
    imap.mail.me.com
    smtp.mail.me.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Zoho Mail ---
for %%D in (
    mail.zoho.com
    zohomail.com
    www.zohomail.com
    imap.zoho.com
    smtp.zoho.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Yandex Mail ---
for %%D in (
    mail.yandex.ru
    imap.yandex.ru
    smtp.yandex.ru
    pop.yandex.ru
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Mail.ru ---
for %%D in (
    mail.ru
    imap.mail.ru
    smtp.mail.ru
    pop.mail.ru
    bk.ru
    list.ru
    inbox.ru
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Rambler Mail ---
for %%D in (
    mail.rambler.ru
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Tuta (Tutanota) ---
for %%D in (
    tuta.com
    www.tuta.com
    app.tuta.com
    tutanota.com
    www.tutanota.com
    mail.tutanota.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- GMX ---
for %%D in (
    gmx.com
    www.gmx.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- Fastmail ---
for %%D in (
    fastmail.com
    www.fastmail.com
    app.fastmail.com
    imap.fastmail.com
    smtp.fastmail.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- AOL Mail ---
for %%D in (
    aol.com
    www.aol.com
    mail.aol.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- QQ Mail ---
for %%D in (
    mail.qq.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- NetEase Mail (163/126) ---
for %%D in (
    mail.163.com
    mail.126.com
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

rem --- AI in search engines ---
for %%D in (
    duck.ai
) do (>>"%HOSTS%" echo 0.0.0.0 %%D %MARKER%)

>nul ipconfig /flushdns
echo.
echo Готово! Заблокировано доменов: %TOTAL%
echo Кэш DNS очищен - изменения действуют сразу.
echo Примечание: некоторые антивирусы предупреждают об изменении
echo файла hosts - это ожидаемое поведение данного скрипта.
echo.
echo Чтобы СНЯТЬ блокировку - просто запустите этот файл ещё раз.
echo.
pause
exit /b 0


:UNBLOCK
set "CNT=0"
for /f %%A in ('findstr /C:"%MARKER%" "%HOSTS%" ^| find /C /V ""') do set "CNT=%%A"
echo.
echo ==================================================
echo   СНЯТИЕ БЛОКИРОВКИ ^(файл hosts^)
echo ==================================================
if %CNT% EQU 0 (
    echo Записи блокировки не найдены - блокировка и так снята.
) else (
    echo Найдено записей: %CNT%. Удаляю...
    call :CLEAN
    >nul ipconfig /flushdns
    echo Готово! Все записи скрипта удалены, кэш DNS очищен.
)
echo.
echo Чтобы снова включить блокировку - запустите этот файл ещё раз.
echo.
pause
exit /b 0


:CLEAN
rem удаляет из hosts только строки с маркером #ai-blocker
findstr /V /C:"%MARKER%" "%HOSTS%" > "%TEMP%\hosts.aiblk.tmp"
copy /y "%TEMP%\hosts.aiblk.tmp" "%HOSTS%" >nul
del /q "%TEMP%\hosts.aiblk.tmp" >nul 2>&1
exit /b 0