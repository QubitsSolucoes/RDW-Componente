unit uRESTDWServerContext;

{
  REST Dataware versão CORE.
  Criado por XyberX (Gilbero Rocha da Silva), o REST Dataware tem como objetivo o uso de REST/JSON
 de maneira simples, em qualquer Compilador Pascal (Delphi, Lazarus e outros...).
  O REST Dataware também tem por objetivo levar componentes compatíveis entre o Delphi e outros Compiladores
 Pascal e com compatibilidade entre sistemas operacionais.
  Desenvolvido para ser usado de Maneira RAD, o REST Dataware tem como objetivo principal você usuário que precisa
 de produtividade e flexibilidade para produção de Serviços REST/JSON, simplificando o processo para você programador.

 Membros do Grupo :

 XyberX (Gilberto Rocha)    - Admin - Criador e Administrador do CORE do pacote.
 Ivan Cesar                 - Admin - Administrador do CORE do pacote.
 Joanan Mendonça Jr. (jlmj) - Admin - Administrador do CORE do pacote.
 Giovani da Cruz            - Admin - Administrador do CORE do pacote.
 Alexandre Abbade           - Admin - Administrador do desenvolvimento de DEMOS, coordenador do Grupo.
 Alexandre Souza            - Admin - Administrador do Grupo de Organização.
 Anderson Fiori             - Admin - Gerencia de Organização dos Projetos
 Mizael Rocha               - Member Tester and DEMO Developer.
 Flávio Motta               - Member Tester and DEMO Developer.
 Itamar Gaucho              - Member Tester and DEMO Developer.
 Ico Menezes                - Member Tester and DEMO Developer.
}


interface

Uses
 SysUtils, Classes, uDWJSONObject, uDWConsts, uDWConstsData, uDWAbout,
 uRESTDWBase, uDWJSONTools{$IFNDEF FPC}
                           {$IF CompilerVersion > 21} // Delphi 2010 pra cima
                            {$IF Defined(HAS_FMX)} // Alteardo para IOS Brito
                              , System.json
                            {$ELSE}
                             , uDWJSON
                            {$IFEND}
                           {$ELSE}
                            , uDWJSON
                           {$IFEND}
                           {$ELSE}
                           , uDWJSON
                           {$ENDIF};

Const
 TServerEventsConst = '{"typeobject":"%s", "objectdirection":"%s", "objectvalue":"%s", "paramname":"%s", "encoded":"%s", "default":"%s"}';

Type
 TDWReplyRequest = Procedure(Const Params       : TDWParams;
                             Var   ContentType,
                                   Result       : String) Of Object;
 TDWReplyRequestStream = Procedure(Const Params       : TDWParams;
                                   Var   ContentType  : String;
                                   Var   Result       : TMemoryStream) Of Object;
 TDWContextRoute  = (crAll, crGet, crPost, crPut, crDelete);
 TDWContextRoutes = Set of TDWContextRoute;

Type
 TDWReplyRequestData = Class(TComponent)
 Private
  vReplyRequest : TDWReplyRequest;
  vReplyRequestStream : TDWReplyRequestStream;
 Public
  Property  OnReplyRequest       : TDWReplyRequest       Read vReplyRequest       Write vReplyRequest;
  Property  OnReplyRequestStream : TDWReplyRequestStream Read vReplyRequestStream Write vReplyRequestStream;
End;

Type
 TDWParamMethod = Class;
 TDWParamMethod = Class(TCollectionItem)
 Private
  vTypeObject      : TTypeObject;
  vObjectDirection : TObjectDirection;
  vObjectValue     : TObjectValue;
  vDefaultValue,
  vParamName       : String;
  vEncoded         : Boolean;
 Public
  Function    GetDisplayName             : String;       Override;
  Procedure   SetDisplayName(Const Value : String);      Override;
  Constructor Create        (aCollection : TCollection); Override;
 Published
  Property TypeObject      : TTypeObject      Read vTypeObject      Write vTypeObject;
  Property ObjectDirection : TObjectDirection Read vObjectDirection Write vObjectDirection;
  Property ObjectValue     : TObjectValue     Read vObjectValue     Write vObjectValue;
  Property ParamName       : String           Read GetDisplayName   Write SetDisplayName;
  Property Encoded         : Boolean          Read vEncoded         Write vEncoded;
  Property DefaultValue    : String           Read vDefaultValue    Write vDefaultValue;
