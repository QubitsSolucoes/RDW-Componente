{
O DWInstall foi desenvolvido para auxiliar na instalação e atualizãção do REST Dataware.
Fica a descrição do desenvolvedor escolher as plataformas e configurar o programa com as informações necessárias.

Desenvolvedor: Anderson Fiori

Colaboradores: Ico Menezes
               Paulo Cesar Tenório
}

Unit Main;

Interface

  Uses
    Winapi.Windows,
    Winapi.Messages,
    System.IniFiles,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Imaging.pngimage,
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.CheckLst,
    Registry,
    Vcl.Buttons,
    Vcl.FileCtrl,
    About,
    Vcl.Imaging.jpeg,
    ShellApi,
    System.Math,

    // verificar possibilidade
    System.Generics.Collections,
    Vcl.ComCtrls;

  Type
    TDestino = (TdSystem, TdDelphi, TdNone);

  Type
    TDataSetInc = (tiClientDataSet, tiDWMemTable, tiFDMemTable, tiKBMemTable, tiJVMemoryData);

    TfrmMain = Class(TForm)
      pnlTopo: TPanel;
      Label9: TLabel;
      Label10: TLabel;
      pnlToobar: TPanel;
      btnInstall: TButton;
      btnCancelar: TButton;
      pnlForms: TPanel;
      Label4: TLabel;
      lblPacote: TLabel;
      ckUseJEDI: TCheckBox;
      ckUseFireDAC: TCheckBox;
      ckUseKBMemTable: TCheckBox;
      Label7: TLabel;
      Label2: TLabel;
      edtDirFontes: TEdit;
      btnSelecDirInstall: TSpeedButton;
      RESTDWDriverFD_dpk: TCheckBox;
      RESTDWDriverZEOS_dpk: TCheckBox;
      Label8: TLabel;
      Label1: TLabel;
      ckUseDWMEM: TCheckBox;
      RESTDWDriverUniDAC_dpk: TCheckBox;
      Label3: TLabel;
      Image1: TImage;
      lblAbout: TLabel;
      EdtDelphiVersion: TEdit;
      ckUseClientDataSet: TCheckBox;
      ckbRemoverArquivosAntigos: TCheckBox;
      Label5: TLabel;
      clbDelphiLibrary: TCheckListBox;
      mmoMsg: TMemo;
      cbxDelphiVersion: TComboBox;
      cbxDelphiCode: TComboBox;
      pg: TPageControl;
      tab_instalacao: TTabSheet;
      tab_log: TTabSheet;
      mmoLog: TMemo;
      tbRepositorio: TTabSheet;
      ckbFecharTortoise: TCheckBox;
      btnSVNCheckoutUpdate: TSpeedButton;
      edtURL: TEdit;
      Label6: TLabel;
      lblInfoObterFontes: TLabel;
    btnFinalizar: TButton;
      Procedure btnCancelarClick(Sender: TObject);
      Procedure btnInstallClick(Sender: TObject);
      Procedure clbDelphiVersionClickCheck(Sender: TObject);
      Procedure FormCreate(Sender: TObject);
      Procedure SetDelphiVersionForInstallation;
      Procedure btnSelecDirInstallClick(Sender: TObject);
      Procedure LerChavesRegistro(root: HKEY; chave: String);
      Procedure checarChDelphi;
      Procedure lblAboutClick(Sender: TObject);
      Procedure Image1Click(Sender: TObject);
      Function GetPathDWInc: TFileName;
      Function RunAsAdminAndWaitForCompletion(HWnd: HWnd; Filename: String): Boolean;

      Procedure RemoverArquivosAntigosDoDisco;
      Procedure CriarBatCompile(projFile: String; NomeBat: String; NomeLog: String; Pacote: String);
      Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
      Procedure ckUseDWMEMClick(Sender: TObject);
      Procedure ckUseJEDIClick(Sender: TObject);
      Procedure ckUseFireDACClick(Sender: TObject);
      Procedure ckUseKBMemTableClick(Sender: TObject);
      Function SepararListaLibrary(lista: String; Const delim: char): TStrings;
      Procedure InserirLibrarySeNaoExistir(valueToAdd: String);
      Procedure GetDriveLetters(AList: TStrings);
      Procedure WriteToTXT(Const ArqTXT: String; ABinaryString: AnsiString; Const AppendIfExists: Boolean = True; Const AddLineBreak: Boolean = True);
      Procedure DefineDWInc(Const ADefineName: TDataSetInc);
      Procedure ckUseClientDataSetClick(Sender: TObject);
      Procedure MultiSelect;
      Procedure clbDelphiLibraryClickCheck(Sender: TObject);
      Function textoCLBListBox: String;

      Procedure InserirKnownPackage(valueToAdd: String; NomeBPL: String; Description: String);
      procedure RemoverDisabledPackage(aValue: String; LibraryToRemove: String);
      procedure RemoverOldPackage(aValue: String; LibraryToRemove: String);
      Procedure btnSVNCheckoutUpdateClick(Sender: TObject);
      FUNCTION IsCheckOutJaFeito(CONST ADiretorio: STRING): Boolean;
      Procedure tbRepositorioShow(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure cbxDelphiVersionSelect(Sender: TObject);


      Private

        FCountErros: Integer;
        IVersion   : Integer;
        SDirRoot   : String;
        SDirLibrary: String;
        SDirPackage: String;
        SDirDriverFD: String;
        SDirDriverZeos: String;
        SDirDriverUNIDAC: String;

        PastaDW    : String;
        SDestino   : TDestino;
        SPathBin   : String;
        { Private declarations }
        FProductVersion: String;
        FVersionDelphi : TList<String>;
        FRegistroWindows : String;

        PlatChave: String;

        // HKEY_CURRENT_USER\Software\Embarcadero\BDS\19.0\Library\Win32    chave pra add as library path
        Procedure LerConfiguracoes;
        Procedure GravarConfiguracoes;
        Procedure MontarPlataforma;
        function InstalarDW: Boolean;
        function RetornaRegistro(Versao : String):string;
        procedure CompilarDCC32(projFile: String; NomeBat: String; NomeLog: String; Pacote: String);
        Function RetornarChaveCliente(SKey: String; NomeDelphi: String): String;

      Public
        { Public declarations }
        Property ProductVersion: String Read FProductVersion Write FProductVersion;
        Property VersionDelphi : TList<String> Read FVersionDelphi Write FVersionDelphi;
        Property RegistroWindows : String Read FRegistroWindows Write FRegistroWindows;
    End;

  Var
    frmMain                 : TfrmMain;
    ListaLibraryPathToAdd   : TStrings;
    ListaLibraryPathToRemove: TStrings;

Implementation

{$R *.dfm}

Uses
  SVN_Class;

Procedure TfrmMain.btnCancelarClick(Sender: TObject);
Begin
  IF Application.MessageBox('Deseja realmente cancelar a instalação?', 'Fechar', MB_ICONQUESTION + MB_YESNO) = ID_YES THEN
  Begin
    Self.Close;
  End;
End;

procedure TfrmMain.btnFinalizarClick(Sender: TObject);
begin
  Application.Terminate;
end;

Procedure TfrmMain.btnInstallClick(Sender: TObject);
Begin

 checarChDelphi;

  if InstalarDW then
  begin
    ShowMessage('Instalação concluída com sucesso!');
    btnFinalizar.Visible := True;
    btnInstall.Visible   := false;
    btnCancelar.Visible  := false;
  end;
End;


Procedure TfrmMain.btnSelecDirInstallClick(Sender: TObject);
Var
  Dir: String;
Begin
  IF SelectDirectory('Selecione o diretório de instalação', '', Dir, [SdNewFolder, SdNewUI, SdValidateDir]) THEN
    edtDirFontes.Text := Dir;
End;

Procedure TfrmMain.btnSVNCheckoutUpdateClick(Sender: TObject);
Begin
  // chamar o método de update ou checkout conforme a necessidade
  IF TButton(Sender).Tag > 0 THEN
  BEGIN
    // criar o diretório onde será baixado o repositório
    IF NOT DirectoryExists(edtDirFontes.Text) THEN
    BEGIN
      IF NOT ForceDirectories(edtDirFontes.Text) THEN
      BEGIN
        RAISE EDirectoryNotFoundException.Create('Ocorreu o seguinte erro ao criar o diretório' + SLineBreak + SysErrorMessage(GetLastError));
      END;
    END;

    // checkout
    TSVN_Class.SVNTortoise_CheckOut(edtURL.Text, edtDirFontes.Text, ckbFecharTortoise.Checked);
  END
  ELSE
  BEGIN
    // update
    TSVN_Class.SVNTortoise_Update(edtDirFontes.Text, ckbFecharTortoise.Checked);
  END;
End;

procedure TfrmMain.cbxDelphiVersionSelect(Sender: TObject);
begin
cbxDelphiCode.ItemIndex:= cbxDelphiVersion.ItemIndex;
SetDelphiVersionForInstallation;
MontarPlataforma;
end;

Procedure TfrmMain.checarChDelphi; // Controla pra não deixar sem marcar alguma versão do Delphi.
Begin
  IF cbxDelphiVersion.ItemIndex = -1 THEN
    Raise Exception.Create('Selecione uma versão do Delphi para instalar.');
End;

Procedure TfrmMain.ckUseClientDataSetClick(Sender: TObject);
Begin
  ckUseJEDI.Checked       := False;
  ckUseFireDAC.Checked    := False;
  ckUseKBMemTable.Checked := False;
  ckUseDWMEM.Checked      := False;
End;

Procedure TfrmMain.ckUseDWMEMClick(Sender: TObject);
Begin

  ckUseJEDI.Checked          := False;
  ckUseFireDAC.Checked       := False;
  ckUseKBMemTable.Checked    := False;
  ckUseClientDataSet.Checked := False;
End;

Procedure TfrmMain.ckUseFireDACClick(Sender: TObject);
Begin

  ckUseJEDI.Checked          := False;
  ckUseDWMEM.Checked         := False;
  ckUseKBMemTable.Checked    := False;
  ckUseClientDataSet.Checked := False;

End;

Procedure TfrmMain.ckUseJEDIClick(Sender: TObject);
Begin

  ckUseDWMEM.Checked         := False;
  ckUseFireDAC.Checked       := False;
  ckUseKBMemTable.Checked    := False;
  ckUseClientDataSet.Checked := False;

End;

Procedure TfrmMain.ckUseKBMemTableClick(Sender: TObject);
Begin

  ckUseJEDI.Checked          := False;
  ckUseFireDAC.Checked       := False;
  ckUseDWMEM.Checked         := False;
  ckUseClientDataSet.Checked := False;

End;

Procedure TfrmMain.clbDelphiLibraryClickCheck(Sender: TObject);
Begin
  // não posso deixar marcar mais de uma opção, pois preciso que seja dinâmica a inserção da library path.
  // não remova esta função.
  MultiSelect;
End;

Procedure TfrmMain.clbDelphiVersionClickCheck(Sender: TObject);
Begin
  SetDelphiVersionForInstallation;
End;

Procedure TfrmMain.DefineDWInc(Const ADefineName: TDataSetInc);
Var
  F: TStringList;
  I: Integer;
Begin
  F := TStringList.Create;
  Try
    F.LoadFromFile(GetPathDWInc);

    Case ADefineName Of
      tiClientDataSet:
        If Not ckUseClientDataSet.Checked Then
          F.Text := StringReplace(F.Text, '{$DEFINE CLIENTDATASET}', '{.$DEFINE CLIENTDATASET}', [rfReplaceAll])
        Else
          F.Text := StringReplace(F.Text, '{.$DEFINE CLIENTDATASET}', '{$DEFINE CLIENTDATASET}', [rfReplaceAll]);

      tiDWMemTable:
        If Not ckUseDWMEM.Checked Then
          F.Text := StringReplace(F.Text, '{$DEFINE DWMEMTABLE}', '{.$DEFINE DWMEMTABLE}', [rfReplaceAll])
        Else
          F.Text := StringReplace(F.Text, '{.$DEFINE DWMEMTABLE}', '{$DEFINE DWMEMTABLE}', [rfReplaceAll]);

      tiFDMemTable:
        If Not ckUseFireDAC.Checked Then
          F.Text := StringReplace(F.Text, '{$DEFINE RESTFDMEMTABLE}', '{.$DEFINE RESTFDMEMTABLE}', [rfReplaceAll])
        Else
          F.Text := StringReplace(F.Text, '{.$DEFINE RESTFDMEMTABLE}', '{$DEFINE RESTFDMEMTABLE}', [rfReplaceAll]);

      tiKBMemTable:
        If Not ckUseKBMemTable.Checked Then
          F.Text := StringReplace(F.Text, '{$DEFINE RESTKBMMEMTABLE}', '{.$DEFINE RESTKBMMEMTABLE}', [rfReplaceAll])
        Else
          F.Text := StringReplace(F.Text, '{.$DEFINE RESTKBMMEMTABLE}', '{$DEFINE RESTKBMMEMTABLE}', [rfReplaceAll]);

      tiJVMemoryData:
        If Not ckUseJEDI.Checked Then
          F.Text := StringReplace(F.Text, '{$DEFINE RESJEDI}', '{.$DEFINE RESJEDI}', [rfReplaceAll])
        Else
          F.Text := StringReplace(F.Text, '{.$DEFINE RESJEDI}', '{$DEFINE RESJEDI}', [rfReplaceAll]);
    End;
    F.SaveToFile(GetPathDWInc);
  Finally
    F.Free;
  End;

End;


Procedure TfrmMain.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  IF Assigned(ListaLibraryPathToAdd) THEN
    FreeAndNil(ListaLibraryPathToAdd);

  IF Assigned(ListaLibraryPathToRemove) THEN
    FreeAndNil(ListaLibraryPathToRemove);
End;

Procedure TfrmMain.FormCreate(Sender: TObject);
Begin
RegistroWindows       := 'Software\Embarcadero\BDS';
  LerChavesRegistro(HKEY_CURRENT_USER, RegistroWindows);
  LerConfiguracoes;
  GravarConfiguracoes;
End;

Procedure TfrmMain.GetDriveLetters(AList: TStrings);
Var
  VDrivesSize: Cardinal;
  VDrives    : ARRAY [0 .. 128] OF char;
  VDrive     : PChar;
  VDriveType : Cardinal;
Begin
  AList.BeginUpdate;
  Try

    AList.Clear;
    VDrivesSize := GetLogicalDriveStrings(SizeOf(VDrives), VDrives);
    IF VDrivesSize = 0 THEN
      Exit;

    VDrive := VDrives;
    While VDrive^ <> #0 DO
    Begin
      // adicionar somente drives fixos
      VDriveType := GetDriveType(VDrive);
      IF VDriveType = DRIVE_FIXED THEN
        AList.Add(StrPas(VDrive));

      Inc(VDrive, SizeOf(VDrive));
    End;
  Finally
    AList.EndUpdate;
  End;
End;

Function TfrmMain.GetPathDWInc: TFileName;
Begin
  Result := IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\uRESTDW.inc';
End;

Procedure TfrmMain.GravarConfiguracoes;
Var
  ArqIni : TIniFile;
  Arquivo: String;
  I      : Integer;
Begin
  Arquivo := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');
  ArqIni  := TIniFile.Create(Arquivo);
  Try
    ArqIni.WriteString('CONFIG', 'DirFontes', Trim(edtDirFontes.Text));

    ArqIni.WriteBool('DRIVER', 'DrvFireDAC', RESTDWDriverFD_dpk.Checked);
    ArqIni.WriteBool('DRIVER', 'DrvZEOS', RESTDWDriverZEOS_dpk.Checked);
    ArqIni.WriteBool('DRIVER', 'DrvUniDAC', RESTDWDriverUniDAC_dpk.Checked);

    ArqIni.WriteBool('DATASET', 'DwMemTable', ckUseDWMEM.Checked);
    ArqIni.WriteBool('DATASET', 'JVMemoryData', ckUseJEDI.Checked);
    ArqIni.WriteBool('DATASET', 'FDMemTable', ckUseFireDAC.Checked);
    ArqIni.WriteBool('DATASET', 'KBMemTable', ckUseKBMemTable.Checked);
    ArqIni.WriteBool('DATASET', 'ClientDataSet', ckUseClientDataSet.Checked);
  Finally
    ArqIni.Free;
  End;
End;

Procedure TfrmMain.Image1Click(Sender: TObject);
Begin
  lblAbout.OnClick(Self);
End;

// Registrando a bpl na IDE
Procedure TfrmMain.InserirKnownPackage(valueToAdd: String; NomeBPL: String; Description: String);
Var
  reg        : TRegistry;
  key        : String;
  I          : Integer;
  ListaKnown : TStringList;
Begin
  Try
    reg        := TRegistry.Create;
    ListaKnown := TStringList.Create;

    reg.RootKey := HKEY_CURRENT_USER;

    key := RegistroWindows+'\' + cbxDelphiCode.Text + '\Known Packages';

    reg.OpenKey(key, False);

    reg.GetValueNames(ListaKnown);

    For I := ListaKnown.Count -1 downto 0 Do
    Begin

      If Pos(NomeBPL, ListaKnown[I]) > 0 Then
         reg.DeleteValue(ListaKnown[i]);

         reg.WriteString(valueToAdd,Description);

    End;
  Finally
    reg.CloseKey;
    reg.Free;
    ListaKnown.Free;
  End;
End;

Procedure TfrmMain.InserirLibrarySeNaoExistir(valueToAdd: String);
Var
  A         : Boolean;
  reg       : TRegistry;
  lista, key: String;
  I, J      : Integer;
Begin
  Try
    reg                   := TRegistry.Create;
    ListaLibraryPathToAdd := TStringList.Create;

    reg.RootKey := HKEY_CURRENT_USER;
    // pego a versão e a plataforma em runtime
    if (textoCLBListBox <> '') then
    begin
    key := RegistroWindows+'\' + cbxDelphiCode.Text + '\Library\' + textoCLBListBox;
    end else
     key := RegistroWindows+'\' + cbxDelphiCode.Text + '\Library\' ;
    reg.OpenKey(key, False);

    lista                 := reg.ReadString('Search Path');
    ListaLibraryPathToAdd := SepararListaLibrary(lista, ';');

    Begin
      A     := False;
      FOR I := ListaLibraryPathToAdd.Count - 1 Downto 0 DO
      Begin
        IF Not(ListaLibraryPathToAdd.Strings[I] = valueToAdd) THEN
        Begin
          IF Not A THEN
            A := False;
        End
        Else
          A := True;
      End;

      IF Not A THEN
        ListaLibraryPathToAdd.Add(valueToAdd);
    End;

    lista   := '';
    FOR I   := 0 TO ListaLibraryPathToAdd.Count - 1 DO
      lista := lista + ListaLibraryPathToAdd.Strings[I];

    IF reg.DeleteValue('Search Path') THEN
      reg.WriteString('Search Path', lista);
  Finally
    reg.CloseKey;
    reg.Free;

  End;
End;

function TfrmMain.InstalarDW: Boolean;
  Var
    DelphiVer: String;
    dirbkpreg: String;
    strbkpreg: String;
    N        : Integer;
    delim    : String;
    IListaVer: Integer;
    cur      : TCursor;
Begin
  Result:= True; // Entra na funcao TRUE e recebe FALSE se houver algum erro ... senão é pq foi até o fim sem erros
  {$IFDEF DEBUG}
     if FindWindow('TAppBuilder', nil) > 0 then
     raise Exception.Create('Feche a IDE do delphi antes de continuar.');
  {$ENDIF}

  Try
    Try
      dirbkpreg := ExtractFilePath(ParamStr(0))+'Regbkp'+cbxDelphiVersion.Text+'.bat';
      strbkpreg := 'reg export HKEY_CURRENT_USER\'+RegistroWindows+'\'+cbxDelphiCode.Text+' "bkpReg'+cbxDelphiVersion.Text+'.reg"';

      WriteToTXT(dirbkpreg,strbkpreg,false);
      ShellExecute(handle,'open',PChar(dirbkpreg), '','',SW_HIDE);



      GravarConfiguracoes;
      Screen.Cursor := crSQLWait;


      IF edtDirFontes.Text = '' THEN
        Raise Exception.Create('A pasta dos fontes não pode ser vazia.');
      IF Not DirectoryExists(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE') THEN
        Raise Exception.Create('Atenção!!!!' + #13 + 'O Pacote não foi encontrado, favor controlar o caminho!!!');

      checarChDelphi;

      IF ckbRemoverArquivosAntigos.Checked THEN
      Begin
        RemoverArquivosAntigosDoDisco;
      End;

      DefineDWInc(tiClientDataSet);
      DefineDWInc(tiDWMemTable);
      DefineDWInc(tiFDMemTable);
      DefineDWInc(tiKBMemTable);
      DefineDWInc(tiJVMemoryData);

      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source;');
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\libs;');
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\libs\JSON;');
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\Memdataset;');
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\DmDados;');
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Packages\Delphi\' + ProductVersion + ';');



      SDirPackage:= (IncludeTrailingPathDelimiter(edtDirFontes.Text)) + 'CORE\Packages\Delphi\'+ ProductVersion;
      SDirDriverFD:= (IncludeTrailingPathDelimiter(edtDirFontes.Text)) +'CORE\Source\Connectors\FireDAC\Package\Berlin';
      SDirDriverZeos:= (IncludeTrailingPathDelimiter(edtDirFontes.Text)) +'CORE\Source\Connectors\ZEOS\Package\Berlin';
      SDirDriverUNIDAC:= (IncludeTrailingPathDelimiter(edtDirFontes.Text)) +'CORE\Source\Connectors\UniDAC\Package\Berlin';

      //Tratando qual delphi está sendo instalado pra saber se chamar a DCC32 ou o msbuild
      delim:= '.';
      N := Pos(delim, cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex]);
      DelphiVer := (copy(cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex], 1, (N-1)));

       if StrToInt(DelphiVer) <= 8 then  //Se o Delphi escolhido para instalação for menor que o 2010 vai chamar o DCC32
                                         //Mantenho essa possibilidade para futura necessidade de compatibilidade

      begin
        CompilarDCC32('RestEasyObjectsCORE.dpk','CompilarDW.bat','LogCORE.txt',SDirPackage);

      if not FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'BPL\RestDatawareCORE.BPL') then
      begin
      if FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogCORE.txt') then
        mmoLog.Lines.LoadFromFile(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogCORE.txt');
        pg.TabIndex:= tab_log.PageIndex;
        raise Exception.Create('Error ao instalar o pacote, contate o suporte ou o instale manualmente.');
      end else
       InserirKnownPackage(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL\RestDatawareCORE.bpl','RestDatawareCORE.bpl','REST Dataware CORE');
      end

      else

      begin
      RemoverDisabledPackage('RestDatawareCORE.bpl','\Disabled Packages');
      RemoverOldPackage('RestDatawareCORE.bpl','\Package Cache');
      RemoverOldPackage('RestDatawareCORE.bpl','\Palette\Cache');

      CriarBatCompile('RestDatawareCORE.dproj','CompilarDW.bat','LogCORE.txt',SDirPackage);

      if not FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'BPL\RestDatawareCORE.BPL') then
      begin
      if FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogCORE.txt') then
        mmoLog.Lines.LoadFromFile(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogCORE.txt');
        pg.TabIndex:= tab_log.PageIndex;
        raise Exception.Create('Error ao instalar o pacote, contate o suporte ou o instale manualmente.');
      end else
       InserirKnownPackage(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL\RestDatawareCORE.bpl','RestDatawareCORE.bpl','REST Dataware CORE');
       end;



      if RESTDWDriverFD_dpk.Checked then
      begin
      CriarBatCompile('RESTDWDriverFD.dproj','CompilarDriverFD.bat','LogDriverFD.txt',SDirDriverFD);
      InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\Connectors\FireDAC;');
       if not FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'BPL\RESTDWDriverFD.BPL') then
       begin
        if FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverFD.txt') then
        mmoLog.Lines.LoadFromFile(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverFD.txt');
        pg.TabIndex:= tab_log.PageIndex;
        raise Exception.Create('Error ao instalar o pacote, contate o suporte ou o instale manualmente.');
       end else
        InserirKnownPackage(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL\RESTDWDriverFD.bpl','RESTDWDriverFD.bpl','REST Dataware CORE - Driver FireDAC');
      end;

      if RESTDWDriverZEOS_dpk.Checked then
      begin
        CriarBatCompile('RESTDWDriverZEOS.dproj','CompilarDriverZeos.bat','LogDriverZeos.txt',SDirDriverZeos);
        InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\Connectors\ZEOS;');
         if not FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'BPL\RESTDWDriverZEOS.BPL') then
       begin
        if FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverZeos.txt') then
        mmoLog.Lines.LoadFromFile(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverZeos.txt');
        pg.TabIndex:= tab_log.PageIndex;
        raise Exception.Create('Error ao instalar o pacote, contate o suporte ou o instale manualmente.');
       end else
        InserirKnownPackage(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL\RESTDWDriverZEOS.bpl','RESTDWDriverZEOS.bpl','REST Dataware CORE - Driver ZEOS');
      end;

      if RESTDWDriverUniDAC_dpk.Checked then
      begin
       CriarBatCompile('RESTDWDriverUNIDAC.dproj','CompilarDriverUniDAC.bat','LogDriverUniDAC.txt',SDirDriverZeos);
       InserirLibrarySeNaoExistir(IncludeTrailingPathDelimiter(edtDirFontes.Text) + 'CORE\Source\Connectors\UniDAC;');
       if not FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'BPL\RESTDWDriverUNIDAC.BPL') then
       begin
        if FileExists(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverUniDAC.txt') then
        mmoLog.Lines.LoadFromFile(IncludeTrailingPathDelimiter(SDirPackage)+'Logs\LogDriverUniDAC.txt');
        pg.TabIndex:= tab_log.PageIndex;
        raise Exception.Create('Error ao instalar o pacote, contate o suporte ou o instale manualmente.');
       end else
        InserirKnownPackage(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL\RESTDWDriverUNIDAC.bpl','RESTDWDriverUNIDAC.bpl','REST Dataware CORE - Driver UniDAC');
      end;


    except
      Result:= False;
    end;
  Finally
    Screen.Cursor := crDefault;
  End;
end;

Function TfrmMain.IsCheckOutJaFeito(Const ADiretorio: STRING): Boolean;
BEGIN
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ADiretorio) + '.svn')
END;

Procedure TfrmMain.lblAboutClick(Sender: TObject);
Begin
  Try
    Application.CreateForm(TfrmAbout, frmAbout);
    frmAbout.ShowModal;
  Finally
    FreeAndNil(frmAbout);
  End;
End;

Procedure TfrmMain.LerChavesRegistro(root: HKEY; chave: String); // Criar CheckBox com as versões do Delphi
Var
  VerKey     : TStringList;
  VerReg     : TRegistry;
  V          : Integer;
  VersionName: String;
Begin
  VerKey := TStringList.Create;
  VerReg := TRegistry.Create(root);

  if VerReg.KeyExists(chave) then
  IF Not VerReg.OpenKey(chave, False) THEN
  Begin
    ShowMessage('Não foram encontradas informações sobre sua versão instalada do Delphi em: ' + chave + '.');
    Abort;
  End;

  // Versões
  VerReg.GetKeyNames(VerKey);
  VerReg.CloseKey();
  VerReg.Free;

  VersionDelphi := TList<String>.Create;

  FOR V := 0 TO VerKey.Count - 1 DO
  Begin
    VerReg         := TRegistry.Create(KEY_READ);
    VerReg.RootKey := HKEY_CURRENT_USER;
    VersionName    := VerKey.Strings[V];
    Try
      IF VerReg.KeyExists(chave + '\' + VersionName + '\Known Packages') THEN
        IF VerReg.OpenKey(chave + '\' + VersionName + '\Known Packages', False) THEN
        Begin

         IF VersionName = '12.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio XE4');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '13.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio XE5');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '14.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio XE6');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '15.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio XE7');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '16.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio XE8');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '17.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio 10 Seattle');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '18.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio 10 Berlin');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End
          Else IF VersionName = '19.0' THEN
          Begin
            cbxDelphiVersion.Items.Add('RAD Studio 10 Tokyo');
            cbxDelphiCode.Items.Add(VersionName);
            VersionDelphi.Add(VersionName);
          End;
        End;
    Finally
      VerReg.CloseKey();
      VerReg.Free;
    End;
  End;

  VerKey.Free;
