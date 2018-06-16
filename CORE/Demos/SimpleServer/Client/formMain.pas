UNIT formMain;

INTERFACE

USES
  DateUtils,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  UDWJSONObject,
  DB,
  Grids,
  DBGrids,
  URESTDWBase,
  UDWJSONTools,
  UDWConsts,
  Vcl.ExtCtrls,
  Vcl.Imaging.Pngimage,
  URESTDWPoolerDB,
  Vcl.ComCtrls,
  System.UITypes,
  IdComponent, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData, System.Actions,
  Vcl.ActnList, uRESTDWServerEvents, uDWDataset, uDWAbout;

TYPE

  { TForm2 }

  TForm2 = CLASS(TForm)
    EHost: TEdit;
    EPort: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    DataSource1: TDataSource;
    Image1: TImage;
    Bevel1: TBevel;
    Label7: TLabel;
    EdPasswordDW: TEdit;
    Label6: TLabel;
    EdUserNameDW: TEdit;
    Label8: TLabel;
    Bevel2: TBevel;
    Label1: TLabel;
    Bevel3: TBevel;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    MComando: TMemo;
    Button1: TButton;
    CheckBox1: TCheckBox;
    RESTDWClientSQL1: TRESTDWClientSQL;
    RESTDWDataBase1: TRESTDWDataBase;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Button4: TButton;
    chkhttps: TCheckBox;
    Button5: TButton;
    ActionList1: TActionList;
    DWClientEvents1: TDWClientEvents;
    RESTClientPooler1: TRESTClientPooler;
    Button6: TButton;
    eAccesstag: TEdit;
    Label3: TLabel;
    eWelcomemessage: TEdit;
    Label9: TLabel;
    RESTDWClientSQL1EMP_NO: TSmallintField;
    RESTDWClientSQL1FIRST_NAME: TStringField;
    RESTDWClientSQL1LAST_NAME: TStringField;
    RESTDWClientSQL1PHONE_EXT: TStringField;
    RESTDWClientSQL1HIRE_DATE: TSQLTimeStampField;
    RESTDWClientSQL1DEPT_NO: TStringField;
    RESTDWClientSQL1JOB_CODE: TStringField;
    RESTDWClientSQL1JOB_GRADE: TSmallintField;
    RESTDWClientSQL1JOB_COUNTRY: TStringField;
    RESTDWClientSQL1SALARY: TFloatField;
    RESTDWClientSQL1FULL_NAME: TStringField;
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE Button2Click(Sender: TObject);
    PROCEDURE RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    PROCEDURE RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    PROCEDURE RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    PROCEDURE RESTDWClientSQL1GetDataError(Sucess: Boolean; CONST Error: STRING);
    PROCEDURE RESTDWDataBase1Status(ASender: TObject; CONST AStatus: TIdStatus; CONST AStatusText: STRING);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE RESTDWDataBase1Connection(Sucess: Boolean; CONST Error: STRING);
    PROCEDURE RESTDWDataBase1BeforeConnect(Sender: TComponent);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  PRIVATE
    { Private declarations }
    FBytesToTransfer: Int64;
  PUBLIC
    { Public declarations }
  END;

VAR
  Form2: TForm2;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TForm2.Button1Click(Sender: TObject);
VAR
  INICIO: TdateTime;
  FIM: TdateTime;
BEGIN
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService  := EHost.Text;
  RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
  RESTDWDataBase1.Login          := EdUserNameDW.Text;
  RESTDWDataBase1.Password       := EdPasswordDW.Text;
  RESTDWDataBase1.Compression    := CheckBox1.Checked;
  RESTDWDataBase1.AccessTag      := eAccesstag.Text;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
  if chkhttps.Checked then
     RESTDWDataBase1.TypeRequest:=TTyperequest.trHttps
  else
     RESTDWDataBase1.TypeRequest:=TTyperequest.trHttp;
  RESTDWDataBase1.Open;
  INICIO                  := Now;
  DataSource1.DataSet     := RESTDWClientSQL1;
  RESTDWClientSQL1.Active := False;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  TRY
    RESTDWClientSQL1.Active := True;
  EXCEPT
    ON E: Exception DO
    BEGIN
      RAISE Exception.Create('Erro ao executar a consulta: ' + sLineBreak + E.Message);
    END;
  END;
  FIM := Now;
  Showmessage(IntToStr(RESTDWClientSQL1.Recordcount) + ' registro(s) recebido(s) em ' + IntToStr(SecondsBetween(FIM, INICIO)) + ' segundos.');
END;

