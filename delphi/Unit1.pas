unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, DBTables, StdCtrls, Buttons, FolderDialog, DBGridEh,
  Mask, DBCtrlsEh, DBLookupEh, DBCtrls, ComCtrls, dxGDIPlusClasses, ActiveX;
//示例form名：FrmFeedBackImport
  type TImportType = (iptFile=0,iptFolder=1); //导入类型： 0 文件，1 文件夹
  type TImportMode = (ipmAdd=0,ipmCover=1,ipmInsertOrUpdate=2);   //导入模式： 0 增量导入（追加），1 覆盖导入（先删除再导入）
  type TImport=(imptBegin=0,imptEnd=1);
  type
    TImportExcelProc = procedure;
    TImportProc=procedure(oepAcc:string) of object;

  type
    TImportThread = class(TThread)
  private
    FProgress: Integer;
    FStatus: string;
    procedure UpdateUI;
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

type
  TForm1 = class(TForm)
    pnl1: TPanel;
    qry_temp: TQuery;
    dlgOpenPath: TOpenDialog;
    fldrdlgReturnData: TFolderDialog;
    qryAddress: TQuery;
    dsAddress: TDataSource;
    btnExport: TButton;
    dsCode: TDataSource;
    qryCode: TQuery;
    grp4: TGroupBox;
    lbl3: TLabel;
    btnBrowse: TBitBtn;
    edtScBilling: TEdit;
    StatusBar1: TStatusBar;
    btnRoll: TButton;
    Label1: TLabel;
    edtHrallyBilling: TEdit;
    BitBtn1: TBitBtn;
    btnImport: TButton;
    btnImportThread: TButton;
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRollClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnImportThreadClick(Sender: TObject);
  private
    { Private declarations }
    g_batchNoLog:Integer;
    v_successCount:Integer;
    g_city_no:string;
    g_importMode:TImportMode;
    loginPhrase,niumaPhrase:array of string;
    procedure ParseReturnOepAcc(rpt_no:Integer;oep_acc:string);
    procedure FlushExpBtn;
  public
    { Public declarations }
    Import_Sno,s_acc_ym_sc,s_acc_ym_hrally:string;
    dblkAddr:string;//投保地点
    Max_Batch_No:Integer;//批号
    procedure RecordImportDate(importType:TImport);
    function FileInUse(FileName:string): Boolean;
    function ImportFeedbackData(filePath,dataType:string;importType:TImportType):Boolean;
    function GetCondition(sql_sno,condition_sno:string):string;
    procedure WriteImportLog(si_rptSno:Integer; si_logType, si_bizType,
      si_oepAcc,si_errMsg: string);
  end;

var
  Form1: TForm1;
  BeforeImportData:TImportExcelProc; //导入之前的处理
  AfterImportData:TImportExcelProc;  //导入之后的处理

implementation
    uses
        unLib,unDmMain,UnCommanBas,ComObj;

{$R *.dfm}

