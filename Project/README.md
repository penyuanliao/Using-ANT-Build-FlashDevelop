### Auto Build Number
=====

####Introduction
主要是給`FlashDevelop + ANT`使用可以自動編譯build number+1跟讀取SVN版號。

####檔案說明
1. `obj\buildVersion.xml`:ANT編譯需要的Build.xml
2. `obj\build.number`:主要儲存ANT編譯編號
3. `obj\Version.xml`:記錄BuildNumber參數
4. `src\Version\Version.as`:記錄BuildNumber參數(主要提供ActionScript可以讀取)
5. `obj\pre_build.bat`:ant.bat 版本編譯需要設定環境變數增加`ANT_HOME`路徑與設定FlashDevelop > Project > Properties > Build > Pre-Build Command Line > input `$(ProjectDir)\obj\pre_build.bat`