End;

Type
 TDWParamsMethods = Class;
 TDWParamsMethods = Class(TOwnedCollection)
 Private
  fOwner      : TPersistent;
  Function    GetRec    (Index       : Integer) : TDWParamMethod;  Overload;
  Procedure   PutRec    (Index       : Integer;
                         Item        : TDWParamMethod);            Overload;
  Procedure   ClearList;
  Function    GetRecName(Index       : String)  : TDWParamMethod;  Overload;
  Procedure   PutRecName(Index       : String;
                         Item        : TDWParamMethod);            Overload;
 Public
  Constructor Create     (AOwner     : TPersistent;
                          aItemClass : TCollectionItemClass);
  Destructor  Destroy; Override;
  Procedure   Delete     (Index      : Integer);                   Overload;
  Property    Items      [Index      : Integer]   : TDWParamMethod Read GetRec     Write PutRec; Default;
  Property    ParamByName[Index      : String ]   : TDWParamMethod Read GetRecName Write PutRecName;
End;

Type
 TDWContext = Class;
 TDWContext = Class(TCollectionItem)
 Protected
 Private
  vDefaultHtml                    : TStringList;
  FName,
  vContentType                    : String;
  vDWParams                       : TDWParamsMethods;
  vOwnerCollection                : TCollection;
  DWReplyRequestData              : TDWReplyRequestData;
  vDWContextRoutes                : TDWContextRoutes;
  Function  GetReplyRequest       : TDWReplyRequest;
  Procedure SetReplyRequest(Value : TDWReplyRequest);
  Function  GetReplyRequestStream       : TDWReplyRequestStream;
  Procedure SetReplyRequestStream(Value : TDWReplyRequestStream);
 Public
  Function    GetDisplayName             : String;       Override;
  Procedure   SetDisplayName(Const Value : String);      Override;
  Procedure   Assign        (Source      : TPersistent); Override;
  Constructor Create        (aCollection : TCollection); Override;
  Function    GetNamePath  : String;                     Override;
  Destructor  Destroy; Override;
 Published
  Property    DWParams             : TDWParamsMethods       Read vDWParams              Write vDWParams;
  Property    ContentType          : String                 Read vContentType           Write vContentType;
  Property    ContextName          : String                 Read GetDisplayName         Write SetDisplayName;
  Property    DefaultHtml          : TStringList            Read vDefaultHtml           Write vDefaultHtml;
  Property    ContextRoutes        : TDWContextRoutes       Read vDWContextRoutes       Write vDWContextRoutes;
  Property    OnReplyRequest       : TDWReplyRequest        Read GetReplyRequest        Write SetReplyRequest;
  Property    OnReplyRequestStream : TDWReplyRequestStream  Read GetReplyRequestStream  Write SetReplyRequestStream;
End;

Type
 TDWContextList = Class;
 TDWContextList = Class(TDWOwnedCollection)
 Protected
  vEditable   : Boolean;
  Function    GetOwner: TPersistent; override;
 Private
  fOwner      : TPersistent;
  Function    GetRec    (Index       : Integer) : TDWContext;       Overload;
  Procedure   PutRec    (Index       : Integer;
                         Item        : TDWContext);                 Overload;
  Procedure   ClearList;
  Function    GetRecName(Index       : String)  : TDWContext;       Overload;
  Procedure   PutRecName(Index       : String;
                         Item        : TDWContext);                 Overload;
//  Procedure   Editable  (Value : Boolean);
 Public
  Function    Add    : TCollectionItem;
  Constructor Create     (AOwner     : TPersistent;
                          aItemClass : TCollectionItemClass);
  Destructor  Destroy; Override;
  Function    ToJSON : String;
  Procedure   FromJSON     (Value      : String );
  Procedure   Delete       (Index      : Integer);                  Overload;
  Property    Items        [Index      : Integer]  : TDWContext     Read GetRec     Write PutRec; Default;
  Property    ContextByName[Index      : String ]  : TDWContext     Read GetRecName Write PutRecName;