End;

Procedure TfrmMain.LerConfiguracoes;
Var
  ArqIni : TIniFile;
  Arquivo: String;
  I      : Integer;
Begin
  Arquivo := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');
  ArqIni  := TIniFile.Create(Arquivo);
  Try
    edtDirFontes.Text := ArqIni.ReadString('CONFIG', 'DirFontes', ExtractFilePath(ParamStr(0)));

    RESTDWDriverFD_dpk.Checked     := ArqIni.ReadBool('DRIVER', 'DrvFireDAC', False);
    RESTDWDriverZEOS_dpk.Checked   := ArqIni.ReadBool('DRIVER', 'DrvZEOS', False);
    RESTDWDriverUniDAC_dpk.Checked := ArqIni.ReadBool('DRIVER', 'DrvUniDAC', False);

    ckUseDWMEM.Checked         := ArqIni.ReadBool('DATASET', 'DwMemTable', False);
    ckUseJEDI.Checked          := ArqIni.ReadBool('DATASET', 'JVMemoryData', False);
    ckUseFireDAC.Checked       := ArqIni.ReadBool('DATASET', 'FDMemTable', False);
    ckUseKBMemTable.Checked    := ArqIni.ReadBool('DATASET', 'KBMemTable', False);
    ckUseClientDataSet.Checked := ArqIni.ReadBool('DATASET', 'ClientDataSet', False);
  Finally
    ArqIni.Free;
  End;
