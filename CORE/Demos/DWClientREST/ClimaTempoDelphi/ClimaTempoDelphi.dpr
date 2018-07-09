program ClimaTempoDelphi;

uses
  Vcl.Forms,
  uClimaTempo in 'uClimaTempo.pas' {frmClimaTempo},
  uLkJSON in '..\..\..\..\..\lkJSON-1.07\uLkJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmClimaTempo, frmClimaTempo);
  Application.Run;
end.