{procedure TForm1.btn10Click(Sender: TObject);
var
  s_sql :string;
  s:Integer;
  i,row:Integer;
  excelApp,workBook,sheet: Variant;
begin
    s_sql := 'update sfsc.imp_oep_real_dec set id = upper(trim(id))';
    Query_Exec('SfscMis',s_sql);
    s_sql := 'update sfsc.imp_oep_real_dec a' +
              ' set (reg_no,emp_no) = (' +
              ' select reg_no,emp_no from sfsc.fs_humbas' +
              ' where id = a.id)' +
              ' where emp_no is null' +
              ' and exists (' +
              ' select 1 from sfsc.fs_humbas' +
              ' where id = a.id)';
    Query_Exec('SfscMis',s_sql);
    s_sql := 'update sfsc.imp_oep_real_dec a' +
              ' set (reg_no,emp_no) = (' +
              ' select reg_no,emp_no from sfsc.fs_humbas' +
              ' where id = sfsc.get_id_15(a.id))' +
              ' where emp_no is null' +
              ' and exists (' +
              ' select 1 from sfsc.fs_humbas' +
              ' where id = sfsc.get_id_15(a.id))';
    Query_Exec('SfscMis',s_sql);
    s_sql := 'update sfsc.imp_oep_real_dec a' +
              ' set (reg_no,emp_no) = (' +
              ' select reg_no,emp_no from sfsc.fs_humbas' +
              ' where id = sfsc.get_id_18(a.id))' +
              ' where emp_no is null' +
              ' and exists (' +
              ' select 1 from sfsc.fs_humbas' +
              ' where id = sfsc.get_id_18(a.id))';
    Query_Exec('SfscMis',s_sql);

    s := Query_Value('SfscMis','select count(*) from sfsc.imp_oep_real_dec where emp_no is null');
    if s=0 then
      ShowMessage('匹配完成！')
    else
    begin
      ShowMessage('仍有'+inttostr(s)+'条数据未匹配到电脑号！');
      Query_Open(qry_temp,'select t.oep_acc 单位社保号,t.id 身份证号,t.name 姓名,t.reg_no 人才号 from sfsc.imp_oep_real_dec t where t.emp_no is null');
      try
         excelApp := CreateOleObject('Excel.Application');
         excelApp.Visible := True;
         workBook := excelApp.WorkBooks.Add;
         sheet := workBook.Sheets[1];
         sheet.Name := 'Sheet1';
         row := 1;
         with qry_temp do
         begin
           for i := 1 to FieldCount do
           begin
             sheet.Cells[row,i] := Fields[i-1].FieldName;
             sheet.Columns[i].NumberFormatLocal := '@';
           end;
           Inc(row);
           while not Eof do
           begin
             for i := 1 to FieldCount do
             begin
               sheet.Cells[row,i] := Fields[i-1].Value;
             end;
             Inc(row);
             next;
           end;
           row := ExcelApp.ActiveSheet.UsedRange.Rows.Count;
           i := ExcelApp.ActiveSheet.UsedRange.Columns.Count;
           sheet.Range[sheet.cells[1,1],sheet.cells[1,i]].Font.Size:=11;
           sheet.Range[sheet.cells[1,1],sheet.cells[1,i]].Font.Name:='黑体';
           sheet.Range[sheet.cells[1,1],sheet.cells[1,i]].Font.Bold:=True;
           sheet.Range[sheet.cells[1,1],sheet.cells[1,i]].Interior.Color := clGray;
           sheet.Range[sheet.cells[1,1],sheet.cells[1,i]].HorizontalAlignment:=3;
           sheet.Range[sheet.cells[1,1],sheet.cells[row,i]].Borders.LineStyle := 1;
           sheet.Range[sheet.cells[1,1],sheet.cells[row,i]].Columns.AutoFit;
         end;
       except
        Application.MessageBox('导出失败！','提示信息',MB_OK+MB_ICONINFORMATION);
        qry_temp.First;
        Exit;
       end;
    end;
end;}

procedure TForm1.btnImportClick(Sender: TObject);
var
  importType:TImportType;
  dataType:string;
  successCountSC, successCountHrally: Integer;
begin
  if (edtScBilling.Text = '') then
  begin
    ShowMessage('请先选择速创账单！');
    Exit;
  end;

  if (edtHrallyBilling.Text = '') then
  begin
    ShowMessage('请先选择聚合力账单！');
    Exit;
  end;

  try
    //导入速创账单
    dataType := 'SC';
    importType := iptFile;
    g_batchNoLog :=0;
    RecordImportDate(imptBegin);
    if ImportFeedbackData(edtScBilling.Text,dataType,importType) then
      successCountSC := v_successCount
    else
      successCountSC := 0;
    RecordImportDate(imptEnd);

    //导入聚合力账单
    dataType := 'Hrally';
    importType := iptFolder;
    g_batchNoLog :=0;
    RecordImportDate(imptBegin);
    if ImportFeedbackData(edtHrallyBilling.Text,dataType,importType) then
      successCountHrally := v_successCount
    else
      successCountHrally := 0;
    RecordImportDate(imptEnd);

    ShowMessage(Format('导入完成，共导入速创账单【%s】条记录，聚合力账单【%s】条记录！',[IntToStr(successCountSC), IntToStr(successCountHrally)]));
  except on e:Exception do
    begin
      ShowMessage(e.Message);
      RecordImportDate(imptEnd);
    end;
  end;

  FlushExpBtn;
