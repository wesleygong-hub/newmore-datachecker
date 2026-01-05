unit undmMe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TdmMe = class(TDataModule)
    qrMain: TQuery;
    tbPersonfile: TTable;
    tbEmpmater: TTable;
    tbPassport: TTable;
    tbCompensate: TTable;
    tbDispute: TTable;
    dsPersonfile: TDataSource;
    dsEmpmater: TDataSource;
    dsPassport: TDataSource;
    dsCompensate: TDataSource;
    dsDispute: TDataSource;
    tbClient: TTable;
    dsClient: TDataSource;
    tbDepts: TTable;
    dsDepts: TDataSource;
    tbHumbas: TTable;
    dsHumbas: TDataSource;
    tbDr_personfile_addr: TTable;
    dsDr_personfile_addr: TDataSource;
    tbDr_Sex: TTable;
    dsDr_Sex: TDataSource;
    tbDr_Marry: TTable;
    dsDr_Marry: TDataSource;
    dsDr_Party: TDataSource;
    tbDr_Party: TTable;
    tbDr_Title: TTable;
    dsDr_Title: TDataSource;
    tbDr_Province: TTable;
    tbDr_District: TTable;
    dsDr_Province: TDataSource;
    dsDr_District: TDataSource;
    tbPfhistory: TTable;
    dsPfhistory: TDataSource;
    qrTemp: TQuery;
    tbDr_passport_type: TTable;
    tbDr_passport_status: TTable;
    dsDr_passport_type: TDataSource;
    dsDr_passport_status: TDataSource;
    tbUsers: TTable;
    dsUsers: TDataSource;
    tbDr_compensate_type: TTable;
    dsDr_compensate_type: TDataSource;
    tbDr_dispute_type: TTable;
    tbDr_dispute_result_type: TTable;
    dsDr_dispute_result_type: TDataSource;
    dsDr_dispute_type: TDataSource;
    tbCompensateSNO: TFloatField;
    tbCompensateREG_NO: TStringField;
    tbCompensateAPPLY_DATE: TDateTimeField;
    tbCompensateCOMPENSATE_TYPE: TFloatField;
    tbCompensateCOMPANY_NO: TStringField;
    tbCompensateAMOUNT: TFloatField;
    tbCompensateDEPART_REMARKS: TStringField;
    tbCompensateDEPART_SALES: TStringField;
    tbCompensateDEPARTER: TStringField;
    tbCompensateHUM_REMARKS: TStringField;
    tbCompensateHUM_SALES: TStringField;
    tbCompensateMANAGER: TStringField;
    tbCompensatelkCompany_address: TStringField;
    tbDisputeDISPUTE_NO: TFloatField;
    tbDisputeDISPUTE_NAME: TStringField;
    tbDisputeDISPUTE_DATE: TDateTimeField;
    tbDisputeDISPUTE_TYPE: TFloatField;
    tbDisputeRESULT_TYPE: TFloatField;
    tbDisputeRESULT_WIN: TStringField;
    tbDisputeAPPEAL_SIDE: TStringField;
    tbDisputeAPPEAL_REG_NO: TStringField;
    tbDisputeAPPEAL_POSITION: TStringField;
    tbDisputePROC_NAME: TStringField;
    tbDisputeCOMPANY_NO: TStringField;
    tbDisputeJUR_NAME: TStringField;
    tbDisputeJUR_POSITION: TStringField;
    tbDisputeAUTH_NAME: TStringField;
    tbDisputeDEPART: TStringField;
    tbPersonfileREG_NO: TStringField;
    tbPersonfileFILE_NO: TStringField;
    tbPersonfileCOMPANY_NO: TStringField;
    tbPersonfileDEPART: TStringField;
    tbPersonfileASSE_DATE: TDateTimeField;
    tbPersonfileREGI: TFloatField;
    tbPersonfileHIRE_DATE: TDateTimeField;
    tbPersonfileFIRE_DATE: TDateTimeField;
    tbPersonfileAPPR_UNIT: TStringField;
    tbPersonfileAPPR_DATE: TDateTimeField;
    tbPersonfileIN_FILE_DATE: TDateTimeField;
    tbPersonfileIN_FILE_WAY: TStringField;
    tbPersonfileOUT_FILE_DATE: TDateTimeField;
    tbPersonfileOUT_FILE_DIRECT: TStringField;
    tbPersonfileADDR: TFloatField;
    tbPersonfileSTORE_NO: TStringField;
    tbPersonfileWAIT_NO: TStringField;
    tbPersonfileWORK_NO: TStringField;
    tbPersonfileWORK_CREATE_DATE: TDateTimeField;
    tbPersonfileWORK_EXPIRE_DATE: TDateTimeField;
    tbPersonfileLIVE_CREATE_DATE: TDateTimeField;
    tbPersonfileLIVE_EXPIRE_DATE: TDateTimeField;
    tbPersonfileREMARKS: TStringField;
    tbPassportREG_NO: TStringField;
    tbPassportREQ_DATE: TDateTimeField;
    tbPassportREQ_TYPE: TFloatField;
    tbPassportCOMPANY_NO: TStringField;
    tbPassportPHONE: TStringField;
    tbPassportNATION: TStringField;
    tbPassportLEAVE_DATE: TDateTimeField;
    tbPassportBACK_DATE: TDateTimeField;
    tbPassportPASSPORT_NO: TStringField;
    tbPassportPASSPORT_DATE: TDateTimeField;
    tbPassportEXPIRE_DATE: TDateTimeField;
    tbPassportPOLIC_DATE: TDateTimeField;
    tbPassportCOMPLETE_DATE: TDateTimeField;
    tbPassportSTATUS: TFloatField;
    tbPassportSALES: TStringField;
    tbPassportREMARKS: TStringField;
    tbEmpmaterREG_NO: TStringField;
    tbEmpmaterMATER_NO: TStringField;
    tbEmpmaterCREATE_DATE: TDateTimeField;
    tbPassportSNO: TStringField;
    tbPersonfileFSAPPR_COMMENTS: TStringField;
    tbPersonfileFSAPPR: TFloatField;
    tbPersonfileINFILE: TFloatField;
    tbIdcard: TTable;
    dsIdcard: TDataSource;
    tbDr_cardtype: TTable;
    dsDr_cardtype: TDataSource;
    tbDr_hospital: TTable;
    dsDr_hospital: TDataSource;
    tbActivity: TTable;
    dsActivity: TDataSource;
    tbActivityREG_NO: TStringField;
    tbActivityACT_NO: TFloatField;
    tbActivityCOMPANY_NO: TStringField;
    tbActivityAWARE_DATE: TDateTimeField;
    tbActivitySALES: TStringField;
    tbActivityDEPART: TStringField;
    tbActivityAPART: TFloatField;
    tbEmpAct: TTable;
    dsEmpact: TDataSource;
    tbEmpActACT_NO: TFloatField;
    tbEmpActACT_NAME: TStringField;
    tbEmpActCONTENT: TStringField;
    tbEmpActACT_DATE: TDateTimeField;
    tbEmpActPLACE: TStringField;
    tbEmpActREMARKS: TStringField;
    tbDr_acttype: TTable;
    dsDr_acttype: TDataSource;
    tbEmpmaterCOMPANY_NO: TStringField;
    tbEmpActACT_TYPE: TFloatField;
    dsDr_nation: TDataSource;
    tbDr_nation: TQuery;
    tbIdcardREG_NO: TStringField;
    tbIdcardSNO: TFloatField;
    tbIdcardCARDTYPE: TFloatField;
    tbIdcardCOMPANY_NO: TStringField;
    tbIdcardACT_PERSON: TStringField;
    tbIdcardACT_DATE: TDateTimeField;
    tbIdcardREV_PERSON: TStringField;
    tbIdcardREV_DATE: TDateTimeField;
    tbIdcardREMARKS: TStringField;
    tbIdcardACT_TYPE: TStringField;
    tbFundcard: TTable;
    tbChildCard: TTable;
    tbJobcard: TTable;
    dsFundcard: TDataSource;
    dsChildcard: TDataSource;
    dsJobcard: TDataSource;
    tbFundcardREG_NO: TStringField;
    tbFundcardSNO: TFloatField;
    tbFundcardCOMPANY_NO: TStringField;
    tbFundcardCARDNO: TStringField;
    tbFundcardACT_PERSON: TStringField;
    tbFundcardACT_DATE: TDateTimeField;
    tbFundcardDEPT_PERSON: TStringField;
    tbFundcardDEPT_DATE: TDateTimeField;
    tbFundcardCARD_DATE: TDateTimeField;
    tbChildCardREG_NO: TStringField;
    tbChildCardSNO: TFloatField;
    tbChildCardCARDTYPE: TFloatField;
    tbChildCardCOMPANY_NO: TStringField;
    tbChildCardREQ_DATE: TDateTimeField;
    tbChildCardEND_DATE: TDateTimeField;
    tbChildCardACT_PERSON: TStringField;
    tbChildCardREV_PERSON: TStringField;
    tbChildCardREMARKS: TStringField;
    tbChildCardACT_TYPE: TStringField;
    tbChildCardACT_DATE: TDateTimeField;
    tbChildCardCHILD_BIRTHDAY: TDateTimeField;
    tbChildCardRELATION: TStringField;
    tbChildCardBEGIN_DATE: TDateTimeField;
    tbChildCardREV_DATE: TDateTimeField;
    tbJobcardREG_NO: TStringField;
    tbJobcardSNO: TFloatField;
    tbJobcardCARDTYPE: TFloatField;
    tbJobcardCOMPANY_NO: TStringField;
    tbJobcardREQ_DATE: TDateTimeField;
    tbJobcardACT_DATE: TDateTimeField;
    tbJobcardACT_PERSON: TStringField;
    tbJobcardCARD_SUM: TFloatField;
    tbJobcardREMARKS: TStringField;
    tbFundcardREMARKS: TStringField;
    tbMedical_insur: TTable;
    StringField1: TStringField;
    FloatField1: TFloatField;
    StringField2: TStringField;
    StringField3: TStringField;
    DateTimeField1: TDateTimeField;
    StringField4: TStringField;
    DateTimeField2: TDateTimeField;
    StringField5: TStringField;
    dsMedical_insur: TDataSource;
    tbMedical_insurHOSPITAL: TStringField;
    tbFundcardCARDTYPE: TFloatField;
    tbJobcardBEGIN_DATE: TDateTimeField;
    tbJobcardEND_DATE: TDateTimeField;
    tbJobcardCARDNO: TStringField;
    tbDisputeNARRATE: TMemoField;
    tbDisputeVERIFY: TMemoField;
    tbDisputeOPINION: TMemoField;
    tbDisputeRESULT: TMemoField;
    tbDisputeEXPER: TMemoField;
    tbDisputeLAW_INDEX: TStringField;
    tbJobcardPAY_UNIT: TFloatField;
    tbJobcardFESCO: TFloatField;
    tbJobcardCONTINUE: TFloatField;
    tbEmpmaterIS_NEW: TFloatField;
    tbPassportcomp_type: TStringField;
    tbPassportname_ch: TStringField;
    tbEmpmaterAPPR_DATE: TDateTimeField;
    tbEmpmaterAPPR_UNIT: TStringField;
    strngfldChildCardCHILD_NAME: TStringField;
    procedure tbEmpmaterBeforeClose(DataSet: TDataSet);
    procedure tbCompensateAMOUNTSetText(Sender: TField;
      const Text: String);
    procedure tbDisputeDISPUTE_DATESetText(Sender: TField;
      const Text: String);
    procedure tbDr_personfile_addrBeforePost(DataSet: TDataSet);
    procedure tbDr_personfile_addrNewRecord(DataSet: TDataSet);
    procedure tbDr_personfile_addrPostError(DataSet: TDataSet;
      E: EDatabaseError; var Action: TDataAction);
    procedure tbDr_cardtypeNewRecord(DataSet: TDataSet);
    procedure tbDr_cardtypeBeforePost(DataSet: TDataSet);
    procedure tbPersonfilePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure tbPassportCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure IsFieldValidYM(Sender: TField; Text: string);
  end;

