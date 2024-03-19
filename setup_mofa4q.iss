; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; to install for Mofa4q
#define MyAppName "MoFa4Q"
; NOTE: set QGIS profile name
#define MyAppCompany "public"
#define MyAppVersion "2.1.2"
#define MyAppPublisher "WhereGroup GmbH"
#define MyAppURL "http://www.wheregroup.com/"
#define MyAppIconName "MoFa4Q"
#define MyAppSyncIconName "MoFa4Q_Sync"
#define QGISVersion "3.34.4"
#define QGISFileName "QGIS-OSGeo4W-3.34.4-1"
#define DEVELDir "devel"
#define DEVEL_QGISInstallMofa4Q "qgis_mofa4q_installer"
; NOTE: set and managed qgis version to qgis or qgis-ltr
#define QGISReleaseVersion "qgis-ltr"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E2ADBEB6-853F-4CB1-B4BB-1F50E09D3154}
AppName={#MyAppName} - {#MyAppCompany}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
;; Note: Not Change Dir Path => it is static
DefaultDirName={autopf64}\{#MyAppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
ShowComponentSizes=no
DisableReadyPage=yes
DefaultGroupName={#MyAppName}_{#MyAppCompany}
OutputDir=C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\output_exe
OutputBaseFilename=MoFa4Q_{#MyAppCompany}_Install
SetupIconFile=C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\icons\mops_install_public.ico
UninstallDisplayIcon=C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\icons\mops_install_public.ico
UninstallDisplayName={#MyAppName}
VersionInfoVersion={#MyAppVersion}
LicenseFile=C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\LICENSE
InfoAfterFile=C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\changelog.md
WizardStyle=modern

; Set default Disk Space require QGIS(~3GB) + Mofa4q(~2GB)
ExtraDiskSpaceRequired=5000000000

; "ArchitecturesAllowed=x64" specifies that Setup cannot run on
; anything but x64.
ArchitecturesAllowed=x64

; Best compression settings in Inno Setup compiler
Compression=none
;Compression=lzma2/fast
SolidCompression=yes
LZMAUseSeparateProcess=yes

; Admin privileges
PrivilegesRequiredOverridesAllowed=commandline dialog
; admin | lowest
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[CustomMessages]
english.UninstallQgisProfile=English Would you also like to completely delete the local QGIS profile %1 ?
german.UninstallQgisProfile=German M�chten Sie komplett das lokale QGIS Profile von %1 l�schen?
english.UninstallQgis=English Would you also like to completely uninstall the QGIS program with version %1 ?
german.UninstallQgis=German M�chten Sie komplett das QGIS-Programm mit der Version von %1 deinstallieren?
english.ErrorUninstallCleanupQgisInstall=Failed running uninstall_cleanup_qgisInstall.bat file
german.ErrorUninstallCleanupQgisInstall=Fehler beim Ausf�hren der Datei uninstall_cleanup_qgisInstall.bat
english.ErrorOtherRunInstaller=Other installer failed to run!
german.ErrorOtherRunInstaller=Anderes Installationsprogramm konnte nicht ausgef�hrt werden!

[Tasks]
; checkbox for creating desktop link

[Files]
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\other_programs\{#QGISFileName}.msi"; \
      Excludes: "*.~*,*__~*,*.git*,*.vscode*,*.idea*"; \
      DestDir: "{app}\other_programs"; \
      AfterInstall: CheckAndInstallQgis; \
      Flags: comparetimestamp;
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\profiles\{#MyAppName}_{#MyAppCompany}\*"; \
      Excludes: "*.~*,*__~*,*.git*,*.vscode*,*.idea*,*__pycache__*,*annotations.yaml*"; \
      DestDir: "{userappdata}\QGIS\QGIS3\profiles\{#MyAppName}_{#MyAppCompany}";  \
      Flags: createallsubdirs recursesubdirs
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\icons\*.*"; \
      Excludes: "*.~*,*__~*,*.git*,*.vscode*,*.idea*"; \
      DestDir: "{app}\icons"; \
      Flags: comparetimestamp;
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\batch\*.*"; \
      Excludes: "*.~*,*__~*,*.git*,*.vscode*,*.idea*,*__pycache__*"; \
      DestDir: "{app}\batch";
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\batch\uninstall_cleanup_qgisInstall.bat"; \
      DestDir: "{app}\batch"; \
      AfterInstall: ReplaceBatfile('{app}\batch','uninstall_cleanup_qgisInstall.bat');
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\batch\mofa4q.bat"; \
      DestDir: "{app}\batch"; \
      AfterInstall: ReplaceBatfile('{app}\batch','mofa4q.bat');
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\batch\mofa4q_sync.bat"; \
      DestDir: "{app}\batch"; \
      AfterInstall: ReplaceBatfile('{app}\batch','mofa4q_sync.bat');
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\input\batch\mofa4q_sync_test_in_terminal.bat"; \
      DestDir: "{app}\batch"; \
      AfterInstall: ReplaceBatfile('{app}\batch','mofa4q_sync_test_in_terminal.bat');
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\LICENSE"; \
      DestDir: "{app}"; \
      Flags: comparetimestamp;
Source: "C:\{#DEVELDir}\{#DEVEL_QGISInstallMofa4Q}\changelog.md"; \
      DestDir: "{app}"; \
      DestName: "changelog.txt"; \
      Flags: comparetimestamp;

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
; create desktop link
; we create desktop link for all users per [code]

; create start menu link
Name: "{autostartmenu}\{#MyAppName}\{#MyAppIconName}_{#MyAppCompany}"; \
      Filename: "{app}\batch\mofa4q.bat"; \
      IconFilename: {app}\icons\mops_public.ico; \
      Comment: "Startet die QGIS mit dem Profil {#MyAppName}"; \
      WorkingDir: "{app}\batch"; \
      Flags: foldershortcut;
Name: "{autostartmenu}\{#MyAppName}\{#MyAppSyncIconName}_{#MyAppCompany}"; \
      Filename: "{app}\batch\mofa4q_sync.bat"; \
      IconFilename: {app}\icons\mops_sync_public.ico; \
      Comment: "Startet die Anwendung Mofa4q-Sync"; \
      WorkingDir: "{app}\batch"; \
      Flags: foldershortcut runminimized;

[Run]

[UninstallDelete]
;This works if it is installed in custom location
Type: files; Name: "{app}\*"; 
Type: filesandordirs; Name: "{app}"

[Code]
var 
  Label1: TLabel;

function frmDomainReg_CreatePage(PreviousPageId: Integer): Integer;
var 
  Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      'MoFa4Q Installer',
      'Installer wird QGIS und MoFa4Q-Profil'
  );
  Label1 := TLabel.Create(Page);
    with Label1 do
    begin
      Parent := Page.Surface;
      Caption := 'Mit dem Installer wird das QGIS und das MoFa4Q-Profil installiert.';
      Left := ScaleX(0);
      Top := ScaleY(0);
      Width := ScaleX(400);
      Height := ScaleY(17);
    end;
 end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  UsersPath: string;
  CommonDesktopShortPath: string;
  DesktopPath: string;
  ShortcutPath_1: string;
  ShortcutPath_2: string;
  FindRec: TFindRec;
  ShortcutsCount: Integer;
begin
  { Once the files are installed }
  if CurStep = ssPostInstall then
  begin
    Log('Creating shortcuts for all users');
    { Assuming the common users root (typically C:\Users) is two level up }
    { from the current user desktop folder }
    UsersPath :=
      AddBackslash(ExtractFilePath(RemoveBackslash(ExtractFilePath(
        RemoveBackslash(ExpandConstant('{userdesktop}'))))));
    Log(Format('Users root [%s]', [UsersPath]));
    CommonDesktopShortPath := GetShortName(ExpandConstant('{commondesktop}'));
    Log(Format('Common desktop [%s]', [CommonDesktopShortPath]));
    
    { check all users if exits icons and delete}
    { Iterate all users }
    ShortcutsCount := 0
    if FindFirst(UsersPath + '*', FindRec) then
    begin
      try
        repeat
          { Just directories, not interested in files }
          if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
          begin
            { Check if there is a Desktop subfolder }
            Log('Start: check all users if exits icons and delete');
            DesktopPath := UsersPath + FindRec.Name + '\Desktop';
            if DirExists(DesktopPath) then
            begin
              if CompareText(
                   CommonDesktopShortPath, GetShortName(DesktopPath)) = 0 then
              begin
                Log(Format('Skipping common desktop [%s]', [DesktopPath]));
              end
              else
              begin
                ShortcutPath_1 := DesktopPath + '\{#MyAppIconName}_{#MyAppCompany}.lnk';
                ShortcutPath_2 := DesktopPath + '\{#MyAppSyncIconName}_{#MyAppCompany}.lnk';
                Log(Format(
                  'Found desktop folder for user [%s], creating shortcut [%s]', [
                  FindRec.Name, ShortcutPath_1]));
                Log(Format(
                  'Found desktop folder for user [%s], creating shortcut [%s]', [
                  FindRec.Name, ShortcutPath_2]));
                try
                  DeleteFile(ExpandConstant(ShortcutPath_1));
                  DeleteFile(ExpandConstant(ShortcutPath_2));
                  Log(Format('Shortcut [%s] delete', [ShortcutPath_1]));
                  Log(Format('Shortcut [%s] delete', [ShortcutPath_2]));
                  Inc(ShortcutsCount);
                except
                  Log(Format('Failed to delete shortcut: %s', [GetExceptionMessage]));
                end;
              end;
            end;
          end;
        until not FindNext(FindRec);
      finally
        FindClose(FindRec);
      end;

      Log(Format('%d shortcuts created', [ShortcutsCount]));
    end
      else
    begin
      Log('Error: check all users if exits icons and delete');
      Log(Format('Error listing [%s]', [UsersPath]));
    end;
      
    { create icon for common or user desktop }
    log('create icon for common or user desktop');
    if isAdmin then
      begin
        CommonDesktopShortPath := GetShortName(ExpandConstant('{commondesktop}'));
        Log(Format('Common desktop [%s]', [CommonDesktopShortPath]));

        DesktopPath := CommonDesktopShortPath;
        ShortcutPath_1 := DesktopPath + '\{#MyAppIconName}_{#MyAppCompany}.lnk';
        ShortcutPath_2 := DesktopPath + '\{#MyAppSyncIconName}_{#MyAppCompany}.lnk';

        DeleteFile(ExpandConstant(ShortcutPath_1));
        DeleteFile(ExpandConstant(ShortcutPath_2));

        try
          ShortcutPath_1 := CreateShellLink(
              ShortcutPath_1, '', ExpandConstant('{app}\batch\mofa4q.bat'), '',
              ExpandConstant('{app}'), ExpandConstant('{app}\icons\mops_public.ico'), 0, SW_SHOWNORMAL);
          ShortcutPath_2 := CreateShellLink(
              ShortcutPath_2, '', ExpandConstant('{app}\batch\mofa4q_sync.bat'), '',
              ExpandConstant('{app}'), ExpandConstant('{app}\icons\mops_sync_public.ico'), 0, SW_SHOWNORMAL);
          Log(Format('Shortcut [%s] created', [ShortcutPath_1]));
          Log(Format('Shortcut [%s] created', [ShortcutPath_2]));
          Inc(ShortcutsCount);
        except
          Log(Format('Failed to create shortcut: %s', [GetExceptionMessage]));
        end;
      end
      else
      begin
        DesktopPath := GetShortName(ExpandConstant('{userdesktop}'));
        ShortcutPath_1 := DesktopPath + '\{#MyAppIconName}_{#MyAppCompany}.lnk';
        ShortcutPath_2 := DesktopPath + '\{#MyAppSyncIconName}_{#MyAppCompany}.lnk';

        Log(Format('User desktop [%s]', [DesktopPath]));
        try
          ShortcutPath_1 := CreateShellLink(
              ShortcutPath_1, '', ExpandConstant('{app}\batch\mofa4q.bat'), '',
              ExpandConstant('{app}'), ExpandConstant('{app}\icons\mops_public.ico'), 0, SW_SHOWNORMAL);
          ShortcutPath_2 := CreateShellLink(
              ShortcutPath_2, '', ExpandConstant('{app}\batch\mofa4q_sync.bat'), '',
              ExpandConstant('{app}'), ExpandConstant('{app}\icons\mops_sync_public.ico'), 0, SW_SHOWNORMAL);
          Log(Format('Shortcut [%s] created', [ShortcutPath_1]));
          Log(Format('Shortcut [%s] created', [ShortcutPath_2]));
        except
          Log(Format('Failed to create shortcut: %s', [GetExceptionMessage]));
        end;
      end;
    end;
end;

procedure ExitProcess(exitCode:integer);
  external 'ExitProcess@kernel32.dll stdcall';

function FileReplaceString(const FileName, SearchString, ReplaceString: string):boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      { Only save if text has been changed. }
      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

procedure ReplaceBatfile(DestDir: String; FileName: String);
var
  ResultCode: Integer;
begin
    ResultCode := 1;
    begin
        if CompareStr(ExpandConstant('{app}'),'C:\Program Files\{#MyAppName}') = 0 then begin
          Log('replace Path of Batchfiles: CompareStr is same');
        end
        else begin
          if FileExists(ExpandConstant(DestDir + '\' + FileName)) then begin
              Log('replace Path of Batchfiles: File found: '+DestDir+'\'+FileName);
              FileReplaceString(ExpandConstant(DestDir + '\' + FileName), 'installFolder=c:\PROGRA~1\MoFa4Q', 'installFolder='+ExpandConstant('{app}'));
          end
        end
    end
end;

procedure InstallQgis;
var
  ResultCode: Integer;
begin
  if ShellExec('', 'msiexec.exe',
    ExpandConstant('/I "{app}\other_programs\{#QGISFileName}.msi" /passive MSIFASTINSTALL=3 INSTALLDESKTOPSHORTCUTS=0 OPTIONS="noAutoStart=true"'),
      '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode)
  then
    begin
        Log('{#QGISFileName}.msi has been installed or is already installed. Continue with MoFa4Q!');
    end
    else begin
        SuppressibleMsgBox(ExpandConstant('{cm:ErrorOtherRunInstaller}') + #13#10 +
        SysErrorMessage(ResultCode), mbError, MB_OK, MB_OK);
        ExitProcess(0);
    end;
end;

procedure CheckAndInstallQgis;
begin
  DeleteFile(ExpandConstant('{app}\manifest.txt'));
  if FileExists(ExpandConstant('{app}\manifest.txt')) then begin
    Log('CheckAndInstallQgis: delete old manifest File!');
    DeleteFile(ExpandConstant('{app}\manifest.txt'))
  end;
  begin
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'appVersion='+'{#MyAppVersion}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'appPublisher='+'{#MyAppPublisher}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'supportQGIS='+'{#QGISVersion}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'qgisReleaseVersion='+'{#QGISReleaseVersion}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'qgisInstallPath='+'C:\PROGRA~1\QGIS {#QGISVersion}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'profilePath='+ ExpandConstant('{userappdata}\QGIS\QGIS3')+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), 'profileName='+'{#MyAppName}_{#MyAppCompany}'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), '##qgisSyncDev='+'dev'+ #13#10, True);
    SaveStringToFile(ExpandConstant('{app}\manifest.txt'), '##qgisSyncDevServer='+'C:\geopackages', True);
  end;
  begin
    Log('CheckAndInstallQgis: Check QGIS {#QGISVersion}!');
    if (DirExists('C:\Program Files\QGIS {#QGISVersion}\lib') = false) then
      begin
        Log('C:\Program Files\QGIS {#QGISVersion}\lib not exits!');
        InstallQgis;
      end
  end;
end;

procedure UninstallQgis;
var
  ResultCode: Integer;
begin
  if ShellExec('', 'msiexec.exe',
    ExpandConstant('/uninstall "{app}\other_programs\{#QGISFileName}.msi" MSIFASTINSTALL=3 /q /passive'),
      '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode)
  then
    begin
         Log('{#QGISFileName}.msi is uninstall. Bye Bye!');
    end
    else begin
        SuppressibleMsgBox(ExpandConstant('{cm:ErrorOtherRunInstaller}') + #13#10 + \
          SysErrorMessage(ResultCode), mbError, MB_OK, MB_OK);
        ExitProcess(0);
    end;

  if Exec(ExpandConstant('{app}\batch\uninstall_cleanup_qgisInstall.bat'), '', '', \
     SW_HIDE, ewWaitUntilTerminated, ResultCode)
  then
    begin
    Log('Succeeded running uninstall_cleanup_qgisInstall batch file');
    end
  else begin
    SuppressibleMsgBox(ExpandConstant('{cm:ErrorUninstallCleanupQgisInstall}') + #13#10 + \
        SysErrorMessage(ResultCode), mbError, MB_OK, MB_OK);
    ExitProcess(0);
    end;

end;

procedure UninstallShortcutAllUsers;
var
  ResultCode: Integer;
begin
  if Exec(ExpandConstant('{app}\batch\uninstall_icons_all_users.bat'), '', '', \
     SW_HIDE, ewWaitUntilTerminated, ResultCode)
  then
    begin
    Log('Succeeded running uninstall_icons_all_users batch file');
    end
  else begin
    SuppressibleMsgBox('Failed running uninstall_icons_all_users.bat file' + #13#10 + \
        SysErrorMessage(ResultCode), mbError, MB_OK, MB_OK);
    ExitProcess(0);
    end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DesktopPath: string;
  ShortcutPath_1: string;
  ShortcutPath_2: string;
  DeleteQGISProfilePath: integer;
  DeleteQGISPath: integer;
  DeleteProfileName: string;
begin
  Log('CurUninstallStepChanged + ' + IntToStr(Integer(CurUninstallStep)));
  case CurUninstallStep of
    usUninstall:      
      begin
        // Ask the user a Yes/No question, defaulting to YES
        DeleteQGISProfilePath := MsgBox(ExpandConstant('{cm:UninstallQgisProfile, {#MyAppName}_{#MyAppCompany}}'), mbConfirmation, MB_YESNO or MB_DEFBUTTON1)
        DeleteQGISPath := MsgBox(ExpandConstant('{cm:UninstallQgis, {#QGISVersion}}'), mbConfirmation, MB_YESNO or MB_DEFBUTTON1)

        if  DeleteQGISProfilePath = IDYES then
        //this is the msg that will display after uninstall,change is as you prefer
        begin
          DeleteProfileName := '{#MyAppName}_{#MyAppCompany}';
          Log('delete QGIS-Profil '+DeleteProfileName);
          DelTree(ExpandConstant('{userappdata}\QGIS\QGIS3\profiles\'+DeleteProfileName), True, True, True);
        end;

        if DeleteQGISPath = IDYES then
        //this is the msg that will display after uninstall,change is as you prefer
        begin
            if (DirExists('C:\Program Files\QGIS {#QGISVersion}\lib') = true) then
            begin
              Log('Uninstall QGIS MSI-File');
              UninstallQgis
            end;
        end;

        DesktopPath := 'C:\Users\Public\Desktop';
        if DirExists(DesktopPath) then
        begin
          Log('find DesktopPath:'+ DesktopPath);
          ShortcutPath_1 := DesktopPath + '\{#MyAppIconName}_{#MyAppCompany}.lnk';
          ShortcutPath_2 := DesktopPath + '\{#MyAppSyncIconName}_{#MyAppCompany}.lnk';
          DeleteFile(ExpandConstant(ShortcutPath_1));
          DeleteFile(ExpandConstant(ShortcutPath_2));
          Log('delete Shortcut:'+ ShortcutPath_1);
          Log('delete Shortcut:'+ ShortcutPath_2);
        end;
        begin
          Log('Start uninstall  Shortcut all users');
          UninstallShortcutAllUsers
        end;
      end;
  end;
end;


procedure InitializeWizard();
begin
{this page will come after welcome page}
frmDomainReg_CreatePage(wpWelcome);
end;