End;

Type
 TDWServerContext = Class(TDWComponent)
 Protected
 Private
  vIgnoreInvalidParams : Boolean;
  vEventList           : TDWContextList;
  vAccessTag,
  vServerContext       : String;
 Public
  Destructor  Destroy; Override;
  Constructor Create(AOwner : TComponent);Override; //Cria o Componente
 Published
  Property    IgnoreInvalidParams : Boolean      Read vIgnoreInvalidParams Write vIgnoreInvalidParams;
  Property    ContextList         : TDWContextList Read vEventList           Write vEventList;
  Property    AccessTag           : String       Read vAccessTag           Write vAccessTag;
  Property    BaseContext         : String       Read vServerContext       Write vServerContext;
End;

implementation

{ TDWContext }

Function TDWContext.GetNamePath: String;
Begin
 Result := vOwnerCollection.GetNamePath + FName;
End;

constructor TDWContext.Create(aCollection: TCollection);
begin
  inherited;
  vDWParams               := TDWParamsMethods.Create(aCollection, TDWParamMethod);
  vContentType            := 'text/html';
  DWReplyRequestData      := TDWReplyRequestData.Create(Nil);
  vOwnerCollection        := aCollection;
  FName                   := 'dwcontext' + IntToStr(aCollection.Count);
  DWReplyRequestData.Name := FName;
  vDWContextRoutes        := [crAll];
  vDefaultHtml            := TStringList.Create;
end;

destructor TDWContext.Destroy;
begin
  vDWParams.Free;
  DWReplyRequestData.Free;
  vDefaultHtml.Free;
  inherited;
end;

Function TDWContext.GetDisplayName: String;
Begin
 Result := DWReplyRequestData.Name;
End;

Procedure TDWContext.Assign(Source: TPersistent);
begin
 If Source is TDWContext then
  Begin
   FName       := TDWContext(Source).ContextName;
   vDWParams   := TDWContext(Source).DWParams;
   DWReplyRequestData.OnReplyRequest := TDWContext(Source).OnReplyRequest;
  End
 Else
  Inherited;
End;

Function TDWContext.GetReplyRequestStream: TDWReplyRequestStream;
Begin
 Result := DWReplyRequestData.OnReplyRequestStream;
End;

Function TDWContext.GetReplyRequest: TDWReplyRequest;
Begin
 Result := DWReplyRequestData.OnReplyRequest;
End;

Procedure TDWContext.SetDisplayName(Const Value: String);
Begin
 If Trim(Value) = '' Then
  Raise Exception.Create('Invalid Event Name')
 Else
  Begin
   FName := Value;
   DWReplyRequestData.Name := FName;
   Inherited;
  End;
End;

Procedure TDWContext.SetReplyRequestStream(Value : TDWReplyRequestStream);
begin
 DWReplyRequestData.OnReplyRequestStream := Value;
end;

procedure TDWContext.SetReplyRequest(Value: TDWReplyRequest);
begin
 DWReplyRequestData.OnReplyRequest := Value;
end;

Function TDWContextList.Add : TCollectionItem;
Begin
 Result := Nil;
 If vEditable Then
  Result := TDWContext(Inherited Add);
End;

procedure TDWContextList.ClearList;
Var
 I : Integer;
 vOldEditable : Boolean;
Begin
 vOldEditable := vEditable;
 vEditable    := True;
 Try
  For I := Count - 1 Downto 0 Do
   Delete(I);
 Finally
  Self.Clear;
  vEditable := vOldEditable;
 End;
End;

Constructor TDWContextList.Create(AOwner     : TPersistent;
                                aItemClass : TCollectionItemClass);
Begin
 Inherited Create(AOwner, TDWContext);
 Self.fOwner := AOwner;
 vEditable   := True;
End;