End;

Procedure TfrmMain.MontarPlataforma;
Var
  PlatChave: String;
  PlatKey  : TStringList;
  PlatReg  : TRegistry;
  P      : Integer;
  PlatName : String;

Begin

  PlatChave := RegistroWindows+'\' + cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex] + '\Library';

  clbDelphiLibrary.Clear;
  PlatKey := TStringList.Create;
  PlatReg := TRegistry.Create(HKEY_CURRENT_USER);

  IF Not PlatReg.OpenKey(PlatChave, False) THEN
  Begin
    ShowMessage('Não foram encontradas informações de Plataforma para a sua versão instalada do Delphi em: ' + PlatChave + '.');
    Abort;
  End;

  PlatReg.GetKeyNames(PlatKey);
  PlatReg.CloseKey();
  PlatReg.Free;

  FOR P := 0 TO PlatKey.Count - 1 DO
  Begin
    PlatReg         := TRegistry.Create(KEY_READ);
    PlatReg.RootKey := HKEY_CURRENT_USER;
    PlatName        := PlatKey.Strings[P];
    IF PlatReg.KeyExists(PlatChave) THEN
      IF PlatReg.OpenKey(PlatChave, False) THEN
      Begin
        clbDelphiLibrary.Items.Add(PlatName);
      End;
  End;

  IF Assigned(PlatKey) THEN
    PlatKey.Free;
  IF Assigned(PlatReg) THEN
    PlatReg.Free;