end;

procedure TForm1.btnRollClick(Sender: TObject);
var
  i,n: Integer;
begin
  n := StrToInt(FormatDateTime('ss', Now)) mod 10;
  if n<=5 then n := n + 5;

  for i:=1 to n do
  begin
    Form1.Caption := '牛马对账助手' + '  -  ' + loginPhrase[Random(50)];
    Sleep(50);
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  try
    begin
      if fldrdlgReturnData.Execute then
        edtHrallyBilling.Text := fldrdlgReturnData.Directory;
    end;
  except on e:Exception do
    ShowMessage(e.Message);
  end;
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  try
    begin
      if dlgOpenPath.Execute then
        edtScBilling.Text := dlgOpenPath.FileName;
    end;
  except on e:Exception do
    ShowMessage(e.Message);
  end;
end;

procedure TForm1.btnExportClick(Sender: TObject);
Var
  s_sql,sheetName:array of string;
  i,row,s,max_s,i_recordCount:Integer;
  excelApp,workBook,tmpSheetName,WorkSheet: Variant;
  s_condition,s_condition1,s_acc_ym,s_statusBar: String;
begin
   max_s := 0;
   SetLength(s_sql,max_s+1);
   SetLength(sheetName,max_s+1);

   for s := 0 to max_s do
   begin
     s_sql[s] := Query_Value('SfscMis','select SQL_CONTENT from sfsc.imp_check_sql where SQL_SNO='+inttostr(max_s-s+1)+'');
     if s_sql[s] = '' then
     begin
        ShowWarning('数据库无配置，请检查配置！');
        Exit;
     end;

     if s=0 then
     begin
       s_acc_ym := s_acc_ym_sc;
       s_sql[s] := Format(s_sql[s],[s_acc_ym,s_acc_ym,s_acc_ym,s_acc_ym]);
       //s_sql[s] := s_sql[s] + s_condition;
       //s_sql[s] := s_sql[s] + GetCondition('3','1');
       sheetName[s] := '上海速创-聚合力对账_' + s_acc_ym;
     end;
   end;

   try
     excelApp := CreateOleObject('Excel.Application');
     excelApp.Visible := False;
     workBook := excelApp.WorkBooks.Add;
     for s := 0 to max_s do
     begin
       s_statusBar := '数据比对中~';
       StatusBar1.Panels[0].Text := s_statusBar;

       Query_Open(qry_temp,s_sql[s]);
       i_recordCount := qry_temp.RecordCount;
       if i_recordCount = 0 then
       begin
         ShowWarning('无数据可导出！');

         s_statusBar := '无数据可导出，so bad！';
         StatusBar1.Panels[0].Text := s_statusBar;

         Exit;
       end;

       {if s < 3 then
       begin
       tmpSheetName := ExcelApp.WorkSheets[s+1].Name;
       if tmpSheetName = ('Sheet'+inttostr(s+1)) then
           ExcelApp.WorkSheets['Sheet'+inttostr(s+1)].Delete;
       end;}
       if s > 0 then
         WorkSheet := ExcelApp.WorkSheets.Add //新建一个Sheet
       else WorkSheet := ExcelApp.WorkSheets['Sheet1'];
       //WorkSheet.Name := 'Sheet'+inttostr(s+1); //Sheet名称
       //ExcelApp.WorkSheets['Sheet'+inttostr(s+1)].Activate;
       row := 1;
       with qry_temp do
       begin
         WorkSheet.Name := sheetName[s];

         s_statusBar := '撰写标题中~';
         StatusBar1.Panels[0].Text := s_statusBar;
         Sleep(1000);

         for i := 1 to FieldCount do
         begin
           WorkSheet.Cells[row,i] := Fields[i-1].FieldName;
           WorkSheet.Columns[i].NumberFormatLocal := '@';
         end;
         Inc(row);

         while not Eof do
         begin
           for i := 1 to FieldCount do
           begin
             s_statusBar := '写入导出数据中：' + inttostr(row-1) + '/' + inttostr(i_recordCount);
             StatusBar1.Panels[0].Text := s_statusBar;
             WorkSheet.Cells[row,i] := Fields[i-1].Value;
           end;
           Inc(row);
           next;
         end;

         s_statusBar := '设置格式中~';
         StatusBar1.Panels[0].Text := s_statusBar;
         row := ExcelApp.ActiveSheet.UsedRange.Rows.Count;
         i := ExcelApp.ActiveSheet.UsedRange.Columns.Count;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[1,i]].Font.Size:=10;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[1,i]].Font.Name:='等线';
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[1,i]].Font.Bold:=True;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[1,i]].Interior.Color := clGray;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[1,i]].HorizontalAlignment:=3;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[row,i]].Borders.LineStyle := 1;
         WorkSheet.Range[WorkSheet.cells[1,1],WorkSheet.cells[row,i]].Columns.AutoFit;

         Sleep(1000);
       end;

       s_statusBar := 'wowowowowow，比对结果导出完毕！';
       StatusBar1.Panels[0].Text := s_statusBar;
     end;
   except
    Application.MessageBox('导出失败！','提示信息',MB_OK+MB_ICONINFORMATION);
    qry_temp.First;
    Exit;
   end;

   Application.MessageBox('导出成功！','提示信息',MB_OK+MB_ICONINFORMATION);
   workBook.SaveAs(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + '上海速创-聚合力对账_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx');
   excelApp.Visible := True;
