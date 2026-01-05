{*******************************************************}
{                                                       }
{       自定义程序库                                    }
{                                                       }
{       Copyright (c) 1998,99 Jetco                     }
{                                                       }
{*******************************************************}

unit unLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,IdAttachmentFile,
  Db, DBTables, StdCtrls,extctrls,grids,dbcgrids,dbctrls,dbGrids,dbGrid_s,mask,comctrls,
  tlhelp32, ComObj, ExcelXP, UnCommanBas, unfrmlogin,unConsts,DBGridEh,
  DBCtrlsEh;

type

  PMyRec = ^TMyRec;
  TMyRec = record
    Code: string;
  end;

//打印和单表查询时使用

  TFieldP = ^TFieldProperties;
  TFieldProperties = record
    NextField: TFieldP;
    Field_Name:String;
    Field_Caption:String;
    FieldSize:integer;
    FieldType: TFieldType;
    Used :Boolean;
    isvalidField:Boolean;
    isDisPlayField:Boolean;
    FieldOrder:integer;
  end;



  TFieldInfo= ^TFieldInfo_;
  TFieldInfo_ = record
    NextField: TFieldInfo;
    Field_Name:String;
    Field_Caption:String;
    Field_Value:variant;
    Field_Pos:TAlignment;
    Field_Size:integer;
    PrintField_Size:integer;
  end;

   TNameValue=^TNameValue_;
   TNameValue_=record
    Next:TNameValue;
    Name:String;
    Value:Variant;
   end;

  //导入参数信息 add by gw in 201211
  type
    TImportInfo = class
    private
      FRptSno: integer;
      FCityNo: string;
      FFileName: string;
      FImportPattern: string;
      FIfBatchNo: string;
      FDeleteClause: string;
      FSfscCode:  string;
    public
      property RptSno: integer read FRptSno write FRptSno;
      property CityNo: string read FCityNo write FCityNo;
      property FileName: string read FFileName write FFileName;
      property ImportPattern: string read FImportPattern write FImportPattern;
      property IfBatchNo: string read FIfBatchNo write FIfBatchNo;
      property DeleteClause: string read FDeleteClause write FDeleteClause;
      property SfscCode: string read FSfscCode write FSfscCode;
  end;

  //日志信息 add by gw in 201211
  type
    TLogInfo = class
    private
      FBizType: string;
      FProcType: string;
      FLogType: string;
      FCompanyAccount: string;
      FEmpAccount: string;
      FAccYm: string;
      FChangeType: string;
      FEmpNo: string;
      FName: string;
      FErrMsg: string;
      FBatchNo: integer;
      FSfsc_Code: integer;
    public
      property BizType: string read FBizType write FBizType;
      property ProcType: string read FProcType write FProcType;
      property LogType: string read FLogType write FLogType;
      property CompanyAccount: string read FCompanyAccount write FCompanyAccount;
      property EmpAccount: string read FEmpAccount write FEmpAccount;
      property AccYm: string read FAccYm write FAccYm;
      property ChangeType: string read FChangeType write FChangeType;
      property EmpNo: string read FEmpNo write FEmpNo;
      property Name: string read FName write FName;
      property ErrMsg: string read FErrMsg write FErrMsg;
      property BatchNo: integer read FBatchNo write FBatchNo;
  end;

  function  HaveInstallPrinter:Boolean;

  function  GetEmptyEditText(EditMask_:String):String;
  Function ClearMaskText(Sender: TObject):Boolean;

  Function  FieldsAsPt(Var RootPoint:TFieldInfo;
                        DataSet:TdataSet;
                        const isAssign_Value:Boolean
                        ):Boolean;
  function  Query_Test(Var Query1:TQuery;strSql:String):Boolean;
  function  Query_refresh(Var Query1:TQuery):Boolean;    //
  function  Query_Sql(Var Query1:TQuery;strSql:String):Boolean;
  function  Query_Open(var Query1:TQuery;const strSql:String):Boolean;
  function  Query_Value(const DataBaseName_,strSql:String):Variant;
  function  Query_Found(const DataBaseName_,strSql:String):Boolean;
  function  Query_Exec(const DataBaseName_,strSql:String):Boolean;
  function  Sql_ToTable(const strSql:String;var tbDest:TTable):integer;
  function  Date_Change(Var Date_Value : String; Date_Format:String):Boolean;
  function GET_stafftypeBySNO(assignsno:string):string;

  function  Sql_ToBDEDataSet(const strSql:String;tbDest:TBDEDataSet):integer;
  function  BDEDataSetMOve(sr:TBDEDataSet;tbDest:TBDEDataSet;KeyFieldsr,KeyFieldDest:string;const isAppend:Boolean):integer;
  function  DataSet_ToTable(scrqr:TDataset;var tbDest:TTable):integer;
  function  DataSet_ToBDEDataSet(scrqr:TDataset; tbDest:TBDEDataSet):integer;

  Function DataSetBatchMove(BDEDataSetSrc:TBDEDataSet;tbDest:TTable;Mode_:TBatchMode;CommitCount_:integer):integer;
  function SqlBatchMove(sDataBaseName_,strSql,dDataBaseName_,Table_name:String;Mode_:TBatchMode;CommitCount_:integer):Boolean;

  function  DataSet_LoadCombox(DataSet:TDataSet;combox:TCombobox):Boolean;
  function  DataSet_Sql(scrqr:TDataset):String;

  function  Query_ToArray(DataBaseName_,strSql:String;var Values:Array of Variant):integer;
  function  Query_ToVar(DataBaseName_,strSql:String;var Value:Variant):integer;
  function  Query_Addmonth(const DataBaseName_:String;const Date_:Tdatetime;Value_:integer):Tdatetime;
  function DataSet_FLabel(var DataSet:TDataSet;StrCapions:Array of String):Boolean;
  function Get_sysdatetime(DataBaseName_:String):Tdatetime;
  function Get_sysdate(DataBaseName_:String):Tdatetime;
  function Fill_Char(s_Str : String; n_len : Integer; s_Char : String) : String;





  function  storedProc_Exec(DataBaseName_,StoredProcName_:String;
                            ParamNames:Array of String;
                            var ParamValues:array of Variant
                            ):boolean;

  function  storedProc_Result(DataBaseName_,StoredProcName_:String;
                            ParamNames:Array of String;
                            ParamValues:array of Variant;
                            RetrunIndex:Word):Variant;
  function GetYearmonth(Date_:Variant):Tdatetime;
  function VartoWord(const var_:Variant):Word;
  function strEncodedate(const yy,mm,dd:Variant):Tdatetime;
  function GetHowYm(const ym1,ym2:Variant;const isdec,notmonth:boolean):variant;
  function  sqlDateStr(date_:variant):String;
  function  sqlDate(date_:variant):String;
  function  sqlDatetime(date_:variant):String;


  function  strstr(str:String):String;
  function  Sqlstr(str:String):String;

  function  sqlToNull(str:String):String;
  function  TrimSubStr(str:String;strsub:String;intOption:integer):String;
  function  strReplace(str,strsub,strRepl:String;intOption:integer):String;
  function  strRevert(str:String):String;

  Procedure Refresh_Table(as_Year,as_Month,as_table : String);

  Procedure EnDis_AllControl(Parent_:TWinControl;const ExceptCon_Name:array of String;const isEnabled,OnlyDB,OKColor:Boolean);
  procedure isEnabledCon(Form:TForm;const Con_Name:array of String;const isEnabled,OKColor:boolean);
  Procedure ReadOnly_AllDBControl(Parent_:TWinControl;const ExceptCon_Name:array of String;const isReadOnly,OKColor:Boolean);
  procedure ReadOnly_DBControl(Form:TForm;const Con_Name:array of String;const isReadOnly,OKColor:boolean);




  Function  MaxSql(const strSql,DataBaseName_:String):Longint;
  Function  PtAsFields(var RootPoint:TFieldInfo;
                         DataSet:TdataSet;
                         const ArrField:Array of string;
                         const NullISOver:Boolean
                        ):Boolean;

  Function MsgBox(const StrHint:String;const Hint_Flag:Word):integer;
  Procedure ShowBox(const StrHint:String);
  Procedure ShowWarning(const StrHint:String);
  Function    D_grd_GotoFirstSel(d_grd:TDBGrid):boolean;


  Function    D_grd_ClearFit(d_grd:TDBGrid;
                               const SkipField:String;
                               _Values:Array of String ):integer;

  Function    D_grd_ClearNoFit(d_grd:TDBGrid;
                               const SkipField:String;
                               _Values:Array of String ):integer;

  Function  D_grd_BuildStr(d_grd:TDBGrid;
                           const FieldName:String ):String;



 Function    D_grd_GotoFirstSel_(d_grd:TDBGrid_):boolean;


  Function    D_grd_ClearFit_(d_grd:TDBGrid_;
                               const SkipField:String;
                               _Values:Array of String ):integer;

  Function    D_grd_ClearNoFit_(d_grd:TDBGrid_;
                               const SkipField:String;
                               _Values:Array of String ):integer;

  Function  D_grd_BuildStr_(d_grd:TDBGrid_;
                           const FieldName:String ):String;
function Select_Dir(const Caption: string; const Root: WideString;
  out Directory: string;Form:Tform): Boolean;


function HasAttr(const FileName: string; Attr: Word): Boolean;
procedure CopyFile(const FileName, DestName: TFileName);
procedure Tree_AddItem(MyTree: TTreeview; Tree_Node: TTreeNode; dataSet: TdataSet);
procedure Tree_AddExpand(TreeView1: TTreeView; FNode: TTreeNode);
procedure ComboBoxAdd(ComboBox1: TCustomComboBox; Query1: TQuery);
Function SearchPinyin(HZstring : String) :String;
function Roundi(const Extended: extended):int64;
function Rounds(Extended: extended; i:integer):extended;
Function Next_acc_ym(acc_ym :string) :String;
Function last_day(month_date:string) :String;
Function NtoC(n0 :real) :String;
function Num2BCNum(dblArabic: double): string;
//zt add 2005.8
function send_email(topic:string;body:Tmemo;from :string;password:string;
                     to_add:string;to_cc:string;to_bcc:string;attach:Tmemo):string;

function FindProcess(AFileName: string): boolean;

function lpad(const str :string; const strlength:integer; const c: string):string;
function rpad(const str :string; const strlength:integer; const c: string):string;
//zhouyingqian 20071121 add
function IsIdValid(id: string; id_type: integer): string;
function GetIdSex(id: string): integer;
function GetIdBirthday(id: string): string;
function CheckIDbit(id:string):boolean;
function CheckIDLastBit(id:string):boolean;
function Power(base:integer;p:integer):integer;
function SplitString(const Source, ch: string): TStringList;  //将String拆分到StringList add by gw in 201211
function ImportIntoTemp(importInfo: TImportInfo): String;     //导入临时表通用接口 add by gw in 201211
function GetImpValue(strData, strFormat, strTruncParam: String): String; //将strData按strFormat进行格式化 add by gw in 201211
function InsertOptLog(logInfo: TLogInfo):Boolean;             //写入后道通用日志wf_operation_log add by gw in 201211
procedure CreateFolder;     //创建文件夹
procedure CreateComboBoxList(var Qry:TQuery; ComboBox:TCustomComboBox; FieldName,FilterStr:string);//生成ComboBox动态列表,FieldName:字段名称；FilterStr:过滤字符串
procedure SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);
function IsEpay2:boolean;
function IsSameCompany(const company_no1, company_no2: string): boolean; //判断两个客户是否同一客户组
function Get_Emp_No(const kind: integer; const value, company_no, comp_grp_no, acc_ym: string): string; //根据传入值取电脑号
function Lock_Payroll_Resource(const acc_ym, company_no, user_id: string; const kind: integer): string; //加锁解锁薪酬资源
function Lock_Attend_Resource(const acc_ym, company_no, user_id: string; const kind: integer): string; //加锁解锁考勤资源
function IsValidGroup(const user_id, company_no: string): boolean; //判断是否是客户销售组的成员
function Lock_Resource(const acc_ym: string; const company_no: string; const op_type: string; const user_id: string): string;
function Unlock_Resource(const acc_ym: string; const company_no: string; const op_type: string; const user_id: string): string;
procedure CopyGridEhDataToExcel(Args: array of const);
function WriteFile(filename, content: string): boolean;
procedure InitDropDownSfscCode(combobox:TDBComboBoxEh);
function GetCompanyAccount(combobox:TDBComboBoxEh;radio:TRadioGroup):string; //根据传入的控件值获取查询单位账号sql
function GetSfscCodeSql(const sfsc_code: string):string;

implementation
uses printers,ShlObj, ActiveX,unDmMain,unfrm_email;

function send_email(topic:string;body:Tmemo;from :string;password:string;
                     to_add:string;to_cc:string;to_bcc:string;attach:Tmemo):string;
var i:integer;
begin
   try
      frm_email := Tfrm_email.Create(Application);
      with frm_email do
      begin
         EDfromAddress.text:=from;
         EDpassword.text:=password;
         EDtoAddress.text:=to_add;
         EDtoCC.text:= to_cc;
         EDtoBCC.text:= to_bcc;
         EDtoSubject.text:= topic;
         i:=0 ;
         while attach.Lines[i]<>'' do
         begin
            TIdAttachmentFile.Create(IdMsgSend.MessageParts, attach.Lines[i]);
            i:=i+1;
         end;
         MMmailBody.Lines:=body.lines;
         BTsend.Click;
         result:=v_error;

      end;

   finally
         frm_email.Free;
   end;

end;

procedure Tree_AddExpand(TreeView1: TTreeView; FNode: TTreeNode);
var
  MyNode: TTreeNode;
begin
  MyNode:=FNode.GetFirstChild;
  while MyNode <> nil do
  begin
    TreeView1.Items.AddChild(MyNode, '');
    MyNode:=MyNode.GetNextSibling;
  end;
end;


procedure Tree_AddItem(MyTree: TTreeview; Tree_Node: TTreeNode; dataSet: TdataSet);
var
  MyRecPtr: PMyRec;
