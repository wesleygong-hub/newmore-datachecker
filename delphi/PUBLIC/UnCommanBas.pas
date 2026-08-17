unit UnCommanBas;

interface
uses
   Windows,SysUtils,Classes,Db,Dbtables,Controls,Stdctrls,Mask,Messages,Forms
   ,DBCtrls,UnFrm_CC_UNIT_CODE,TypInfo,Graphics,Variants;
type
  TPubFunc = Class
  private

  protected

  public
    Function Get15BitID(strID : string ) : string;
    Function Get18BitID(strID : string ) : string;
    procedure CheckYearMonth(Sender : Tobject);
    Function IsPermitFillPay(strChgType,strAddrCode: string): Boolean;
    Function GetOep_AccYm(FUnit_Code : String;FOepFlag : string): string;
    Function CheckEndAcc(FUnit_Code : String) : boolean;
    Function GetFirstMonth(FAcc_Ym : String) : string;
    //取fs_fincsys的city_no
    Function GetCityNo : string;
    //取fs_fincsys的emp_account_mode
    Function GetAccfundEmpAccMode: String;
    //取fs_fincsys的rate_mode
    Function GetAccfundRateMode: String;
    //根据小盘单位帐号去acc_ym
    Function GetAccfundAccYm(companyAccount: String): String;
    //获取公积金代理机构模式，1为普通模式（即单一委托机构），2为特殊模式（即多委托机构）
    Function GetAccfundAgentMode: String;
    //获取公积金单位帐号确定模式，1为取入职单模式，2为通用模式（调派+单位帐号），3为北京模式（调派+单位帐号+业务部），4为成都模式（调派+单位帐号+缴纳地+代办机构）
    Function GetAccfundCompAccMode: String;
    //获取公积金应办模式，1为普通模式，2为广州模式，0为未启用
    Function GetAccfundShouldDoMode: String;
    //公积金补缴是否延迟，0为否，1为是
    Function IfAccfundSupplyLate: String;
  end;
  
var pubFunc : TPubFunc ;
  type TOepAcc =record
  oep_acc, is_oep,is_med,is_lose,is_injure,is_birth: string;
  end;
  const APP_ALLUNITNO = '073001';  //社保全部单位账户权限
//
function GetAccType(Account: String): TOepAcc;
//初始化单位账号下拉框
procedure InitOepAccDropDownList(cbbOepAcc:TObject;AddrCode:string='');
// 单位账号选择  IsOnlyview是否仅查询用 1 是  0否
procedure GetOepacc(DoControl:TObject;Addrcode:string='';IsOnlyview:Boolean=False;SfscCode:string='');
//获取业务员下所有单位账号、
procedure GetOepaccByuser(qery1:TQuery;Istype:string='';Addrcode:string='';andstr:string='';SfscCode:string='');//istype 1 大盘 2 小盘  andstr 续加条件
procedure SetControlReadonly(control:TWinControl;isReadOnly:Boolean=True);
//初始化城市下拉框
procedure InitAddrCodeDropDown(cbbAddr:TDBLookupComboBox;
  qryAddr:TQuery);overload;
//取入职单信息
function GetEntrantInfo(entrant_no:string;field_name:string):string;

implementation

uses unfrmLogin,unLib;

{ TPubFunc }

procedure GetOepaccByuser(qery1:TQuery;Istype:string='';Addrcode:string='';andstr:string='';SfscCode:string='');
var
ls_sql:string;
begin
  //获取当前业务员下所有单位账号
  if IsValidApp(GetCurUser.User_Id,APP_ALLUNITNO) then
    ls_sql:='select unit_code from sfsc.sd_unitid where '
    +' is_valid=1  '
    +' and addr_code in (SELECT addr_code FROM'
    +' sfsc_sec.sd_oep_address sd'
    +'  WHERE sd.city_no = '+quotedstr(GetCurUser.City_no)+')'
  else
    ls_sql:='select unit_code from sfsc.sd_unitid  '
    +'where is_valid=1  and'
    +' addr_code in (SELECT addr_code FROM'
    +' sfsc_sec.sd_oep_address sd '
    +'  WHERE  sd.city_no = '+quotedstr(GetCurUser.City_no)+')'
    +'and manage_user='+QuotedStr(GetCurUser.User_Id);

  if SfscCode='' then
  begin
    ls_sql := ls_sql + ' and sfsc_code in (select sfsc_code '
      +' from sfsc.fs_usr_org fo where user_id='+QuotedStr(GetCurUser.User_Id)+')';
  end
  else
  begin
    ls_sql := ls_sql + ' and sfsc_code = '+QuotedStr(SfscCode);
  end;
  if Istype<>'' then
    ls_sql:=ls_sql+'   and unit_type='+QuotedStr(Istype)+'';
  if Addrcode<>'' then
    ls_sql:=ls_sql+'   and ADDR_CODE='+QuotedStr(Addrcode)+'';
  if andstr<>'' then
    ls_sql:=ls_sql+andstr;
  with qery1 do
  begin
    SQL.Clear;
    SQL.Text:=ls_sql;
    Open;
  end;