var
  dmMe: TdmMe;

implementation

uses unfrmMeFunction;

{$R *.DFM}

const
  INVALID_AMOUNT = '无效数值。';
  OUT_AMOUNT = '数值超出范围。';
  INVALID_DATE = '无效日期。';
  NULL_NAME = '请输入名称。';
  NULL_APPID = '请输入应用代码。';
  POST_ERROR1 = '关键字不能重复。';

procedure TdmMe.IsFieldValidYM(Sender: TField; Text: string);
begin
  if (Trim(Text) = '') or (Trim(Text) = '-  -') then
    Sender.AsString:=''
  else
    begin
      Text:=copy(Text, 1, 4)+'-'+copy(Text, 6, 2)+'-'+copy(Text, 9, 2);
      if Trim(copy(Text, 9, 2)) = '' then
        Text:=copy(Text, 1, 8)+'01';
      try
        StrToDate(Text);
        Sender.AsString:=Text;
      except
        on EConvertError do ShowInfo(INVALID_DATE);
      end;
    end;
end;

procedure TdmMe.tbEmpmaterBeforeClose(DataSet: TDataSet);
begin
  with DataSet do
    begin
      if (State = dsInsert) or (State = dsEdit) then
        Cancel;
    end;
end;

procedure TdmMe.tbCompensateAMOUNTSetText(Sender: TField;
  const Text: String);
