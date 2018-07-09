unit SysTypes;

Interface

Uses
  IdURI, IdGlobal, SysUtils, Classes, ServerUtils, uRESTDWBase, uDWConsts,
  uDWJSONObject, uDWConstsData, uDWMassiveBuffer, uRESTDWServerEvents, uSystemEvents;

Type
 TReplyEvent     = Procedure(SendType           : TSendEvent;
                             Context            : String;
                             Var Params         : TDWParams;
                             Var Result         : String;
                             AccessTag          : String) Of Object;
 TMassiveProcess = Procedure(Var MassiveDataset : TMassiveDatasetBuffer; Var Ignore : Boolean) Of Object;

Type
  TResultErro = Record
    Status, MessageText: String;
  End;

  TArguments = Array Of String;

Type
  TServerUtils = Class
    Class Function ParseRESTURL(Const Cmd: String;vEncoding : TEncodeSelect; Var UrlMethod, urlContext : String): TDWParams;
    Class Function Result2JSON(wsResult: TResultErro): String;
    Class Function ParseWebFormsParams(Params: TStrings; Const URL, Query: String;
                                       Var UrlMethod, urlContext : String;
                                       vEncoding: TEncodeSelect;MethodType : String = 'POST'): TDWParams;
  End;

Type
  TServerMethods = Class(TComponent)
  Protected
   vReplyEvent     : TReplyEvent;
   vWelcomeMessage : TWelcomeMessage;
   vMassiveProcess : TMassiveProcess;
   Function ReturnIncorrectArgs: String;
   Function ReturnMethodNotFound: String;
  Public
   Encoding: TEncodeSelect;
   Constructor Create(aOwner: TComponent); Override;
   Destructor Destroy; Override;
  Published
   Property OnReplyEvent     : TReplyEvent      Read vReplyEvent     Write vReplyEvent;
   Property OnWelcomeMessage : TWelcomeMessage  Read vWelcomeMessage Write vWelcomeMessage;
   Property OnMassiveProcess : TMassiveProcess  Read vMassiveProcess Write vMassiveProcess;
  End;

implementation


Class Function TServerUtils.ParseRESTURL(Const Cmd: String;vEncoding: TEncodeSelect; Var UrlMethod, urlContext : String): TDWParams;
Var
 vTempData,
  NewCmd: String;
  ArraySize,
  iBar1,
  IBar2, Cont : Integer;
  JSONParam   : TJSONParam;
  Function CountExpression(Value: String; Expression: Char): Integer;
  Var
    I: Integer;
  Begin
    Result := 0;
    For I := 0 To Length(Value) - 1 Do
    Begin
      If Value[I] = Expression Then
        Inc(Result);
    End;
  End;
Begin
 Result := Nil;
 JSONParam := Nil;
 NewCmd := Cmd;
 urlContext := '';
 UrlMethod  := '';
 If (CountExpression(NewCmd, '/') > 0) Then
  Begin
   ArraySize := CountExpression(NewCmd, '/');
   Result := TDWParams.Create;
   Result.Encoding := vEncoding;
   NewCmd := NewCmd + '/';
   iBar1 := Pos('/', NewCmd);
   Delete(NewCmd, 1, iBar1);
   For Cont := 0 to ArraySize - 1 Do
    Begin
     IBar2     := Pos('/', NewCmd);
     vTempData := TIdURI.URLDecode(Copy(NewCmd, 1, IBar2 - 1), GetEncodingID(vEncoding));
     If (Cont = (ArraySize - 1)) Then
      Begin
       UrlMethod := Copy(NewCmd, 1, IBar2 - 1);
       JSONParam := TJSONParam.Create(Result.Encoding);
       JSONParam.ParamName := Format('PARAM%d', [0]);
       JSONParam.SetValue(vTempData);
      End;
     If (ArraySize > 1) And (Cont = (ArraySize - 2)) Then
      urlContext := vTempData;
     Delete(NewCmd, 1, IBar2);
    End;
  End;
 //Alexandre Magno - 07/11/2017
 If Assigned(JSONParam) Then
  FreeAndNil(JSONParam);
End;

Class Function TServerUtils.ParseWebFormsParams(Params: TStrings;
  const URL, Query: String; Var UrlMethod, urlContext: String;vEncoding: TEncodeSelect;
  MethodType : String = 'POST'): TDWParams;
Var
  I: Integer;
  Cmd: String;
  JSONParam: TJSONParam;
  vParams : TStringList;
  Uri : TIdURI;