end;


//选择单位账号
//2013-04-11
procedure GetOepacc(DoControl:TObject;Addrcode:string='';IsOnlyview:Boolean=False;SfscCode:string='');
var
  strSql,SqlWhere:string;
begin
  try
    if DoControl.InheritsFrom(TCustomEdit) then
    begin
      SqlWhere:=(DoControl as  TCustomEdit).Text;
    end
    else
      Exit;
    strSql := 'select u.*,'
    +'(select addr_name from sfsc_sec.SD_OEP_ADDRESS d where u.addr_code=d.addr_code  )as addr_name,'
    +'(select n.name from sfsc.fs_users n  where u.manage_user=n.user_id ) as user_name,'
    +'(select t.name from dr_district t where t.NO=u.district and t.oep_addr_code = u.addr_code )as dist_name from sfsc.sd_unitid u where '
    +' (unit_code like ''%'+SqlWhere+'%'' or unit_name like ''%'+SqlWhere+'%'')';
    
    if SfscCode='' then
    begin
      strSql := strSql + ' and u.sfsc_code in (select sfsc_code '
        +' from sfsc.fs_usr_org fo where user_id='+QuotedStr(GetCurUser.User_Id)+')';
    end
    else
    begin
      strSql := strSql + ' and u.sfsc_code = '+QuotedStr(SfscCode);
    end;

    if AddrCode='' then
    begin
      if not IsOnlyview then
      begin
        if not IsValidApp(GetCurUser.User_Id,APP_ALLUNITNO) then
          strSql := strSql + 'and  addr_code in (SELECT addr_code '
          +'FROM sfsc_sec.sd_oep_address sd'
          +' WHERE sd.city_no = '+quotedstr(GetCurUser.City_no)+')'
          +' and manage_user='
          +''+QuotedStr(GetCurUser.User_Id)
        else
          strSql := strSql + 'and  addr_code in (SELECT addr_code '
          +'FROM sfsc_sec.sd_oep_address sd '
          +' WHERE  sd.city_no = '+quotedstr(GetCurUser.City_no)+')';
      end
      else
        strSql := strSql + 'and  addr_code in (SELECT addr_code '
        +'FROM sfsc_sec.sd_oep_address sd '
        +' WHERE  sd.city_no = '+quotedstr(GetCurUser.City_no)+')';
    end
    else
    begin
      if not IsOnlyview then
      begin
        if IsValidApp(GetCurUser.User_Id,APP_ALLUNITNO) then
          strSql := strSql + ' and ADDR_CODE='+QuotedStr(AddrCode)
        else
        strSql := strSql + ' and ADDR_CODE='+QuotedStr(AddrCode)
        + ' and manage_user='+QuotedStr(GetCurUser.User_Id);
      end
      else
      strSql := strSql + ' and ADDR_CODE='+QuotedStr(AddrCode);
    end;
    Frm_cc_unitcode:=TFrm_cc_unitcode.Create(Application);
    if SqlWhere='' then
    exit;
    with Frm_cc_unitcode do
    begin
      qry_ccOepacc.SQL.Clear;
      qry_ccOepacc.SQL.Text:=strSql;
      qry_ccOepacc.Open;
    end;
    if Frm_cc_unitcode.qry_ccOepacc.RecordCount=1 then
    begin
      Frm_cc_unitcode.UOepacc:=Frm_cc_unitcode.qry_ccOepacc.FieldByName('UNIT_CODE').AsString;
      Frm_cc_unitcode.qry_ccOepacc.Close;
      Exit;
    end;
    if Frm_cc_unitcode.qry_ccOepacc.IsEmpty then
    begin
      (DoControl as  TCustomEdit).Text:='';
      Frm_cc_unitcode.qry_ccOepacc.Close;
      ShowBox('未找到对应的社保账号！');
      (DoControl as  TCustomEdit).SetFocus;
      Exit;
    end;
    Frm_cc_unitcode.ShowModal;
  finally
    (DoControl as  TCustomEdit).Text:=Frm_cc_unitcode.UOepacc;
    Frm_cc_unitcode.Free;
  end;