procedure TDWContextList.Delete(Index: Integer);
begin
 If (Index < Self.Count) And (Index > -1) And (vEditable) Then
  TOwnedCollection(Self).Delete(Index);
end;

destructor TDWContextList.Destroy;
begin
 ClearList;
 inherited;
end;

{
procedure TDWContextList.Editable(Value: Boolean);
begin
 vEditable := Value;
end;
}

{$IFDEF Defined(HAS_FMX)}
Procedure TDWContextList.FromJSON(Value : String);
Var
 bJsonOBJ,
 bJsonOBJb,
 bJsonOBJc    : system.json.TJsonObject;

 bJsonArray,
 bJsonArrayB,
 bJsonArrayC  : system.json.TJsonArray;

 I, X, Y      : Integer;
 vDWEvent     : TDWContext;
 vDWParamMethod : TDWParamMethod;
Begin
 Try
  bJsonArray  := TJSONObject.ParseJSONValue(Value) as TJSONArray;
  For I := 0 to bJsonArray.count -1 Do
   Begin
    bJsonOBJ := bJsonArray.get(I) as TJsonobject;
    Try
     bJsonArrayB := bJsonOBJ.getvalue('serverevents') as Tjsonarray;
     For X := 0 To bJsonArrayB.count -1 Do
      Begin
       bJsonOBJb := bJsonArrayB.get(X) as TJsonObject;
       If ContextByName[bJsonOBJb.getvalue('contextname').value] = Nil Then
        vDWEvent  := TDWContext(Self.Add)
       Else
        vDWEvent  := ContextByName[bJsonOBJb.getvalue('contextname').value];
       vDWEvent.Name := bJsonOBJb.getvalue('contextname').value;
       If bJsonOBJb.getvalue('params').ToString <> '' Then
        Begin
         bJsonArrayC    := bJsonOBJb.getvalue('params') as Tjsonarray;
         Try
          For Y := 0 To bJsonArrayC.count -1 do
           Begin
            bJsonOBJc                      := bJsonArrayC.get(Y) as TJsonobject;
            If vDWEvent.vDWParams.ParamByName[bJsonOBJc.getvalue('paramname').value] = Nil Then
             vDWParamMethod                := TDWParamMethod(vDWEvent.vDWParams.Add)
            Else
             vDWParamMethod                := vDWEvent.vDWParams.ParamByName[bJsonOBJc.getvalue('paramname').value];
            vDWParamMethod.TypeObject      := GetObjectName(bJsonOBJc.getvalue('typeobject').value);
            vDWParamMethod.ObjectDirection := GetDirectionName(bJsonOBJc.getvalue('objectdirection').value);
            vDWParamMethod.ObjectValue     := GetValueType(bJsonOBJc.getvalue('objectvalue').value);
            vDWParamMethod.ParamName       := bJsonOBJc.getvalue('paramname').value;
            vDWParamMethod.Encoded         := StringToBoolean(bJsonOBJc.getvalue('encoded').value);
            If Trim(bJsonOBJc.getvalue('default').value) <> '' Then
             vDWParamMethod.DefaultValue   := DecodeStrings(bJsonOBJc.getvalue('default').value{$IFDEF FPC}, csUndefined{$ENDIF});
           End;
         Finally
          bJsonArrayC.Free;
         End;
        End
       Else
        vDWEvent.vDWParams.ClearList;
      End;
    Finally
     bJsonArrayB.Free;
    End;
   End;
 Finally
  bJsonArray.Free;
 End;
End;
{$ELSE}
Procedure TDWContextList.FromJSON(Value : String);
Var
 bJsonOBJ,
 bJsonOBJb,
 bJsonOBJc    : {$IFDEF Defined(HAS_FMX)}system.json.TJsonObject;
                {$ELSE}       udwjson.TJsonObject;{$ENDIF}
 bJsonArray,
 bJsonArrayB,
 bJsonArrayC  : {$IFDEF Defined(HAS_FMX)}system.json.TJsonArray;
                {$ELSE}       udwjson.TJsonArray;{$ENDIF}
 I, X, Y      : Integer;
 vDWEvent     : TDWContext;
 vDWParamMethod : TDWParamMethod;