End;

Procedure TfrmMain.MultiSelect;
Var
  I: Integer;
Begin
  With clbDelphiLibrary Do
  Begin
    If (Checked[ItemIndex]) Then
    Begin
      Items.BeginUpdate;
      For I := 0 To Pred(Items.Count) Do
      Begin
        If (I <> ItemIndex) Then
          Checked[I] := False;
      End;
      Items.EndUpdate;
    End;
  End;
End;

procedure TfrmMain.CompilarDCC32(projFile: String; NomeBat: String; NomeLog: String; Pacote: String);
const
  Versoes : array[0..10] of string =
          ('8.0',
            '9.0',
            '10.0',
            '11.0',
            '12.0',
            '13.0',
            '14.0',
            '15.0',
            '17.0',
             '18.0',
             '19.0'
          );
Var
  libraryDW: TStrings;
  rtlPath  : String;
  ParamLib : String;
  SPathPrj: String;

  xAuxCompiler,
  xAuxCompiler1,
  xAuxCompiler2  : String;
  rsvarsDirDelphi: String;
  PathBat        : String;
  ConteudoArquivo: TStringList;
  I              : Integer;
  reg : TRegistry;
  lista,
  key: String;


begin
  for I := Low(Versoes) to High(Versoes) do
   if Versoes[i] = cbxDelphiCode.Text then
   begin
    rtlPath :=  '"'+RetornaRegistro(cbxDelphiCode.Text)+'lib\Win32\release"';
   end else
   begin
     rtlPath :=  '"'+RetornaRegistro(cbxDelphiCode.Text)+ '\Lib"';
   end;


  If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'Logs') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'Logs');
      If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL');
          If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'DCU') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'DCU');

  PathBat := ExtractFilePath(ParamStr(0)) + NomeBat;


  try
    reg                   := TRegistry.Create;
    reg.RootKey := HKEY_CURRENT_USER;

    key := RegistroWindows+'\' + cbxDelphiCode.Text + '\Library\' + textoCLBListBox;
    reg.OpenKey(key, False);
    lista := reg.ReadString('Search Path');

    libraryDW:= TStrings.Create;
    libraryDW:= SepararListaLibrary(lista,';');
     for I := libraryDW.Count - 1 downto 0 do
     begin
       if  pos('CORE',libraryDW[i])<=0 then
        libraryDW.Delete(i);
     end;

    lista := '';

   for I := libraryDW.Count - 1 downto 0 do
     begin
      lista:= lista + libraryDW[i];
     end;

    ConteudoArquivo:= TStringList.Create;

    ConteudoArquivo.add('echo off');
    ConteudoArquivo.add('set PRJ='+projFile);
    ConteudoArquivo.add('set DIR_PRJ='+SDirPackage);
    ConteudoArquivo.add('set DIR_DELPHI='+'"'+RetornaRegistro(cbxDelphiCode.Text)+'\bin\dcc32.exe"');
    ConteudoArquivo.add('set DIR_OUTPUT='+ IncludeTrailingPathDelimiter(SDirPackage) + 'BPL');
    ConteudoArquivo.add('set DIR_OUTDCU='+ IncludeTrailingPathDelimiter(SDirPackage) + 'DCU');
    ConteudoArquivo.add('set Param_Library='+rtlPath+';'+lista);
    ConteudoArquivo.add('set Param_U=%Param_Library%');
    ConteudoArquivo.add('set Param_I=%Param_Library%');
    ConteudoArquivo.add('set Param_O=%Param_Library%');
    ConteudoArquivo.add('set Param_S=System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;System;Xml;Data;Datasnap;Web;Soap;Posix;Winapi;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell');
    ConteudoArquivo.add('set Param_Conf=-$O- -$W+ -B -Q -Z -TX.bpl -DCONSOLE_TESTRUNNER');
    ConteudoArquivo.add('cd %DIR_PRJ%');
    ConteudoArquivo.add('%DIR_DELPHI% -E%DIR_OUTPUT% -N0%DIR_OUTDCU% -LE%DIR_OUTPUT% -LN%DIR_OUTPUT% %Param_Conf% -I%Param_I% -U%Param_U% -O%Param_O% -NS%Param_S% %PRJ% > %DIR_PRJ%\Logs\'+NomeLog);


     WriteToTXT(PathBat, ConteudoArquivo.Text, False);
  finally
    reg.CloseKey;
    reg.Free;
    libraryDW.Free;
    ConteudoArquivo.Free;
  end;
   RunAsAdminAndWaitForCompletion(Handle, PathBat);
end;

Procedure TfrmMain.CriarBatCompile(projFile: String; NomeBat: String; NomeLog: String; Pacote: String);
Var
  xAuxCompiler,
  xAuxCompiler1,
  xAuxCompiler2  : String;
  rsvarsDirDelphi: String;
  PathBat        : String;
  ConteudoArquivo: TStringList;
  I              : Integer;

Begin

  If Not FileExists(RetornaRegistro(cbxDelphiCode.Text)+'\bin\rsvars.bat') Then
    Raise Exception.Create('Error ao iniciar o instalador, contate o suporte ou instale o pacote manualmente.');

  If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'Logs') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'Logs');
     If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'BPL');
          If Not DirectoryExists(IncludeTrailingPathDelimiter(SDirPackage) + 'DCU') Then
    ForceDirectories(IncludeTrailingPathDelimiter(SDirPackage) + 'DCU');

  rsvarsDirDelphi :='"'+ RetornaRegistro(cbxDelphiCode.Text) + '\bin\rsvars.bat"';

  PathBat := ExtractFilePath(ParamStr(0)) + NomeBat;

  ConteudoArquivo := TStringList.Create;
  ConteudoArquivo.Add('@echo off');
  Try

    ConteudoArquivo.Add('set NomeLog='+NomeLog);
    ConteudoArquivo.Add('set DirLog='+SDirPackage);
    ConteudoArquivo.Add('set runDir=' + Pacote);
    ConteudoArquivo.Add('set rsvarsDir=' + rsvarsDirDelphi);
    ConteudoArquivo.Add('set projFile='+projFile);
    ConteudoArquivo.Add('set currPlatform=' + textoCLBListBox);
    ConteudoArquivo.Add('set BPLDir=' + IncludeTrailingPathDelimiter(SDirPackage) + 'BPL');
    ConteudoArquivo.Add('echo %BPLDir%');
    ConteudoArquivo.Add('set DCUDir=' + IncludeTrailingPathDelimiter(SDirPackage) + 'DCU');
    ConteudoArquivo.Add('echo %DCUDir%');
    ConteudoArquivo.Add('call %rsvarsDir%');
    ConteudoArquivo.Add('set FullProjPath=%runDir%\%projFile%');
    ConteudoArquivo.Add('echo %FullProjPath%');
    ConteudoArquivo.Add('set FullDCUPathDebug=%DCUDir%\%currPlatform%\Debug');
    ConteudoArquivo.Add('echo %FullDCUPathDebug%');
    ConteudoArquivo.Add('set FullDCUPathRelease=%DCUDir%\%currPlatform%\Release');
    ConteudoArquivo.Add('echo %FullDCUPathRelease%');


   xAuxCompiler := '%FrameworkDir%\msbuild.exe /nologo %FullProjPath% /target:clean /p:DCC_BuildAllUnits=true';
    xAuxCompiler := xAuxCompiler +
     '/p:"Config=Debug" /p:"Platform=%currPlatform%" /p:"DCC_BPLOutput=%BPLDir%" /p:"DCC_DCUOutput=%FullDCUPathDebug%" /p:"DCC_Define=CONSOLE_TESTRUNNER" /l:FileLogger,Microsoft.Build.Engine;logfile="%DirLog%\Logs\%NomeLog%"';
    ConteudoArquivo.Add(xAuxCompiler);

    xAuxCompiler1 := '%FrameworkDir%\msbuild.exe /nologo %FullProjPath% /target:build /p:DCC_BuildAllUnits=true';
    xAuxCompiler1 := xAuxCompiler1 +
     '/p:"Config=Debug" /p:"Platform=%currPlatform%" /p:"DCC_BPLOutput=%BPLDir%" /p:"DCC_DCUOutput=%FullDCUPathDebug%" /p:"DCC_Define=CONSOLE_TESTRUNNER" /l:FileLogger,Microsoft.Build.Engine;logfile="%DirLog%\Logs\%NomeLog%"';
    ConteudoArquivo.Add(xAuxCompiler1);

    xAuxCompiler2 := '%FrameworkDir%\msbuild.exe /nologo %FullProjPath% /target:build /p:DCC_BuildAllUnits=true';
    xAuxCompiler2 := xAuxCompiler2 +
     '/p:"Config=Release" /p:"Platform=%currPlatform%" /p:"DCC_BPLOutput=%BPLDir%" /p:"DCC_DCUOutput=%FullDCUPathRelease%" /p:"DCC_Define=CONSOLE_TESTRUNNER" /l:FileLogger,Microsoft.Build.Engine;logfile="%DirLog%\Logs\%NomeLog%"';
    ConteudoArquivo.Add(xAuxCompiler2);



    WriteToTXT(PathBat, ConteudoArquivo.Text, False);
  Finally
    ConteudoArquivo.Free;
  End;

  RunAsAdminAndWaitForCompletion(Handle, PathBat);

