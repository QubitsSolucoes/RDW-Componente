unit formMain;

interface

uses
  Lcl, uDWJSON, uDWJSONObject, DateUtils, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, fpjson, DB, DBGrids, ExtCtrls, ComCtrls,
  uRESTDWPoolerDB, uRESTDWServerEvents, uRESTDWBase, IdComponent, uDWConstsData;

type

  { TForm2 }

  TForm2 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    chkhttps: TCheckBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DWClientEvents1: TDWClientEvents;
    eAccesstag: TEdit;
    edPasswordDW: TEdit;
    edUserNameDW: TEdit;
    eHost: TEdit;
    ePort: TEdit;
    eWelcomemessage: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mComando: TMemo;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    RESTClientPooler1: TRESTClientPooler;
    RESTDWClientSQL1: TRESTDWClientSQL;
    RESTDWClientSQL1DEPT_NO: TStringField;
    RESTDWClientSQL1DEPT_NO1: TStringField;
    RESTDWClientSQL1EMP_NO: TSmallintField;
    RESTDWClientSQL1EMP_NO1: TSmallintField;
    RESTDWClientSQL1FIRST_NAME: TStringField;
    RESTDWClientSQL1FIRST_NAME1: TStringField;
    RESTDWClientSQL1FULL_NAME: TStringField;
    RESTDWClientSQL1FULL_NAME1: TStringField;
    RESTDWClientSQL1HIRE_DATE: TDateTimeField;
    RESTDWClientSQL1JOB_CODE: TStringField;
    RESTDWClientSQL1JOB_CODE1: TStringField;
    RESTDWClientSQL1JOB_COUNTRY: TStringField;
    RESTDWClientSQL1JOB_COUNTRY1: TStringField;
    RESTDWClientSQL1JOB_GRADE: TSmallintField;
    RESTDWClientSQL1JOB_GRADE1: TSmallintField;
    RESTDWClientSQL1LAST_NAME: TStringField;
    RESTDWClientSQL1LAST_NAME1: TStringField;
    RESTDWClientSQL1PHONE_EXT: TStringField;
    RESTDWClientSQL1PHONE_EXT1: TStringField;
    RESTDWClientSQL1SALARY: TFloatField;
    RESTDWClientSQL1SALARY1: TFloatField;
    RESTDWDataBase1: TRESTDWDataBase;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RESTDWClientSQL1AfterInsert(DataSet: TDataSet);
    procedure RESTDWDataBase1BeforeConnect(Sender: TComponent);
    procedure RESTDWDataBase1Connection(Sucess: Boolean; const Error: String);
    procedure RESTDWDataBase1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  private
    { Private declarations }
   FBytesToTransfer : Int64;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$IFDEF LCL}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


{ TForm2 }

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 Form2 := Nil;
 Release;
end;

procedure TForm2.RESTDWClientSQL1AfterInsert(DataSet: TDataSet);
begin

end;

procedure TForm2.RESTDWDataBase1BeforeConnect(Sender: TComponent);
begin
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
end;

procedure TForm2.RESTDWDataBase1Connection(Sucess: Boolean; const Error: String
  );
begin
 IF Sucess THEN
 BEGIN
   Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.');
 END
 ELSE
 BEGIN
   Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conexão ao Database: ' + Error);
 END;
end;

procedure TForm2.RESTDWDataBase1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
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
end;

procedure TForm2.RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
 If FBytesToTransfer = 0 Then // No Update File
  Exit;
 ProgressBar1.Position := AWorkCount;
end;

procedure TForm2.RESTDWDataBase1WorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
 FBytesToTransfer      := AWorkCountMax;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

procedure TForm2.RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

procedure TForm2.Button1Click(Sender: TObject);
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
     RESTDWDataBase1.TypeRequest:=trHttps
  else
     RESTDWDataBase1.TypeRequest:=trHttp;
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

procedure TForm2.Button2Click(Sender: TObject);
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
  If chkhttps.Checked Then
   RESTDWDataBase1.TypeRequest   := trHttps
  Else
   RESTDWDataBase1.TypeRequest   := trHttp;
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
  RESTClientPooler1.TypeRequest := trHttps
 Else
  RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('getemployee', dwParams);
 DWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 dwParams.Free;
 If vNativeResult <> '' Then
  Showmessage(vNativeResult)
 Else
  Showmessage(vErrorMessage);
end;

procedure TForm2.Button4Click(Sender: TObject);
Var
 vError : String;
begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, mtError, [mbOK], 0);
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
  RESTClientPooler1.TypeRequest := trHttps
 Else
  RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('servertime', dwParams);
 dwParams.ItemsString['inputdata'].AsString := 'teste de string';
 DWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage);
 If vErrorMessage = '' Then
  Begin
   If dwParams.ItemsString['result'].AsString <> '' Then
    Showmessage('Server Date/Time is : ' + DateTimeToStr(dwParams.ItemsString['result'].Value))
   Else
    Showmessage('Invalid result data...');
   dwParams.ItemsString['result'].SaveToFile('json.json');
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
end;

end.
