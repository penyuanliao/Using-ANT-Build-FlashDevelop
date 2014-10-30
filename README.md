ANT Build FlashDevelop
========================
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

#### build.xml compile SWF 
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
#### Target執行SWF
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
#### Target執行flexUnit

##### ActionScript
```actionscript
//libs\FlexUnit4\flexunit-4.1.0-8-as3_4.1.0.16076.swc
import org.flexunit.internals.TraceListener; 
//libs\FlexUnit4\flexunit-cilistener-4.2.0-20140410-4.12.0.swc
import org.flexunit.listeners.CIListener;
//libs\FlexUnit4\flexunit-4.1.0-8-as3_4.1.0.16076.swc
import org.flexunit.runner.FlexUnitCore; 
//libs\FlexUnit4\flexunit-4.1.0-8-as3_4.1.0.16076.swc
import org.flexunit.runner.notification.async.XMLListener; 
/**
* 單元測試
**/
private function setupUnitTest():void
{
    // Unit Test
    var core:FlexUnitCore = new FlexUnitCore();
    // flash output
    core.addListener(new TraceListener());
    // Ant output
    core.addListener(new CIListener(1025, "127.0.0.1")); 
    core.addListener(new XMLListener("FlexUnit4Test"));
    // set as default unit test
    core.run(SoundUnitSuite);
}
```
##### Build.xml
```xml
<?xml version="1.0"?>
<!- default_預設開始編譯 basedir_檔案位置路徑-->
<project name="ANT編譯名稱" default="main" basedir=".">
<!-- 設定變數 -->
<property name=" FLEX_HOME " value="你的Flex SDK 路徑"/>
<!-- 重要flash編譯需要的jar -->
<taskdef resource="flexTasks.tasks" classpath="${FLEX_HOME}/ant"/>
<!-- 確定flexUnitTasks.jar的位置 -->
<taskdef resource="flexUnitTasks.tasks">
    <classpath>
        <fileset dir="D:\libs\FlexUnit4\">
             <include name="flexUnitTasks-4.2.0-20140410.jar"/>
        </fileset>
    </classpath>
</taskdef>
<!-- Flash Develop swf檔案位置 -->
<property name="DEPLOY.dir" value="${basedir}/bin"/>
	<!-- 主要編譯事件depends:執行順序 -->
	<target name="main" depends="clean, UnitTest"/>
	<target name="UnitTest">
	<!--
	file:set as default application
	output:swf output file
	static-link-runtime-shared-libraries:shared embed
	-->
        <mxmlc
            file="${basedir}/src/Unit/FlexUnitApplication.as"
            output="${DEPLOY_DIR}/output.swf" 
            static-link-runtime-shared-libraries="true" 
			show-actionscript-warnings="true" 
            failonerror="true" 
			debug="true" 
            maxmemory="1024m">
		<load-config filename="${FLEX_HOME}/frameworks/flex-config.xml"/>
		<load-config append="true" filename="${basedir}\obj\soundConfig.xml"/>
                <source-path path-element="${basedir}/src"/>
                <source-path path-element="${FLEX_HOME}/frameworks"/>
		<source-path path-element="${Shared_FilesVer2.dir}"/>
		<source-path path-element="${core3.dir}"/>
        </mxmlc>
	<mkdir dir="${DEPLOY_DIR}"/>
	<!--
	timeout:連線逾時timeout
	port:連線port對應CIListener port
	toDir:swf資料夾
	player:編譯是屬於flash,air
	command:需要是debug flashPlayer
	-->
	<flexunit 
		timeout="5000"
		port="1025"
		swf="${DEPLOY_DIR}/output.swf" 
		toDir="${DEPLOY_DIR}" 
		workingDir="${DEPLOY_DIR}"
		player="flash"
		haltonfailure="true" 
		failureproperty="flexunit.failure"
		verbose="true" 
		localTrusted="true" 
		command="D:/flashplayer_15_sa.exe" />
	<!-- xml report資料夾 -->
	<junitreport todir="${DEPLOY_DIR}">
	    <!-- xml report資料夾 -->
	    <fileset dir="${DEPLOY_DIR}">
        	<include name="TEST-*.xml"/>
	    </fileset>
	    <!-- html report資料夾資料夾 -->
    	    <report format="frames" todir="${DEPLOY_DIR}/html"/>
        </junitreport>
	</target>
	<!-- 刪除SWF檔案 -->
	<target name="Clean">
		<echo>cleaning of temporary files.</echo>
		<delete file="${DEPLOY_DIR}/output.swf"/>
		<echo>clean complement.</echo>
	</target>
</project>

```
#### Target執行Subversion, TortoiseSVN 更新
[Automating TortoiseSVN](http://tortoisesvn.net/docs/release/TortoiseSVN_en/tsvn-automation.html)
#####同步SVN檔案
更新同步SVN檔案到用戶電腦上須要輸入位置`update.directory`

closeonend相關參數:

/closeonend:0 不自動關閉對話框 

/closeonend:1 如果沒發生錯誤則自動關閉對話框

/closeonend:2 如`果沒發生錯誤和衝突則自動關閉對話框

/closeonend:3 如果沒有錯誤、衝突和合併，會自動關閉

```xml
	<target name="SVN-Update">
		<!-- 執行系統 command line -->
		<exec dir="${tortoiseSVN.path}" executable="TortoiseProc.exe" failonerror="true">
			<arg line=" /command:update /path:'${update.directory}' /notempfile /closeonend:2" />
		</exec>
	</target>
```

#####建立SVN連動
建立SVN同步到用戶電腦上須要輸入位置`checkout.directory`與輸入SVN來源`url.of.repository`
```xml
	<target name="SVN-Checkout">
		<exec dir="." executable="TortoiseProc.exe" failonerror="true">
			<arg line=" /command:checkout /path:'${checkout.directory}' /url:'${url.of.repository}'" />
		</exec>
	</target>
```