end;


procedure TPubFunc.CheckYearMonth(Sender: Tobject);
var strAccYm,strYm : string;
    dAccYm : TDate;
begin
  try
    strAccYm := Trim(TMaskEdit(Sender).Text);
    if Length(strAccYm) <> 6 then
    begin
      Application.MessageBox('日期输入有误！','提示信息',MB_OK+MB_ICONINFORMATION);
      Exit;
    end;
    strYm := Copy(strAccYm,1,4)+'-'+Copy(strAccYm,5,2)+'-01';
    dAccYm := StrToDate(strYm);
  except
    Application.MessageBox('日期输入有误！','提示信息',MB_OK+MB_ICONINFORMATION);
    TMaskEdit(Sender).SetFocus;
  end;
end;


function TPubFunc.Get15BitID(strID: string): string;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select get_id_15('+QuotedStr(strID)+') as id from dual';
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      Result := qryTemp.FieldByName('id').AsString;
    finally
      qryTemp.Free;
    end;
  end;
end;

function TPubFunc.Get18BitID(strID: string): string;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select get_id_18('+QuotedStr(strID)+') as id from dual';
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      Result := qryTemp.FieldByName('id').AsString;
    finally
      qryTemp.Free;
    end;
  end;
end;

function TPubFunc.IsPermitFillPay(strChgType,strAddrCode: string): Boolean;
var qryTemp : TQuery ;
    strSQL: string;
begin
  strSQL := 'select change_type,change_addpay_flag from sfsc_sec.sd_oep_chg_type where change_type='
     + QuotedStr(strChgType) + ' and addr_code= ' +QuotedStr(StrAddrCode) ;
  qryTemp := TQuery.Create(nil);
  try
    qryTemp.DataBaseName := 'SfscMis';
    qryTemp.Close;
    qryTemp.SQL.Clear;
    qryTemp.SQL.Add(strSQL);
    qryTemp.Open;
    if qryTemp.FieldByName('change_addpay_flag').Value = '1' then
      Result := True
    else
      Result := False;
  finally
    qryTemp.Free;
  end;
end;

function TPubFunc.GetOep_AccYm(FUnit_Code : String;FOepFlag : string): string;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select unit_code,acc_ym from sfsc.sd_unitid where is_valid = 1 and  unit_code = ' + QuotedStr(FUnit_Code);
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.FieldByName('acc_ym').AsString = '' then
        Raise Exception.Create('没有找到对应的账务年月！');
      Result := qryTemp.FieldByName('acc_ym').AsString;
    finally
      qryTemp.Free;
    end;
  end;
end;


function TPubFunc.CheckEndAcc(FUnit_Code: String): boolean;
var qryTemp : TQuery;
    strSQL : string;
begin
  Result := True;
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sfsc.sd_unitid where is_valid = 1 and  unit_code = ' + QuotedStr(FUnit_Code) ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('基础信息中该社保账户没有找到！');
      if qryTemp.FieldByName('proc_flag').AsString = '1' then
        Result := False;
    finally
      qryTemp.Free;
    end;

  end;
end;



function TPubFunc.GetCityNo: string;
var qryTemp : TQuery;
    strSQL : string;
begin
  {with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from fs_fincsys' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('财务基础信息中该城市号没有找到！');
      Result := qryTemp.FieldByName('city_no').AsString;
    finally
      qryTemp.Free;
    end;

  end;}

  result := GetCurUser.City_No;

 // result := '0018';
end;


function TPubFunc.GetFirstMonth(FAcc_Ym: String): string;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select to_char(to_date('+QuotedStr(FAcc_Ym)+',''yyyy-mm'')-1,''yyyymm'') as acc_ym from dual' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('取上月日期错误！');
      Result := qryTemp.FieldByName('acc_ym').AsString;
    finally
      qryTemp.Free;
    end;

  end;
