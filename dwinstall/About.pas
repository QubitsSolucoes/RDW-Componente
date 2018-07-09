{ DWInstall - Instalador para componentes RESTDATAWARE CORE Version
Criador : Anderson Fiori
Colaborar : Ico Menezes
Desenvolvido em Delphi Tokyo
}


unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ShellApi;

type
  TfrmAbout = class(TForm)
    Panel2: TPanel;
    imgLogomarca: TImage;
    Label27: TLabel;
    Label26: TLabel;
    Label6: TLabel;
    Label20: TLabel;
    Label28: TLabel;
    Label19: TLabel;
    lblUrlDW1: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label21: TLabel;
    lblUrlForum1: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure ShellOpen(const Url: string; const Params: string = '');
    procedure Label28Click(Sender: TObject);
    procedure lblUrlDW1Click(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure lblUrlForum1Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

{ TfrmAbout }

procedure TfrmAbout.Label11Click(Sender: TObject);
begin
ShellOpen(Label11.Caption);
end;

procedure TfrmAbout.Label25Click(Sender: TObject);
begin
ShellOpen(Label25.Caption);
end;

procedure TfrmAbout.Label28Click(Sender: TObject);
begin
ShellOpen(Label28.Caption);
end;

procedure TfrmAbout.Label2Click(Sender: TObject);
begin
ShellOpen(Label12.Caption);
end;

procedure TfrmAbout.Label4Click(Sender: TObject);
begin
ShellOpen('mailto:'+Label4.Caption);
end;

procedure TfrmAbout.lblUrlDW1Click(Sender: TObject);
begin
ShellOpen(lblUrlDW1.Caption);
end;

procedure TfrmAbout.lblUrlForum1Click(Sender: TObject);
begin
ShellOpen(lblUrlForum1.Caption);
end;

procedure TfrmAbout.ShellOpen(const Url, Params: string);
begin
  ShellAPI.ShellExecute(0, 'Open', PChar(Url), PChar(Params), nil, SW_SHOWNORMAL);
end;

end.
