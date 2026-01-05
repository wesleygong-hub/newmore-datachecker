program NewMoreDataChecker;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Dbgrid_s in 'PUBLIC\Dbgrid_s.pas',
  UnCommanBas in 'PUBLIC\UnCommanBas.pas',
  unConsts in 'PUBLIC\unConsts.pas',
  unDmMain in 'PUBLIC\unDmMain.pas' {DmMain: TDataModule},
  Unfrm_email in 'PUBLIC\Unfrm_email.pas' {frm_email},
  unLib in 'PUBLIC\unLib.pas',
  unfrmLogin in 'PUBLIC\unfrmLogin.pas' {frmLogin},
  UnFrm_CC_UNIT_CODE in 'PUBLIC\UnFrm_CC_UNIT_CODE.pas' {Frm_cc_unitcode},
  unpub_sfsc in 'PUBLIC\unpub_sfsc.pas',
  rsa in 'PUBLIC\rsa.pas',
  rsa_sh in 'PUBLIC\rsa_sh.pas',
  undmMe in 'PUBLIC\undmMe.pas' {dmMe: TDataModule},
  unfrmMeFunction in 'PUBLIC\unfrmMeFunction.pas' {frmMeFunction};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDmMain, DmMain);
  Application.CreateForm(TdmMe, dmMe);
  Application.Run;
end.