Begin
  // Extrai nome do ServerMethod
  Result := TDWParams.Create;
  Result.Encoding := vEncoding;
  If Pos('?', URL) > 0 Then
   Begin
    Cmd := URL;
    I := Pos('?', Cmd);
    UrlMethod := StringReplace(Copy(Cmd, 1, I - 1), '/', '', [rfReplaceAll]);
    Delete(Cmd, 1, I);
//    I := Pos('?', Cmd);
   End
  Else
   Begin
    Cmd := URL + '/';
    I := Pos('/', Cmd);
    Delete(Cmd, 1, I);
    UrlMethod := '';
    urlContext := '';
    While Pos('/', Cmd) > 0 Do
     Begin
      I := Pos('/', Cmd);
      If urlContext = '' Then
       urlContext := Copy(Cmd, 1, I - 1)
      Else If UrlMethod = '' Then
       UrlMethod := Copy(Cmd, 1, I - 1);
      Delete(Cmd, 1, I);
     End;
    If UrlMethod = '' Then
     Begin
      UrlMethod  := urlContext;
      urlContext := '';
     End;
   End;
  // Extrai Parametros
  If (Params.Count > 0) And (MethodType = 'POST') Then
   Begin
    For I := 0 To Params.Count - 1 Do
     Begin
      JSONParam := TJSONParam.Create(Result.Encoding);
      JSONParam.ObjectDirection := odIN;
      If Pos('{', Params[I]) > 0 Then
       JSONParam.FromJSON(Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I]))))
      Else
       Begin
        JSONParam.ParamName := Copy(Params[I], 1, Pos('=', Params[I]) - 1);
        JSONParam.AsString  := Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I])));
        If JSONParam.AsString = '' Then
         Begin
//          JSONParam.ObjectDirection := odOut; //Observar
          JSONParam.Encoded         := False;
         End;
       End;
      Result.Add(JSONParam);
     End;
   End
  Else
   Begin
    vParams := TStringList.Create;
    vParams.Delimiter := '&';
    {$IFNDEF FPC}{$if CompilerVersion > 21}vParams.StrictDelimiter := true;{$IFEND}{$ENDIF}
    If pos(UrlMethod + '/', Cmd) > 0 Then
     Cmd := StringReplace(UrlMethod + '/', Cmd, '', [rfReplaceAll]);
    If (Params.Count > 0) And (Pos('?', URL) = 0) then
     Cmd := Cmd + Params.Text
    Else
     Cmd := Cmd + Query;
    Uri := TIdURI.Create(Cmd);
    Try
     vParams.DelimitedText := Uri.Params;
     If vParams.count = 0 Then
      If Trim(Cmd) <> '' Then
       vParams.DelimitedText := StringReplace(Cmd, #13#10, '&', [rfReplaceAll]); //Alterações enviadas por "joaoantonio19"
       //vParams.Add(Cmd);
    Finally
     Uri.Free;
     For I := 0 To vParams.Count - 1 Do
      Begin
       JSONParam                 := TJSONParam.Create(Result.Encoding);
       JSONParam.ParamName       := Trim(Copy(vParams[I], 1, Pos('=', vParams[I]) - 1));
       JSONParam.AsString        := Trim(Copy(vParams[I],    Pos('=', vParams[I]) + 1, Length(vParams[I])));
       JSONParam.ObjectDirection := odIN;
       Result.Add(JSONParam);
      End;
     vParams.Free;
    End;
   End;
End;

Class Function TServerUtils.Result2JSON(wsResult: TResultErro): String;
Begin
  Result := '{"STATUS":"' + wsResult.Status + '","MENSSAGE":"' +
    wsResult.MessageText + '"}';
End;

constructor TServerMethods.Create(aOwner: TComponent);
begin
  inherited;
end;

destructor TServerMethods.Destroy;
begin
  inherited;
end;

Function TServerMethods.ReturnIncorrectArgs: String;
Var
  wsResult: TResultErro;
Begin
  wsResult.Status := '-1';
  wsResult.MessageText := 'Total de argumentos menor que o esperado';
  Result := TServerUtils.Result2JSON(wsResult);
End;

Function TServerMethods.ReturnMethodNotFound: String;
Var
  wsResult: TResultErro;
Begin
  wsResult.Status := '-2';
  wsResult.MessageText := 'Metodo nao encontrado';
  Result := TServerUtils.Result2JSON(wsResult);
End;

end.

