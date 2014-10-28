ANT Build FlashDevelop<BR>
###設定
#### Java
1.	需要安裝JRE( Java Runtime Environment) 。
2.	並在環境變數的系統變數上增加JAVA_HOME值輸入`<你的Java路徑>`並設置環境變數Path加上『`;%JAVA_HOME%\bin`』。
3.	檢查是否可以在command line 輸入Java可以執行表示設定成功。

#### ANT
1.	下載ANT http://ant.apache.org/bindownload.cgi

2.	設定環境變數的系統變數上增加。
ANT_HOME 值輸入`<你的Ant路徑>`，並設置環境變數PATH 增加`;% ANT_HOME %\bin`。
3.	檢查是否可以command line輸入ant可以執行表示設定成功。

#### ActionScript
```actionscript
import org.flexunit.internals.TraceListener;
import org.flexunit.listeners.CIListener;
import org.flexunit.runner.FlexUnitCore;
import org.flexunit.runner.notification.async.XMLListener;
/**
* 單元測試
**/
private function setupUnitTest():void
{
    // Unit Test
    var core:FlexUnitCore = new FlexUnitCore();
    core.addListener(new TraceListener());
    core.addListener(new CIListener(1025, "127.0.0.1")); 
    core.addListener(new XMLListener("FlexUnit4Test"));
    core.run(SoundUnitSuite);
}
```


```xml
<?xml version="1.0"?>
<!- default_預設開始編譯 basedir_檔案位置路徑-->
<project name="ANT編譯名稱" default="main" basedir=".">
<!-- 設定變數 -->
<property name=" FLEX_HOME " value="你的Flex SDK 路徑"/>
<!-- 重要flash編譯需要的jar -->
<taskdef resource="flexTasks.tasks" classpath="${FLEX_HOME}/ant"/>
<!-- Flash Develop swf檔案位置 -->
<property name="DEPLOY.dir" value="${basedir}/bin"/>
<!-- 主要編譯事件depends:執行順序 -->
<target name="main" depends="clean, compile"/>
<!-- Dos 刪除指令 -->
<target name="clean">
    <delete dir="${DEPLOY.dir}"/>
    <mkdir dir="${DEPLOY.dir}"/>
</target>
<!-- 編譯SWF物件 -->
    <target name="compile">
        <mxmlc
        file="${basedir}/src/Main.as"
        output="${DEPLOY_DIR}/Main.swf"  
        show-actionscript-warnings="true" 
        failonerror="true" 
        debug="false" 
        maxmemory="1024m">
            <!-- Embed links -->
            <static-link-runtime-shared-libraries>true</static-link-runtime-shared-libraries>
            <!-- 載入預設flex config檔案 -->
            <load-config filename="${FLEX_HOME}/frameworks/flex-config.xml"/>
            <!-- 載入FlashDevelop設定檔案, 必須要增加append參數true不然不會加入此設定檔案 -->
            <load-config append="true" filename="${basedir}\obj\soundConfig.xml"/>
            <!-- 載入 References -->
            <source-path path-element="${basedir}/src"/>
            <!-- classpath檔案 -->
            <source-path path-element="${FLEX_HOME}/frameworks"/>
        </mxmlc>
    </target>
</project>
```
```xml
	<!-- 打開Player進行調試 -->
	<target name="RunSwf">
		<!-- 不能直接調用fdb，因為這樣不會打開新的命令行窗口，必須使用/K或者/C參數，加上start來啟動fdb -->
		<echo>${basedir}\bin\output.swf</echo>
		<exec executable="cmd" spawn="true" osfamily="windows">
			<arg line="/K start ${basedir}\bin\output.swf" />
		</exec>
	</target>
```
#### Subversion, TortoiseSVN
```xml
	<target name="svn-update-Subversion">
		<exec dir="${tortoiseSVN.path}" executable="TortoiseProc.exe" failonerror="true">
			<arg line=" /command:update /path:'${dir}' /notempfile /closeonend:2" />
		</exec>
	</target>
```
