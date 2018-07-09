unit uClimaTempo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Vcl.StdCtrls, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB, uDWResponseTranslator,
  uDWAbout, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Imaging.pngimage;


type  TBusca = (tCod, tCid);

type
  TfrmClimaTempo = class(TForm)
    DWClientRESTClima: TDWClientREST;
    DWResponseClima: TDWResponseTranslator;
    DWClima: TRESTDWClientSQL;
    btnCod: TButton;
    btCidade: TButton;
    imPrevisao: TImage;
    edCidade: TEdit;
    edUF: TEdit;
    edToken: TEdit;
    Label1: TLabel;
    edCodCid: TEdit;
    cbRetornoPais: TComboBox;
    memWeather: TFDMemTable;
    memMain: TFDMemTable;
    lbl_temp: TLabel;
    lbl_descricao: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbl_max: TLabel;
    lbl_min: TLabel;
    lbl_umidade: TLabel;
    lbl_vento: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure ExecuteApi(Busca : TBusca);
    procedure btnCodClick(Sender: TObject);
    procedure btCidadeClick(Sender: TObject);
  private
    { Private declarations }
    sPath : String;
  public
    { Public declarations }
  end;

const
  vToken = '';

var
  frmClimaTempo: TfrmClimaTempo;


implementation

uses
  uDWJSONObject, uDWConsts, Web.HTTPApp;

{$R *.dfm}

{ TfrmClimaTempo }


procedure TfrmClimaTempo.btCidadeClick(Sender: TObject);
begin
  ExecuteApi(tCid);
end;

procedure TfrmClimaTempo.btnCodClick(Sender: TObject);
begin
  ExecuteApi(tCod);
end;


procedure TfrmClimaTempo.ExecuteApi(Busca: TBusca);
var  AUrl: string;
     vTempJson: String;
     pathImg  : String;
     vJson    : TJSONValue;
     DwTranslator: TDWResponseTranslator;
begin
  try
    Screen.Cursor := crSQLWait;
    sPath:= '';
    case Busca of
      tCod:
      begin
        if (edCodCid.Text = '') then
        begin
          ShowMessage('Digite um código de cidade');
          exit;
        end;
        AUrl := format('http://api.openweathermap.org/data/2.5/weather?id=%s&appid=%s&units=metric&lang=%s',[edCodCid.Text,edToken.Text,Copy(cbRetornoPais.Text, 0, 2)]);
      end;
      tCid:
      begin
        if (edCidade.Text = '') and (edUF.Text = '') then
        begin
          ShowMessage('Digite uma cidade');
          exit;
        end;
        AUrl := format('http://api.openweathermap.org/data/2.5/weather?q=%s,%s&appid=%s&units=metric&lang=%s',[HTTPEncode(edCidade.Text),edUF.Text,edToken.Text, Copy(cbRetornoPais.Text, 0, 2)]);
      end;
    end;

    try
      DWClima.Close;
      DWResponseClima.RequestOpenUrl:= AUrl;
      DWClima.Open;
    except
      Exception.Create('Erro ao ler URL! Tente novamente!');
    end;

    if (DWClima.FieldCount > 1) then
    begin
      vJson         := TJSONValue.Create;
      DwTranslator  := TDWResponseTranslator.Create(self);

      vTempJson:= DWClima.FieldByName('main').AsString;
      vJson.WriteToDataset(vTempJson, memMain, DwTranslator, rtJSONAll);

      if not memMain.IsEmpty then
      begin
        lbl_temp.Caption      := Copy(memMain.FieldByName('temp').AsString, 0,2);
        lbl_max.Caption       := memMain.FieldByName('temp_max').AsString + 'ºc';
        lbl_min.Caption       := memMain.FieldByName('temp_min').AsString + 'ºc';
        lbl_umidade.Caption   := memMain.FieldByName('humidity').AsString + '%';
        lbl_vento.Caption     := Copy(memMain.FieldByName('pressure').AsString, 0,2) + 'km';;
      end;


      DwTranslator.FieldDefs.Clear;
      vTempJson:= DWClima.FieldByName('weather').AsString;
      vJson.WriteToDataset(vTempJson, memWeather, DwTranslator, rtJSONAll);

      if not memWeather.IsEmpty then
      begin
        lbl_descricao.Caption   := memWeather.FieldByName('description').AsString;
        sPath   := sPath + 'imagens\'+ memWeather.FieldByName('icon').AsString +'.png';
        if (sPath <> EmptyStr) then
          imPrevisao.Picture.LoadFromFile(sPath);
      end;
    end;
  finally
    vJson.Free;
    DwTranslator.Free;
    Screen.Cursor := crDefault;
  end;

end;

procedure TfrmClimaTempo.FormCreate(Sender: TObject);
begin
  sPath:= ExtractFilePath(Application.ExeName);
end;

end.

