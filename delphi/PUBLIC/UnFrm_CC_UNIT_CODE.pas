unit UnFrm_CC_UNIT_CODE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, GridsEh, DBGridEh, ExtCtrls;

type
  TFrm_cc_unitcode = class(TForm)
    grp1: TGroupBox;
    dbgrdh1: TDBGridEh;
    btn_ok: TButton;
    btn_Cancel: TButton;
    qry_ccOepacc: TQuery;
    ds_CCoepacc: TDataSource;
    strngfld_ccOepaccUNIT_CODE: TStringField;
    strngfld_ccOepaccUNIT_NAME: TStringField;
    strngfld_ccOepaccUNIT_CODE_OLD: TStringField;
    strngfld_ccOepaccADDR_CODE: TStringField;
    strngfld_ccOepaccACC_YM: TStringField;
    fltfld_ccOepaccPROC_FLAG: TFloatField;
    fltfld_ccOepaccMONTH_FLAG: TFloatField;
    strngfld_ccOepaccORGAN_NUM: TStringField;
    strngfld_ccOepaccUNIT_TYPE: TStringField;
    fltfld_ccOepaccDISTRICT: TFloatField;
    strngfld_ccOepaccMANAGE_USER: TStringField;
    fltfld_ccOepaccIS_VALID: TFloatField;
    strngfld_ccOepaccADDR_NAME: TStringField;
    strngfld_ccOepaccUSER_NAME: TStringField;
    strngfld_ccOepaccDIST_NAME: TStringField;
    pnlpan1: TPanel;
    procedure btn_okClick(Sender: TObject);
    procedure dbgrdh1DblClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure dbgrdh1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    UOepacc:string;
    { Public declarations }
  end;

var
  Frm_cc_unitcode: TFrm_cc_unitcode;

implementation

{$R *.dfm}

procedure TFrm_cc_unitcode.btn_okClick(Sender: TObject);
begin
  UOepacc:=qry_ccOepacc.FieldByName('UNIT_CODE').AsString;
  Self.Close;
end;

procedure TFrm_cc_unitcode.btn_CancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_cc_unitcode.dbgrdh1DblClick(Sender: TObject);
begin
  UOepacc:=qry_ccOepacc.FieldByName('UNIT_CODE').AsString;
  Self.Close;
end;

procedure TFrm_cc_unitcode.dbgrdh1KeyPress(Sender: TObject; var Key: Char);
begin
  UOepacc:=qry_ccOepacc.FieldByName('UNIT_CODE').AsString;
  Self.Close;
end;

end.