End;

Procedure TfrmMain.RemoverArquivosAntigosDoDisco;
Var
  PathBat        : String;
  DriverList     : TStringList;
  ConteudoArquivo: String;
  I              : Integer;
Begin
  PathBat := ExtractFilePath(ParamStr(0)) + 'apagarDW.bat';

  // listar driver para montar o ConteudoArquivo
  DriverList := TStringList.Create;
  Try
    GetDriveLetters(DriverList);
    ConteudoArquivo := '@echo off' + SLineBreak;
    FOR I           := 0 TO DriverList.Count - 1 DO
    Begin
      ConteudoArquivo := ConteudoArquivo + StringReplace(DriverList[I], '\', '', []) + SLineBreak;
      ConteudoArquivo := ConteudoArquivo + 'cd\' + SLineBreak;
      ConteudoArquivo := ConteudoArquivo + 'del ';

      ConteudoArquivo := ConteudoArquivo + ' RestDatawareCORE.dcp';
      ConteudoArquivo := ConteudoArquivo + ' RestDatawareCORE.bpl';
      ConteudoArquivo := ConteudoArquivo + ' RestDatawareCORE*.bpi';
      ConteudoArquivo := ConteudoArquivo + ' RestDatawareCORE*.lib';
      ConteudoArquivo := ConteudoArquivo + ' RestDatawareCORE*.hpp';

      ConteudoArquivo := ConteudoArquivo + ' RESTDWDriver*.dcp';
      ConteudoArquivo := ConteudoArquivo + ' RESTDWDriver*.bpl';
      ConteudoArquivo := ConteudoArquivo + ' RESTDWDriver**.bpi';
      ConteudoArquivo := ConteudoArquivo + ' RESTDWDriver*.lib';
      ConteudoArquivo := ConteudoArquivo + ' RESTDWDriver*.hpp';

      ConteudoArquivo := ConteudoArquivo + ' /s' + SLineBreak;
      ConteudoArquivo := ConteudoArquivo + SLineBreak;
    End;
    WriteToTXT(PathBat, ConteudoArquivo, False);
  Finally
    DriverList.Free;
  End;

  btnInstall.Enabled := False;

  btnCancelar.Enabled := False;

  RunAsAdminAndWaitForCompletion(Handle, PathBat);

  btnInstall.Enabled := True;

  btnCancelar.Enabled := True;
End;

procedure TfrmMain.RemoverDisabledPackage(aValue: String; LibraryToRemove: String);
Var
  reg        : TRegistry;
  key        : String;
  I          : Integer;
  ListaDisablePackage : TStringList;
Begin
  Try
    reg        := TRegistry.Create;
    ListaDisablePackage := TStringList.Create;

    reg.RootKey := HKEY_CURRENT_USER;

    key := RegistroWindows+'\' + cbxDelphiCode.Text + LibraryToRemove;

    reg.OpenKey(key, False);

    reg.GetValueNames(ListaDisablePackage);

    For I := ListaDisablePackage.Count -1 downto 0 Do
    Begin

      If Pos(aValue, ListaDisablePackage[I]) > 0 Then
         reg.DeleteValue(ListaDisablePackage[i]);
    End;
  Finally
    reg.CloseKey;
    reg.Free;
    ListaDisablePackage.Free;
  End;
End;
procedure TfrmMain.RemoverOldPackage(aValue, LibraryToRemove: String);
Var
  reg        : TRegistry;
  key        : String;
  I          : Integer;
  ListaDisablePackage : TStringList;
Begin
  Try
    reg        := TRegistry.Create;
    ListaDisablePackage := TStringList.Create;

    reg.RootKey := HKEY_CURRENT_USER;

    key := RegistroWindows+'\' + cbxDelphiCode.Text + LibraryToRemove;

    reg.OpenKey(key, False);

    reg.GetKeyNames(ListaDisablePackage);

    For I := ListaDisablePackage.Count -1 downto 0 Do
    Begin

      If Pos(AnsiUpperCase(aValue), AnsiUpperCase(ListaDisablePackage[I])) > 0 Then
         reg.DeleteKey(ListaDisablePackage[i]);
    End;
  Finally
    reg.CloseKey;
    reg.Free;
    ListaDisablePackage.Free;
  End;
End;

function TfrmMain.RetornaRegistro(Versao: String): string;
var
 Registro : TRegistry;
 RegDelphi,
 delim,
 testeAnd,
 Chave : String;
 N: Integer;
 begin
  Registro := TRegistry.Create(KEY_READ);
  Registro.RootKey:=HKEY_CURRENT_USER;

  result := '';

      delim:= '.';
    N := Pos(delim, cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex]);
   testeAnd := (copy(cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex], 1, (N-1)));

   if StrToInt(testeAnd) <= 8 then
    begin
     Chave := RegistroWindows + '\' + cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex];
    end else
  Chave := RegistroWindows + '\' + cbxDelphiCode.Items[cbxDelphiVersion.ItemIndex];


  if registro.OpenKey(Chave, False) then
   result := Registro.ReadString('RootDir');

   if copy(result,length(result),1) = '\' then
   result := Copy(result,1,length(result)-1);

  registro.CloseKey;
  registro.Free;