begin
  try
    Sender.AsString:=Text;
  except
    on EDBEngineError do ShowInfo(OUT_AMOUNT);
    on EDatabaseError do ShowInfo(INVALID_AMOUNT);
  end;
end;

procedure TdmMe.tbDisputeDISPUTE_DATESetText(Sender: TField;
  const Text: String);
begin
  IsFieldValidYM(Sender, Text);
end;

procedure TdmMe.tbDr_personfile_addrBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('NAME').AsString:=Trim(DataSet.FieldByName('NAME').AsString);
  if DataSet.FieldByName('NAME').AsString = '' then
    begin
      ShowInfo(NULL_NAME);
      Abort;
    end;
end;

procedure TdmMe.tbDr_personfile_addrNewRecord(DataSet: TDataSet);
begin
  QueryOpen(dmMe.qrMain, 'select decode(count(*), 0, 1, max(no)+1)'
    +' from '+TTable(DataSet).TableName);
  DataSet.FieldByName('NO').AsInteger:=dmMe.qrMain.Fields[0].AsInteger;
end;

procedure TdmMe.tbDr_personfile_addrPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
{   if (E is EDBEngineError) then
     begin
       if (E as EDBEngineError).Errors[0].Errorcode = 9729 then
         raise Exception.create(POST_ERROR1);
     end;}