PROCEDURE TForm2.Button2Click(Sender: TObject);
VAR
  VError: STRING;
BEGIN
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService := EHost.Text;
  RESTDWDataBase1.PoolerPort    := StrToInt(EPort.Text);
  RESTDWDataBase1.Login         := EdUserNameDW.Text;
  RESTDWDataBase1.Password      := EdPasswordDW.Text;
  RESTDWDataBase1.Compression   := CheckBox1.Checked;
  RESTDWDataBase1.AccessTag     := eAccesstag.Text;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
  if chkhttps.Checked then
     RESTDWDataBase1.TypeRequest:=TTyperequest.trHttps
  else
     RESTDWDataBase1.TypeRequest:=TTyperequest.trHttp;
  RESTDWDataBase1.Open;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  IF NOT RESTDWClientSQL1.ExecSQL(VError) THEN
    Application.MessageBox(PChar('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text), 'Erro...', Mb_iconerror + Mb_ok)
  ELSE
    Application.MessageBox('Comando executado com sucesso...', 'Informa��o !!!', Mb_iconinformation + Mb_ok);
END;

procedure TForm2.Button3Click(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage,
 vNativeResult : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := CheckBox1.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest := TTyperequest.trHttps
 Else
  RESTClientPooler1.TypeRequest := TTyperequest.trHttp;
 DWClientEvents1.CreateDWParams('getemployee', dwParams);
 DWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 If vNativeResult <> '' Then
  Showmessage(vNativeResult)
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
end;

procedure TForm2.Button4Click(Sender: TObject);
Var
 vError : String;
begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
 If RESTDWClientSQL1.MassiveCount > 0 Then
  Showmessage(RESTDWClientSQL1.MassiveToJSON);
end;

procedure TForm2.Button6Click(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := CheckBox1.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest := TTyperequest.trHttps
 Else
  RESTClientPooler1.TypeRequest := TTyperequest.trHttp;
 DWClientEvents1.CreateDWParams('servertime', dwParams);
 dwParams.ItemsString['inputdata'].AsString := 'teste de string';
 DWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage);
 If vErrorMessage = '' Then
  Begin
   If dwParams.ItemsString['result'].AsString <> '' Then
    Showmessage('Server Date/Time is : ' + DateTimeToStr(dwParams.ItemsString['result'].Value))
   Else
    Showmessage(vErrorMessage);
   dwParams.ItemsString['result'].SaveToFile('json.txt');
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
end;

PROCEDURE TForm2.FormCreate(Sender: TObject);
BEGIN
  Memo1.Lines.Clear;
END;

PROCEDURE TForm2.RESTDWClientSQL1GetDataError(Sucess: Boolean; CONST Error: STRING);
BEGIN
  Showmessage(Error);
END;

PROCEDURE TForm2.RESTDWDataBase1BeforeConnect(Sender: TComponent);
BEGIN
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
END;

PROCEDURE TForm2.RESTDWDataBase1Connection(Sucess: Boolean; CONST Error: STRING);
BEGIN
  IF Sucess THEN
  BEGIN
    Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.');
  END
  ELSE
  BEGIN
    Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conex�o ao Database: ' + Error);
  END;
END;

PROCEDURE TForm2.RESTDWDataBase1Status(ASender: TObject; CONST AStatus: TIdStatus; CONST AStatusText: STRING);
BEGIN
 if Self = Nil then
  Exit;
  CASE AStatus OF
    hsResolving:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsResolving...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnecting:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnecting:
      BEGIN
        if StatusBar1.Panels.count > 0 then
         StatusBar1.Panels[0].Text := 'hsDisconnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsDisconnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsStatusText:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsStatusText...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    // These are to eliminate the TIdFTPStatus and the coresponding event These can be use din the other protocols to.
    ftpTransfer:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpTransfer...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpReady:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpReady...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpAborted:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpAborted...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
  END;
END;

PROCEDURE TForm2.RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
BEGIN
  IF FBytesToTransfer = 0 THEN // No Update File
    Exit;
  ProgressBar1.Position := AWorkCount;
  ProgressBar1.Update;
END;

PROCEDURE TForm2.RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
BEGIN
  FBytesToTransfer      := AWorkCountMax;
  ProgressBar1.Max      := FBytesToTransfer;
  ProgressBar1.Position := 0;
  ProgressBar1.Update;
END;

PROCEDURE TForm2.RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
BEGIN
  ProgressBar1.Position := FBytesToTransfer;
  Application.ProcessMessages;

  FBytesToTransfer := 0;
END;

END.