end;

Function TfrmMain.RetornarChaveCliente(SKey: String; NomeDelphi: String): String;
var
 delim,
 Chave : String;
 N: Integer;
begin
     result := '';

      delim:= '.';
    N := Pos(delim, sKey);
   Chave := (copy(sKey, 1, (N-1)));

   if StrToInt(Chave) <= 8 then
    begin
     result := 'Software\Borland\Delphi'
    end else
  result := 'Software\Embarcadero\BDS'
end;

Function TfrmMain.RunAsAdminAndWaitForCompletion(HWnd: HWnd; Filename: String): Boolean;
Var
  Sei     : TShellExecuteInfo;
  ExitCode: DWORD;
Begin
  ZeroMemory(@Sei, SizeOf(Sei));
  Sei.CbSize       := SizeOf(TShellExecuteInfo);
  Sei.Wnd          := HWnd;
  Sei.FMask        := SEE_MASK_FLAG_DDEWAIT OR SEE_MASK_FLAG_NO_UI OR SEE_MASK_NOCLOSEPROCESS;
  Sei.LpVerb       := PWideChar('runas');
  Sei.LpFile       := PWideChar(Filename);
  Sei.LpParameters := PWideChar('');
  Sei.NShow        := SW_HIDE;

  IF ShellExecuteEx(@Sei) THEN
  Begin
    REPEAT
      Application.ProcessMessages;
      GetExitCodeProcess(Sei.HProcess, ExitCode);
    UNTIL (ExitCode <> STILL_ACTIVE) OR Application.Terminated;
  End;