end;

function TPubFunc.GetAccfundEmpAccMode: String;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sd_accfund_param where sfsc_code='''+getCurUser.Sfsc_code+'''' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('公积金参数sd_accfund_param未维护！');
      Result := qryTemp.FieldByName('emp_account_mode').AsString;
    finally
      qryTemp.Free;
    end;

  end;
end;

function TPubFunc.GetAccfundRateMode: String;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sd_accfund_param where sfsc_code='''+getCurUser.Sfsc_code+'''' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('公积金参数sd_accfund_param未维护！');
      Result := qryTemp.FieldByName('rate_mode').AsString;
    finally
      qryTemp.Free;
    end;

  end;
end;

Function TPubFunc.GetAccfundAgentMode: String;
var
  strCityNo: String;
begin
  strCityNo := GetCityNo;

  if strCityNo = '0017' //成都
  then
  begin
    Result := '2'; //当地多委托机构模式
  end
  else
  begin
    Result := '1'; //当地单一委托机构模式
  end;
end;

function TPubFunc.GetAccfundAccYm(companyAccount: String): String;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sfsc.wf_accfundb_company where company_account = ''' + companyAccount + ''' and first_flag = ''1''';
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('公积金单位未维护！');
      Result := qryTemp.FieldByName('acc_ym').AsString;
    finally
      qryTemp.Free;
    end;

  end;
end;

function GetAccType(Account: String): TOepAcc;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sfsc.sd_account_type where unit_code='''+Account+'''' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
      begin
          Result.oep_acc := Account;
          Result.is_oep:='1';
          Result.is_med:='1';
          Result.is_lose:='1';
          Result.is_injure:='1';
          Result.is_birth:='1';
      end
      else
      begin
          Result.oep_acc := Account;
          Result.is_oep:=qryTemp.fieldbyname('is_oep').asstring;
          Result.is_med:=qryTemp.fieldbyname('is_med').asstring;
          Result.is_lose:=qryTemp.fieldbyname('is_lose').asstring;
          Result.is_injure:=qryTemp.fieldbyname('is_injure').asstring;
          Result.is_birth:=qryTemp.fieldbyname('is_birth').asstring;
      end;
    finally
      qryTemp.Free;
    end;
  end;
end;

Function TPubFunc.GetAccfundCompAccMode: String;
var
  strCityNo: String;
begin
  strCityNo := GetCityNo;

  if strCityNo = '0018' then
    result := '1'
  else if strCityNo = '0001' then
    result := '3'
  else if strCityNo = '0017' then
    result := '4'
  else result := '2';
end;

Function TPubFunc.GetAccfundShouldDoMode: String;
var
  strCityNo: String;
begin
  strCityNo := GetCityNo;

 { if strCityNo = '0019' then
    result := '2'
  else }
   result := '1';

  {if strCityNo = '0017' then
    result := '1'
  else if strCityNo = '0019' then
    result := '2'
  else result := '0';}
end;

function TPubFunc.IfAccfundSupplyLate: String;
var qryTemp : TQuery;
    strSQL : string;
begin
  with qryTemp do
  begin
    qryTemp := TQuery.Create(nil);
    try
      strSQL := 'select * from sd_accfund_param where sfsc_code='''+getCurUser.Sfsc_code+'''' ;
      qryTemp.DatabaseName := 'SfscMis';
      qryTemp.Close;
      qryTemp.SQL.Clear;
      qryTemp.SQL.Add(strSQL);
      qryTemp.Open;
      if qryTemp.IsEmpty then
        Raise Exception.Create('公积金参数sd_accfund_param未维护！');
      Result := qryTemp.FieldByName('IF_SUPPLY_LATE').AsString;
    finally
      qryTemp.Free;
    end;

  end;
end;

//初始化单位账号下拉框 
//2013-01-11
procedure InitOepAccDropDownList(cbbOepAcc:TObject;AddrCode:string='');
var
  strSql,sqlText:string;
  Query:TQuery;
  dataSet:TDataSet;
begin
  sqlText:= 'SELECT unit_code' +
           '  FROM sfsc.sd_unitid s' +
           ' WHERE IS_VALID=''1'' and addr_code IN (SELECT addr_code' +
           '  FROM sfsc_sec.sd_oep_address sd ' +
           '  WHERE  sd.city_no ='+quotedstr(GetCurUser.City_no)+')';
  if cbbOepAcc=nil then
    Exit;
  if AddrCode='' then
  begin
    if IsValidApp(GetCurUser.User_Id,APP_ALLUNITNO) then
        strSql := sqlText
    else
      strSql := sqlText + ' and manage_user='+QuotedStr(GetCurUser.User_Id);
  end
  else
  begin
    if IsValidApp(GetCurUser.User_Id,APP_ALLUNITNO) then
        strSql := sqlText + ' and ADDR_CODE='+QuotedStr(AddrCode)
    else
      strSql := sqlText + ' and ADDR_CODE='+QuotedStr(AddrCode)
                        + ' and manage_user='+QuotedStr(GetCurUser.User_Id);
  end;
  
  if cbbOepAcc.InheritsFrom(TComboBox) then
  begin
    Query := TQuery.Create(nil);
    try
      with Query do
      begin
        DatabaseName := 'SfscMis';
        Query_Open(Query,strSql);
        (cbbOepAcc as TComboBox).Items.Clear;
        First;
        while not eof do
        begin
          (cbbOepAcc as TComboBox).Items.Add(Fields[0].AsString);
          Next;
        end;
        Close;
      end;
    finally
      Query.Free;
    end;
  end
  else if cbbOepAcc.InheritsFrom(TDBLookupComboBox) then
  begin
    try
      dataSet := (cbbOepAcc as TDBLookupComboBox).ListSource.DataSet;
      if dataSet<>nil then
      begin
        with TQuery(dataSet) do
        begin
          Close;
          SQL.Text := strSql;
          Open;
        end;
      end;
    except
      on E:Exception do
        ShowWarning('初始化单位账户失败!');
    end;
  end;
end;

procedure SetControlReadonly(control:TWinControl;isReadOnly:Boolean=True);
var
  I:Integer;
begin
  if not Assigned(control) then
    Exit;
  for I := 0 to control.ControlCount - 1 do
  begin
    if control.Controls[i].InheritsFrom(TCustomEdit) then
      SetControlReadonly(control.Controls[i] as TCustomEdit,IsReadOnly)
    else if control.Controls[i].InheritsFrom(TCustomControl) then
      SetControlReadonly(control.Controls[i] as TCustomControl,IsReadOnly)
    else if control.Controls[i].InheritsFrom(TButtonControl) then
      SetControlReadonly(control.Controls[i] as TButtonControl,IsReadOnly)
  end;
  
  if IsPublishedProp(control,'ReadOnly') then
    SetPropValue(control,'ReadOnly',IsReadOnly)
  else if IsPublishedProp(control,'Enabled') then
    SetPropValue(control,'Enabled',not IsReadOnly);

  if IsPublishedProp(control,'Color') then
  begin
    if IsReadOnly then
      SetPropValue(control,'Color',clBtnFace)
    else
      SetPropValue(control,'Color',clWindow);
  end;
end;

procedure InitAddrCodeDropDown(cbbAddr:TDBLookupComboBox;qryAddr:TQuery);
var
  sql:string;
begin
  sql:='select *' +
    '  from sfsc_sec.sd_oep_address a' +
    ' where a.city_no = ' + QuotedStr(pubFunc.GetCityNo) +
    ' order by a.addr_code';
  qryAddr.DatabaseName:='SfscMis';
  Query_Open(qryAddr,sql);
  qryAddr.Locate('is_default','1',[]);
  cbbAddr.KeyValue:=VarToStr(qryAddr.FieldValues['addr_code']);
end;

function GetEntrantInfo(entrant_no:string;field_name:string):string;
var
  sql:string;
begin
  if (entrant_no=EmptyStr)
    or (field_name=EmptyStr) then
  begin
    Result:=EmptyStr;
    Exit;
  end;

  sql:='select sfsc.pkg_entrant_adp.fun_get_entrant_info(%s,%s) from dual';
  sql:=Format(sql,[entrant_no,QuotedStr(field_name)]);
  Result:=Query_Value('sfscMis',sql);
end;

initialization
  pubFunc := TPubFunc.Create;
finalization
  pubFunc.Free;
end.
