////////////////////////
// 外服公司公用程序  //
//  QLF             ///
//  2000/12         ///
///////////////////////
unit unpub_sfsc;
interface
uses
  //Forms ,  DBTables,dbgrids,controls,Messages;
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Db, DBTables, DBCGrids, Mask, DBCtrls, Grids, DBGrids,
  ExtCtrls,ComObj;
  //把string格式为（yyyymm）的月份进行增量计算
  Function add_date(date:string;i:integer):string;
  Function Read_sysdate :String;
  Function Check_date(checked_date : String):integer;
  // 检查总帐与明细帐的数据apply_fee 是否一致，并获取明细记录数
  Function Check_data(Query_total,Query_detail : Tquery; detail_count :Integer) : integer;
  Function Set_detailsno(query_total,query_detail : Tquery;sno :String;check_mark :string):Integer;
  type
    Raccfundparam = record
                  acc_ym : String;
                  proc_flag : integer;
    end ;
  Function Get_accfundcurym(accfund_type : Integer; open_type : Integer; company_account: String):Raccfundparam;
  Function Get_curym:STRING;//取当前财务年月
  function IsTableExist(table_name: string): boolean;
  function QueryValue(str: string): variant;
  function CreateExcelApplication(IsVisible: boolean; Var Excel, WorkSheet,WorkBook : Variant; S_template:String): boolean;
  function rounds(Extended: real; i:integer):real;//四舍五入函数
  function Roundi(const Extended: extended):integer; //四舍五入到整数

  procedure SrcToDes(Src, Des: TListBox);        //列表项目单项移动
  procedure SrcAllToDes(Src, Des: TListBox);     //列表项目全体移动

implementation
uses unfrmLogin;
const  DB_name = 'sfscmis';

function Roundi(const Extended: extended):integer;
begin
  if (trunc(Extended*10) mod 10) in [0,1,2,3,4] then
     result:=trunc(extended)
  else
     result:=trunc(extended) + 1;
end;

Function rounds(Extended: real; i:integer):real;
var j:integer;
begin
     if i>0 then
     begin
        for j:=1 to i do
           extended:=extended*10;
        extended:=roundI(extended);
        for j:=1 to i do
           extended:=extended/10;
     end
     else if i<0 then
     begin
        for j:=1 to i do
           extended:=extended/10;
        extended:=roundI(extended);
        for j:=1 to i do
           extended:=extended*10;
     end
     ELSE
        extended:=roundI(extended);
     result:=extended  ;
end;

Function add_date(date:string;i:integer):string;
Var
   qry_date :Tquery;