End;

Function TfrmMain.SepararListaLibrary(lista: String; Const delim: char): TStrings;
Var
  P: Integer;
Begin

  Result := TStringList.Create;

  IF not (copy(lista, Length(lista), 1) = delim) THEN
  lista  := lista + delim;

  While Length(lista) > 0 DO
  Begin
    P := Pos(delim, lista);
    IF P = Length(lista) THEN
      SetLength(lista, Length(lista) - 1);

    IF Not(copy(lista, Length(lista), 1) = delim) THEN
    Begin
      Result.Add(copy(lista, 1, P) + delim);
    End
    Else
      Result.Add(copy(lista, 1, P));

    Delete(lista, 1, P);
  End;

End;

Procedure TfrmMain.SetDelphiVersionForInstallation;
Begin
  IF cbxDelphiVersion.ItemIndex >= 0 THEN
  Begin
        IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio XE 4') THEN
    Begin
      ProductVersion        := 'D18';
    End;
       IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio XE 5') THEN
    Begin
      ProductVersion        := 'D19';

    End;
       IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio XE 6') THEN
    Begin
      ProductVersion        := 'D20';

    End;
    IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio XE 7') THEN
    Begin
      ProductVersion        := 'D21';

    End;
    IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio XE 8') THEN
    Begin
      ProductVersion        := 'D22';

    End;
       IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio 10 Seattle') THEN
    Begin
      ProductVersion        := 'D23';

    End;
    IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio 10 Berlin') THEN
    Begin
      ProductVersion        := 'D24';

    End;
    IF (cbxDelphiVersion.Items[cbxDelphiVersion.ItemIndex] = 'RAD Studio 10 Tokyo') THEN
    Begin
      ProductVersion        := 'D25';
    End;
  End;