Begin
 Try
  bJsonArray  := Tjsonarray.Create(Value);
  For I := 0 to bJsonArray.length -1 Do
   Begin
    bJsonOBJ := bJsonArray.getJSONObject(I);
    Try
     bJsonArrayB := Tjsonarray.Create(bJsonOBJ.get('serverevents').tostring);
     For X := 0 To bJsonArrayB.length -1 Do
      Begin
       bJsonOBJb := bJsonArrayB.getJSONObject(X);
       If ContextByName[bJsonOBJb.get('contextname').tostring] = Nil Then
        vDWEvent  := TDWContext(Self.Add)
       Else
        vDWEvent  := ContextByName[bJsonOBJb.get('contextname').tostring];
       vDWEvent.ContextName := bJsonOBJb.get('contextname').tostring;
       If bJsonOBJb.get('params').toString <> '' Then
        Begin
         bJsonArrayC    := Tjsonarray.Create(bJsonOBJb.get('params').toString);
         Try
          For Y := 0 To bJsonArrayC.length -1 do
           Begin
            bJsonOBJc                      := bJsonArrayC.getJSONObject(Y);
            If vDWEvent.vDWParams.ParamByName[bJsonOBJc.get('paramname').toString] = Nil Then
             vDWParamMethod                := TDWParamMethod(vDWEvent.vDWParams.Add)
            Else
             vDWParamMethod                := vDWEvent.vDWParams.ParamByName[bJsonOBJc.get('paramname').toString];
            vDWParamMethod.TypeObject      := GetObjectName(bJsonOBJc.get('typeobject').toString);
            vDWParamMethod.ObjectDirection := GetDirectionName(bJsonOBJc.get('objectdirection').toString);
            vDWParamMethod.ObjectValue     := GetValueType(bJsonOBJc.get('objectvalue').toString);
            vDWParamMethod.ParamName       := bJsonOBJc.get('paramname').toString;
            vDWParamMethod.Encoded         := StringToBoolean(bJsonOBJc.get('encoded').toString);
            If Trim(bJsonOBJc.get('default').toString) <> '' Then
             vDWParamMethod.DefaultValue   := DecodeStrings(bJsonOBJc.get('default').toString{$IFDEF FPC}, csUndefined{$ENDIF});
           End;
         Finally
          bJsonArrayC.Free;
         End;
        End
       Else
        vDWEvent.vDWParams.ClearList;
      End;
    Finally
     bJsonArrayB.Free;
    End;
   End;
 Finally
  bJsonArray.Free;
 End;
End;
{$ENDIF}

Function TDWContextList.GetOwner: TPersistent;
Begin
 Result:= fOwner;
End;

function TDWContextList.GetRec(Index: Integer): TDWContext;
begin
 Result := TDWContext(Inherited GetItem(Index));
end;

function TDWContextList.GetRecName(Index: String): TDWContext;
Var
 I : Integer;
Begin
 Result := Nil;
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(Self.Items[I].FName)) Then
    Begin
     Result := TDWContext(Self.Items[I]);
     Break;
    End;
  End;
End;

procedure TDWContextList.PutRec(Index: Integer; Item: TDWContext);
begin
 If (Index < Self.Count) And (Index > -1) And (vEditable) Then
  SetItem(Index, Item);
end;

procedure TDWContextList.PutRecName(Index: String; Item: TDWContext);
Var
 I : Integer;
Begin
 If (vEditable) Then
  Begin
   For I := 0 To Self.Count - 1 Do
    Begin
     If (Uppercase(Index) = Uppercase(Self.Items[I].FName)) Then
      Begin
       Self.Items[I] := Item;
       Break;
      End;
    End;
  End;
End;

Function TDWContextList.ToJSON: String;
Var
 A, I : Integer;
 vTagEvent,
 vParamsLines,
 vParamLine,
 vEventsLines : String;