end;

procedure TForm1.RecordImportDate(importType:TImport);
var
  strSql:string;
begin
  if not DmMain.DbMain.InTransaction then
    DmMain.DbMain.StartTransaction;
  try
    if importType=imptBegin then
      strSql := 'insert into sfsc.wf_temp values(''速创-聚合力对账数据导入开始'',sysdate)'
    else
      strSql := 'insert into sfsc.wf_temp values(''速创-聚合力对账数据导入结束'',sysdate)';
    Query_Exec('sfscMis',strsql);
    if DmMain.DbMain.InTransaction then
      DmMain.DbMain.Commit;
  except on e:Exception do
    begin
      if DmMain.DbMain.InTransaction then
        DmMain.DbMain.Rollback;
      ShowMessage(e.Message);
    end;
  end;
end;

function TForm1.FileInUse(FileName:string): Boolean;
var
  HFileRes: HFILE;
begin
  Result :=False;
  if FileExists(FileName) then
  begin
    HFileRes:=CreateFile(PChar(FileName),GENERIC_READ
      or GENERIC_WRITE,0, nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);
    Result:=(HFileRes=INVALID_HANDLE_VALUE);
    if not Result then
      CloseHandle(HFileRes);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetLength(loginPhrase, 50);
  SetLength(niumaPhrase, 50);

  loginPhrase[0] := '「你醒了，该上班了」';
  loginPhrase[1] := '「别看了，是工作日」';
  loginPhrase[2] := '「恭喜存活，又获得一天班」';
  loginPhrase[3] := '「系统检测到：你还没下班」';
  loginPhrase[4] := '「你今天也没有暴富，继续上班」';
  loginPhrase[5] := '「早啊，该为生活卖命了」';
  loginPhrase[6] := '「工位已就绪，请就位」';
  loginPhrase[7] := '「没事，我扛得住，我是牛马」';
  loginPhrase[8] := '「我不累，我只是活得很具体」';
  loginPhrase[9] := '「我不伟大，我只是一直在上班」';

  loginPhrase[10] := '「我是牛马，不是人，请直接下需求」';
  loginPhrase[11] := '「牛马无需理解，只需执行」';
  loginPhrase[12] := '「别问我意见，我只是个工位附件」';
  loginPhrase[13] := '「作为牛马，我的感受不在需求范围内」';
  loginPhrase[14] := '「牛马没有情绪，只有排期」';
  loginPhrase[15] := '「会议一开，马喽智商归零」';
  loginPhrase[16] := '「这个项目没问题，有问题的是我」';
  loginPhrase[17] := '「别问马喽怎么看，马喽只想下班」';
  loginPhrase[18] := '「牛马的极限，就是领导的起点」';
  loginPhrase[19] := '「牛马今天也在被“充分利用”」';

  loginPhrase[20] := '「马喽今天也在模仿人类上班」';
  loginPhrase[21] := '「马喽听不懂，但马喽点头」';
  loginPhrase[22] := '「马喽已读不回，因为已读不懂」';
  loginPhrase[23] := '「马喽一思考，会议就变长」';
  loginPhrase[24] := '「马喽不是摆烂，是失去希望」';
  loginPhrase[25] := '「马喽的沉默，是最后的体面」';
  loginPhrase[26] := '「马喽的工作状态：已麻」';
  loginPhrase[27] := '「马喽不配累，但马喽很累」';
  loginPhrase[28] := '「马喽的心死得很安详」';
  loginPhrase[29] := '「马喽只是笑了一下，灵魂已经裂开」';

  loginPhrase[30] := '「马喽只是坐在这里，事情就自己来了」';
  loginPhrase[31] := '「马喽还在这，说明昨天也挺过去了」';
  loginPhrase[32] := '「马喽的核心竞争力：还能来上班」';
  loginPhrase[33] := '「牛马最大的错觉：干完这波就轻松了」';
  loginPhrase[34] := '「努力不一定有回报，但一定有活」';
  loginPhrase[35] := '「我为公司付出了青春，公司让我成熟」';
  loginPhrase[36] := '「牛马今天也在为别人的目标燃烧自己」';
  loginPhrase[37] := '「尼采看了都要沉默三秒然后打卡」';
  loginPhrase[38] := '「世界是荒诞的，而我在其中做 Excel」';
  loginPhrase[39] := '「马喽不是摸鱼，是在和现实断联」';

  loginPhrase[40] := '「欢迎登录，本日精神损耗 +20%」';
  loginPhrase[41] := '「系统提示：你又要上一天班了」';
  loginPhrase[42] := '「牛马上线，尊严下线」';
  loginPhrase[43] := '「今日份人类体验即将结束」';
  loginPhrase[44] := '「你不是不行，是环境太行」';
  loginPhrase[45] := '「又是为公司奉献青春的一天」';
  loginPhrase[46] := '「上班不是选择，是轮回」';
  loginPhrase[47] := '「工位一坐，人生暂停」';
  loginPhrase[48] := '「你不干，有的是马喽干（包括你）」';
  loginPhrase[49] := '「别急，下班还在很远的未来」';

  Randomize;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  s_sql, s_acc_ym_sc, s_acc_ym_hrally: String;