begin
     qry_date := Tquery.Create(Application);
     try
         with qry_date do
         begin
                 DataBaseName := db_name;
          //if not prepare then prepare;
                 sql.clear;
                 sql.add('select to_char(add_months(to_date('''+date+''',''yyyymm''),'+inttostr(i)+'),''yyyymm'') from dual');
                 open;
                 first;
                 result := Fields[0].AsString;
                 close;
             end;
     finally
            qry_date.free;
     end;
end;

Function read_sysdate:String;
Var
   qry_date :Tquery;
begin
          qry_date := Tquery.Create(Application);
      try
            with qry_date do
             begin
                 if Active then
                    Close;
                 DataBaseName := db_name;
          //if not prepare then prepare;
                 sql.clear;
                 sql.add('select to_char(sysdate,''yyyy/mm/dd'') from dual');
                 open;
                 first;
                 result := Fields[0].AsString;
                 close;
             end;
     finally
            qry_date.free;
     end;
end;

Function   Check_date(checked_date : String):integer;
Var
   D_date : TDateTime;
Begin
     Try
        D_date := StrToDate(Checked_date);
        result := 1;
     Except
           On EConvertError do
           begin
              Result := -1;
           end;
     ENd;
End;


Function  Check_data(Query_total,Query_detail : Tquery; detail_count :Integer) : integer;
Var
   apply_Fee  : Variant;
   total_applyfee : Variant;
begin
     apply_Fee := 0;
     Result := 1;
     Detail_count :=0;
     With query_detail do
    // With qry_medical_detail do
     begin
          First;
          While not Eof do
          begin
                apply_fee := apply_Fee + FieldValues['apply_fee'];
                Detail_count := Detail_count +1;
                Next;
          end;
     end;

     // 总帐与明细是否相等

     //with qry_medical do
     With query_total do
     begin
          total_applyfee :=  FieldBYName('Apply_sum').AsFloat;
          if FormatFloat('0.00',apply_Fee) <> FormatFloat('0.00',total_applyfee)  then
          begin
             Result := -3;
          end;
     end;
end;

Function Set_detailsno(query_total,query_detail : Tquery; sno :String;check_mark:string ):Integer;
begin
     Result := 0;
     with query_detail do
     begin
          first;
          while not eof do
          begin
               result := result +1;
               Edit;
               FieldValues['rcv_sno'] := sno;
               FieldValues['EMP_NO'] := query_total.FieldValues['EMP_NO'];
               FieldValues['Proc_mark'] := check_mark;
               next;
          end;
     end;
end;

 // 获得公积金办理的帐务年月及是否能够进行处理
  // accfund_type : 1 = 基本公积金 else 补充公积金  open_type = 1 非独立开户 else 独立开户
 Function Get_accfundcurym(accfund_type : integer; open_type : Integer; company_account: String):Raccfundparam;
  Var
     qry_temp : Tquery;
  begin
       qry_temp := Tquery.Create(nil);
       With qry_temp do
       Begin
             Databasename :='SFSCMIS';
             if accfund_type = 1 then // 基本
                 Sql.Add('select * from sd_accfund_param where type = 1 and sfsc_code='''+GetCurUser.Sfsc_code+'''')
             else     // 补充
                 Sql.Add('Select * from sd_accfund_param where type = 2 and sfsc_code='''+GetCurUser.Sfsc_code+'''');
             Open;
             if RecordCount > 0  then
             Begin

                  if open_type = 1 then
                  begin  //非独立
                     if company_account = '' then
                       Result.acc_ym := FieldByname('acc_ym').AsString;
                     Result.proc_flag := FieldByName('proc_flag').Asinteger;
                  end
                  else
                  begin  //独立
                     if company_account = '' then
                       Result.acc_ym := FieldByName('acc_ymindept').AsString;
                     Result.proc_flag := FieldByName('proc_flagindept').Asinteger;
                  end;

                  if company_account <> '' then
                  begin
                    Sql.Clear;
                    Sql.Add(PChar('select  acc_ym from wf_accfundb_company where (invalid_date IS NULL OR invalid_date >acc_ym ) and  first_flag = ''1'' and company_account = ''' + company_account + ''''));
                    Open;
                    if RecordCount > 0  then
                    begin
                      Result.acc_ym := FieldByname('acc_ym').AsString;
                    end
                    else Result.acc_ym := '';
                  end;
             end{
             else
                 Result.acc_ym := ''};
       End;
       qry_temp.Free;
  end;

 Function Get_curym:STRING;
  Var
     qry_temp : Tquery;
  begin
       qry_temp := Tquery.Create(nil);
       With qry_temp do
       Begin
             Databasename :='SFSCMIS';
             Sql.Add('select TO_CHAR(ACC_YM,''YYYYMM'') from FS_FINCSYS');
             Open;
             if RecordCount > 0  then
                Result := FieldS[0].AsString
             else
                 Result := '';
       End;
       qry_temp.Free;
  end;

// 调集高程序 (养老金)
function IsTableExist(table_name: string): boolean;
const
  s = 'select count(*) from user_tables where table_name = upper(''%s'')';
begin
  result:=vartostr(QueryValue(format(s, [table_name]))) <> '0';
end;


// 调集高程序 (养老金)
function QueryValue(str: string): variant;
var
  query1: TQuery;
begin
  query1:=TQuery.Create(nil);
  query1.Databasename:='SFSCMIS';
  query1.SQL.Add(str);
  try
    query1.Open;
    result:=query1.Fields[0].value;
  except
  end;
  query1.Close;
  query1.Free;
end;

function CreateExcelApplication(IsVisible: boolean; Var Excel, WorkSheet,WorkBook : Variant; S_template:String): boolean;
Begin

{  Try
    Excel.WorkBooks[1].Close(SaveChanges:=False);
  Except
    Excel := CreateOleObject('Excel.Application')
  End;

  Excel.WorkBooks.Open(g_Enviroment_Param.s_Template);
  Excel.Visible := False;
  Excel.Caption := is_Template_Title;}
    try
      excel:= CreateOleObject('excel.application');
    except
      on EOleSysError do
        begin
          Application.MessageBox('没有安装EXCEL','信息提示',MB_OK);
          Result:=False;
          Exit;
        end;
    end;
    WorkBook:=excel.WorkBooks.Add;
    WorkSheet:=WorkBook.WorkSheets.Item[1];
    if S_template<>'' then
        Excel.WorkBooks.Open(s_template)
    else
        Excel.WorkBooks.Open;

  if IsVisible then
      excel.Visible:=True;
  Result:=True;
End;

procedure SrcToDes(Src, Des: TListBox);
var
  i: integer;
begin
  if Src.Items.Count = 0 then
    Exit;

  if Src.SelCount = 0 then
    Src.Selected[0]:=True;

  //add items to Des
  for i:=0 to Src.Items.Count-1 do
    begin
      if Src.Selected[i] then
        Des.Items.Add(Src.Items.Strings[i]);
    end;

  //delete items from Src
  for i:=Src.Items.Count-1 downto 0 do
    begin
      if Src.Selected[i] then
        Src.Items.Delete(i);
    end;
end;

procedure SrcAllToDes(Src, Des: TListBox);
var
  i: integer;
begin
  if Src.Items.Count = 0 then
    Exit;

  for i:=0 to Src.Items.Count-1 do
    Des.Items.Add(Src.Items.Strings[i]);

  Src.Items.Clear;
end;

end.