Begin
 Result := '';
 vEventsLines := '';
 For I := 0 To Count -1 Do
  Begin
   vTagEvent    := Format('{"contextname":"%s"', [Items[I].FName]);
   vTagEvent    := vTagEvent + ', "params":[%s]}';
   vParamsLines := '';
   For A := 0 To Items[I].vDWParams.Count -1 Do
    Begin
     vParamLine := Format(TServerEventsConst,
                          [GetObjectName(Items[I].vDWParams[A].vTypeObject),
                           GetDirectionName(Items[I].vDWParams[A].vObjectDirection),
                           GetValueType(Items[I].vDWParams[A].vObjectValue),
                           Items[I].vDWParams[A].vParamName,
                           BooleanToString(Items[I].vDWParams[A].vEncoded),
                           EncodeStrings(Items[I].vDWParams[A].vDefaultValue{$IFDEF FPC}, csUndefined{$ENDIF})]);
     If vParamsLines = '' Then
      vParamsLines := vParamLine
     Else
      vParamsLines := vParamsLines + ', ' + vParamLine;
    End;
   If vEventsLines = '' Then
    vEventsLines := vEventsLines + Format(vTagEvent, [vParamsLines])
   Else
    vEventsLines := vEventsLines + Format(', ' + vTagEvent, [vParamsLines]);
  End;
 Result := Format('{"serverevents":[%s]}', [vEventsLines]);
End;

Constructor TDWServerContext.Create(AOwner : TComponent);
Begin
 Inherited;
 vEventList := TDWContextList.Create(Self, TDWContext);
 vIgnoreInvalidParams := False;
End;

Destructor TDWServerContext.Destroy;
Begin
 vEventList.Free;
 Inherited;
End;

procedure TDWParamsMethods.ClearList;
Var
 I : Integer;
Begin
 For I := Count - 1 Downto 0 Do
  Delete(I);
 Self.Clear;
End;

constructor TDWParamsMethods.Create(AOwner     : TPersistent;
                                    aItemClass : TCollectionItemClass);
begin
 Inherited Create(AOwner, TDWParamMethod);
 Self.fOwner := AOwner;
end;

procedure TDWParamsMethods.Delete(Index: Integer);
begin
 If (Index < Self.Count) And (Index > -1) Then
  TOwnedCollection(Self).Delete(Index);
end;

destructor TDWParamsMethods.Destroy;
begin
 ClearList;
 Inherited;
end;

Function TDWParamsMethods.GetRec(Index: Integer): TDWParamMethod;
Begin
 Result := TDWParamMethod(inherited GetItem(Index));
End;

function TDWParamsMethods.GetRecName(Index: String): TDWParamMethod;
Var
 I : Integer;
Begin
 Result := Nil;
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(Self.Items[I].vParamName)) Then
    Begin
     Result := TDWParamMethod(Self.Items[I]);
     Break;
    End;
  End;
End;

procedure TDWParamsMethods.PutRec(Index: Integer; Item: TDWParamMethod);
begin
 If (Index < Self.Count) And (Index > -1) Then
  SetItem(Index, Item);
end;

procedure TDWParamsMethods.PutRecName(Index: String; Item: TDWParamMethod);
Var
 I : Integer;
Begin
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(Self.Items[I].vParamName)) Then
    Begin
     Self.Items[I] := Item;
     Break;
    End;
  End;
End;

Constructor TDWParamMethod.Create(aCollection: TCollection);
Begin
 Inherited;
 vTypeObject      := toParam;
 vObjectDirection := odINOUT;
 vObjectValue     := ovString;
 vParamName       :=  'dwparam' + IntToStr(aCollection.Count);
 vEncoded         := True;
 vDefaultValue    := '';
End;

function TDWParamMethod.GetDisplayName: String;
begin
 Result := vParamName;
end;

procedure TDWParamMethod.SetDisplayName(const Value: String);
begin
 If Trim(Value) = '' Then
  Raise Exception.Create('Invalid Param Name')
 Else
  Begin
   vParamName := Trim(Value);
   Inherited;
  End;
end;

Initialization
 RegisterClass(TDWServerContext);
end.