end;

procedure TdmMe.tbDr_cardtypeNewRecord(DataSet: TDataSet);
begin
  QueryOpen(dmMe.qrMain, 'select decode(count(*), 0, 1, max(cardno)+1)'
    +' from '+TTable(DataSet).TableName);
  DataSet.FieldByName('CARDNO').AsInteger:=dmMe.qrMain.Fields[0].AsInteger;
end;

procedure TdmMe.tbDr_cardtypeBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('CARDNAME').AsString:=Trim(DataSet.FieldByName('CARDNAME').AsString);
  if DataSet.FieldByName('CARDNAME').AsString = '' then
    begin
      ShowInfo(NULL_NAME);
      Abort;
    end;

  DataSet.FieldByName('LEGAL_APPID').AsString:=Trim(DataSet.FieldByName('LEGAL_APPID').AsString);
  if DataSet.FieldByName('LEGAL_APPID').AsString = '' then
    begin
      ShowInfo(NULL_APPID);
      Abort;
    end;
end;

procedure TdmMe.tbPersonfilePostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  if E is EDBEngineError then
  case EDBEngineError(E).Errors[0].ErrorCode of
    9729: raise exception.Create('关键字重复。');
    10259: raise exception.Create('该记录已被其他用户修改，本次修改无效。');
    else ShowInfo('异常出错。');
  end;
end;

procedure TdmMe.tbPassportCalcFields(DataSet: TDataSet);
begin
  QueryOpen(qrMain, 'select name_ch, comp_type from fs_client'
    +' where company_no = '''+tbPassport.FieldByName('company_no').AsString+'''');
  tbPassport.FieldByName('name_ch').AsString:=qrMain.Fields[0].AsString;
  tbPassport.FieldByName('comp_type').AsString:=qrMain.Fields[1].AsString;
end;

end.