begin
  if dataSet.IsEmpty then
    Exit;
  with dataSet do
    begin
      First;
      while not EOF do
        begin
          New(MyRecPtr);
          MyRecPtr^.Code:=dataSet.Fields[1].AsString;
          MyTree.Items.AddChildObject(Tree_Node, dataSet.Fields[0].AsString, MyRecPtr);
          Next;
        end;
    end;
end;

Function SearchPinyin(HZstring : String) :String ;
Var
        i :Integer;
        S_char,HZchar: string;
Begin

        For  i := 0 to Length(HZstring) div 2 -1 do
      //For i:= 0 to 2 do
        Begin
                HZchar := Copy(Hzstring,(i+1)*2-1,2);
         case Word(hzchar[1]) shl 8 + Word(hzchar[2]) of
              $B0A1..$B0C4: S_char := 'A';
              $B0C5..$B2C0: S_char := 'B';
              $B2C1..$B4ED: S_char := 'C';
              $B4EE..$B6E9: S_char := 'D';
              $B6EA..$B7A1: S_char := 'E';
              $B7A2..$B8C0: S_char := 'F';
              $B8C1..$B9FD: S_char := 'G';
              $B9FE..$BBF6: S_char := 'H';
              $BBF7..$BFA5: S_char := 'J';
              $BFA6..$C0AB: S_char := 'K';
              $C0AC..$C2E7: S_char := 'L';
              $C2E8..$C4C2: S_char := 'M';
              $C4C3..$C5B5: S_char := 'N';
              $C5B6..$C5BD: S_char := 'O';
              $C5BE..$C6D9: S_char := 'P';
              $C6DA..$C8BA: S_char := 'Q';
              $C8BB..$C8F5: S_char := 'R';
              $C8F6..$CBF9: S_char := 'S';
              $CBFA..$CDD9: S_char := 'T';
              $CDDA..$CEF3: S_char := 'W';
              $CEF4..$D1B8: S_char := 'X';
              $D1B9..$D4D0: S_char := 'Y';
              $D4D1..$D7F9: S_char := 'Z';
            else
              S_char := '';
            end;
            Result := Result + S_char;
        End;