End;

Procedure TfrmMain.tbRepositorioShow(Sender: TObject);
Begin
  // verificar se o checkout já foi feito se sim, atualizar
  // se não fazer o checkout
  IF IsCheckOutJaFeito(edtDirFontes.Text) THEN
  BEGIN
    lblInfoObterFontes.Caption   := 'Clique em "Atualizar" para efetuar a atualização do repositório.';
    btnSVNCheckoutUpdate.Caption := 'Atualizar...';
    btnSVNCheckoutUpdate.Tag     := -1;
  END
  ELSE
  BEGIN
    lblInfoObterFontes.Caption   := 'Clique em "Download" para efetuar o download do repositório.';
    btnSVNCheckoutUpdate.Caption := 'Download...';
    btnSVNCheckoutUpdate.Tag     := 1;
  END;

End;

Function TfrmMain.textoCLBListBox: String;
Var
  I: Integer;
Begin
  For I := 0 To clbDelphiLibrary.Count - 1 Do
  Begin
    If clbDelphiLibrary.Checked[I] Then
      Result := clbDelphiLibrary.Items[I].Trim;
  End;
End;

Procedure TfrmMain.WriteToTXT(Const ArqTXT: String; ABinaryString: AnsiString; Const AppendIfExists, AddLineBreak: Boolean);
Var
  FS       : TFileStream;
  LineBreak: AnsiString;
Begin
  FS := TFileStream.Create(ArqTXT, IfThen(AppendIfExists AND FileExists(ArqTXT), Integer(FmOpenReadWrite), Integer(FmCreate)) OR FmShareDenyWrite);
  Try
    FS.Seek(0, SoFromEnd); // vai para EOF
    FS.Write(Pointer(ABinaryString)^, Length(ABinaryString));

    IF AddLineBreak THEN
    Begin
      LineBreak := SLineBreak;
      FS.Write(Pointer(LineBreak)^, Length(LineBreak));
    End;
  Finally
    FS.Free;
  End;
End;

End.