begin
  Form1.Caption := '牛马对账助手' + '  -  ' + loginPhrase[Random(10)];

  FlushExpBtn;
end;

procedure TForm1.WriteImportLog(si_rptSno:Integer; si_logType, si_bizType,
  si_oepAcc,si_errMsg: string);
var
  v_logInfo:TLogInfo;
begin
  v_logInfo := TLogInfo.Create;
  try
    with v_logInfo do
    begin
      LogType := si_logType;
      BizType := si_bizType;
      CompanyAccount := si_oepAcc;
      AccYm :=VarToStr(Query_Value('sfscMis','select t.acc_ym from sfsc.sd_unitid t'
        +' where t.unit_code=' + QuotedStr(si_oepAcc)));
      BatchNo := g_batchNoLog;
      ErrMsg := StringReplace(si_errMsg,'''','',[rfReplaceAll]);
    end;
    InsertOptLog(v_logInfo);
  finally
    v_logInfo.Free;
  end;
end;

procedure TForm1.ParseReturnOepAcc(rpt_no:Integer;oep_acc: string);
var
  strdprcUpdateReturnData:TStoredProc;
  proc_flag:string;
begin
  strdprcUpdateReturnData:= TStoredProc.Create(Application);
  strdprcUpdateReturnData.DatabaseName := 'SfscMis';
  strdprcUpdateReturnData.StoredProcName := 'PKG_OEP.PROC_UPDATE_RETURN_OEPACC';
  try
    with  strdprcUpdateReturnData.Params do
    begin
      Clear;
      CreateParam(ftInteger,'ni_rpt_sno',ptInput).Value := rpt_no;
      CreateParam(ftString,'si_oep_acc',ptInput).Value := oep_acc;
      CreateParam(ftString,'so_result',ptOutput);
      strdprcUpdateReturnData.ExecProc;
      proc_flag := ParamByName('so_result').Value;
    end;
    if proc_flag<>'1' then
    begin
      Exception.Create(proc_flag);
      Exit;
    end;
  finally
    strdprcUpdateReturnData.Free;
  end;
end;

function TForm1.ImportFeedbackData(filePath,dataType:string;importType:TImportType):Boolean;
var
  v_fileFlag,v_rptSno:Integer;
  v_searchRec:TSearchRec;
  v_fileName,v_fileTypeName,v_tmpFileName,v_fileExt,v_oepAcc:string;
  v_ImportPattern,v_is_batch,v_cityNo,v_batchNo, s_statusBar:string;//导入模式
  v_batchNoList:TStringList;  //记录单位账号

   /// <summary>
  /// 赋值导入模式和是否生成批号
  /// </summary>
  procedure SetImportPatternAndIsBatch(si_importMode:TImportMode);
  begin
    if si_importMode = ipmAdd then //增量导入
    begin
      v_ImportPattern := '1';
      v_is_batch := '0';
    end else
    if si_importMode = ipmInsertOrUpdate then
    begin
      v_ImportPattern :='3';
    end
    else
    begin
      v_ImportPattern := '2';   //缺省值，导入模式，先删除后导入
      v_is_batch := '0';        //缺省值，是否记录批号
    end;
  end;
/// <summary>
  /// 调用公共导入接口（unLib.ImportIntoTemp）,导入回盘数据
  /// </summary>
  function ImportData(ni_rptSno:Integer;si_filePath,si_oepAcc,si_ImportPattern,si_IsBatch:string):Integer;
  var
    v_importInfo:TImportInfo;
    v_strResult,v_strFileName:string;
    v_resultList:TStringList;
  begin
    Result := 0;
    if FileInUse(v_fileName) then
    begin
      //WriteImportLog(v_rptSno,'1','oep',si_oepAcc,Format('【%s】文件正在使用中，请关闭该文件！',[si_filePath]));
      ShowMessage(Format('【%s】文件正在使用中，请关闭该文件！',[si_filePath]));
      Result := -1;
      Exit;
    end;

    try
      v_resultList:= TStringList.Create;
      v_importInfo := TImportInfo.Create;
      try
        with v_importInfo do
        begin
          RptSno := ni_rptSno;
          FileName := Trim(si_filePath);
          ImportPattern := si_ImportPattern;
          IfBatchNo := si_IsBatch;
          CityNo := v_cityNo;
        end;
        //导入核心逻辑
        v_strResult := ImportIntoTemp(v_importInfo);

        v_resultList.Delimiter := ';';
        v_resultList.DelimitedText := v_strResult;

        //如果返回结果是“Done”，说明导入成功
        if v_resultList.Count=1 then
        begin
          //WriteImportLog(ni_rptSno,'1','oep',si_oepAcc,v_strResult);
          ShowMessage('导入异常，请检查导入格式！');
        end
        else
        begin
          v_batchNo := v_resultList[2]; //Copy(v_strResult,LastDelimiter(';',v_strResult)+1,Length(v_strResult));
          {v_strFileName := ExtractFileName(si_filePath);
          if pos('_',v_strFileName)>0 then
            ParseReturnOepAcc(ni_rptSno,Copy(v_strFileName,1,LastDelimiter('.',v_strFileName)-1));}
          Result := StrToInt(v_resultList.Strings[1]);
        end;
        if v_batchNo='' then
            v_batchNo:='0';
      finally
        v_importInfo.Free;
        FreeAndNil(v_resultList);
      end;
    except on e:Exception do
      ShowMessage(e.Message);
    end;
  end;
begin
  Result := False;
  if Trim(filePath) = '' then
  begin
    ShowMessage('请先选择导入文件！');
    Exit;
  end;

    //导入之前的处理
  if @BeforeImportData<>nil then
    BeforeImportData;
    
  try
    v_ImportPattern := '2';   //缺省值，导入模式
    v_is_batch := '0';        //缺省值，是否记录批号
    v_successCount := 0;

    begin
      //按文件夹导入，遍历文件夹中所有的.xls文件，循环导入
      v_tmpFileName := filePath;
      if dataType = 'SC' then
      begin
        v_fileTypeName := '速创关联方账单';
        v_rptSno := 2025;
      end
      else if dataType = 'Hrally' then
      begin
        v_fileTypeName := '聚合力账单';
        v_rptSno := -2025;
      end;
      v_cityNo := '0002';

      if importType = iptFile then
      begin
        try
          v_fileName := v_tmpFileName;
          v_fileExt := ExtractFileExt(v_fileName);

          if (SameText(v_fileExt,'.xls'))
            or (SameText(v_fileExt,'.xlsx'))  then
          begin
            v_oepAcc := v_searchRec.Name;
            g_importMode := ipmCover;
            SetImportPatternAndIsBatch(g_importMode); //赋值导入模式和是否生成批号
            //导入数据
            s_statusBar := '正在导入' + v_fileTypeName + '，嘿咻嘿咻~';
            StatusBar1.Panels[0].Text := s_statusBar;

            v_successCount := v_successCount + ImportData(v_rptSno,v_fileName,v_oepAcc,v_ImportPattern,v_is_batch);

            s_statusBar := v_fileTypeName + '导入完毕！';
            StatusBar1.Panels[0].Text := s_statusBar;
          end;
        finally
          FindClose(v_searchRec);
        end;
      end
      else if importType = iptFolder then
      begin
        v_fileFlag := FindFirst(v_tmpFileName +'\*.*',faDirectory,v_searchRec);
        v_batchNoList := TStringList.Create;
        try
          while v_fileFlag = 0 do
          begin
            v_fileName := v_tmpFileName + '\' + v_searchRec.Name;
            v_fileExt := ExtractFileExt(v_fileName);

            if (SameText(v_fileExt,'.xls'))
              or (SameText(v_fileExt,'.xlsx'))  then
            begin
              v_oepAcc := v_searchRec.Name;

              if v_successCount = 0 then
                g_importMode := ipmCover
              else g_importMode := ipmAdd;
              SetImportPatternAndIsBatch(g_importMode); //赋值导入模式和是否生成批号

              //导入数据
              s_statusBar := '正在导入' + v_fileTypeName + '，嘿咻嘿咻~';
              StatusBar1.Panels[0].Text := s_statusBar;

              v_successCount := v_successCount + ImportData(v_rptSno,v_fileName,v_oepAcc,v_ImportPattern,v_is_batch);

              s_statusBar := v_fileTypeName + '导入完毕！';
              StatusBar1.Panels[0].Text := s_statusBar;

              v_batchNoList.add(v_batchNo);
            end;
            v_fileFlag := FindNext(v_searchRec);
          end;

        finally
          FindClose(v_searchRec);
          v_batchNoList.Free;
        end;
      end;
    end;

    //导入之后的处理
    if @AfterImportData<>nil then
      AfterImportData;

    Result := True;
    if v_successCount >=0 then
    begin
      s_statusBar := 'wowowowowow，速创关联方账单+聚合力账单导入完毕！';
      StatusBar1.Panels[0].Text := s_statusBar;
    end;
  except on e:Exception do
    begin
      //WriteImportLog(v_rptSno,'1','oep','发生异常：'+v_oepAcc,e.Message);
      ShowMessage('导入异常，报错信息：' + e.Message);
    end;
  end;
end;

function TForm1.GetCondition(sql_sno,condition_sno:string):string;
begin
    Result := Query_Value('sfscMis','select field_name from sfsc.imp_check_condition where sql_sno = '+sql_sno+' and condition_sno = '+condition_sno+'');
end;

procedure TForm1.FlushExpBtn;
var
  s_sql: String;
begin
  s_sql := 'select distinct acc_ym from sfsc.rcv_check_sc_rcv';
  s_acc_ym_sc := vartostr(Query_Value('SfscMis',s_sql));

  s_sql := 'select distinct acc_ym from sfsc.rcv_check_hrally_rcv';
  s_acc_ym_hrally := vartostr(Query_Value('SfscMis',s_sql));

  if (s_acc_ym_sc = '') or (s_acc_ym_hrally = '') then
  begin
    btnExport.Caption := '导出比对结果'+'（数据未导入）';
    btnExport.Enabled := False;
  end
  else if s_acc_ym_sc = s_acc_ym_hrally then
  begin
    btnExport.Caption := '导出比对结果'+'（'+s_acc_ym_sc+'）';
    btnExport.Enabled := True;
  end
  else
  begin
    btnExport.Caption := '导出比对结果'+'（速创vs聚合力数据不一致）';
    btnExport.Enabled := False;
  end;
end;

procedure TForm1.btnImportThreadClick(Sender: TObject);
begin
  TImportThread.Create; // 创建线程
end;

constructor TImportThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(False); // 立即启动
end;

procedure TImportThread.Execute;
var
  i: Integer;
  importType:TImportType;
  dataType:string;
  successCountSC, successCountHrally: Integer;
begin
  CoInitialize(nil);
  try
    if (Form1.edtScBilling.Text = '') then
    begin
      ShowMessage('请先选择速创账单！');
      Exit;
    end;

    if (Form1.edtHrallyBilling.Text = '') then
    begin
      ShowMessage('请先选择聚合力账单！');
      Exit;
    end;

    Form1.btnImportThread.Caption := '系统正在努力干活，建议你去摸个鱼，顺便Roll一下《今日牛马情绪播报》';
    Form1.btnImportThread.Enabled := False;

    try
      //导入速创账单
      dataType := 'SC';
      importType := iptFile;
      Form1.g_batchNoLog :=0;
      Form1.RecordImportDate(imptBegin);
      if Form1.ImportFeedbackData(Form1.edtScBilling.Text,dataType,importType) then
        successCountSC := Form1.v_successCount
      else
        successCountSC := 0;
      Form1.RecordImportDate(imptEnd);
      //Synchronize(UpdateUI);

      //导入聚合力账单
      dataType := 'Hrally';
      importType := iptFolder;
      Form1.g_batchNoLog :=0;
      Form1.RecordImportDate(imptBegin);
      if Form1.ImportFeedbackData(Form1.edtHrallyBilling.Text,dataType,importType) then
        successCountHrally := Form1.v_successCount
      else
        successCountHrally := 0;
      Form1.RecordImportDate(imptEnd);
      //Synchronize(UpdateUI);

      Form1.btnImportThread.Caption := '导入';
      Form1.btnImportThread.Enabled := True;

      ShowMessage(Format('导入完成，共导入速创账单【%s】条，聚合力账单【%s】条！',[IntToStr(successCountSC), IntToStr(successCountHrally)]));
    except on e:Exception do
      begin
        ShowMessage(e.Message);
        Form1.RecordImportDate(imptEnd);
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TImportThread.UpdateUI;
begin
  //
end;

end.
