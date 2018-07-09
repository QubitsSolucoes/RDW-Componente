program DWInstall;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  About in 'About.pas' {frmAbout},
  SVN_Class in 'SVN_Class.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