End;



 function  HaveInstallPrinter:Boolean;
 begin
   result:=(Printer<>nil) and (Printer.Printers.Count>0)
 end;
 function  GetEmptyEditText(EditMask_:String):String;
 begin
      result:='';
      with   TMaskEdit.Create(Application) do
      try
         EditMask:=EditMask_;
         result:=EditText;
      finally
         Free;
      end;
 end;

 Function ClearMaskText(Sender: TObject):Boolean;
 begin
  try
     if (Sender is  TCustomMaskEdit) then
        with   TMaskEdit.Create(Application) do
         begin
              EditMask:=TMaskEdit(Sender).EditMask;
              Clear;
              if TMaskEdit(Sender).EditText=EditText then
              begin
                 if  not (Sender is TdbEdit) then            TMaskEdit(Sender).EditMask:='';
                  if (Sender is  TDBEdit)
                     and Assigned(TDBEdit(Sender).Field)
                     and (TDBEdit(Sender).Field.DataSet.state in [dsinsert,dsEdit])
                     and (TDBEdit(Sender).Field.CanModify)
                    then  begin
                             if    TDBEdit(Sender).Field.Required  then
                               TDBEdit(Sender).EditText:=TDBEdit(Sender).Field.value
                             else
                              begin
                               TMaskEdit(Sender).EditMask:='';
                               TDBEdit(Sender).Field.Clear;
                              end;
                          end;

                 if  not (Sender is TdbEdit) then      TMaskEdit(Sender).Clear;
                 TMaskEdit(Sender).EditMask:=EditMask;
              end;
            Free;
         end;
        result:=True;
    Except
        result:=False;
   end;
  end;




 Function   Set_Readonly(conTmp:TControl;Const Value:Boolean):Boolean;
 begin
   Result:=True;
   if conTmp is TDBEDIT then
      TDBEDIT(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBCheckBox then
      TDBCheckBox(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBCheckBox then
      TDBCheckBox(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBRadioGroup then
      TDBRadioGroup(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBLookupComboBox then
      TDBLookupComboBox(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBGrid then
      TDBGrid(conTmp).ReadOnly:=Value
   else
   if conTmp is TDBComboBox then
    begin
       TDBComboBox(conTmp).ReadOnly:=Value;
      if value  then      //bug
        TDBComboBox(conTmp).style:=csDropDown
       else
         TDBComboBox(conTmp).style:=csDropDownList;
    end
  else
    result:=False;
 end;

 function  Date_Change(Var Date_Value : String; Date_Format:String):Boolean;
 Const
    StrSql = 'Select To_Char(To_Date(''%s'',''yyyy-mm-dd''),''%s'') from dual';
 Var
    ls_Date : String;
 Begin
    if Copy(Trim(Date_Value),1,1) = '-' Then
        Begin
           Result := True;
           Exit;
        End;

    if UpperCase(Date_Format) = 'YYYY-MM' Then
       ls_Date := Date_Value + '-01'
    Else
       ls_Date := Date_Value;

    With DmMain.QrTemp Do
       Try
         if Active Then Close;
         Sql.Clear;
         Sql.Add(Format(StrSql,[ls_Date,Date_Format]));
         Open;

         Date_Value := Fields[0].asString;
         Result := True;
       Except
         ShowMessage(Date_Value + '不是有效日期');
         Result := False;
       End;
 End;





Function  FieldsAsPt;
 var
   tmpFieldInfo:TFieldInfo;
   intCount:integer;
   strTmp:String;
  begin

   if RootPoint<>nil then
    begin
      disPose(RootPoint);
      RootPoint:=nil;
    end;
    for intCount:=DataSet.FieldCount -1 downto 0  do    //各个字段的值赋给TmpFieldInfo；
     begin
      if not  (DataSet.Fields[intCount].DataType in
          [ftString, ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftDate, ftTime, ftDateTime])
          or
          not DataSet.Fields[intCount].visible
      then
      Continue;
      New(TmpFieldInfo);
      TmpFieldInfo^.Field_Name:=DataSet.Fields[intCount].FieldName;
      strTmp:=DataSet.Fields[intCount].DisplayLabel;
      TmpFieldInfo^.Field_Caption :=strTmp;
      TmpFieldInfo^.Field_Size:=DataSet.Fields[intCount].DisplayWidth;
      TmpFieldInfo^.Field_pos:=DataSet.Fields[intCount].Alignment;

      if isAssign_Value then
         TmpFieldInfo^.Field_Value:=DataSet.Fields[intCount].Value
      else
          TmpFieldInfo^.Field_Value:=Null;



      if   TmpFieldInfo^.Field_Size<length(strTmp)then
           TmpFieldInfo^.Field_Size:=length(strTmp);

      TmpFieldInfo^.NextField:=RootPoint ;
      RootPoint:=TmpFieldInfo;
    end;  //for
    result:=True;
  end;

 Function  PtAsFields;  //TmpFieldInfo的值赋给DATASET的各个字段；
 var
   iCount:integer;
   tmpFieldInfo:TFieldInfo;
   NOSucess:Boolean;
   FieldTmp:TField;
 begin
   Result:=False;
   if RootPoint=nil then Exit;
   tmpFieldInfo:=RootPoint;
   DataSet.Edit;
   While tmpFieldInfo<>nil do
      begin
         NOSucess:=True;
         for iCount:=low(ArrField) to high(ArrField) do
           if  compareText(tmpFieldInfo.Field_Name,ArrField[iCount])=0 then
              Begin
                 NOSucess:=False;
                 Break;
              End;


      FieldTmp:= DataSet.FindField(tmpFieldInfo.Field_Name);

      if  NOSucess and (FieldTmp<>nil) and (FieldTmp.FieldKind=fkData)  then
        if NullISOver  or not  varisNull(tmpFieldInfo.Field_Value) then
           FieldTmp.value:= tmpFieldInfo.Field_Value;


       tmpFieldInfo:=tmpFieldInfo^.NextField ;
   end;
    Result:=True;
 end;



function  Query_Test(Var Query1:TQuery;strSql:String):Boolean;
var
  iCount:integer;
begin
  result:=True;
  with Query1 do
  try
    Sql.Clear;
    Sql.Add(strSql);

    Prepare;
    for iCount:=0 to  ParamCount-1 do
     Params[iCount].Value:=0;
     Open;
     Close;
  Except
   result:=False;
  end;
end;

function  Query_refresh(Var Query1:TQuery):Boolean;
var
  oldBookMark:TBookmark;
begin
 try
  oldBookMark:=Query1.GetBookmark;
   result:=True;
   Query1.close;
  if Query1.text='' then Exit;
 if   not Query1.Prepared then
   Query1.Prepare;

  Query1.open;
  if oldBookMark = nil then
      exit
  else if Query1.BookmarkValid(oldBookMark) then
    Query1.GotoBookmark(oldBookMark);
 except
  result:=False;
 end;
end;

function  Query_Sql(Var Query1:TQuery;strSql:String):Boolean;
begin
 try
   Query1.Sql.clear;
   Query1.SQL.Add(strSql);
   result:=true;
 except
   result:=False;
 end;
end;



function  Query_Open ;
begin
 Query1.Close;
 Query1.Sql.Clear;
 Query1.Sql.Add(strSql);
 try
  if not Query1.prepared then  Query1.Prepare;
  
  Query1.Open;

   if not Query1.IsEmpty Then
      Result:=True
   Else
      Result:=False;
 except
  result:=False;
  Exit;
 end;
end;


 function  Query_Value;
 var
  Query1:TQuery;
 begin
  result:=Null;
  Query1:=TQuery.Create(Application);
  Query1.DatabaseName := DatabaseName_;
  Query1.Sql.Add(strSql);

 try
  Query1.Prepare;
  Query1.Open;
  Result:=Query1.Fields[0].Value;
  Query1.Close;
  Query1.Free;
 except
  Query1.Free;
  Exit;
 end;
end;

  function GET_stafftypeBySNO(assignsno:string):string;
  begin
    Result:=VarToStr(Query_Value('sfscMis','select a.staff_type From fs_assign a  where a.sno='+quotedstr(assignsno)+''));
  end;


 function  Query_Found;
 var
  Query1:TQuery;
 begin

  Query1:=TQuery.Create(Application);
  Query1.DatabaseName := DatabaseName_;
   Query1.Sql.Add(strSql);
  try
    Query1.Prepare;
    Query1.Open;
  except
    result:=False;
    Query1.Free;
    Exit;
 end;
 Result:=  not Query1.IsEmpty ;
 Query1.Free;
end;

function  Query_Exec;
var
  Query1:TQuery;
 begin                
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName := DatabaseName_;
     Query1.Sql.Add(strSql);
     try
        Query1.Prepare;
        Query1.ExecSql;
     except
        result:=False;
        Query1.Free;
        Exit;
     end;
    Result:=True;
    Query1.Free;
 end;

//本函数用于将小于十万亿元的小写金额转换为大写
Function NtoC(n0 :real) :String;
  Function IIF( b :boolean; s1,s2 :string) :string;
    begin if b then IIF:= s1 else IIF:=s2;
    end; //本函数的功能一目了然: 当b为真时返回s1,否则返回s2
  Const c= '零壹贰叁肆伍陆柒捌玖◇分角圆拾佰仟万拾佰仟亿拾佰仟万';
  var L,i,n :integer;   Z :boolean;   s,s1,s2 :string;
begin
  s:= FormatFloat( '0.00', ABS(n0));
  L:= Length( s);
  Z:= n0<1;
  For i:= 1 To L-3 do
    begin
    n:= StrToInt( s[ L-i-2]);
    s1:=IIf((n=0)And(Z Or (i=9) Or (i=5) Or (i=1)), '', Copy( c, n*2+1, 2))
      + IIf((n=0)And((i<>9)And(i<>5)And(i<>1) Or Z And(i=1)),'',Copy(c,(i+13)*2-1,2))
      + s1;
    Z:= (n=0);
    end;
  Z:= False;
  For i:= 1 To 2 do
    begin
    n:= StrToInt( s[ L-i+1]);
    s2:= IIf((n=0)And((i=1) Or (i=2)And(Z Or (n0<1))), '', Copy( c, n*2+1, 2))
       + IIf( (n>0), Copy( c,(i+11)*2-1, 2), IIf( (i=2) Or Z, '','整'))
       + s2;
    Z:= (n=0);
    end;
  For i:= 1 To Length( s1) do If Copy(s1, i, 4) = '亿万' Then Delete(s1,i+2,2);
  NtoC:= IIf(n0=0, '零', IIF(n0<0, '-','')+ s1+s2);
End;

function Num2BCNum(dblArabic: double): string;
const
  _ChineseNumeric = '零壹贰叁肆伍陆柒捌玖';
var
  sArabic: string;
  sIntArabic: string;
  iPosOfDecimalPoint: integer;
  i: integer;
  iDigit: integer;
  iSection: integer;
  sSectionArabic: string;
  sSection: string;
  bInZero: boolean;
  bMinus: boolean;

  (* 将字串反向, 例如: 传入 '1234', 传回 '4321' *)
  function ConvertStr(const sBeConvert: string): string;
  var
    x: integer;
  begin
    Result := '';
    for x := Length(sBeConvert) downto 1 do
      AppendStr(Result, sBeConvert[x]);
  end; { of ConvertStr }
begin
  Result := '';
  bInZero := True;
  sArabic := FloatToStr(dblArabic); (* 将数字转成阿拉伯数字字串 *)
  if sArabic[1] = '-' then
  begin
    bMinus := True;
    sArabic := Copy(sArabic, 2, 254);
  end
  else
    bMinus := False;
  iPosOfDecimalPoint := Pos('.', sArabic);  (* 取得小数点的位置 *)

  (* 先处理整数的部分 *)
  if iPosOfDecimalPoint = 0 then
    sIntArabic := ConvertStr(sArabic)
  else
    sIntArabic := ConvertStr(Copy(sArabic, 1, iPosOfDecimalPoint - 1));
  (* 从个位数起以-四位数为一小节 *)
  for iSection := 0 to ((Length(sIntArabic) - 1) div 4) do
  begin
    sSectionArabic := Copy(sIntArabic, iSection * 4 + 1, 4);
    sSection := '';
    (* 以下的 i 控制: 个十百千位四个位数 *)
    for i := 1 to Length(sSectionArabic) do
    begin
      iDigit := Ord(sSectionArabic[i]) - 48;
      if iDigit = 0 then
      begin
        (* 1. 避免 '零' 的重覆出现 *)
        (* 2. 个位数的 0 不必转成 '零' *)
        if (not bInZero) and (i <> 1) then sSection := '零' + sSection;
        bInZero := True;
      end
      else
      begin
        case i of
          2: sSection := '拾' + sSection;
          3: sSection := '佰' + sSection;
          4: sSection := '仟' + sSection;
        end;
        sSection := Copy(_ChineseNumeric, 2 * iDigit + 1, 2) +
          sSection;
        bInZero := False;
      end;
    end;

    (* 加上该小节的位数 *)
    if Length(sSection) = 0 then
    begin
      if (Length(Result) > 0) and (Copy(Result, 1, 2) <> '零') then
        Result := '零' + Result;
    end
    else
    begin
      case iSection of
        0: Result := sSection;
        1: Result := sSection + '万' + Result;
        2: Result := sSection + '亿' + Result;
        3: Result := sSection + '兆' + Result;
      end;
    end;
  end;

  (* 处理小数点右边的部分 *)
  if iPosOfDecimalPoint > 0 then
  begin
    AppendStr(Result, '点');
    for i := iPosOfDecimalPoint + 1 to Length(sArabic) do
    begin
      iDigit := Ord(sArabic[i]) - 48;
      AppendStr(Result, Copy(_ChineseNumeric, 2 * iDigit + 1, 2));
    end;
  end;

  (* 其他例外状况的处理 *)
  if Length(Result) = 0 then Result := '零';
  if Copy(Result, 1, 2) = '点' then Result := '零' + Result;

  (* 是否为负数 *)
  if bMinus then Result := '负' + Result;
end;

 function  Sql_ToTable;
 var
  Query1:TQuery;
  iCount:integer;
  fTmp:TField;
 begin
     result:=-1;
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName :=tbDest.DatabaseName;
     Query1.Sql.Add(strSql);
     try
        Query1.Prepare;
        Query1.Open;
     except
        Query1.close ;
        Query1.Free;
        Exit;
     end;
     Result:=0;
     if Query1.IsEmpty  then Exit;
     if not  tbDest.Active then    tbDest.Open;
     if  not (tbdest.State in [dsEdit,dsinsert]) then
        tbDest.Edit;
     try
      for iCount:=0 to Query1.FieldCount-1 do
      begin
         Ftmp:=tbdest.FindField(Query1.Fields[iCount].FieldName);
         if    ( ftmp<>nil)
           and (fTmp.DataType=Query1.Fields[iCount].DataType)
           and (fTmp.Size>=Query1.Fields[iCount].Size) then
         begin
           Ftmp.Value :=Query1.Fields[iCount].value;
           Result:=1;
         end;
      end;
      Query1.Close;
      Query1.Free;
    Except
        Result:=-1;
        Query1.close ;
        Query1.Free;
        Exit;
     end;

 end;

 function  Sql_ToBDEDataSet;
 var
  Query1:TQuery;
  iCount:integer;
  fTmp:TField;
 begin
     result:=-1;
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName :=TQuery(tbDest).DatabaseName;
     Query1.Sql.Add(strSql);
     try
        Query1.Prepare;
        Query1.Open;
     except
        Query1.close ;
        Query1.Free;
        Exit;
     end;
     Result:=0;

     if Query1.IsEmpty  then Exit;

     if not  tbDest.Active then    tbDest.Open;

     if  not (tbdest.State in [dsEdit,dsinsert]) then  tbDest.Edit;

     try
      for iCount:=0 to Query1.FieldCount-1 do
      begin
         Ftmp:=tbdest.FindField(Query1.Fields[iCount].FieldName);
         if    ( ftmp<>nil)
           and (fTmp.DataType=Query1.Fields[iCount].DataType)
           and (fTmp.Size>=Query1.Fields[iCount].Size) then
         begin
           Ftmp.Value :=Query1.Fields[iCount].value;
           Result:=1;
         end;
      end;
      Query1.Close;
      Query1.Free;
    Except
        Result:=-1;
        Query1.close ;
        Query1.Free;
        Exit;
     end;
 end;



 function  DataSet_ToTable(scrqr:Tdataset;var tbDest:TTable):integer;
 var
  iCount:integer;
  fTmp:TField;
 begin

     Result:=0;

     if not scrqr.active or scrqr.IsEmpty  then Exit;
     if not  tbDest.Active then    tbDest.Open;
     if  not (tbdest.State in [dsEdit,dsinsert]) then
        tbDest.Edit;
     try
      for iCount:=0 to scrqr.FieldCount-1 do
      begin

         Ftmp:=tbdest.FindField(scrqr.Fields[iCount].FieldName);
         if    ( ftmp<>nil)
           and (fTmp.DataType=scrqr.Fields[iCount].DataType)
           and (fTmp.Size>=scrqr.Fields[iCount].Size) then
         begin
           Ftmp.Value :=scrqr.Fields[iCount].value;
           Result:=1;
         end;
      end;
     Except
        Result:=-1;
        Exit;
     end;

 end;

 function  DataSet_ToBDEDataSet(scrqr:TDataset; tbDest:TBDEDataSet):integer;
 var
  iCount:integer;
  fTmp:TField;
  ls_FieldName : String;
 begin
     Result:=0;
     if not scrqr.active or scrqr.IsEmpty  then Exit;
     if not  tbDest.Active then    tbDest.Open;
     if  not (tbdest.State in [dsEdit,dsinsert]) then
        tbDest.Edit;
     try
      for iCount:=0 to scrqr.FieldCount-1 do
      begin
         Ftmp:=tbdest.FindField(scrqr.Fields[iCount].FieldName);

         if    ( ftmp<>nil)
           and (fTmp.DataType=scrqr.Fields[iCount].DataType)
           and (fTmp.Size>=scrqr.Fields[iCount].Size) then
         begin
           Ftmp.Value :=scrqr.Fields[iCount].value;
           Result:=1;
         end;
      end;
     Except
        Result:=-1;
        Exit;
     end;

 end;

  function  BDEDataSetMOve(sr:TBDEDataSet;tbDest:TBDEDataSet;KeyFieldsr,KeyFieldDest:string;const isAppend:Boolean):integer;
  var
    isFound :boolean;
    isopen:Boolean;
    varTmp:variant;
  begin
    result:=-1;        
    isopen:= sr.Active;
   try
    if not tbDest.Active then   tbDest.Open;

    if not isopen  then   sr.Open else sr.first;
    result:=0;
    with tbDest do
    while   not sr.eof do
    begin
      varTmp:= sr.FieldbyName(KeyFieldsr).value;
      if vartostr(varTmp)<>'' then
      begin
       isFound:= Locate(KeyFielddest,varTmp , []);
       if isFound or  isAppend then
       begin
       if isFound then  Edit else Append;
        DataSet_ToBDEDataSet(sr,tbdest);
       end;

      try
       if tbdest.modified then 
        post;
      except
        Cancel;
      end;
      result:=result+1;
     end;
      sr.Next;
    end;
   finally
    sr.Active :=isopen;
   end; 
  end;


function  DataSet_LoadCombox(DataSet:TDataSet;combox:TCombobox):Boolean;
begin
   try
    DataSet.Active:=True;
    if  not DataSet.BOF  then
     DataSet.First;
    while not DataSet.EOF  do
    begin
       combox.Items.Add(DataSet.Fields[0].Text);
       dataSet.Next;
    end;
     result:=True;
   except
     result:=False;
   end;
end;


 function  DataSet_Sql(scrqr:TDataset):String;
 var
  iCount:integer;
  strTmp:String;
 begin
  result:='';
  strTmp:='';
  try
      for iCount:=0 to scrqr.FieldCount-1 do
      with  scrqr.Fields[iCount] do
      begin
        strTmp:='';
         case dataType of
          ftAutoInc,ftBytes,ftSmallint,ftFloat, ftCurrency,ftInteger, ftWord:
           begin
              if isnull then  strTmp:=' null '+FieldName
              else   strTmp:=AsString+#32+FieldName;
            end;
          ftString:
           begin
              if isnull then  strTmp:=' null '+FieldName
              else     strTmp:=strstr(AsString)+#32+FieldName;
            end;
          ftDate:
           begin
              if isnull then  strTmp:=' null '+FieldName
              else  strTmp:=sqldate(value) +#32+FieldName;
            end;
          ftdatetime:
            begin
              if isnull then  strTmp:=' null '+FieldName
              else    strTmp:=sqldatetime(value)+#32+FieldName;
            end;
         end;
          if strTmp<>'' then
          begin
           if result='' then result:=strTmp else result:=result+','+strTmp;
          end;
      end;
   finally
   end;
 end;



 function    Query_ToArray(DataBaseName_,strSql:String;var Values:Array of Variant):integer;
 var
  Query1:TQuery;
  iCount:integer;

 begin
     result:=-1;
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName :=DatabaseName_;
     Query1.Sql.Add(strSql);
     try
       Query1.Prepare;
       Query1.Open;
     except
        Query1.close ;
        Query1.Free;
        Exit;
     end;
     if Query1.IsEmpty  and (high(Values)=0) then Exit;

     result:=0;
     try
      for iCount :=0 to high(Values)-low(Values) do
      begin
         if iCount>Query1.FieldCount-1  then Break;
          Values[iCount]:=Query1.Fields[iCount].value;
          result:=1;
      end;
      Query1.Close;
      Query1.Free;


     Except
        Result:=-1;
        Query1.close ;
        Query1.Free;
        Exit;
     end;
 end;



 function    Query_ToVar(DataBaseName_,strSql:String;var Value:Variant):integer;
 var
   Query1:TQuery;
 begin
     result:=-1;
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName :=DatabaseName_;
     Query1.Sql.Add(strSql);
     try
        Query1.Prepare;
        Query1.Open;
     except
        Query1.close ;
        Query1.Free;
        Exit;
     end;
    if Query1.RecordCount=0   then Exit;

    try
      if  not Query1.Fields[0].isnull then
       value:=Query1.Fields[0].Value;
     Query1.Close;
     Query1.Free;
     result:=1;
    except
     result:=0;
    end;

 end;




 function  Query_Addmonth;
 var
  Query1:TQuery;
  strSql:String;
 begin
  result:=0;
  Query1:=TQuery.Create(Application);
  Query1.DatabaseName := DatabaseName_;

  strSql:= 'Select Add_months(to_date('#39
           +Formatdatetime('yyyy''/''mm''/''dd',Date_)
           +#39',''yyyy/mm/dd''),'
           +intTostr(value_)
           +') from dual ';

  Query1.Sql.Add(strSql);
 try
  Query1.Prepare;
  Query1.Open;
  Result:=Query1.Fields[0].asDatetime;
  Query1.Close;
  Query1.Free;
 except
  Query1.Free;
  Exit;
 end;
end;

 function DataSet_FLabel(var DataSet:TDataSet;StrCapions:Array of String):Boolean;
 var
   iCount:integer;
 begin
   result:=False;
  if not  Dataset.Active then exit;
  try
    for iCount:=0 to  DataSet.FieldCount-1 do
    begin
       if iCount>High(StrCapions) then  break;
       DataSet.Fields[iCount].DisplayLabel:=StrCapions[iCount];
     end;
  result:=True;
  except
  end;
 end;

Function   DataSetBatchMove(BDEDataSetSrc:TBDEDataSet;tbDest:TTable;Mode_:TBatchMode;CommitCount_:integer):integer;
begin

   with  TBatchMove.Create(Application) do
   try
     Result:=-1;
     Source:=BDEDataSetSrc;
     Destination:=tbDest;
     CommitCount:=CommitCount_;
     Transliterate:=True;
     Mode:=Mode_;
     Execute;
     Result:=MovedCount;
   finally

    Free;
   end;

end;
 function SqlBatchMove(sDataBaseName_,strSql,dDataBaseName_,Table_name:String;Mode_:TBatchMode;CommitCount_:integer):Boolean;
  var
   qrSrc:TQuery;
   tbDest:TTable;
 begin
    qrSrc:=nil;
    tbDest:=nil;
   try
    qrSrc:=TQuery.Create(Application);
    qrSrc.DatabaseName:=sDataBaseName_;
    qrSrc.SQL.Add(strSql);

    tbDest:=TTable.Create(Application);
    tbDest.DatabaseName:=dDataBaseName_;
    tbDest.TableName :=Ansiuppercase(Table_name);
    result:= DataSetBatchMove(qrSrc,tbDest,Mode_,CommitCount_)>-1;
   finally
    if assigned(qrSrc)  then   qrSrc.Free;
    if assigned(tbDest) then   tbDest.Free;
   end;
  end;

function Get_sysdatetime(DataBaseName_:String):Tdatetime;
var
  Query1:TQuery;
  strSql:String;
 begin
  result:=0;
  Query1:=TQuery.Create(Application);
  Query1.DatabaseName := DatabaseName_;
  strSql:= 'Select sysdate from dual ';
  Query1.Sql.Add(strSql);
 try
  Query1.Prepare;
  Query1.Open;
  Result:=Query1.Fields[0].asDatetime;
  Query1.Close;
 Query1.Free;
 except
  Query1.Free;
  Exit;
 end;
end;
function Get_sysdate(DataBaseName_:String):Tdatetime;
var
  Query1:TQuery;
  strSql:String;
 begin
  result:=0;
  Query1:=TQuery.Create(Application);
  Query1.DatabaseName := DatabaseName_;
  strSql:= 'Select trunc(sysdate) from dual ';
  Query1.Sql.Add(strSql);
 try
  Query1.Prepare;
  Query1.Open;
  Result:=Query1.Fields[0].asDatetime;
  Query1.Close;
 Query1.Free;
 except
  Query1.Free;
  Exit;
 end;
end;


function  storedProc_Exec(DataBaseName_,StoredProcName_:String;
                            ParamNames:Array of String;
                            var ParamValues:array of Variant
                            ):boolean;
var
 storedProc1:TStoredProc;
 iCount,iStep:integer;
begin
  result:=False;

 {
  if   (high(ParamNames)-low(ParamNames)<>high(ParamValues)-low(ParamValues))
       or  (high(ParamNames)=0) then Exit;
  }

  storedProc1:= TstoredProc.Create(Application);
  storedProc1.DatabaseName :=DatabaseName_;
  storedProc1.StoredProcName:=uppercase(StoredProcName_);
  try
     if not  storedProc1.Prepared then
           storedProc1.Prepare;
     for iCount:= low(ParamNames) to  high(ParamNames) do
       for iStep:=0 to storedProc1.ParamCount-1 do
        if  (compareText(storedProc1.Params[iStep].Name,ParamNames[iCount])=0)
            and
             (storedProc1.Params[iStep].Paramtype  in [ptInput,ptInputOutput])
            then
        begin
            storedProc1.Parambyname(ParamNames[iCount]).Value:= ParamValues[iCount];
            break;
        end;

   STOREDPROC1.EXECPROC;
   for iCount:=low(ParamNames) to  high(ParamNames) do
       for iStep:=0 to storedProc1.ParamCount-1 do
        if (compareText(storedProc1.Params[iStep].Name,ParamNames[iCount])=0)
           and not
          (storedProc1.Params[iStep].Paramtype in [ptUnknown, ptInput])
         then
        begin
         if  not   storedProc1.Parambyname(ParamNames[iCount]).isnull then
            ParamValues[iCount]:=storedProc1.Parambyname(ParamNames[iCount]).Value;
            break;
        end;


    storedProc1.UnPrepare ;
    storedProc1.close;
    storedProc1.free;
   Except
    exit;
   end;
    result:=True;
 end ;
 function  storedProc_Result(DataBaseName_,StoredProcName_:String;
                            ParamNames:Array of String;
                            ParamValues:array of Variant;
                            RetrunIndex:Word):Variant;
  begin
  try
    result:=ParamValues[low(ParamValues)+RetrunIndex] ;
    if  (high(ParamNames)<RetrunIndex) or  storedProc_Exec(DataBaseName_,StoredProcName_,ParamNames,ParamValues) then
       result:=ParamValues[low(ParamValues)+RetrunIndex] ;
   Except
   end;     
  end;



 function GetYearmonth(Date_:Variant):Tdatetime;
 var
  year,month,dd:Word;
 begin
  result:=0;
  if (vartype(date_)<>varDate) or varisNUll(date_)  then  exit;
  DecodeDate(vartoDatetime(date_),year,month,dd);
  result:=EncodeDate(year,month,1);
 end;


 function VartoWord(const var_:Variant):Word;
 var
   strTmp:String;
  begin
   result:=0;
   if  (varType(var_)= varInteger) and (var_>-1)   then
      result:=trunc(abs(var_))
   else
   try
    strTmp:=vartostr(var_);
    result:=trunc(abs(strToint(strTmp)));
   except
   end;


  end;

function  strEncodedate(const yy,mm,dd:Variant):Tdatetime;
begin
 result:=0;
  try
    result:=encodedate(VartoWord(yy),VartoWord(mm),VartoWord(dd));
  except
  end;
end;


function GetHowYm(const ym1,ym2:Variant;const isdec,notmonth:boolean):variant;
var
 fym1,fYm2:real;
 inttmp,intyy1,intmm1,intyy2,intmm2:integer;
begin
  result:=0;
 try
   if varType(ym1)=varDate then
      fYm1:=abs(StrToFloat(FormatDatetime('yyyy''.''mm',varTodateTime(ym1))))
   else
      fYm1:=abs(StrToFloat(varToStr(ym1)));

   if varType(ym2)=varDate then
     fYm2:=abs(StrToFloat(FormatDatetime('yyyy''.''mm',varTodateTime(ym2))))
   else
     fYm2:=abs(StrToFloat(varToStr(ym2)));

    intyy1:=trunc(fYm1);
    intyy2:=trunc(fYm2);
    intmm1:=trunc(fym1*100-intyy1*100+0.00001);
    intmm2:=trunc(fym2*100-intyy2*100+0.00001);

    if  intyy1*12+intmm1>intyy2*12+intmm2 then
    begin
     inttmp:=intyy1;
     intyy1:=intyy2;
     intyy2:=inttmp;

     inttmp:=intmm1;
     intmm1:=intmm2;
     intmm2:=inttmp;
    end;

    intyy1:=intmm1 div  12+intyy1;
    intmm1:=intmm1 mod  12;
    if  intmm2<intmm1 then
    begin
      intmm2:=intmm2+12;
      dec(intyy2);
    end;
   if isdec then
   begin
    intyy1:=-intyy1;
    intmm1:=-intmm1;
   end;

   intyy2:=intyy2+intyy1;
   intmm2:=intmm2+intmm1;

   intyy2:=intmm2 div 12 +intyy2;
   intmm2:=intmm2 mod 12;
   if notmonth then
      result:=intyy2+intmm2/100
   else
      result:=intmm2+intyy2*12;
  except
  end;
end;
function  sqlDateStr(date_:variant):String;
begin
 result:='';
 try
  if     (varTostr(date_)='')
       or (varType(date_)=varString) and (Trim(Date_)='')
    then  exit;
   result:=formatdatetime('yyyy''/''mm''/''dd',vartodatetime(date_));
   result:='to_date('#39+result+#39',''yyyy/mm/dd'')'
 except
 end;
end;

function  sqlDate(date_:variant):String;
begin
 result:='NULL';
 try
  if     (varTostr(date_)='')
       or (varType(date_)=varString) and (Trim(Date_)='')
    then  exit;

   result:=formatdatetime('yyyy''/''mm''/''dd',vartodatetime(date_));
   result:='to_date('#39+result+#39',''yyyy/mm/dd'')'
 except
 end;
end;

function  sqlDatetime(date_:variant):String;
begin
 result:='NULL';
 try
  if     (varTostr(date_)='')
       or (varType(date_)=varString) and (Trim(Date_)='')
    then  exit;
   result:=formatdatetime('yyyy''/''mm''/''dd'' ''HH:n',vartodatetime(date_));
   result:='to_date('#39+result+#39',''yyyy/mm/dd HH24:MI'')';
 except
 end;
end;


function  Sqlstr(str:String):String;
  begin
    if str='' then
     result:='null'
    else
      result:=#39+str+#39;
  end;

 function  strstr(str:String):String;
  begin
     result:=#39+str+#39;
  end;


 function  sqlToNull(str:String):String;
 begin
  if str='' then
   result:='null'
  else
    result:=Str;
 end;

function  TrimSubStr(str:String;strsub:String;intOption:integer):String;
var
 strTmp:String;
 iPos,iLen,iLensub:integer;
begin
 strTmp:='';
 iPos:=pos(strSub,str);
 iLensub:=Length(strsub);
 iLen:=Length(str);

  if ipos>0  then
  begin
    if (intoption=0) //All
     or (intOption=1) and (iPos=1)//Left
     or (intOption=2) and (iPos=iLen-iLensub+1)//Right
     or (intOption=3) and (ipos>1) and (iPos<iLen-iLensub+1) //Center
     then
      begin
         strTmp:=Copy(str,1,ipos-1)
                 +Copy(str,iPos+iLensub,iLen-iLensub-ipos+1);

          result:=TrimSubStr(strTmp,strsub,intOption);
      end
      else
        result:=str;
  end
  else
    result:=str;

end;

function  strReplace(str,strsub,strRepl:String;intOption:integer):String;
var
 iold,iPos,iLen,iLensub:integer;
 strTmp:String;

begin

  iold:=intOption;

 if  intOption =2 then
  begin
   str:=strRevert(str);
   strSub:=strRevert(strSub);
   strRepl:=strRevert(strRepl);
   intOption:=1;
  end;

 iPos:=pos(strSub,str);
 iLensub:=Length(strsub);
 iLen:=Length(str);



  if ipos>0  then
  begin
    if (intoption=0) //All
     or (intOption=1) and (iPos=1)  //Left
     then
      begin
           strTmp:=strReplace(Copy(str,iPos+iLensub,iLen-iLensub-ipos+1),strsub,strRepl,intOption);
           result:=Copy(str,1,ipos-1)
                 +strRepl
                 +strTmp;
      end
      else
        result:=str;
  end
  else
    result:=str;

   if iold=2 then   result:=strRevert(result);


end;

function  strRevert(str:String):String;
var
 itmp:integer;
 strTmp:String;
begin
  strTmp:='';
  for iTmp:=length(str)  downto 1 do
   strTmp:=strTmp+str[itmp];
  result:=strTmp;
end;


Procedure EnDis_AllControl;
var
  iCount,iCount1:integer;
  conTmp:TControl;
  isOk:boolean;
 begin
  for iCount:=0 to Parent_.ControlCount-1 do//for1
   begin
     ConTmp:=Parent_.Controls[iCount];
      if (ConTmp is TCustomLabel) or (ConTmp is TCustomStaticText)
      then
        Continue;
     isOk:=True;
     if  not  OnlyDB or (CompareText(Copy(ConTmp.ClassName,1,3),'TDB')= 0) then
     begin
       for iCount1:=low(ExceptCon_Name) to high(ExceptCon_Name) do
         if (ExceptCon_Name[iCount1]<>'')and  (CompareText( ExceptCon_Name[iCount1],ConTmp.Name)=0) then
         begin
          isOk:=False;
          Break;
         end;
       if isOK then
          conTmp.Enabled :=isEnabled
       else
          conTmp.Enabled :=not isEnabled;

       if OKColor and (conTmp is TWinControl)  then
        begin
          if  (isEnabled) then
          begin
             if (conTmp is TButtonControl) or (conTmp is TCustomGroupBox) then
               TEdit(conTmp).Color:=clbtnFace
            else
               TEdit(conTmp).Color:=clWindow
          end
          else
           TEdit(conTmp).Color:=clInfoBk;
       end;
     end;
   end;  //for1
 end;

 procedure isEnabledCon;
 var
  iCount:integer;
  compTmp:TComponent;
 begin
   for iCount:=low(Con_Name) to  high(Con_Name) do
   begin
     compTmp:=Form.FindComponent(Con_Name[iCount]);
     if  compTmp=nil then Continue;
      TControl(CompTmp).Enabled:=isEnabled;
      if OKColor and  (CompTmp is TWinControl)  then
      begin
          if  (isEnabled) then
          begin
            if (CompTmp is TButtonControl) or (CompTmp is TCustomGroupBox) then
               TEdit(CompTmp).Color:=clbtnFace
            else
               TEdit(CompTmp).Color:=clWindow;
          end
          else
           TEdit(CompTmp).Color:=clInfoBk;
       end;
   end;
 end;
Procedure ReadOnly_AllDBControl;
var
  iCount1,iCount:integer;
  conTmp:TControl;
  isOk:boolean;
 begin
  for iCount:=0 to Parent_.ControlCount-1 do//for1
   begin
     ConTmp:=Parent_.Controls[iCount];
     if  (CompareText(Copy(ConTmp.ClassName,1,3),'TDB')<> 0)
        or   (ConTmp is TCustomLabel)
        or   (ConTmp is TCustomPanel)
//        or   (ConTmp is TCustomGrid)
        or   (ConTmp is TDBCtrlGrid)
      then
           Continue;
      isOk:=True;
      for iCount1:=low(ExceptCon_Name) to high(ExceptCon_Name) do
       if (ExceptCon_Name[iCount1]<>'')and  (CompareText( ExceptCon_Name[iCount1],ConTmp.Name)=0) then
         begin
          isOk:=False;
          Break;
         end;
      if  not   Set_ReadOnly(ConTmp,isReadonly and isOK) then        Continue;
      if OKColor   then
      begin
       if (ConTmp is TButtonControl) or (ConTmp is TCustomGroupBox) then   TEdit(ConTmp).Color:=clbtnFace
       else    if  (isReadonly) then             TEdit(ConTmp).Color:=clInfoBk
               else                   TEdit(ConTmp).Color:=clWindow;
      end;

   end;//for1
   end;

Procedure ReadOnly_DBControl;
 var
  iCount:integer;
  compTmp:TComponent;
 begin
   for iCount:=low(Con_Name) to  high(Con_Name) do
   begin
     compTmp:=Form.FindComponent(Con_Name[iCount]);
      if (compTmp=nil)
        or   (CompareText(Copy(compTmp.ClassName,1,3),'TDB')<> 0)
        or   (compTmp is TCustomLabel)
        or   (compTmp is TCustomPanel)
        or   (compTmp is TCustomGrid)
        or   (compTmp is TDBCtrlGrid)
        or  not   Set_ReadOnly(TControl(CompTmp),isReadonly) then       Continue;

        if OKColor   then
        if  (isReadonly) then      TEdit(CompTmp).Color:=clInfoBk
         else
          begin
            if (CompTmp is TButtonControl) or (CompTmp is TCustomGroupBox) then
               TEdit(CompTmp).Color:=clbtnFace
            else
               TEdit(CompTmp).Color:=clWindow;
          end;
   end;//for
 end;


Function  MaxSql;
var
 QrTmp:TQuery;
begin
 result:=-1;
 QrTmp:=Tquery.Create (Application);
 QrTmp.DataBaseName:=DataBaseName_;
 QrTmp.SQL.Add(strSql);
 try
   QrTmp.Open;
 except
   qrTmp.Free;
  Exit;
 end;
  if QrTmp.isEmpty or QrTmp.Fields[0].isNull then    Result:=0
  else   Result:=QrTmp.Fields[0].Value;
    qrTmp.Close;
    QrTmp.Free;
end;
 Function MsgBox;
 begin
    result:=Application.MessageBox(Pchar(strHint),PChar(Application.Title),Hint_Flag);
 end;


 Procedure ShowBox;
 begin
   Application.MessageBox(Pchar(strHint),PChar('信息提示'),MB_OK	+MB_ICONINFORMATION);
 end;

 Procedure ShowWarning;
 begin
   Application.MessageBox(Pchar(strHint),PChar('信息提示'),MB_OK	+MB_ICONWARNING);
 end;

Function    D_grd_GotoFirstSel(d_grd:TDBGrid):boolean;
var
   DataSet:TdataSet;
   strFirst:String;
begin
 Result:=False;
 DataSet:=d_grd.DataSource.DataSet;

 if   (DataSet=nil)  or not DataSet.Active  or  (d_grd.SelectedRows.Count <1 )
 then Exit;
 strFirst:=d_grd.SelectedRows.Items[0];
 DataSet.DisableControls;
 DataSet.First;

 While not Dataset.eof   do
   if DataSet.Bookmark=StrFirst  then
   begin
      Result:=True ;
      break;
   end
   else
      DataSet.Next;

  DataSet.EnableControls;



end;




Function    D_grd_ClearFit;
var
   iCount,iTotal,iStep:integer;
   DataSet:TdataSet;
begin
 Result:=-1;
 DataSet:=d_grd.DataSource.DataSet;
 if   (DataSet=nil)
    or not DataSet.Active
    or(SkipField='')
    or(DataSet.FindField(SkipField)=nil)then Exit;
 DataSet.DisableControls;

 DataSet.First;
 iTotal:=d_grd.SelectedRows.Count;
 iCount:=0;
 While not Dataset.eof  and (iTotal >iCount)   do
  begin
   if d_grd.SelectedRows.Find(DataSet.Bookmark,iStep) then
   begin
     for iStep:=low(_Values) to high(_Values) do
      if  CompareText(DataSet.FieldByName(SkipField).AsString,_Values[iStep])=0  then
        d_grd.SelectedRows.CurrentRowSelected :=False;
     inc(iCount);
   end;

     DataSet.Next;
   end;
 DataSet.EnableControls;
 Result:=d_grd.SelectedRows.Count ;
end;

Function    D_grd_ClearNoFit;
var
  iCount,itotal,iStep:integer;
   DataSet:TdataSet;
begin
 Result:=-1;
 DataSet:=d_grd.DataSource.DataSet;
 if   (DataSet=nil)
    or not DataSet.Active
    or(SkipField='')
    or(DataSet.FindField(SkipField)=nil)then Exit;
 DataSet.DisableControls;


  iTotal:=d_grd.SelectedRows.Count;
  iCount:=0;


 DataSet.First;
 While not Dataset.eof and (itotal>iCount)   do
  begin
   if d_grd.SelectedRows.Find(DataSet.Bookmark,iStep) then
   begin
     for iStep:=low(_Values) to high(_Values) do
       if  CompareText(DataSet.FieldByName(SkipField).AsString,_Values[iStep])<>0  then
          d_grd.SelectedRows.CurrentRowSelected :=False;
      inc(iCount);
    end;
     DataSet.Next;
    end;
 DataSet.EnableControls;
 Result:=d_grd.SelectedRows.Count ;
end;


Function  D_grd_BuildStr;
var
   strTmp:String;
   iSelectRow:integer;
   DataSet:TdataSet;
   itotal,iCount:integer;
begin
 Result:='';
 DataSet:=d_grd.DataSource.DataSet;
 if (DataSet=nil)
     or not DataSet.Active
     or  (DataSet.FindField(FieldName)=nil)
     then Exit;
 DataSet.DisableControls;
 iCount:=0;
 itotal:=d_grd.SelectedRows.Count;
 Dataset.First;
 While not Dataset.eof   and (itotal>iCount) do
  begin
  if d_grd.SelectedRows.Find(DataSet.Bookmark,iSelectRow) then
   begin
        if strTmp='' then
          strTmp:=DataSet.fieldByName(FieldName).Text
        else
          strTmp:=strTmp+','+DataSet.fieldByName(FieldName).Text;
      inc(iCount);
    end;
   DataSet.Next;
 end;
 DataSet.EnableControls;
 Result:=strTmp;
end;



Function    D_grd_GotoFirstSel_(d_grd:TDBGrid_):boolean;
var
   DataSet:TdataSet;
   strFirst:String;
begin
 Result:=False;
 DataSet:=d_grd.DataSource.DataSet;

 if   (DataSet=nil)  or not DataSet.Active  or  (d_grd.SelectedRows.Count <1 )
 then Exit;
 strFirst:=d_grd.SelectedRows.Items[0];
 //DataSet.DisableControls;
 DataSet.First;

 While not Dataset.eof   do
   if DataSet.Bookmark=StrFirst  then
   begin
      Result:=True ;
      break;
   end
   else
      DataSet.Next;

//  DataSet.EnableControls;



end;




Function    D_grd_ClearFit_;
var
   iCount,iTotal,iStep:integer;
   DataSet:TdataSet;
begin
 Result:=-1;
 DataSet:=d_grd.DataSource.DataSet;
 if   (DataSet=nil)
    or not DataSet.Active
    or(SkipField='')
    or(DataSet.FindField(SkipField)=nil)then Exit;
 DataSet.DisableControls;

 DataSet.First;
 iTotal:=d_grd.SelectedRows.Count;
 iCount:=0;
 While not Dataset.eof  and (iTotal >iCount)   do
  begin
   if d_grd.SelectedRows.Find(DataSet.Bookmark,iStep) then
   begin
     for iStep:=low(_Values) to high(_Values) do
      if  CompareText(DataSet.FieldByName(SkipField).AsString,_Values[iStep])=0  then
        d_grd.SelectedRows.CurrentRowSelected :=False;
     inc(iCount);
   end;

     DataSet.Next;
   end;
 DataSet.EnableControls;
 Result:=d_grd.SelectedRows.Count ;
end;

Function    D_grd_ClearNoFit_;
var
  iCount,itotal,iStep:integer;
   DataSet:TdataSet;
begin
 Result:=-1;
 DataSet:=d_grd.DataSource.DataSet;
 if   (DataSet=nil)
    or not DataSet.Active
    or(SkipField='')
    or(DataSet.FindField(SkipField)=nil)then Exit;
 DataSet.DisableControls;


  iTotal:=d_grd.SelectedRows.Count;
  iCount:=0;


 DataSet.First;
 While not Dataset.eof and (itotal>iCount)   do
  begin
   if d_grd.SelectedRows.Find(DataSet.Bookmark,iStep) then
   begin
     for iStep:=low(_Values) to high(_Values) do
       if  CompareText(DataSet.FieldByName(SkipField).AsString,_Values[iStep])<>0  then
          d_grd.SelectedRows.CurrentRowSelected :=False;
      inc(iCount);
    end;
     DataSet.Next;
    end;
 DataSet.EnableControls;
 Result:=d_grd.SelectedRows.Count ;
end;


Function  D_grd_BuildStr_;
var
   strTmp:String;
   iSelectRow:integer;
   DataSet:TdataSet;
   itotal,iCount:integer;
begin
 Result:='';
 DataSet:=d_grd.DataSource.DataSet;
 if (DataSet=nil)
     or not DataSet.Active
     or  (DataSet.FindField(FieldName)=nil)
     then Exit;
 DataSet.DisableControls;
 iCount:=0;
 itotal:=d_grd.SelectedRows.Count;
 Dataset.First;
 While not Dataset.eof   and (itotal>iCount) do
  begin
  if d_grd.SelectedRows.Find(DataSet.Bookmark,iSelectRow) then
   begin
        if strTmp='' then
          strTmp:=DataSet.fieldByName(FieldName).Text
        else
          strTmp:=strTmp+';'+DataSet.fieldByName(FieldName).Text;
      inc(iCount);    
    end;
   DataSet.Next;
 end;
 DataSet.EnableControls;
 Result:=strTmp;
end;

function Select_Dir(const Caption: string; const Root: WideString;
  out Directory: string;Form:Tform): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: dword;
begin
  Result := False;
  Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      SHGetDesktopFolder(IDesktopFolder);
      IDesktopFolder.ParseDisplayName(Form.Handle, nil,
        POleStr(Root), Eaten, RootItemIDList, Flags);
      with BrowseInfo do
      begin
        hwndOwner := Form.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        //ulFlags := BIF_BROWSEINCLUDEFILES;
      end;
      ItemIDList := ShBrowseForFolder(BrowseInfo);
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

function HasAttr(const FileName: string; Attr: Word): Boolean;
begin
  Result := (FileGetAttr(FileName) and Attr) = Attr;
end;

function Fill_Char(s_Str : String; n_len : Integer; s_Char : String) : String;
Var
   li_Index : integer;
   ls_Str : String;
Begin
     ls_Str := s_Str;

     if Length(ls_Str) <> n_Len Then
        For li_Index := 1 To n_len - Length(ls_Str) Do
           ls_Str := s_Char + ls_Str;

     Result := ls_Str;
End;

procedure CopyFile(const FileName, DestName: TFileName);
var
  CopyBuffer: Pointer; { buffer for copying }
  BytesCopied: Longint;
  Source, Dest: Integer; { handles }
  Destination: TFileName; { holder for expanded destination name }
const
  ChunkSize: Longint = 8192; { copy in 8K chunks }
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
  if HasAttr(Destination, faDirectory) then { if destination is a directory... }
    Destination := Destination + '\' + ExtractFileName(FileName); { ...clone file name }
  GetMem(CopyBuffer, ChunkSize); { allocate the buffer }
  try
    Source := FileOpen(FileName, fmShareDenyWrite); { open source file }
    if Source < 0 then raise EFOpenError.CreateFmt('File %s Open Error', [FileName]);
    try
      Dest := FileCreate(Destination); { create output file; overwrite existing }
      if Dest < 0 then raise EFCreateError.CreateFmt('File %s Create Error', [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize); { read chunk }
          if BytesCopied > 0 then { if we read anything... }
            FileWrite(Dest, CopyBuffer^, BytesCopied); { ...write chunk }
        until BytesCopied < ChunkSize; { until we run out of chunks }
      finally
        FileClose(Dest); { close the destination file }
      end;
    finally
      FileClose(Source); { close the source file }
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize); { free the buffer }
  end;
end;

Procedure Refresh_Table(as_Year,as_Month,as_table : String);
Const
   StrSql = 'Select Count(*) from %s where Rpt_yyyy = ''%s'' and rpt_mm = ''%s''';
   StrDel = 'Delete From %s where Rpt_yyyy = ''%s'' and rpt_mm = ''%s''';
Begin
   if Query_Value('sfscmis',Format(StrSql,[as_Table,as_year,as_Month])) <> 0 Then
      if Application.messageBox('当月数据存在，是否重新生成','报表',MB_YESNO) = IDYES Then
      BEGIN
         Query_Exec('sfscmis',Format(StrDel,[as_Table,as_year,as_Month]));
         Query_Exec('sfscmis','Commit');
     eND;
End;

procedure ComboBoxAdd(ComboBox1: TCustomComboBox; Query1: TQuery);
var
  s: String;
  i: integer;
begin
  //将查询结果加入组合框列表
  ComboBox1.Clear;
  with Query1 do
    begin
      if not IsEmpty then
        begin
          First;
          while not EOF do
            begin
              s:=Fields[0].AsString;
              for i:=1 to FieldCount-1 do
                s:=s+' '+Fields[i].AsString;
              ComboBox1.Items.Add(s);
              Next;
            end;
        end;
    end;
end;

function Move_Point(const extended: extended; move_num:integer):extended;
var
   value,new_value :string;
   i,j :integer;
begin
  if move_num=0 then
  begin
     result:=extended;
     exit;
  end;
  value:=floattostr(extended);
  i:=pos('.',value);
  if move_num>0 then
  begin
    if i=0 then
       for j:=1 to move_num do
           value:=value+'0'
    else begin
       new_value:=StringReplace(value,'.','',[rfReplaceAll]);
       if move_num+i>=length(value) then
       begin
          for j:=1 to move_num+i-length(value) do
            new_value:=new_value+'0';
          value:=new_value;
       end
       else begin
          value:=copy(new_value,1,i+move_num-1)+'.'+copy(new_value,i+move_num,length(new_value)+1-i-move_num);
       end;
    end;
  end;
  result:=strtofloat(value);
end;

function Roundi(const Extended: extended):int64;
var i:integer;
begin
  //i:= trunc(Extended*10) mod 10;
  i:=trunc(Move_Point(Extended,1)) mod 10;
  if (i>=-4) and (i<=4) then
//     result:=trunc(extended)
     result:=trunc(strtofloat(floattostr(extended)))
  else
     if extended>0 then
        result:=trunc(strtofloat(floattostr(extended))) + 1
     else
        result:=trunc(strtofloat(floattostr(extended))) - 1;
end;

Function rounds(Extended: extended; i:integer):extended;
var j:integer;
begin
     if i > 0 then
     begin
	for j:=0 to i do
	   extended:=extended*10;
	extended:=roundi(extended);
	for j:=0 to i do
	   extended:=extended/10;
     end
     else if i < 0 then
     begin
	for j:=2 to -i do
	   extended:=extended/10;
	extended:=roundi(extended);
	for j:=2 to -i do
	   extended:=extended*10;
     end;
     result:=extended  ;
end;

Function Next_acc_ym(acc_ym :string) :String;
var m:string;
begin
  if copy(acc_ym,5,2)='12' then
     result:=inttostr(strtoint(copy(acc_ym,1,4))+1)+'01'
  else begin
     m:=inttostr(strtoint(copy(acc_ym,5,2))+1);
     if length(m)=1 then
        m:='0'+m;
     result:=copy(acc_ym,1,4)+m;
  end;
end;

function last_day(month_date:string) :String;
var
  Query1:TQuery;
begin
     Query1:=TQuery.Create(Application);
     Query1.DatabaseName := 'SfscMis';
     Query1.Sql.Add('select last_day(to_date('''+month_date+''',''yyyy-mm-dd'')) from dual');
     try
        Query1.Prepare;
        Query1.open;
     except
        result:='';
        Query1.Free;
        Exit;
     end;
    Result:=query1.Fields[0].AsString;
    Query1.Free;
end;

function FindProcess(AFileName: string): boolean;
var
  hSnapshot: THandle;//用于获得进程列表
  lppe: TProcessEntry32;//用于查找进程
  Found: Boolean;//用于判断进程遍历是否完成
  KillHandle: THandle;//用于杀死进程
begin
  Result :=False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);//获得系统进程列表
  lppe.dwSize := SizeOf(TProcessEntry32);//在调用Process32First API之前，需要初始化lppe记录的大小
  Found := Process32First(hSnapshot, lppe);//将进程列表的第一个进程信息读入ppe记录中
  while Found do
  begin
    if ((UpperCase(ExtractFileName(lppe.szExeFile))=UpperCase(AFileName)) or (UpperCase(lppe.szExeFile )=UpperCase(AFileName))) then
    begin
      {if MsShow('发现打开Excel,是否将其关闭?',2)=6 then
      begin
      //由于我的操作系统是xp，所以在调用TerminateProcess API之前
      //我必须先获得关闭进程的权限,如果操作系统是NT以下可以直接中止进程
      KillHandle := OpenProcess(PROCESS_TERMINATE, False, lppe.th32ProcessID);
      TerminateProcess(KillHandle, 0);//强制关闭进程
      CloseHandle(KillHandle);
      end;}
      Result :=True;
    end;
    Found := Process32Next(hSnapshot, lppe);//将进程列表的下一个进程信息读入lppe记录中
  end;
end;

function lpad(const str :string; const strlength:integer; const c: string):string;
var s :string;
    i :integer;
begin
  s:=str;
  for i:=1 to strlength-length(str) do
  begin
    s:=c+s;
  end;
  result:=s;
end;

function rpad(const str :string; const strlength:integer; const c: string):string;
var s :string;
    i :integer;
begin
  s:=str;
  for i:=1 to strlength-length(str) do
  begin
    s:=s+c;
  end;
  result:=s;
end;
function GetIdSex(id: string): integer;
var
  sex_char: string;
  sex_int: integer;
begin
  case length(id) of
    15: sex_char:=copy(id, 15, 1);
    18: sex_char:=copy(id, 17, 1);
  end;
  try
    sex_int:=StrToInt(sex_char);
    if Odd(sex_int) then
      Result:=1
    else
      Result:=2;
  except
    on EConvertError do
      Result:=0;
  end;
end;
function Power(base:integer;p:integer):integer;
var i:integer;
begin
  try
    result:=1;
    for i:=1 to p do
      result:=result*base;
  except
    result:=0;
  end;
end;
function GetIdBirthday(id: string): string;
var
  sBirth: string;
  yyyy, mm, dd: variant;
begin
  case length(id) of
    15: sBirth:='19'+copy(id, 7, 6);
    18: sBirth:=copy(id, 7, 8);
  end;
  yyyy:=copy(sBirth, 1, 4);
  mm:=copy(sBirth, 5, 2);
  dd:=copy(sBirth, 7, 2);
  try
    sBirth:=DateToStr(EncodeDate(yyyy, mm, dd));
    Result:=sBirth;
  except
    on EConvertError do Result:='';
  end;
end;

function CheckIDbit(id:string):boolean;
var
  i,j,k:integer;
begin
  try
    if length(id)=18 then
       i:=17
    else
       i:=15;
    for j:=1 to i do
       if (copy(id,j,1)<'0') or (copy(id,j,1)>'9') then
       begin
         result:=false;
         exit;
       end;
    result:=true;
  except
    on EConvertError do Result:=false;
  end;
end;

function CheckIDLastBit(id:string):boolean;
var
  i,num:integer;
  code:string;
begin
  try
  num:=0;
  for i:=18 downto 2 do
  begin
    num:= num+(power(2,i-1) mod 11) * strtoint(copy(id,19 - i,1));
  end;
  num:=num mod 11;
  case num of
    0:code:='1';
    1:code:='0';
    2:code:='X';
    3:code:='9';
    4:code:='8';
    5:code:='7';
    6:code:='6';
    7:code:='5';
    8:code:='4';
    9:code:='3';
    10:code:='2';
  end;
  result:=(code=copy(id,18,1));
  except
    result:=false;
  end;
end;
function IsIdValid(id: string; id_type: integer): string;
const
  ID_LENGTH = [15, 18];
  INVALID_ID_LENGTH = '身份证必须为15位或18位';
  INVALID_ID_SEX = '身份证性别位必须是数字';
  INVALID_ID_BIRTHDAY = '无效出生日期';
  INVALID_ID_Validbit = '身份证含有无效字符';
  INVALID_ID_Lastbit = '无效身份证校验位';
begin
  case id_type of
    1: begin     //id
         if not (length(Id) in ID_LENGTH) then     //id length error
           begin
             Result:=INVALID_ID_LENGTH;
             Exit;
           end;

         if GetIdSex(id) = 0 then     //id sex error
           begin
             Result:=INVALID_ID_SEX;
             Exit;
           end;

         if GetIdBirthday(id) = '' then   //id birthday error
           begin
             Result:=INVALID_ID_BIRTHDAY;
             Exit;
	   end;

         if not checkidbit(id) then
           begin
             Result:=INVALID_ID_Validbit;
             Exit;
           end;
         if (length(Id)=18) and (not CheckIDLastbit(id)) then
           begin
             Result:=INVALID_ID_Lastbit;
             Exit;
           end;
       end;
    2: Begin   //passport
       End;
    3: begin     //other
             if  (length(Id) in ID_LENGTH) then
              Begin
		   Result := '身份证为15位或18位时证件类别必须为身份证！';
                   Exit;
              End;
       end;
  end;
  Result:='';
end;

function SplitString(const Source, ch: string): TStringList;
var
  temp: string;
  i: Integer;
begin
  Result := TStringList.Create;
  //如果是空自符串则返回空列表
  if Source = ''
    then exit;
  temp := Source;
  i := pos(ch, Source);
  while i <> 0 do
  begin
    Result.add(copy(temp, 0, i - 1));
    Delete(temp, 1, i);
    i := pos(ch, temp);
  end;
  Result.add(temp);
end;

function ImportIntoTemp(importInfo: TImportInfo): string;
var
  excelApp,workBook,sheet,cityNo: Variant;
  strSql, strBatchNo, fieldValue, strIFields, strIValues, strUSet, strWhereClause, strUpdateFlag: String;
  strPK, strUpdate, strUpdateDtl, strImport, strImportDtl: TStringList;
  i, row, valueRow, successCount, sheetNo, sheetStartNo, sheetCount: Integer;
  qry_rpt_param,qry_temp: TQuery;
  LastRow, LastCol: Integer;
  Data: Variant;

  procedure FreeParam;
  begin
    strPK.Free;
    strUpdate.Free;
    strUpdateDtl.Free;
    strImport.Free;
    strImportDtl.Free;

    qry_temp.Free;
    qry_rpt_param.Free;

    if not VarIsEmpty(ExcelApp) then
    begin
      ExcelApp.Quit;
      ExcelApp := Unassigned;
    end;
  end;
begin
  //取出导入格式参数
  strSql := 'SELECT a.import_table, a.import_pk, a.batch_no_field, nvl(a.if_sheet,''0'') if_sheet,'
            + ' a.sheet_row_count, a.sheet_no, a.batch_no_seq, b.*'
            + ' FROM sfsc.sd_accfund_report a, sfsc.sd_accfund_report_dtl b'
            + ' WHERE a.city_no = ''' + importInfo.CityNo + ''''
            + '   AND a.rpt_sno = ' + IntToStr(importInfo.RptSno)
            + '   AND a.io_type = ''i'''
            + '   AND a.city_no = b.city_no'
            + '   AND a.rpt_sno = b.rpt_sno';
  qry_rpt_param := TQuery.Create(Application);
  qry_rpt_param.DataBaseName := 'sfscmis';
  Query_Open(qry_rpt_param, strSql);

  if qry_rpt_param.RecordCount = 0 then
  begin
    result := '【' + importInfo.FileName + '】导入失败，未维护对应的格式参数';
    Exit;
  end;

  strPK := TStringList.Create;
  strUpdate := TStringList.Create;
  strUpdateDtl := TStringList.Create;
  strImport := TStringList.Create;
  strImportDtl := TStringList.Create;

  qry_temp := TQuery.Create(Application);
  qry_temp.DataBaseName := 'sfscmis';

  DmMain.DbMain.StartTransaction;
  try
    //打开导入文件
    ExcelApp := CreateOleObject('Excel.Application');
    WorkBook := CreateOleobject('Excel.Sheet');
    WorkBook := ExcelApp.workBooks.Open(importInfo.FileName);

    //对于importPattern为3、4的，将配置表中的PK信息初始化进strUpdate
    if (importInfo.ImportPattern = '3') or (importInfo.ImportPattern = '4') then
    begin
      if trim(qry_rpt_param.FieldByName('import_pk').AsString) = '' then
      begin
        DmMain.DbMain.Rollback;
        result := '【' + importInfo.FileName + '】导入失败，未配置导入表对应的PK';
        FreeParam;
        Exit;
      end;

      strPK := SplitString(trim(qry_rpt_param.FieldByName('import_pk').AsString), ';');
      strUpdate.Clear;
      for i := 0 to strPK.Count - 1 do
      begin
        strSql := 'SELECT b.* FROM sfsc.sd_accfund_report a, sfsc.sd_accfund_report_dtl b'
                + ' WHERE a.city_no = ''' + importInfo.CityNo + ''''
                + '   AND a.rpt_sno = ' + IntToStr(importInfo.RptSno)
                + '   AND a.io_type = ''i'''
                + '   AND a.city_no = b.city_no'
                + '   AND a.rpt_sno = b.rpt_sno'
                + '   AND b.field_name = ''' + strPK.Strings[i] + '''';
        Query_Open(qry_temp, strSql);

        if qry_temp.FieldByName('column_no').AsString = '' then
        begin
          DmMain.DbMain.Rollback;
          result := '【' + importInfo.FileName + '】导入失败，导入表对应PK配置有误';
          FreeParam;
          Exit;
        end;

        strUpdate.Add(strPK.Strings[i]
                      + ';' + trim(qry_temp.FieldByName('column_no').AsString)
                      + ';' + trim(qry_temp.FieldByName('data_format').AsString)
                      + ';' + trim(qry_temp.FieldByName('trunc_param').AsString)
                      + ';' + trim(qry_temp.FieldByName('row_no').AsString)
                      + ';' + trim(qry_temp.FieldByName('is_fix').AsString)
                      + ';' + trim(qry_temp.FieldByName('seq_name').AsString));
      end;
    end;

    //将配置表中的插入或更新信息初始化进strImport
    strImport.Clear;
    while not qry_rpt_param.Eof do
    begin
      strImport.Add(trim(qry_rpt_param.FieldByName('field_name').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('column_no').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('data_format').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('trunc_param').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('row_no').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('is_fix').AsString)
                    + ';' + trim(qry_rpt_param.FieldByName('seq_name').AsString));

      qry_rpt_param.Next;
    end;

    //对于需要插入批次的，取最大批次+1作为本次批次
    if importInfo.IfBatchNo = '1' then
    begin
      if qry_rpt_param.FieldByName('batch_no_field').AsString <> '' then
      begin
        if qry_rpt_param.FieldByName('batch_no_seq').AsString <> '' then
        begin
          strSql := 'select ' + qry_rpt_param.FieldByName('batch_no_seq').AsString + '.NextVal batch_no'
                 + ' from dual';
        end
        else
        begin
          strSql := 'select nvl(max(' + qry_rpt_param.FieldByName('batch_no_field').AsString + '),0) + 1 batch_no'
                 + ' from ' + qry_rpt_param.FieldByName('import_table').AsString;
        end;
      end;

      if (not Query_Open(qry_temp,strSql))
        or (qry_rpt_param.FieldByName('batch_no_field').AsString = '') then
      begin
        DmMain.DbMain.Rollback;
        result := '【' + importInfo.FileName + '】导入失败，批号字段配置有误';
        FreeParam;
        Exit;
      end;
      strBatchNo := qry_temp.FieldByName('batch_no').AsString;
    end
    else strBatchNo := '';

    //对于importPattern为2的，先清理数据
    if importInfo.ImportPattern = '2' then
    begin
      try
        with qry_temp do
        begin
          Close;
          Sql.Text := 'delete ' + qry_rpt_param.FieldByName('import_table').AsString
                   + ' where 1=1 ';
          if trim(importInfo.DeleteClause) <> '' then
          begin
            Sql.Text := Sql.Text + 'and ' + trim(importInfo.DeleteClause);
          end;
          ExecSQL;
          Close;
        end;
      except
        DmMain.DbMain.Rollback;
        result := '【' + importInfo.FileName + '】导入失败，清除数据失败';
        FreeParam;
        Exit;
      end;
    end;

    //插入或更新数据
    qry_rpt_param.First;
    successCount := 0;

    //初始化sheet数
    if qry_rpt_param.FieldByName('if_sheet').AsString = '1' then
    begin
      if qry_rpt_param.FieldByName('sheet_no').AsString = '*' then
      begin
        sheetCount := WorkBook.WorkSheets.Count;
        sheetStartNo := 1;
      end
      else
        try
          sheetCount := qry_rpt_param.FieldByName('sheet_no').AsInteger;
          sheetStartNo := sheetCount;
        except
          DmMain.DbMain.Rollback;
          result := '【' + importInfo.FileName + '】导入失败，sheet参数维护有误';
          FreeParam;
          Exit;
        end;
    end
    else
    begin
      sheetCount := 1;
      sheetStartNo := 1;
    end;

    for sheetNo := sheetStartNo to sheetCount do
    begin
      row := qry_rpt_param.FieldByName('row_no').AsInteger + 1;

      //1. 用 End(xlUp) 找最后一行（准确）
      //LastRow := WorkBook.WorkSheets[sheetNo].Cells[WorkBook.WorkSheets[sheetNo].Rows.Count, 1].End(-4162).Row;
      LastRow := WorkBook.WorkSheets[sheetNo].UsedRange.Rows.Count;

      //2. 用 UsedRange.Columns.Count 找列数（快）
      LastCol := WorkBook.WorkSheets[sheetNo].UsedRange.Columns.Count;

      //3. 一次性读取
      Data := WorkBook.WorkSheets[sheetNo].Range[WorkBook.WorkSheets[sheetNo].Cells[1, 1],WorkBook.WorkSheets[sheetNo].Cells[LastRow, LastCol]].Value;

      while (row <= LastRow) and (trim(Data[row,1]) <> '') and (trim(Data[row,1]) <> '合计：')
        and ((qry_rpt_param.FieldByName('if_sheet').AsString = '1')
              and ((qry_rpt_param.FieldByName('sheet_row_count').AsString = '')
                   or (row <= qry_rpt_param.FieldByName('sheet_row_count').AsInteger + qry_rpt_param.FieldByName('row_no').AsInteger))
             or (qry_rpt_param.FieldByName('if_sheet').AsString = '0')) do
      begin
        //将要插入或更新的字段和值取到strFields，strValues，以便后续拼SQL
        strIFields := '';
        strIValues := '';
        strUSet := '';
        for i := 0 to strImport.Count - 1 do
        begin
          strImportDtl := SplitString(strImport.Strings[i], ';');

          strIFields := strIFields + strImportDtl.Strings[0] + ',';
          try
            //对于配置了sequence的，则FieldValue即为sequence的
            if strImportDtl.Strings[6] <> '' then
            begin
              strIValues := strIValues + strImportDtl.Strings[6] + '.NextVal'
                         + ',';
              strUSet := strUSet + strImportDtl.Strings[0] + ' = '
                      + strImportDtl.Strings[6] + '.NextVal'
                      + ',';
            end
            //将标签名作为FieldValue
            else if StrToInt(strImportDtl.Strings[1]) = 0 then
            begin
              strIValues := strIValues + GetImpValue(trim(WorkBook.ActiveSheet.Name),
                         strImportDtl.Strings[2],
                         strImportDtl.Strings[3])
                         + ',';
              strUSet := strUSet + strImportDtl.Strings[0] + ' = '
                      + GetImpValue(trim(WorkBook.ActiveSheet.Name),
                      strImportDtl.Strings[2],
                      strImportDtl.Strings[3])
                      + ',';
            end
            //将文件名作为FieldValue
            else if StrToInt(strImportDtl.Strings[1]) = -1 then
            begin
              strIValues := strIValues + GetImpValue(trim(Copy(importInfo.FileName,
                         LastDelimiter('\', importInfo.FileName) + 1,
                         LastDelimiter('.', importInfo.FileName) - LastDelimiter('\', importInfo.FileName) - 1)),
                         strImportDtl.Strings[2],
                         strImportDtl.Strings[3])
                         + ',';
              strUSet := strUSet + strImportDtl.Strings[0] + ' = '
                      + GetImpValue(trim(Copy(importInfo.FileName,
                      LastDelimiter('\', importInfo.FileName) + 1,
                      LastDelimiter('.', importInfo.FileName) - LastDelimiter('\', importInfo.FileName) - 1)),
                      strImportDtl.Strings[2],
                      strImportDtl.Strings[3])
                      + ',';
            end
            //将对应文件单元格值作为FieldValue
            else
            begin
              //固定单元格内容的，单元格行号为参数表中的固定行号
              if strImportDtl.Strings[5] = '1' then
                valueRow := StrToInt(strImportDtl.Strings[4])
              //非固定单元格内容，单元格行号为当前行号
              else
                valueRow := row;

              strIValues := strIValues + GetImpValue(trim(Data[valueRow,StrToInt(strImportDtl.Strings[1])]),
                         strImportDtl.Strings[2],
                         strImportDtl.Strings[3])
                         + ',';
              strUSet := strUSet + strImportDtl.Strings[0] + ' = '
                      + GetImpValue(trim(Data[valueRow,StrToInt(strImportDtl.Strings[1])]),
                      strImportDtl.Strings[2],
                      strImportDtl.Strings[3])
                      + ',';
            end;
          except
            DmMain.DbMain.Rollback;
            result := '【' + importInfo.FileName + '】导入失败，第' + IntToStr(sheetNo) + '个sheet的第' + IntToStr(row) + '行转换导入文件信息出错';
            FreeParam;
            Exit;
          end;
        end;
        strIFields := Copy(strIFields, 1, Length(strIFields) - 1);
        strIValues := Copy(strIValues, 1, Length(strIValues) - 1);
        strUSet := Copy(strUSet, 1, Length(strUSet) - 1);

        //对于importPattern为3、4的，需要按pk更新记录
        if (importInfo.ImportPattern = '3') or (importInfo.ImportPattern = '4') then
        begin
          try
            strUpdateFlag := '0';

            with undmmain.dmmain do
            begin
              strSql := 'select * from ' + qry_rpt_param.FieldByName('import_table').AsString
                     + ' where 1=1 ';
              if importInfo.SfscCode<>'' then
                strWhereClause := ' and sfsc_code='+QuotedStr(importInfo.SfscCode)
              else
                strWhereClause := '';
                
              for i := 0 to strUpdate.Count - 1 do
              begin
                strUpdateDtl := SplitString(strUpdate.Strings[i], ';');

                //将标签名作为FieldValue
                if StrToInt(strUpdateDtl.Strings[1]) = 0 then
                begin
                  strWhereClause := strWhereClause + ' and ' + strUpdateDtl.Strings[0] + ' = '
                                 + GetImpValue(trim(WorkBook.ActiveSheet.Name),
                                               strUpdateDtl.Strings[2],
                                               strUpdateDtl.Strings[3]);
                end
                //将文件名作为FieldValue
                else if StrToInt(strUpdateDtl.Strings[1]) = -1 then
                begin
                  strWhereClause := strWhereClause + ' and ' + strUpdateDtl.Strings[0] + ' = '
                                 + GetImpValue(trim(Copy(importInfo.FileName,
                                               LastDelimiter('\', importInfo.FileName) + 1,
                                               LastDelimiter('.', importInfo.FileName) - LastDelimiter('\', importInfo.FileName) - 1)),
                                               strUpdateDtl.Strings[2],
                                               strUpdateDtl.Strings[3]);
                end
                //将对应文件单元格值作为FieldValue
                else
                begin
                  //固定单元格内容的，单元格行号为参数表中的固定行号
                  if strUpdateDtl.Strings[5] = '1' then
                    valueRow := StrToInt(strUpdateDtl.Strings[4])
                  //非固定单元格内容，单元格行号为当前行号
                  else
                    valueRow := row;

                  strWhereClause := strWhereClause + ' and ' + strUpdateDtl.Strings[0] + ' = '
                                 + GetImpValue(trim(Data[valueRow,StrToInt(strUpdateDtl.Strings[1])]),
                                               strUpdateDtl.Strings[2],
                                               strUpdateDtl.Strings[3]);
                end;
              end;
              Query_Open(qrtemp, strSql + strWhereClause);

              if qrtemp.RecordCount > 0 then
              begin
                if strBatchNo <> '' then
                begin
                  strUSet := strUSet + ',' + qry_rpt_param.FieldByName('batch_no_field').AsString
                          + ' = ' + strBatchNo;
                end;

                with qrtemp do
                begin
                  Close;
                  Sql.Text := 'update ' + qry_rpt_param.FieldByName('import_table').AsString
                           + ' set ' + strUSet
                           + ' where 1=1 ' + strWhereClause;
                  ExecSQL;
                  Inc(successCount);
                  Close;
                end;
                strUpdateFlag := '1';
              end;
            end;
          except
            DmMain.DbMain.Rollback;
            result := '【' + importInfo.FileName + '】导入失败，第' + IntToStr(sheetNo) + '个sheet的第' + IntToStr(row) + '行更新记录失败';
            FreeParam;
            Exit;
          end;
        end;

        //对于importPattern为1、2、3的，需要插入记录
        if (importInfo.ImportPattern = '1')
          or (importInfo.ImportPattern = '2')
          or (importInfo.ImportPattern = '3') and (strUpdateFlag = '0') then
        begin
          try
            with qry_temp do
            begin
              if strBatchNo <> '' then
              begin
                strIFields := strIFields + ',' + qry_rpt_param.FieldByName('batch_no_field').AsString;
                strIValues := strIValues + ',' + strBatchNo;
              end;
              if importInfo.SfscCode <> '' then
              begin
                strIFields := strIFields + ',sfsc_code';
                strIValues := strIValues + ',' + QuotedStr(importInfo.SfscCode);
              end;

              Close;
              Sql.Text := 'insert into ' + qry_rpt_param.FieldByName('import_table').AsString
                       + '(' + strIFields + ') values (' + strIValues + ')';
              ExecSQL;
              Inc(successCount);
              Close;
            end;
          except
            DmMain.DbMain.Rollback;
            result := '【' + importInfo.FileName + '】导入失败，第' + IntToStr(sheetNo) + '个sheet的第' + IntToStr(row) + '行插入记录失败';
            FreeParam;
            Exit;
          end;
        end;
        inc(row);
      end;
    end;

    {with undmmain.dmmain.qrtemp do
    begin
      close;
      sql.Text := 'commit';
      ExecSQL ;
    end;}
    DmMain.DbMain.Commit;
    FreeParam;
    result := 'DONE';

    result := result + ';' + IntToStr(successCount) + ';' + strBatchNo;
  except
    {with undmmain.dmmain.qrtemp do
    begin
      close;
      sql.Text := 'rollback';
      ExecSQL ;
    end;}
    DmMain.DbMain.Rollback;
    result := '【' + importInfo.FileName + '】导入失败，未知错误';
    FreeParam;
    Exit;
  end;
end;

function GetImpValue(strData, strFormat, strTruncParam: String): String;
var
  strResult: String;
  stlIndex: TStringList;
begin
  strResult := StringReplace(strData,'　','',[rfReplaceAll]);
  stlIndex := TStringList.Create;

  try
    if (strFormat = 'yyyymm')
      or (strFormat = 'yyyymmdd')
      or (strFormat = 'yyyy-mm-dd') then
    begin
      result := 'to_date(''' + strResult + ''', ''' + strFormat + ''')';
    end
    else if strFormat = 'string' then
    begin
      if strTruncParam = '' then
        result := '''' + Trim(strResult) + ''''
      else
      begin
        stlIndex := SplitString(strTruncParam, ',');
        result := '''' + Trim(Copy(strData, StrToInt(stlIndex.Strings[0]), StrToInt(stlIndex.Strings[1]))) + '''';
      end;
    end
    else if strFormat = 'number' then
    begin
      if (strResult ='') then
        strResult := '0';
      result := strResult;
    end
    else if strFormat = 'number*100' then
    begin
      result := FloatToStr(StrToFloat(strResult)*100);
    end
    else result := 'null';
  except
    result := 'null';
  end;
end;

function InsertOptLog(logInfo: TLogInfo):Boolean;
var
  strSql, strFields, strValues: String;
begin
  if logInfo.BizType <> '' then
  begin
    strFields := strFields + 'biz_type,';
    strValues := strValues + '''' + logInfo.BizType + ''',';
  end;
  if logInfo.ProcType <> '' then
  begin
    strFields := strFields + 'proc_type,';
    strValues := strValues + '''' + logInfo.ProcType + ''',';
  end;
  if logInfo.LogType <> '' then
  begin
    strFields := strFields + 'log_type,';
    strValues := strValues + '''' + logInfo.LogType + ''',';
  end;
  if logInfo.CompanyAccount <> '' then
  begin
    strFields := strFields + 'company_account,';
    strValues := strValues + '''' + logInfo.CompanyAccount + ''',';
  end;
  if logInfo.EmpAccount <> '' then
  begin
    strFields := strFields + 'emp_account,';
    strValues := strValues + '''' + logInfo.EmpAccount + ''',';
  end;
  if logInfo.AccYm <> '' then
  begin
    strFields := strFields + 'acc_ym,';
    strValues := strValues + '''' + logInfo.AccYm + ''',';
  end;
  if logInfo.ChangeType <> '' then
  begin
    strFields := strFields + 'change_type,';
    strValues := strValues + '''' + logInfo.ChangeType + ''',';
  end;
  if logInfo.EmpNo <> '' then
  begin
    strFields := strFields + 'emp_no,';
    strValues := strValues + '''' + logInfo.EmpNo + ''',';
  end;
  if logInfo.Name <> '' then
  begin
    strFields := strFields + 'name,';
    strValues := strValues + '''' + logInfo.Name + ''',';
  end;
  if logInfo.ErrMsg <> '' then
  begin
    strFields := strFields + 'err_msg,';
    strValues := strValues + '''' + logInfo.ErrMsg + ''',';
  end;

  strSql := 'insert into wf_operation_log ('
         + strFields + 'create_person, create_date,sfsc_code,batch_no)'
         + ' values (' + strValues + '''' + GetCurUser.User_id + ''',sysdate,'
         + ''''+GetCurUser.Sfsc_code+''','
         + IntToStr(logInfo.BatchNo) + ')';
  Query_Exec('sfscmis', strSql);
end;

procedure CreateFolder;
begin
   //创建文件夹,如果d盘下的sfsc文件夹中没有公积金报表文件夹，则新增该文件夹
   if not DirectoryExists(accfundreportroute) then
    CreateDirectory(accfundreportroute,nil);
end;

procedure CreateComboBoxList(var Qry:TQuery; ComboBox:TCustomComboBox; FieldName,FilterStr:string);
var
  FieldNameStr: string;
begin
  with Qry do
  begin
    ComboBox.Items.Clear;
    First;
    while not EOF do
    begin
      FieldNameStr := FieldByName(FieldName).AsString;
      if (AnsiPos(FilterStr,FieldNameStr)>0) or (FilterStr = '') then
        ComboBox.Items.Add(FieldByName(FieldName).AsString);
      Next;
    end;
  end;
end;

procedure SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);
var
 I, TextLen: Longint;
 lf: LOGFONT;
 f: HFONT;
begin
  if Width < ComboBox.Width then
  begin
    FillChar(lf,SizeOf(lf),0);
    StrPCopy(lf.lfFaceName, ComboBox.Font.Name);
    lf.lfHeight := ComboBox.Font.Height;
    lf.lfWeight := FW_NORMAL;
    if fsBold in ComboBox.Font.Style then
      lf.lfWeight := lf.lfWeight or FW_BOLD;

    f := CreateFontIndirect(lf);
    if (f <> 0) then
    begin
      try
        ComboBox.Canvas.Handle := GetDC(ComboBox.Handle);
        SelectObject(ComboBox.Canvas.Handle,f);
        try
          for I := 0 to ComboBox.Items.Count -1 do
          begin
            TextLen := ComboBox.Canvas.TextWidth(ComboBox.Items[I]);
            if TextLen > Width then
              Width := TextLen;
          end;
          (* Standard ComboBox drawing is Rect.Left + 2,
          adding the extra spacing offsets this *)
          Inc(Width, GetSystemMetrics(SM_CYVTHUMB) +
            GetSystemMetrics(SM_CXVSCROLL));
        finally
          ReleaseDC(ComboBox.Handle, ComboBox.Canvas.Handle);
        end;
      finally
        DeleteObject(f);
      end;
    end;
  end;
  SendMessage(ComboBox.Handle, CB_SETDROPPEDWIDTH, Width, 0);
end;

function IsEpay2:boolean;
var qryTemp : TQuery;
begin
  Result:=false;;
  qryTemp:=TQuery.Create(Application);
  try
    with qryTemp do
    begin
      DatabaseName:='SFSCMIS';
      SQL.Text:='select * from wf_epay_config where rownum=1';
      Open;
      Result:=Not Eof;
    end;
  finally
    qryTemp.Free;
  end;
end;

function IsSameCompany(const company_no1, company_no2: string): boolean;
var qryTemp: TQuery;
begin
  Result := false; ;
  qryTemp := TQuery.Create(Application);
  try
    with qryTemp do
    begin
      DatabaseName := 'SFSCMIS';
      SQL.Text := 'select sfsc.wf_public.IsSameCompany(''' + company_no1 + ''',''' + company_no2 + ''') from dual';
      Open;
      Result := Fields[0].AsInteger = 1;
    end;
  finally
    qryTemp.Free;
  end;
end;

function Get_Emp_No(const kind: integer; const value, company_no, comp_grp_no, acc_ym: string): string; //根据传入值取电脑号
var
  s, emp_no, sqlselect: string;
  qryTemp2: TQuery;
begin
  s := StringReplace(value, ' ', '', [rfReplaceAll]);
  emp_no := '';
  if pos(' ', s) > 0 then s := copy(s, 1, pos(' ', s) - 1);
  qryTemp2 := TQuery.Create(Application);
  qryTemp2.DatabaseName := 'SFSCMIS';
  case kind of
    0: //姓名
      begin
        sqlselect := 'select GET_EMP_BY_COMPANY(''' + s + ''',''' + company_no + ''',''' + acc_ym + ''') from dual';
        query_open(qryTemp2, sqlselect);
        if qryTemp2.Fields[0].isnull then
        else
          emp_no := qryTemp2.Fields[0].asstring;
      end;
    1: //电脑号
      begin
        emp_no := s;
      end;
    2: //身份证号
      begin
        sqlselect := 'select emp_no from fs_humbas where emp_no is not null and id=get_id_15(''' + Uppercase(s) + ''') or id=get_id_18(''' + uppercase(s) + ''') and merge_mark=0';
        query_open(qryTemp2, sqlselect);
        if qryTemp2.Eof then
        else
          emp_no := qryTemp2.Fields[0].asstring;
      end;
    3: //客户工号
      begin
        if company_no<>'' then
           sqlselect:='select distinct a.emp_no from fs_humbas a,fs_comp_org_emp b where a.emp_no=b.emp_no and b.in_no='''+s+''' and b.company_no='''+company_no+''''
        else
           sqlselect:='select distinct a.emp_no from fs_humbas a,fs_comp_org_emp b,fs_client c where b.company_no=c.company_no and a.emp_no=b.emp_no and b.in_no='''+s+''' and c.comp_grp_code='''+comp_grp_no+'''';
        query_open(qryTemp2,sqlselect);
      if qryTemp2.RecordCount=1 then emp_no:=qryTemp2.Fields[0].asstring;
      end;
  end;
  qryTemp2.Free;
  result := emp_no;
end;

function Lock_Payroll_Resource(const acc_ym, company_no, user_id: string; const kind: integer): string; //加锁解锁资源
var
  spLock: TStoredProc;
begin
  spLock := TStoredProc.Create(Application);
  try
    try
      with spLock do
      begin
        DatabaseName := 'sfscmis';
        StoredProcName := 'PROC_LOCK_PAYROLL_RESOURCE';
        Prepare;
        ParamByName('si_acc_ym').AsString := acc_ym;
        ParamByName('si_company_no').AsString := company_no;
        ParamByName('si_user_id').AsString := user_Id;
        ParamByName('ni_kind').AsInteger := kind;
        ExecProc;
        result := ParamByName('so_msg').AsString;
      end;
    except
      result := '加锁解锁时发生错误';
    end;
  finally
    spLock.Free;
  end;
end;

function Lock_Attend_Resource(const acc_ym, company_no, user_id: string; const kind: integer): string; //加锁解锁资源
var
  spLock: TStoredProc;
begin
  spLock := TStoredProc.Create(Application);
  try
    try
      with spLock do
      begin
        DatabaseName := 'sfscmis';
        StoredProcName := 'PROC_LOCK_ATTEND_RESOURCE';
        Prepare;
        ParamByName('si_acc_ym').AsString := acc_ym;
        ParamByName('si_company_no').AsString := company_no;
        ParamByName('si_user_id').AsString := user_Id;
        ParamByName('ni_kind').AsInteger := kind;
        ExecProc;
        result := ParamByName('so_msg').AsString;
      end;
    except
      result := '加锁解锁时发生错误';
    end;
  finally
    spLock.Free;
  end;
end;

function IsValidGroup(const user_id, company_no: string): boolean;
var qryTemp: TQuery;
begin
  Result := false; ;
  qryTemp := TQuery.Create(Application);
  try
    with qryTemp do
    begin
      DatabaseName := 'SFSCMIS';
      SQL.Text := 'select sfsc.wf_public.IsValidGroup(''' + user_id + ''',''' + company_no + ''') from dual';
      Open;
      Result := Fields[0].AsInteger = 1;
    end;
  finally
    qryTemp.Free;
  end;
end;

function Lock_Resource(const acc_ym: string; const company_no: string; const op_type: string; const user_id: string): string;
var
  spLock: TStoredProc;
begin
  spLock := TStoredProc.Create(Application);
  try
    with spLock do
    begin
      DatabaseName := 'sfscmis';
      StoredProcName := 'PROC_LOCK_RESOURCE';
      Prepare;
      ParamByName('si_acc_ym').asstring := acc_ym;
      ParamByName('si_company_no').asstring := company_no;
      ParamByName('si_op_type').asstring := op_type;
      ParamByName('si_operator').asstring := user_id;
      ExecProc;
      if ParamByName('io_success').asinteger = 1 then
      begin
        result := '0';
      end
      else begin
        result := ParamByName('So_failure_desc').asstring;
      end;
    end;
  finally
    spLock.Free;
  end;
end;

function Unlock_Resource(const acc_ym: string; const company_no: string; const op_type: string; const user_id: string): string;
var
  spUnlock: TStoredProc;
begin
  spUnlock := TStoredProc.Create(Application);
  try
    with spUnlock do
    begin
      DatabaseName := 'sfscmis';
      StoredProcName := 'PROC_UNLOCK_RESOURCE';
      Prepare;
      ParamByName('si_acc_ym').asstring := acc_ym;
      ParamByName('si_company_no').asstring := company_no;
      ParamByName('si_operator').asstring := user_id;
      ParamByName('si_op_type').asstring := op_type;
      ExecProc;
      if ParamByName('io_success').asinteger = 1 then
      begin
        result := '0';
      end
      else begin
        result := ParamByName('So_failure_desc').asstring;
      end;
    end;
  finally
    spUnlock.Free;
  end;
end;

procedure CopyGridEhDataToExcel(Args: array of const);
var
  iCount, jCount, kCount: Integer;
  XLApp: Variant;
  Sheet: Variant;
  I: Integer;
begin
  //  Screen.Cursor := crHourGlass;
  if not VarIsEmpty(XLApp) then
  begin
    XLApp.DisplayAlerts := False;
    XLApp.Quit;
    VarClear(XLApp);
  end;

  try
    XLApp := CreateOleObject('Excel.Application');
  except
    Screen.Cursor := crDefault;
    Exit;
  end;

  XLApp.WorkBooks.Add;
  XLApp.SheetsInNewWorkbook := High(Args) + 1;

  for I := Low(Args) to High(Args) do
  begin

    XLApp.WorkBooks[1].WorkSheets[I + 1].Name := TDBGridEh(Args[I].VObject).Name;
    Sheet := XLApp.Workbooks[1].WorkSheets[TDBGridEh(Args[I].VObject).Name];

    if not TDBGridEh(Args[I].VObject).DataSource.DataSet.Active then
    begin
      Screen.Cursor := crDefault;
      Exit;
    end;

    TDBGridEh(Args[I].VObject).DataSource.DataSet.first;
    kCount := 0;
    for iCount := 0 to TDBGridEh(Args[I].VObject).Columns.Count - 1 do
    begin
      if TDBGridEh(Args[I].VObject).Columns[icount].visible then
      begin
        inc(kCount);
        Sheet.Cells[1, kCount] := TDBGridEh(Args[I].VObject).Columns.Items[iCount].Title.Caption;
      end;
    end;

    jCount := 1;
    while not TDBGridEh(Args[I].VObject).DataSource.DataSet.Eof do
    begin
      kCount := 0;
      for iCount := 0 to TDBGridEh(Args[I].VObject).Columns.Count - 1 do
      begin
        if TDBGridEh(Args[I].VObject).Columns[icount].visible then
        begin
          inc(kCount);
          Sheet.Cells[jCount + 1, kCount].NumberFormatLocal := '@';
          Sheet.Cells[jCount + 1, kCount] := TDBGridEh(Args[I].VObject).Columns.Items[iCount].Field.AsString;
        end;
      end;

      Inc(jCount);
      TDBGridEh(Args[I].VObject).DataSource.DataSet.Next;
    end;
    XlApp.Visible := True;
  end;
  Screen.Cursor := crDefault;
end;

function WriteFile(filename, content: string): boolean;
const
  msg1 = '写文件“%s”时出错。';
var
  F: TextFile;
begin
  try
    AssignFile(F, filename);
    Rewrite(F);
    Write(F, content);
    CloseFile(F);
    Result := True;
  except
    ShowBox(format(msg1, [filename]));
    Result := False;
  end;
end;

procedure InitDropDownSfscCode(combobox:TDBComboBoxEh);
const
  sfscCodeSql='select a.sfsc_code, a.sfsc_code||'' | ''||a.org_name sfsc_name' +
  '  from sfsc.fs_org a, sfsc.fs_usr_org b' +
  ' where a.sfsc_code = b.sfsc_code' +
  '   and a.tree_grade = 1' +
  '   and a.sfsc_code in (''91520900MAD955MQ2P'',''91520115MADH25K16W'',''91520115666982151H'')' +
  '   and b.user_id = ''%s''';
begin
  if not Assigned(combobox) then
    Exit;
  with TQuery.Create(Application) do
  try
    DatabaseName:='SfscMis';
    SQL.Text:=Format(sfscCodeSql,['0116']);
    Close;
    Open;

    combobox.Clear;
    combobox.KeyItems.Clear;
    combobox.Items.Clear;
    First;
    while not Eof do
    begin
      combobox.KeyItems.Add(VarToStr(FieldValues['sfsc_code']));
      combobox.Items.Add(VarToStr(FieldValues['sfsc_name']));
      Next;
    end;
      //取消初始化的默认值 zhuxl 2016-09-18
//    //账套下拉框默认选择当前用户所选的账套
//    combobox.ItemIndex:=combobox.KeyItems.IndexOf(GetCurUser.Sfsc_code);
  finally
    Free;
  end;
end;

function GetCompanyAccount(combobox:TDBComboBoxEh;radio:TRadioGroup):string;
var strSql:string;
begin
    if vartostr(combobox.Value)='' then
   begin
   strSql := 'select company_account,'
           + ' company_account || '' '' || company_name account_name'
           + ' from wf_accfundb_company a'
           + ' where first_flag = ''1'' AND (invalid_date IS NULL OR invalid_date > acc_ym)'
           + ' and sfsc_code in (select sfsc_code from  sfsc.fs_usr_org where user_id='''+GetCurUser.User_Id+''')';

           if  Assigned(radio) then
           begin
              if radio.ItemIndex = 0 then
              begin
                strSql := strSql + ' and comp_type = ''1''';
              end
              else
              begin
                strSql := strSql + ' and comp_type = ''0''';
              end;
           end;
           strSql := strSql+ ' order by company_account';

   end
   else
   begin
   strSql := 'select company_account,'
           + ' company_account || '' '' || company_name account_name'
           + ' from wf_accfundb_company'
           + ' where first_flag = ''1'' AND (invalid_date IS NULL OR invalid_date > acc_ym)'
           + ' and sfsc_code = ''' + vartostr(combobox.Value) + '''';
           if  Assigned(radio) then
           begin
              if radio.ItemIndex = 0 then
              begin
                strSql := strSql + ' and comp_type = ''1''';
              end
              else
              begin
                strSql := strSql + ' and comp_type = ''0''';
              end;
           end;
           strSql := strSql+ ' order by company_account';
   end;
   result:=strSql;
end;

//add by zhanyq in 20161101 公积金所有查询SQL增加该语句，用于实现账套号权限
function GetSfscCodeSql(const sfsc_code: string):string;
var strSql:string;
begin
    if sfsc_code = '' then
     begin
       strSql := ' and exists(select 1 from  sfsc.fs_usr_org where sfsc_code=a.sfsc_code and user_id='''+GetCurUser.User_Id+''') ';
     end
     else
     begin
       strSql := ' and a.sfsc_code = ''' + sfsc_code + '''';
     end;
    result:=strSql;
end;

end.

