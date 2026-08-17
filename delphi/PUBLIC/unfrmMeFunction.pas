unit unfrmMeFunction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Menus, ExtCtrls, StdCtrls, DB, DBTables, Registry,
  Mask, DBCtrls, Grids, DBGrids, ComObj;

type
  TfrmMeFunction = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMeFunction: TfrmMeFunction;

type
  PMyRec = ^TMyRec;
  TMyRec = record
    Code: string;
  end;
  TStrArray = record
    StrCount: integer;
    Str: array [0..100] of string;
  end;

const
  App_Client_View = '000003';
  App_Client_Add = '000004';
  App_Client_Edit = '000005';
  App_Client_Delete = '000006';
  App_Bulding_View = '000007';
  App_Bulding_Add = '000008';
  App_Bulding_Edit = '000009';
  App_Bulding_Delete = '000010';
  App_Visits_View = '000011';
  App_Visits_Add = '000012';
  App_Visits_Edit = '000013';
  App_Visits_Delete = '000014';
  App_Client_Approve = '000015';
  App_Nation_Add_Edit = '000016';
  App_Clleader_View = '000017';
  APP_CLIENT_DEPT = '000018';
  APP_CLIENT_SALES = '000019';
  APP_ALL_CLIENT_EDIT = '000020';
  APP_CLIENT_PRINT_SALE = '000021';
  APP_CLIENT_PRINT_DEPT = '000022';
  APP_CLIENT_PRINT_ALL = '000023';

  APP_HUMBAS_VIEW = '001001';
  APP_HUMBAS_ADD_STOCK_1 ='001002';
  APP_HUMBAS_EDIT = '001003';
  APP_HUMBAS_DELETE = '001004';
  APP_HUMBAS_QUERY = '001005';
  APP_REQUIRE_VIEW = '001006';
  APP_REQUIRE_ADD = '001007';
  APP_REQUIRE_EDIT = '001008';
  APP_REQUIRE_DELETE = '001009';
  APP_RECOMMEND = '001010';
  APP_RECOMMEND_HISTORY = '001011';
  APP_HUMAN_STOCK = '001012';
//  APP_RECOMMEND_CANCEL = '001014';
  APP_RECOM_RELEASE_ALL = '001013';
  APP_RECOM_RELEASE_SELF = '001014';
  APP_INTERNET_VIEW = '001015';
  APP_INTERNET_RECEIVE = '001016';
  APP_HUMAN_DICT = '001018';
  APP_HUMAN_PRINT = '001019';
  APP_HUMAN_ASSESSMENT = '001020';
  APP_HUMBAS_ADD_STOCK_2 = '001021';
  APP_RECOM_DAY = '001022';

  APP_PERSONFILE_VIEW = '002001';
  APP_PERSONFILE_EDIT = '002002';
  APP_PERSONFILE_EMP = '002003';
  APP_PERSONFILE_HISTORY = '002004';
  APP_PERSONFILE_QUERY = '002005';
  APP_PERSONFILE_ADD = '002006';
  APP_PERSONFILE_EDIT1 = '002007';
  APP_PERSONFILE_EDIT2 = '002008';
  APP_PERSONFILE_EDIT3 = '002009';
  APP_PERSONFILE_EDIT4 = '002010';
  APP_EMPMATER_VIEW = '002011';
  APP_EMPMATER_ADD = '002012';
  APP_EMPMATER_EDIT = '002013';
  APP_EMPMATER_DELETE = '002014';
  APP_PASSPORT_VIEW = '002021';
  APP_PASSPORT_ADD = '002022';
  APP_PASSPORT_EDIT = '002023';
  APP_PASSPORT_DELETE = '002024';
  APP_EMPACT_VIEW = '002031';
  APP_EMPACT_ADD = '002032';
  APP_EMPACT_EDIT = '002033';
  APP_EMPACT_DELETE = '002034';
//  APP_EMPCARD_VIEW = '002041';
//  APP_EMPCARD_ADD = '002042';
//  APP_EMPCARD_EDIT = '002043';
//  APP_EMPCARD_DELETE = '002044';
  APP_COMPENSATE_VIEW = '002051';
  APP_COMPENSATE_ADD = '002052';
  APP_COMPENSATE_EDIT = '002053';
  APP_COMPENSATE_DELETE = '002054';
  APP_DISPUTE_VIEW = '002061';
  APP_DISPUTE_ADD = '002062';
  APP_DISPUTE_EDIT = '002063';
  APP_DISPUTE_DELETE = '002064';
  APP_ME_DICT = '002071';
//合同，雇员管理
  APP_YGGL_DEPTDEL='300001';
  APP_YGGL_BLYG='300002';
  APP_YGGL_WCYG='300003';
  APP_YGGL_BM='300004';
  APP_YGGL_BLTG='300005';
  APP_YGGL_KDTG='300006';
  APP_YGGL_WCTG='300008';
  APP_YGGL_VIEW='300009';
  APP_ARCH_DEPTDEL='300010';
  APP_ARCH_HJDEL='300011';
  APP_ARCH_VIEW='300012';
  APP_ARCHFEE_DEPTDEL='300013';
  APP_ARCHFEE_HJDEL='300014';
  APP_ARCHFEE_VIEW='300015';
  APP_CONTR_DEPTDEL='300016';
  APP_CONTR_COMPANY='300017';
  APP_CONTR_VIEW='300018';
  APP_SERVCEFEE_UNIT='300019';
  APP_SERVCEFEE_COMPANY='300020';
 //合同，雇员管理
  APP_EMPCARD_VIEW: array [1..9] of string = ('002101', '002103', '002105'
    , '002107', '002109', '002111', '002113', '002115', '002117');
  APP_EMPCARD_EDIT: array [1..9] of string = ('002102', '002104', '002106'
    , '002108', '002110', '002112', '002114', '002116', '002118');

{  APP_IDCARD_VIEW = '002101';
  APP_IDCARD_EDIT = '002102';
  APP_MEDICALCARD_VIEW = '002103';
  APP_MEDICALCARD_EDIT = '002104';
  APP_CHILDCARD1_VIEW = '002105';
  APP_CHILDCARD1_EDIT = '002106';
  APP_CHILDCARD2_VIEW = '002107';
  APP_CHILDCARD2_EDIT = '002108';
  APP_MEDICAL_INSUR_VIEW = '002109';
  APP_MEDICAL_INSUR_EDIT = '002110';
  APP_FUNDCARD_VIEW = '002111';
  APP_FUNDCARD_EDIT = '002112';
  APP_JOBCARD1_VIEW = '002113';
  APP_JOBCARD1_EDIT = '002114';
  APP_JOBCARD2_VIEW = '002115';
  APP_JOBCARD2_EDIT = '002116';
  APP_OLDCARD_VIEW = '002117';
  APP_OLDCARD_EDIT = '002118';}

  APP_PAYABLE = '250001';
  APP_PAYABLE_DEPT09 = '250002';

  COL_WIDTH_EMP: array [0..7] of integer = (60,70,40,80,90,80,200,90);
  COL_NAME_EMP: array [0..7] of string = ('工号','雇员姓名','性别','出生年月','个人材料编号','归档日期','所在商社','人才登记号');
  COL_ORDER_EMP: array [0..7] of integer = (0,1,2,3,4,5,6,7);
  COL_WIDTH_PASS: array [0..10] of integer = (60,70,150,80,100,80,80,80,70,90,80);
  COL_NAME_PASS: array [0..10] of string = ('工号','姓名','所在商社','商社类型','申请类别','申请日期','办理状态','所在部','业务员','人才登记号','序号');
  COL_ORDER_PASS: array [0..10] of integer = (0,1,2,3,4,5,6,7,8,9,10);
  COL_WIDTH_ACT: array [0..2] of integer = (100,150,100);
  COL_NAME_ACT: array [0..2] of string = ('活动类别','活动名称','活动日期');
  COL_ORDER_ACT: array [0..2] of integer = (0,1,2);
  COL_WIDTH_CARD: array [0..7] of integer = (90,100,100,90,90,150,100, 80);
  COL_NAME_CARD: array [0..7] of string = ('工号','雇员姓名','证号','发证日期','领证日期','所在商社','人才登记号','序号');
  COL_ORDER_CARD: array [0..7] of integer = (0,1,2,3,4,5,6,7);
  COL_WIDTH_DISP: array [0..7] of integer = (100,100,80,60,70,150,70,70);
  COL_NAME_DISP: array [0..7] of string = ('案例类型','案例名称','出生年月','申诉方','雇员姓名','商社名称','胜负结果','案例编号');
  COL_ORDER_DISP: array [0..7] of integer = (0,1,2,3,4,5,6,7);
  COL_WIDTH_ACTIVITY: array [0..5] of integer = (80,150,300,50,80,70);
  COL_NAME_ACTIVITY: array [0..5] of string = ('姓名','活动名称','所在商社','参与','人才编号','活动编号');
  COL_ORDER_ACTIVITY: array [0..5] of integer = (0,1,2,3,4,5);

  HUM_STATE: array [1..3] of string = ('','已推荐','不推荐');

var
  ListOrder, Column_Index: integer;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
function CustomSortProcNum(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
function GetErrorMessage(code: integer): string;
function QueryExec(Query1: TQuery; sqltext: string): boolean;
function QueryOpen(Query1: TQuery; sqltext: string): boolean;
function QueryValue(str: string): variant;
function QueryOpenParam(query1: TQuery; param: string): boolean;
procedure QueryRefresh(query: TQuery; isBookMark: boolean);
procedure EnDis_AllControl(const Parent_:array of TWinControl;const ExceptCon_Name:array of String;const isEnabled:Boolean);
procedure ReadOnlyControl(conTmp: TWinControl; isReadOnly: boolean);
procedure ReadOnlyControls(const conTmp: array of TWinControl; isReadOnly: boolean);
procedure ReadOnly_AllControl(const Parent_:array of TWinControl;const ExceptCon_Name:array of String;const isReadOnly:Boolean);
procedure EnableControl(const ControlName: array of TControl; IsEnable: boolean);
procedure VisibleControl(const ControlName: array of TControl; IsVisible: boolean);
procedure ShowInfo(mess: string);
function ShowDelete(cap, delete_value: string): boolean;
procedure StatusBarAdd(StatusBar1: TStatusBar; text1: String);
procedure ComboBoxAdd(ComboBox1: TCustomComboBox; Query1: TQuery);
procedure ComboBoxAdd2(ComboBox1: TCustomComboBox; Query1: TQuery);
procedure ComboBoxItemIndex(Combobox: array of TCustomCombobox; value: integer);
procedure DBComboboxClear(DBCombobox: array of TDBLookUpCombobox);
function ReadKey(regkey, keyname, new_default_val: string):string;
procedure WriteKey(regkey, keyname, val: string);
procedure SetTextEmpty(const ControlName: array of TCustomEdit);
procedure SetText(const ControlName: array of TCustomEdit; TextValue: string);
procedure SetTextQuery(const ControlName: array of TCustomEdit; Query1: TQuery);
procedure SetComboBoxTextEmpty(const ControlName: array of TComboBox);
procedure ClearDBLookupComboBox(const ControlName: array of TDBLookupCombobox);
function FillDateLastDay(todate: string): string;
function FormatFirstDay(s: string): string;
function FormatLastDay(s: string): string;
function FormatYM(s: string): string;
function IsValidDate(sDate: string): boolean;
function IsValidDate_2(sDate: string): boolean;
function IsMedValidDate(med1: TMaskEdit): boolean;
function IsValidYM(sDate: string): boolean;
function IsValidYM_2(sDate: string): boolean;
function IsMedValidYM(med1: TMaskEdit): boolean;
function IsEditValidYM(Edit1: TCustomEdit): boolean;
function IsEditValidFloat(Edit1: TEdit): integer;
function IsEditValidInt(Edit1: TCustomEdit): boolean;
function MyStrToInt(str: string): integer;
function StrReplace(str, source, dest: string): string;
function StrToStrArray(str1: string; const sep: array of string): TStrArray;
function MyStrToDateStr(str: string): string;
function StrWordCopy(s: string; len: integer): string;
function StrWrap(s: string; len: integer): string;
function IntToCode(iCode: string; len: integer): string;
function IsValidInt(sInt: string): boolean;
function IsValidFloat(sFloat: string): boolean;
procedure ListAddCol(ListView1: TListView; const ColWidth: array of integer; const ColName: array of string);
procedure ListAddColOrder(ListView1: TListView; const ColWidth: array of integer; const ColName: array of string; const ColOrder: array of integer);
procedure ListAdd(MyList: TListView; QueryTemp: TQuery);
procedure ListAddOrder(MyList: TListView; QueryTemp: TQuery; const ColOrder: array of integer);
procedure ListAddAll(MyList: TListView; QueryTemp: TQuery);
procedure ListInsert(MyList: TListView; Query1: TQuery);
function ListInsertOrder(MyList: TListView; Query1: TQuery; const ColOrder: array of integer): TListItem;
procedure ListDelete(MyList: TListView);
procedure ListUpdate(ListItem: TListItem; Query1: TQuery);
function ListFindSubItem(ListView1: TListView; FindValue: string; SubItemIndex: integer): TListItem;
procedure ListAppend(MyList: TListView; Query1: TQuery);
procedure ListClear(MyList: TListView);
procedure TableOpen(const tables: array of TDataSet);
procedure TableClose(const tables: array of TDataSet);
procedure TableCancel(const tables: array of TTable);
procedure TreeAdd(MyTree: TTreeView; MyTreeNode: TTreeNode; QueryTemp: TQuery);
procedure TreeAddPtr(MyTree: TTreeview; MyTreeNode: TTreeNode; QueryTemp: TQuery);
function TreeAddOnePtr(MyTree: TTreeView; ParentTreeNode: TTreeNode; ChildText, ChildData: string): TTreeNode;
procedure TreeAddExpand(TreeView1: TTreeView; FNode: TTreeNode);
procedure TreeAddOther(TreeView1: TTreeview; FNode: TTreeNode);
procedure TreeAddImage(TreeView1: TTreeView; StartIndex: integer);
procedure TreeNodeAddImage(Node: TTreeNode; StartIndex: integer);
procedure TreeAddImageDif(TreeView1: TTreeView; StartIndex: integer);
function TreeGetParent(TreeView1: TTreeView; MyTreeNode: TTreeNode): TTreeNode;
function TreeGetLevelFirst(TreeView1: TTreeview; lev: integer): TTreeNode;
function TreeFindData(TreeView1: TTreeView; FindValue: string; FindLevel: integer): TTreeNode;
function TreeFindChildData(ParentNode: TTreeNode; FindValue: string): TTreeNode;
procedure StringGridSetColWidth(StringGrid1: TStringGrid; const ColWidth: array of integer);
procedure StringGridSetColName(StringGrid1: TStringGrid; const ColName: array of string);
procedure StringGridAddRow(StringGrid1: TStringGrid);
procedure StringGridDeleteRow(StringGrid1: TStringGrid; row: integer);
procedure StringGridClear(StringGrid1: TStringGrid);
procedure StringGridDisplay(StringGrid1: TStringGrid; Query1: TQuery);
procedure CopyStringGrid(srcStringGrid, desStringGrid: TStringGrid);
function IsStringGridRowEmpty(StringGrid1: TStringGrid; row: integer): boolean;
procedure DBGridAddCol(DBGrid: TDBGrid; const ColWidth: array of integer; const ColName: array of string);
procedure DBGridSetTitle(DBGrid: TDBGrid; const ColWidth: array of integer; const ColName: array of string);
procedure DBGridSetField(DBGrid: TDBGrid; Query: TQuery);
procedure DBGridSelectAll(DBGrid: TDBGrid);
function GetSysDate: TDateTime;
function GetSysDateTime: TDateTime;
function PosOfArray(const a: array of string; value: string): integer;
procedure BlobFieldReadControl(field1: TField; control1: TControl);
procedure BlobFieldWrite(field1: TField; s: string);
function CreateWordApplication(var wrd: variant; IsVisible: boolean): boolean;
function IsTableExist(table_name: string): boolean;

function GetFullNameOfApp(filename: string): string;

{创建Excel}
function CreateExcelApplication(var excel: variant; IsVisible: boolean): boolean;

{新建Excel工作簿}
function AddWorkBook(var excel, workbook: variant): boolean; overload;
{用模板新建Excel工作簿}
function AddWorkBook(var excel, workbook: variant; template: string): boolean; overload;
{用模板的某个工作表新建Excel工作簿}
function AddWorkBook(var excel, workbook: variant; template, sheetname: string): boolean; overload;

function DBGridToExcel(ADBGrid: TDBGrid; worksheet: variant): boolean; overload;

function SqlToExcel(ADatabaseName, ASql: string; worksheet: variant): boolean;
function DataSetToExcel(ADataSet: TDataSet; worksheet: variant): boolean; overload;
function DataSetToExcel(ADataSet: TDataSet; worksheet: variant; FirstRow, FirstCol: integer; ColHead: boolean): boolean; overload;

implementation

uses undmMain;

{$R *.DFM}

const
  REG_KEY_SELECT = '\software\sfsc\sfscma\select';
  KEY_LR = 'ListRow';
  KEY_CS = 'CheckSpelling';
  INVALID_DATE = '无效日期。';
  INVALID_FLOAT = '无效数值。';
  CONFIRM_DELETE_WARN = '确实要删除“%s”的信息吗？（操作将无法被恢复）';

procedure EnDis_AllControl(const Parent_:array of TWinControl;const ExceptCon_Name:array of String;const isEnabled:Boolean);
var
  iParent, iCount,iCount1:integer;
  conTmp:TControl;
  isOK: boolean;
begin
 for iParent:= Low(Parent_) to High(Parent_) do
  for iCount:=0 to Parent_[iParent].ControlCount-1 do
    begin
      ConTmp:=Parent_[iParent].Controls[iCount];
      isOK:=conTmp.Tag >= 0;
      if isOK then
        for iCount1:=low(ExceptCon_Name) to high(ExceptCon_Name) do
          if (ExceptCon_Name[iCount1]<>'') and  (CompareText( ExceptCon_Name[iCount1],ConTmp.ClassName)=0) then
            begin
              isOK:=False;
              Break;
            end;
      if isOK then
        conTmp.Enabled :=isEnabled;
    end;
end;

procedure ReadOnlyControl(conTmp: TWinControl; isReadOnly: boolean);
begin
  if conTmp.Tag < 0 then Exit;

  try
  if (conTmp is TEdit) then
    TEdit(conTmp).ReadOnly:=isReadOnly
  else
    if (conTmp is TMaskEdit) then
      TMaskEdit(conTmp).ReadOnly:=isReadOnly
    else
      if (conTmp is TDBEdit) then
        TDBEdit(conTmp).ReadOnly:=isReadOnly
      else
        if (conTmp is TDBLookupComboBox) then
          TDBLookUpComboBox(conTmp).ReadOnly:=isReadOnly
        else
          if (conTmp is TDBComboBox) then
            TDBComboBox(conTmp).ReadOnly:=isReadOnly
          else
            if (conTmp is TDBMemo) then
              TDBMemo(conTmp).ReadOnly:=isReadOnly
            else
              if (conTmp is TDBCheckBox) then
                TDBCheckBox(conTmp).ReadOnly:=isReadOnly
              else
                if (conTmp is TMemo) then
                  TMemo(conTmp).ReadOnly:=isReadOnly
                else
                  if (conTmp is TDBRichEdit) then
                    TDBRichEdit(conTmp).ReadOnly:=isReadOnly
                  else
                    if (conTmp is TDBGrid) then
                      TDBGrid(conTmp).ReadOnly:=isReadOnly
                    else
                      if (conTmp is TDBRadioGroup) then
                        TDBRadioGroup(conTmp).ReadOnly:=isReadOnly
                      else
                        if (conTmp is TListView) then
                          TListView(conTmp).ReadOnly:=isReadOnly
                        else
                          conTmp.Enabled:=not isReadOnly;
  except      
  end;
end;

procedure ReadOnlyControls(const conTmp: array of TWinControl; isReadOnly: boolean);
var
  i: integer;
begin
  for i:=Low(conTmp) to High(conTmp) do
    ReadOnlyControl(conTmp[i], isReadOnly);
end;

procedure ReadOnly_AllControl(const Parent_:array of TWinControl;const ExceptCon_Name:array of String;const isReadOnly:Boolean);
var
  iParent, iCount,iCount1:integer;
  conTmp:TControl;
  isOK: boolean;
begin
 for iParent:= Low(Parent_) to High(Parent_) do
  for iCount:=0 to Parent_[iParent].ControlCount-1 do
    begin
      ConTmp:=Parent_[iParent].Controls[iCount];
      isOK:=True;
      for iCount1:=low(ExceptCon_Name) to high(ExceptCon_Name) do
        if (ExceptCon_Name[iCount1]<>'') and  (CompareText( ExceptCon_Name[iCount1],ConTmp.ClassName)=0) then
          begin
            isOK:=False;
            Break;
          end;
      if isOK then
        ReadOnlyControl(TWinControl(conTmp), isReadOnly);
    end;
end;

function GetErrorMessage(code: integer): string;
begin
  case code of
    9729: result:='唯一关键字错误。';
    9732: result:='不能为空值。';
    9734: result:='外键错误。';
  else
    result:='异常出错。';
  end;
end;

function QueryExec(Query1: TQuery; sqltext: string): boolean;
begin
  //运行查询，若成功返回True, 不成功返回False
  with Query1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqltext);
      try
        ExecSQL;
        Result:=True;
      except
        Result:=False;
      end;
    end;
end;

function QueryOpen(Query1: TQuery; sqltext: string): boolean;
begin
  //打开查询返回的数据集
  with Query1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqltext);
      try
        Open;
        Result:=True;
      except
        Close;
        SQL.Clear;
        SQL.Add('select * from dual where 1=2');
        Open;
        Result:=False;
      end;
    end;
end;

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

function QueryOpenParam(query1: TQuery; param: string): boolean;
begin
  with query1 do
    try
      Close;
      Params[0].AsString:=param;
      Prepare;
      Open;
      result:=True;
    except
      result:=False;
    end;
end;

procedure QueryRefresh(query: TQuery; isBookMark: boolean);
var
  bookmark: TBookMark;
begin
  if query.Text = '' then
    Exit;

  if isBookMark then
    bookmark:=query.GetBookmark;
  query.DisableControls;
  query.Close;
  query.Open;
  if isBookMark then
    begin
      try
        query.GotoBookMark(bookmark);
      except
      end;
      query.FreeBookMark(bookMark);
    end;
  query.EnableControls;
end;

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

procedure ComboBoxAdd2(ComboBox1: TCustomComboBox; Query1: TQuery);
var
  s: String;
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
              ComboBox1.Items.Add(s);
              Next;
            end;
        end;
    end;
end;

procedure ComboboxItemIndex(Combobox: array of TCustomCombobox; value: integer);
var
  i: integer;
begin
  for i:=Low(Combobox) to High(Combobox) do
    Combobox[i].ItemIndex:=value;
end;

procedure DBComboboxClear(DBCombobox: array of TDBLookUpCombobox);
var
  i: integer;
begin
  for i:=Low(DBCombobox) to High(DBCombobox) do
    DBCombobox[i].KeyValue:=NULL;
end;

function ReadKey(regkey, keyname, new_default_val: string):String;
var
  reg1: TRegistry;
begin
  //if key has exist then open key
  //if key hasn't exist then create key and write default value to it
  reg1:=TRegistry.Create;

  with reg1 do
    begin
      if KeyExists(regkey) then
        begin
          OpenKey(regkey,False);
          if not ValueExists(keyname) then
            WriteString(keyname, new_default_val);
        end
      else
        begin
          CreateKey(regkey);
          OpenKey(regkey,False);
          WriteString(keyname, new_default_val);
        end;
      Result:=ReadString(keyname);
    end;
end;

procedure WriteKey(regkey, keyname, val: string);
var
  reg1: TRegistry;
begin
  reg1:=TRegistry.Create;
  with reg1 do
    begin
      OpenKey(regkey, True);
      WriteString(keyname, val);
      CloseKey;
    end;
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
  //将TListItem排序
  if ListOrder > 0 then
    if ParamSort = 0 then
      Result := lstrcmp(PChar(TListItem(Item1).Caption),
                        PChar(TListItem(Item2).Caption))
    else
      Result := lstrcmp(PChar(TListItem(Item1).SubItems.strings[ParamSort-1]),
                        PChar(TListItem(Item2).SubItems.strings[ParamSort-1]))
  else
    if ParamSort = 0 then
      Result := -lstrcmp(PChar(TListItem(Item1).Caption),
                         PChar(TListItem(Item2).Caption))
    else
      Result := -lstrcmp(PChar(TListItem(Item1).SubItems.strings[ParamSort-1]),
                         PChar(TListItem(Item2).SubItems.strings[ParamSort-1]));
end;

function CustomSortProcNum(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
  //将TListItem排序
  if ListOrder > 0 then
    if ParamSort = 0 then
      Result := MyStrToInt(TListItem(Item1).Caption)-
                        MyStrToInt(TListItem(Item2).Caption)
    else
      Result := MyStrToInt(TListItem(Item1).SubItems.strings[ParamSort-1])-
                        StrToInt(TListItem(Item2).SubItems.strings[ParamSort-1])
  else
    if ParamSort = 0 then
      Result := -(MyStrToInt(TListItem(Item1).Caption)-
                         MyStrToInt(TListItem(Item2).Caption))
    else
      Result := -(MyStrToInt(TListItem(Item1).SubItems.strings[ParamSort-1])-
                         MyStrToInt(TListItem(Item2).SubItems.strings[ParamSort-1]));
end;

procedure EnableControl(const ControlName: array of TControl; IsEnable: boolean);
var
  i: integer;
begin
  //将一组TControl的Enabled置为True或False
  try
    for i:=Low(ControlName) to High(ControlName) do
      ControlName[i].Enabled:=IsEnable;
  except
  end;
end;

procedure VisibleControl(const ControlName: array of TControl; IsVisible: boolean);
var
  i: integer;
begin
  //将一组TControl的Visible置为True或False
  try
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].Visible:=IsVisible;
  except
  end;
end;

procedure SetTextEmpty(const ControlName: array of TCustomedit);
var
  i: integer;
begin
  //将一组TCustomEdit的Text置为空
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].Clear;
end;

procedure SetText(const ControlName: array of TCustomedit; TextValue: string);
var
  i: integer;
begin
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].Text:=TextValue;
end;

procedure SetTextQuery(const ControlName: array of TCustomedit; Query1: TQuery);
var
  i: integer;
begin
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].Text:=Query1.Fields[i].AsString;
end;

procedure SetComboBoxTextEmpty(const ControlName: array of TComboBox);
var
  i: integer;
begin
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].Text:='';
end;

procedure ClearDBLookupComboBox(const ControlName: array of TDBLookupCombobox);
var
  i: integer;
begin
  for i:=Low(ControlName) to High(ControlName) do
    ControlName[i].KeyValue:=Null;
end;

function FillDateLastDay(todate: string): string;
var
  lastday: string;
begin
  lastday:=copy(todate, 1, 7);
  with dmMain.qrTemp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select to_char(last_day(to_date('''+lastday
        +''', ''yyyy-mm'')), ''yyyy-mm-dd'')'
        +' from dual');
      Open;
      lastday:=Fields[0].AsString;
    end;
  Result:=lastday;
end;

function FormatFirstDay(s: string): string;
var
  yyyy, mm, dd: string;
begin
  //1. '        '     ->     ''
  //2. 'yyyymm  '     ->     'yyyy-mm-01'
  //3. 'yyyymmdd'     ->     'yyyy-mm-dd'
  //4.  不合法        ->     ''

  if trim(s) = '' then
    begin
      result:=trim(s);
    end
  else
    begin
      yyyy:=copy(s, 1, 4);
      mm:=copy(s, 5, 2);
      dd:=copy(s, 7, 2);
      if trim(dd) = '' then dd:='01';

      result:=yyyy+'-'+mm+'-'+dd;

      try
        result:=DateToStr(StrToDate(result));
      except
        result:='';
        raise;
      end;
    end;
end;

function FormatLastDay(s: string): string;
var
  yyyy, mm, dd, tmp: string;
begin
  //1. '        '     ->     ''                           true
  //2. 'yyyymm  '     ->     'yyyy-mm-(28,29,30,30)'      true
  //3. 'yyyymmdd'     ->     'yyyy-mm-dd'                 true
  //4.  不合法        ->     ''                           false

  if trim(s) = '' then
    begin
      result:=trim(s);
    end
  else
    begin
      yyyy:=copy(s, 1, 4);
      mm:=copy(s, 5, 2);
      dd:=copy(s, 7, 2);
      try
        tmp:=DateToStr(StrToDate(yyyy+'-'+mm+'-'+'01'));
        yyyy:=copy(tmp, 1, 4);
        mm:=copy(tmp, 6, 2);
      except
        result:='';
        raise;
      end;

      if trim(dd) = '' then
        with dmMain.qrTemp do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select to_char(last_day(to_date('''+yyyy+mm
              +''', ''yyyymm'')), ''dd'')'
              +' from dual');
            Open;
            dd:=Fields[0].AsString;
          end;

      result:=yyyy+'-'+mm+'-'+dd;

      try
        result:=DateToStr(StrToDate(result));
      except
        result:='';
        raise;
      end;
    end;
end;

function FormatYM(s: string): string;
begin
  if trim(s) = '' then
    begin
      result:=trim(s);
    end
  else
    begin
      result:=copy(s, 1, 4)+'-'+copy(s, 5, 2)+'-01';

      try
        result:=FormatDatetime('yyyymm', StrToDate(result));
      except
        result:='';
        raise;
      end;
    end;
end;

function IsMedValidDate(med1: TMaskEdit): boolean;
begin
  Result:=True;
  if med1.Text <> '    -  -  ' then
    try
      StrToDate(med1.Text);
    except
      on EConvertError do
        begin
          Result:=False;
          ShowInfo(Invalid_Date);
          med1.Text:='    -  -  ';
          if med1.CanFocus then
            med1.SetFocus;
          Exit;
        end;
    end;
end;

function IsValidDate(sDate: string): boolean;
begin
  //判断sDate是否是合法的日期类型
  Result:=True;
  if not ((sDate = '') or (sDate = '    -  -  ')) then
    try
      StrToDate(sDate);
    except
      on EConvertError do Result:=False;
    end;
end;

function IsValidDate_2(sDate: string): boolean;
begin
  result:=True;
  sDate:=Trim(sDate);
  if sDate <> '' then
    try
      StrToDate(copy(sDate, 1, 4)+'-'+copy(sDate, 5, 2)+'-'+copy(sDate, 7, 2));
    except
      result:=False;
    end;
end;

function IsValidYM(sDate: string): boolean;
begin
  //判断sDate是否是合法的年月类型
  Result:=True;
  if not ((sDate = '') or (sDate = '    -  -  ')) then
    begin
      if copy(sDate, 9, 2) = '  ' then
        sDate:=copy(sDate, 1, 8)+'01';
      try
        StrToDate(sDate);
      except
        on EConvertError do Result:=False;
      end;
    end;
end;

function IsValidYM_2(sDate: string): boolean;
begin
  Result:=True;
  sDate:=Trim(sDate);
  if sDate <> '' then
    begin
      sDate:=copy(sDate, 1, 4)+'-'+copy(sDate, 5, 2)+'-'+'01';
      try
        StrToDate(sDate);
      except
        Result:=False;
      end;
    end;
end;

function IsMedValidYM(med1: TMaskEdit): boolean;
var
  text: String;
begin
  Result:=True;
  text:=med1.Text;
  if text <> '    -  -  ' then
    begin
      if copy(text, 9, 2) = '  ' then
        text:=copy(text, 1, 8)+'01';
      try
        StrToDate(text);
        Result:=True;
      except
        on EConvertError do
          begin
            Result:=False;
            ShowInfo(Invalid_Date);
            med1.Text:='    -  -  ';
            if med1.CanFocus then
              med1.SetFocus;
            Exit;
          end;
      end;
    end;
end;

function IsEditValidYM(Edit1: TCustomEdit): boolean;
var
  sDate: string;
begin
  //判断TEdit是否是合法的年月类型
  Result:=True;
  sDate:=Edit1.Text;
  if (Trim(sDate) = '') or (Trim(sDate) = '-  -') then
    Exit;

  sDate:=copy(sDate, 1, 4)+'-'+copy(sDate, 6, 2)+'-'+copy(sDate, 9, 2);
  if Trim(copy(sDate, 9, 2)) = '' then
    sDate:=copy(sDate, 1, 8)+'01';

  try
    StrToDate(sDate);
    Edit1.Text:=sDate;
  except
    on EConvertError do
      begin
        ShowInfo(INVALID_DATE);
        if Edit1.ClassName = 'TMaskEdit' then
          Edit1.Text:='    -  -  '
        else
          Edit1.Clear;
        if Edit1.Canfocus then
          Edit1.SetFocus;
        Result:=False;
      end;
  end;
end;

function IsEditValidFloat(Edit1: TEdit): integer;
var
  sFloat: string;
begin
  sFloat:=Trim(Edit1.Text);
  Result:=1;
  if sFloat = '' then
    Exit;

  try
    Edit1.Text:=FloatToStr(StrToFloat(sFloat));
  except
    on EConvertError do
      begin
        ShowInfo(INVALID_FLOAT);
        Edit1.Clear;
        Edit1.SetFocus;
        Result:=0;
      end;
  end;
end;

function IsEditValidInt(Edit1: TCustomEdit): boolean;
var
  sInt: string;
begin
  sInt:=Trim(Edit1.Text);
  Result:=True;
  if sInt = '' then
    Exit;

  try
    Edit1.Text:=IntToStr(StrToInt(sInt));
  except
    on EConvertError do
      begin
        ShowInfo(INVALID_FLOAT);
        Edit1.Clear;
        Edit1.SetFocus;
        Result:=False;
      end;
  end;
end;

function MyStrToInt(str: string): integer;
begin
  try
    Result:=StrToInt(str);
  except
    Result:=0;
  end;
end;

function StrReplace(str, source, dest: string): string;
var
  str1, str2: string;
  p: integer;
begin
  p:=pos(source, str);
  if p > 0 then
    begin
      str1:=copy(str, 1, p-1)+dest;
      str2:=copy(str, p+length(source), length(str)+1-p-length(source));
      Result:=str1+StrReplace(str2, source, dest);
    end
  else
    Result:=str;
end;

function StrToStrArray(str1: string; const sep: array of string): TStrArray;
var
  str_remain: string;
  sPos, i, iCount: integer;
begin
  //将字符串str1按分隔符拆开，放入数组，返回该数组和数组大小
  if str1 = '' then
    begin
      Result.StrCount:=0;
      Exit;
    end;

  str_remain:=str1;
  for i:=1 to High(sep) do
    str_remain:=StrReplace(str_remain, sep[i], sep[0]);

  iCount:=0;
  sPos:=pos(sep[0], str_remain);
  while sPos > 0 do
    begin
      Inc(iCount);
      Result.Str[iCount-1]:=copy(str_remain, 1, sPos-1);
      str_remain:=copy(str_remain, sPos+Length(sep[0]), Length(str_remain)-sPos-Length(sep[0])+1);
      sPos:=pos(sep[0], str_remain);
    end;

  Inc(iCount);
  Result.Str[iCount-1]:=str_remain;
  Result.StrCount:=iCount;
end;

function MyStrToDateStr(str: string): string;
begin
  //若日期的日为空，将日置为“01”返回
  if (Trim(str) = '-  -') or (Trim(str) = '') then
    Result:=''
  else
    begin
      if copy(str, 9, 2) = '  ' then
        str:=copy(str, 1, 8)+'01';
      try
        StrToDate(str);
        Result:=str;
      except
        Result:='';
      end;
    end;
end;

function StrWordCopy(s: string; len: integer): string;
var
  i: integer;
  s1, c: string;
begin
  s1:='';
  i:=1;
  while length(s1) < length(s) do
    begin
      i:=length(s1)+1;
      if Ord(s[i]) <= 127 then
        c:=copy(s, i, 1)
      else
        c:=copy(s, i, 2);

      if length(s1+c) <= len then
        s1:=s1+c
      else
        break;
    end;

  Result:=s1;
end;

function StrWrap(s: string; len: integer): string;
var
  s1, s2, temp: string;
begin
  s1:='';
  s2:=s;
  while s2 <> '' do
    begin
      temp:=StrWordCopy(s2, len);
      s2:=copy(s2, length(temp)+1, length(s2)-length(temp));
      if s1 <> '' then
        s1:=s1+' ';
      s1:=s1+temp;
    end;
  Result:=s1;
end;

function IntToCode(iCode: string; len: integer): string;
var
  i: integer;
begin
  for i:=1 to len-Length(iCode) do
    iCode:='0'+iCode;
  Result:=iCode;
end;

function IsValidInt(sInt: string): boolean;
begin
  //判断string是否可转换成合法的Int类型
  sInt:=Trim(sInt);
  Result:=True;
  if not (sInt = '') then
    try
      StrToInt(sInt);
    except
      on EConvertError do Result:=False;
    end;
end;

function IsValidFloat(sFloat: string): boolean;
begin
  //判断string是否可转换成合法的Float类型
  sFloat:=Trim(sFloat);
  Result:=True;
  if not (sFloat = '') then
    try
      StrToFloat(sFloat);
    except
      on EConvertError do Result:=False;
    end;
end;

procedure ListAddCol(ListView1: TListView; const ColWidth: array of integer; const ColName: array of string);
var
  j: integer;
begin
  //将指定列名加入ListView
  ListView1.Items.BeginUpdate;
  ListView1.Columns.BeginUpdate;
  ListView1.Items.Clear;
  ListView1.Columns.Clear;

  for j:=low(ColName) to high(ColName) do
    begin
      ListView1.Columns.Add;
      ListView1.Columns.Items[j].Caption:=ColName[j];
      ListView1.Columns.Items[j].Width:=ColWidth[j];
    end;

  ListView1.Columns.EndUpdate;
  ListView1.Items.EndUpdate;
end;

procedure ListAddColOrder(ListView1: TListView; const ColWidth: array of integer; const ColName: array of string; const ColOrder: array of integer);
var
  j: integer;
begin
  //将指定列名加入ListView
  ListView1.Items.BeginUpdate;
  ListView1.Columns.BeginUpdate;
  ListView1.Items.Clear;
  ListView1.Columns.Clear;

  for j:=low(ColName) to high(ColName) do
    begin
      ListView1.Columns.Add;
      ListView1.Columns.Items[j].Caption:=ColName[ColOrder[j]];
      ListView1.Columns.Items[j].Width:=ColWidth[ColOrder[j]];
    end;

  ListView1.Columns.EndUpdate;
  ListView1.Items.EndUpdate;
end;

procedure ListAdd(MyList: TListView; QueryTemp: TQuery);
var
  i, r: integer;
  NewItem: TListItem;
  row: String;
begin
  MyList.Items.BeginUpdate;
  MyList.Items.Clear;
  MyList.Items.EndUpdate;

  if QueryTemp.IsEmpty then
    Exit;

  row:=ReadKey(REG_KEY_SELECT, KEY_LR, '');

  if (row = '') or (row = 'all') then
    with MyList do
      begin
        QueryTemp.First;
        while not QueryTemp.EOF do
          begin
            NewItem:=Items.Add;
            NewItem.Caption:=QueryTemp.Fields[0].AsString;
            for i:=1 to QueryTemp.FieldCount-1 do
              begin
                NewItem.SubItems.Add(QueryTemp.Fields[i].AsString);
              end;
            QueryTemp.Next;
          end;
      end
  else
    begin
      r:=StrToInt(row);
      with MyList do
        begin
          QueryTemp.First;
          while (not QueryTemp.EOF) and (r > 0) do
            begin
              NewItem:=Items.Add;
              NewItem.Caption:=QueryTemp.Fields[0].AsString;
              for i:=1 to QueryTemp.FieldCount-1 do
                begin
                  NewItem.SubItems.Add(QueryTemp.Fields[i].AsString);
                end;
              QueryTemp.Next;
              r:=r-1;
            end;
        end
    end;
end;

procedure ListAddOrder(MyList: TListView; QueryTemp: TQuery; const ColOrder: array of integer);
var
  i, r: integer;
  NewItem: TListItem;
  row: String;
begin
  //将ListView清空，查询结果加入ListView
  MyList.Items.BeginUpdate;
  MyList.Items.Clear;
  MyList.Items.EndUpdate;

  if QueryTemp.IsEmpty then
    Exit;

  row:=ReadKey(REG_KEY_SELECT, KEY_LR, '');

  if (row = '') or (row = 'all') then
    with MyList do
      begin
        QueryTemp.First;
        while not QueryTemp.EOF do
          begin
            NewItem:=Items.Add;
            NewItem.Caption:=QueryTemp.Fields[0].AsString;
            for i:=1 to QueryTemp.FieldCount-1 do
              begin
                NewItem.SubItems.Add(QueryTemp.Fields[ColOrder[i]].AsString);
              end;
            QueryTemp.Next;
          end;
      end
  else
    begin
      r:=StrToInt(row);
      with MyList do
        begin
          QueryTemp.First;
          while (not QueryTemp.EOF) and (r > 0) do
            begin
              NewItem:=Items.Add;
              NewItem.Caption:=QueryTemp.Fields[0].AsString;
              for i:=1 to QueryTemp.FieldCount-1 do
                begin
                  NewItem.SubItems.Add(QueryTemp.Fields[ColOrder[i]].AsString);
                end;
              QueryTemp.Next;
              r:=r-1;
            end;
        end
    end;
end;

procedure ListAddAll(MyList: TListView; QueryTemp: TQuery);
var
  i: integer;
  NewItem: TListItem;
begin
  //将ListView清空，查询结果加入ListView
  MyList.Items.BeginUpdate;
  MyList.Items.Clear;
  MyList.Items.EndUpdate;

  if QueryTemp.IsEmpty then
    Exit;

  with MyList do
    begin
      QueryTemp.First;
      while not QueryTemp.EOF do
        begin
          NewItem:=Items.Add;
          NewItem.Caption:=QueryTemp.Fields[0].AsString;
          for i:=1 to QueryTemp.FieldCount-1 do
            begin
              NewItem.SubItems.Add(QueryTemp.Fields[i].AsString);
            end;
          QueryTemp.Next;
        end;
    end;
end;

procedure ListInsert(MyList: TListView; Query1: TQuery);
var
  i: integer;
  NewItem: TListItem;
begin
  if Query1.IsEmpty then
    Exit;

  with MyList do
    begin
      Query1.First;
      while not Query1.EOF do
        begin
          NewItem:=Items.Add;
          NewItem.Caption:=Query1.Fields[0].AsString;
          for i:=1 to Query1.FieldCount-1 do
            begin
              NewItem.SubItems.Add(Query1.Fields[i].AsString);
            end;
          Query1.Next;
        end;
    end
end;

function ListInsertOrder(MyList: TListView; Query1: TQuery; const ColOrder: array of integer): TListItem;
var
  i: integer;
  NewItem: TListItem;
begin
  //将查询结果追加入ListView
  if Query1.IsEmpty then
    begin
      Result:=nil;
      Exit;
    end;

  with MyList do
    begin
      Query1.First;
      while not Query1.EOF do
        begin
          NewItem:=Items.Add;
          NewItem.Caption:=Query1.Fields[0].AsString;
          for i:=1 to Query1.FieldCount-1 do
            begin
              NewItem.SubItems.Add(Query1.Fields[ColOrder[i]].AsString);
            end;
          Query1.Next;
        end;
    end;
  Result:=NewItem;
end;

procedure ListDelete(MyList: TListView);
var
  i, j: integer;
  MyListItem: TListItem;
begin
  //删除ListView选中的行
  MyList.Items.BeginUpdate;
  with MyList do
    begin
      j:=0;
      for i:=0 to Items.Count-1 do
        begin
          MyListItem:=Items[j];
          if MyListItem.Selected then
            begin
              MyListItem.Delete;
              j:=j-1;
            end;
          j:=j+1;
        end;
    end;
  MyList.Items.EndUpdate;
end;

procedure ListUpdate(ListItem: TListItem; Query1: TQuery);
var
  i: integer;
begin
  //用Query1的值更新指定列表项。
  if ListItem <> nil then
    if Query1.IsEmpty then
      begin
        ListItem.Delete;
      end
    else
      begin
        ListItem.Caption:=Query1.Fields[0].AsString;
        for i:=0 to Query1.FieldCount-2 do
          ListItem.SubItems.Strings[i]:=Query1.Fields[i+1].AsString;
      end;
end;

function ListFindSubItem(ListView1: TListView; FindValue: string; SubItemIndex: integer): TListItem;
var
  ListItem: TListItem;
  i: integer;
begin
  //查找指定Index的SubItem的值，找到则返回该项，否则返回空。
  ListItem:=nil;
  with ListView1 do
    begin
      for i:=0 to Items.Count-1 do
        if Items[i].SubItems.Strings[SubItemIndex] = FindValue then
          begin
            ListItem:=Items[i];
            break;
          end;
    end;
  Result:=ListItem;
end;

procedure ListAppend(MyList: TListView; Query1: TQuery);
var
  i, j: integer;
  NewItem: TListItem;
begin
  j:=0;
  with MyList do
    begin
      while (not Query1.EOF) and (j < 1000) do
        begin
          NewItem:=Items.Add;
          NewItem.Caption:=Query1.Fields[0].AsString;
          for i:=1 to Query1.FieldCount-1 do
            begin
              NewItem.SubItems.Add(Query1.Fields[i].AsString);
            end;
          Query1.Next;
          Inc(j);
        end;
    end
end;

procedure ListClear(MyList: TListView);
begin
  if MyList.Items.Count > 0 then
    with MyList.Items do
      begin
        BeginUpdate;
        Clear;
        EndUpdate;
      end;
end;

procedure ShowInfo(mess: string);
begin
  Application.MessageBox(PChar(mess), PChar(Application.Title), MB_OK+MB_ICONINFORMATION);
end;

function ShowDelete(cap, delete_value: string): boolean;
var
  mess: string;
begin
  mess:=Format(CONFIRM_DELETE_WARN, [delete_value]);
  if Application.MessageBox(PChar(mess), PChar(cap), MB_YESNO+MB_DEFBUTTON2+MB_ICONWARNING) = IDNO then
    Result:=False
  else
    Result:=True;
end;

procedure StatusBarAdd(StatusBar1: TStatusBar; text1: String);
begin
  StatusBar1.Panels.Items[0].Text:=text1;
end;

procedure TableOpen(const tables: array of TDataSet);
var
  i: integer;
begin
  for i:=Low(tables) to High(tables) do
    if not tables[i].Active then
      tables[i].Open;
end;

procedure TableClose(const tables: array of TDataSet);
var
  i: integer;
begin
  for i:=Low(tables) to High(tables) do
    begin
      if (tables[i].State = dsInsert) or (tables[i].State = dsEdit) then
        tables[i].Cancel;
      tables[i].Close;
    end;
end;

procedure TableCancel(const tables: array of TTable);
var
  i: integer;
begin
  for i:=Low(tables) to High(tables) do
    if (tables[i].State = dsInsert) or (tables[i].State = dsEdit) then
      tables[i].Cancel;
end;

procedure TreeAddPtr(MyTree: TTreeview; MyTreeNode: TTreeNode; QueryTemp: TQuery);
var
  MyRecPtr: PMyRec;
begin
  if QueryTemp.IsEmpty then
    Exit;
  with QueryTemp do
    begin
      First;
      while not EOF do
        begin
          if QueryTemp.Fields[0].AsString <> '' then
            begin
              New(MyRecPtr);
              MyRecPtr^.Code:=QueryTemp.Fields[1].AsString;
              MyTree.Items.AddChildObject(MyTreeNode, QueryTemp.Fields[0].AsString, MyRecPtr);
            end;
          Next;
        end;
    end;
end;

function TreeAddOnePtr(MyTree: TTreeView; ParentTreeNode: TTreeNode; ChildText, ChildData: string): TTreeNode;
var
  MyRecPtr: PMyRec;
  ChildNode: TTreeNode;
begin
  New(MyRecPtr);
  MyRecPtr^.Code:=ChildData;
  ChildNode:=MyTree.Items.AddChildObject(ParentTreeNode, ChildText, MyRecPtr);
  ChildNode.ImageIndex:=ChildNode.Level;
  Result:=ChildNode;
end;

procedure TreeAdd(MyTree: TTreeView; MyTreeNode: TTreeNode; QueryTemp: TQuery);
begin
  if QueryTemp.IsEmpty then
    Exit;
  with QueryTemp do
    begin
      First;
      while not EOF do
        begin
          MyTree.Items.AddChild(MyTreeNode, Fields[0].AsString);
          Next;
        end;
    end;
end;

procedure TreeAddExpand(TreeView1: TTreeView; FNode: TTreeNode);
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

procedure TreeAddOther(TreeView1: TTreeview; FNode: TTreeNode);
begin
  TreeView1.Items.AddChild(FNode, '其他');
end;

procedure TreeAddImage(TreeView1: TTreeView; StartIndex: integer);
var
  i: integer;
begin
  for i:=0 to TreeView1.Items.Count-1 do
    TreeView1.Items[i].ImageIndex:=TreeView1.Items[i].Level+StartIndex;
end;

procedure TreeNodeAddImage(Node: TTreeNode; StartIndex: integer);
var
  i: integer;
begin
  for i:=0 to Node.Count-1 do
    Node.Item[i].ImageIndex:=Node.Item[i].Level+StartIndex;
end;

procedure TreeAddImageDif(TreeView1: TTreeView; StartIndex: integer);
var
  i: integer;
begin
  for i:=0 to TreeView1.Items.Count-1 do
    TreeView1.Items[i].ImageIndex:=i+StartIndex;
end;

function TreeGetParent(TreeView1: TTreeView; MyTreeNode: TTreeNode): TTreeNode;
var
  ParentNode: TTreeNode;
begin
  //返回某节点的父节点
  if MyTreeNode.Level = 0 then
    Result:=nil
  else
    begin
      ParentNode:=MyTreeNode;
      repeat
        ParentNode:=ParentNode.GetPrev;
      until MyTreeNode.HasAsParent(ParentNode);
      Result:=ParentNode;
    end;
end;

function TreeGetLevelFirst(TreeView1: TTreeview; lev: integer): TTreeNode;
var
  node1: TTreeNode;
  i: integer;
begin
  //返回指定层上的第一个节点，无则返回空。
  node1:=nil;
  for i:=0 to TreeView1.Items.Count-1 do
    if TreeView1.Items[i].Level = lev then
      begin
        node1:=TreeView1.Items[i];
        break;
      end;
  Result:=node1;
end;

function TreeFindData(TreeView1: TTreeView; FindValue: string; FindLevel: integer): TTreeNode;
var
  node1: TTreeNode;
  find: boolean;
begin
  //查找指定层上节点的Data值，若找到则返回该节点，否则返回空。
  find:=False;
  node1:=TreeGetLevelFirst(TreeView1, Findlevel);
  while node1 <> nil do
    begin
      if (node1.Level = FindLevel) and (node1.Data <> nil) and (PMyRec(node1.Data)^.Code = FindValue) then
        begin
          find:=True;
          break;
        end
      else
        node1:=node1.GetNext;
    end;

  if find then
    Result:=node1
  else
    Result:=nil;
end;

function TreeFindChildData(ParentNode: TTreeNode; FindValue: string): TTreeNode;
var
  node1: TTreeNode;
  find: boolean;
begin
  //查找指定节点的所有子节点的Data值，若找到则返回该节点，否则返回空。
  find:=False;
  node1:=ParentNode.GetFirstChild;
  while node1 <> nil do
    begin
      if (node1.Data <> nil) and (PMyRec(node1.Data)^.Code = FindValue) then
        begin
          find:=True;
          break;
        end
      else
        node1:=node1.GetNextSibling;
    end;

  if find then
    Result:=node1
  else
    Result:=nil;
end;

procedure StringGridSetColWidth(StringGrid1: TStringGrid; const ColWidth: array of integer);
var
  j: integer;
begin
  for j:=low(ColWidth) to high(ColWidth) do
    StringGrid1.ColWidths[j]:=ColWidth[j];
end;

procedure StringGridSetColName(StringGrid1: TStringGrid; const ColName: array of string);
var
  j: integer;
begin
  for j:=low(ColName) to high(ColName) do
    StringGrid1.Cells[j+1,0]:=ColName[j];
end;

procedure StringGridAddRow(StringGrid1: TStringGrid);
var
  j: integer;
begin
  for j:=1 to StringGrid1.ColCount-1 do
    StringGrid1.Cells[j,StringGrid1.RowCount]:='';
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
end;

procedure StringGridDeleteRow(StringGrid1: TStringGrid; row: integer);
var
  i, j: integer;
begin
  for i:=row to StringGrid1.RowCount-1 do
    for j:=1 to StringGrid1.ColCount-1 do
      StringGrid1.Cells[j,i]:=StringGrid1.Cells[j,i+1];
  if StringGrid1.RowCount > 2 then
    StringGrid1.RowCount:=StringGrid1.RowCount-1;
end;

procedure StringGridClear(StringGrid1: TStringGrid);
var
  i, j: integer;
begin
  for i:=1 to StringGrid1.RowCount-1 do
    for j:=1 to StringGrid1.ColCount-1 do
      StringGrid1.Cells[j,i]:='';
  StringGrid1.RowCount:=2;
end;

procedure StringGridDisplay(StringGrid1: TStringGrid; Query1: TQuery);
var
  i,j: integer;
begin
  //将查询结果显示在StringGrid
  StringGridClear(StringGrid1);
  if Query1.IsEmpty then
    Exit;
  Query1.First;

  for i:=0 to Query1.RecordCount-1 do
    begin
      for j:=0 to Query1.FieldCount-1 do
        StringGrid1.Cells[j+1,i+1]:=Query1.Fields[j].AsString;
      Query1.Next;
    end;

  StringGrid1.RowCount:=Query1.RecordCount+1;
end;

procedure CopyStringGrid(srcStringGrid, desStringGrid: TStringGrid);
var
  iRow, iCol: integer;
begin
  for iRow:=1 to srcStringGrid.RowCount do
    for iCol:=1 to srcStringGrid.ColCount do
      desStringGrid.Cells[iCol, iRow]:=srcStringGrid.Cells[iCol, iRow];

  desStringGrid.RowCount:=srcStringGrid.RowCount;
end;

function IsStringGridRowEmpty(StringGrid1: TStringGrid; row: integer): boolean;
var
  j: integer;
begin
  //判断StringGrid的某一行的单元是否全部为空
  Result:=True;
  for j:=1 to StringGrid1.ColCount-1 do
    begin
      if (Trim(StringGrid1.Cells[j,row]) <> '') and (Trim(StringGrid1.Cells[j,row]) <> '-  -') then
        Result:=False;
    end;
end;

procedure DBGridAddCol(DBGrid: TDBGrid; const ColWidth: array of integer; const ColName: array of string);
var
  j: integer;
begin
  DBGrid.Columns.Clear;

  for j:=low(ColName) to high(ColName) do
    begin
      DBGrid.Columns.Add;
      DBGrid.Columns.Items[j].Title.Caption:=ColName[j];
      DBGrid.Columns.Items[j].Width:=ColWidth[j];
    end;
end;

procedure DBGridSetTitle(DBGrid: TDBGrid; const ColWidth: array of integer; const ColName: array of string);
var
  j: integer;
begin
  for j:=low(ColName) to high(ColName) do
    begin
      DBGrid.Columns.Items[j].Title.Caption:=ColName[j];
      DBGrid.Columns.Items[j].Width:=ColWidth[j];
    end;
end;

procedure DBGridSetField(DBGrid: TDBGrid; Query: TQuery);
var
  i: integer;
begin
  for i:=0 to Query.FieldCount-1 do
    DBGrid.Columns.Items[i].Field:=Query.Fields[i];
end;

procedure DBGridSelectAll(DBGrid: TDBGrid);
begin
  with DBGrid do
    if DataSource.DataSet.Active then
      begin
        DataSource.DataSet.First;
        while not DataSource.DataSet.EOF do
          begin
            SelectedRows.CurrentRowSelected:=True;
            DataSource.DataSet.Next;
          end;
      end;
end;

function GetSysDate: TDateTime;
begin
  QueryOpen(dmMain.qrMain, 'select trunc(sysdate) from dual');
  Result:=dmMain.qrMain.Fields[0].Value;
end;

function GetSysDateTime: TDateTime;
begin
  QueryOpen(dmMain.qrMain, 'select sysdate from dual');
  Result:=dmMain.qrMain.Fields[0].Value;
end;

function PosOfArray(const a: array of string; value: string) :integer;
var
  i: integer;
begin
  Result:=-1;
  for i:=Low(a) to High(a) do
    begin
      if a[i] = value then
        begin
          Result:=i;
          break;
        end;
    end;
end;

procedure BlobFieldReadControl(field1: TField; control1: TControl);
var
  Buffer: PChar;
  MemSize: Integer;
  Stream: TBlobStream;
begin
  Stream := TBlobStream.Create(TBlobField(field1), bmRead);
  try
    MemSize := Stream.Size;
    Inc(MemSize); {Make room for the buffer's null terminator.}
    Buffer := AllocMem(MemSize);     {Allocate the memory.}
    try
      Stream.Read(Buffer^, MemSize); {Read Notes field into buffer.}
      control1.SetTextBuf(buffer);
    finally
      FreeMem(Buffer, MemSize);
    end;
  finally
    Stream.Free;
  end;
end;

procedure BlobFieldWrite(field1: TField; s: string);
var
  Stream: TBlobStream;
begin
  Stream := TBlobStream.Create(TBlobField(field1), bmReadWrite);
  try
    Stream.Seek(0, 0);
    Stream.Truncate;
    Stream.Write(s[1], Length(s));
  finally
    Stream.Free;
  end;
end;

function CreateWordApplication(var wrd: variant; IsVisible: boolean): boolean;
const
  NO_WORD = '请先安装Microsoft Word 97。';
begin
  try
    wrd:=GetActiveOleObject('word.application');
  except
    try
      wrd:=CreateOleObject('word.application');
    except
      on EOleSysError do
        begin
          ShowInfo(NO_WORD);
          Result:=False;
          Exit;
        end;
    end;
  end;
  if IsVisible then
    wrd.Visible:=True;
  Result:=True;
end;

function IsTableExist(table_name: string): boolean;
const
  s = 'select count(*) from user_tables where table_name = upper(''%s'')';
begin
  result:=vartostr(QueryValue(format(s, [table_name]))) <> '0';
end;

function CreateExcelApplication(var excel: variant; IsVisible: boolean): boolean;
begin
//  try
//    excel:=GetActiveOleObject('excel.application');
    //excel.quit;
    //excel:=CreateOleObject('excel.application');
//  except
    try
      excel:=CreateOleObject('excel.application');
    except
      ShowInfo('请先安装Excel');
      Result:=False;
      Exit;
    end;
//  end;
  excel.Visible:=IsVisible;
  excel.DisplayAlerts:=False;
  Result:=True;
end;

function AddWorkBook(var excel, workbook: variant): boolean;
begin
  result:=False;

  try
    workbook:=excel.WorkBooks.Add;
  except
    ShowInfo('新建工作簿失败');
    Exit;
  end;

  result:=True;
end;

function AddWorkBook(var excel, workbook: variant; template: string): boolean;
var
  fullname: string;
begin
  result:=False;

  fullname:=GetFullNameOfApp(template);

  try
    workbook:=excel.WorkBooks.Add(fullname);
  except
    ShowInfo(format('找不到模板文件“%s”', [fullname]));
    Exit;
  end;

  result:=True;
end;

function AddWorkBook(var excel, workbook: variant; template, sheetname: string): boolean;
var
  fullname: string;
  template_workbook, template_sheet, sheet: variant;
  i: integer;
begin
  result:=False;

  try
    workbook:=excel.WorkBooks.Add;
    sheet:=workbook.WorkSheets.Item[1];
  except
    ShowInfo('新建工作簿失败');
    Exit;
  end;

  fullname:=GetFullNameOfApp(template);

  try
    template_workbook:=excel.WorkBooks.Open(fullname);
  except
    ShowInfo(format('找不到模板文件“%s”', [fullname]));
    Exit;
  end;

  try
    template_sheet:=template_workbook.WorkSheets.Item[sheetname];
  except
    template_workbook.Close;
    ShowInfo(format('模板“%s”中找不到工作表“%s”', [fullname, sheetname]));
    Exit;
  end;

  try
//    template_sheet.Cells.Copy(sheet.Range['A1']);
    template_sheet.Copy(sheet);
  except
    template_workbook.Close;
    ShowInfo('复制模板工作表失败');
    Exit;
  end;

{  try
    sheet.PageSetup.Orientation:=template_sheet.PageSetup.Orientation;
    sheet.PageSetup.LeftMargin:=template_sheet.PageSetup.LeftMargin;
    sheet.PageSetup.RightMargin:=template_sheet.PageSetup.RightMargin;
    sheet.PageSetup.TopMargin:=template_sheet.PageSetup.TopMargin;
    sheet.PageSetup.BottomMargin:=template_sheet.PageSetup.BottomMargin;
    sheet.PageSetup.HeaderMargin:=template_sheet.PageSetup.HeaderMargin;
    sheet.PageSetup.FooterMargin:=template_sheet.PageSetup.FooterMargin;
  except
  end;

  try
    workbook.Windows.Item[1].Zoom:=75;
  except
  end;}

  template_workbook.Close;
  result:=True;
end;

function DBGridToExcel(ADBGrid: TDBGrid; worksheet: variant): boolean;
var
  i, j: integer;
  bookmark: TBookMark;
begin
  try
    for i:=1 to ADBGrid.FieldCount do
    begin
      if ADBGrid.Columns[i-1].Title.Caption = '' then
      begin
        WorkSheet.Cells[1, i]:=ADBGrid.DataSource.DataSet.FieldByName(
          ADBGrid.Columns[i-1].FieldName).DisplayLabel;
      end
      else
        WorkSheet.Cells[1, i]:=ADBGrid.Columns[i-1].Title.Caption;

      if ADBGrid.DataSource.DataSet.FieldByName(ADBGrid.Columns[i-1].FieldName).DataType
        in [ftString, ftMemo, ftFmtMemo, ftWideString] then
        WorkSheet.Columns.Item[i].NumberFormatLocal:='@';
    end;

    ADBGrid.DataSource.DataSet.DisableControls;
    bookmark:=ADBGrid.DataSource.DataSet.GetBookmark;
    ADBGrid.DataSource.DataSet.First;
    j:=2;
    while not ADBGrid.DataSource.DataSet.EOF do
    begin
      for i:=1 to ADBGrid.FieldCount do
        WorkSheet.Cells[j, i]:=ADBGrid.Fields[i-1].AsString;
      ADBGrid.DataSource.DataSet.Next;
      Inc(j);
    end;
    ADBGrid.DataSource.DataSet.GotoBookMark(bookmark);
    ADBGrid.DataSource.DataSet.FreeBookMark(bookMark);
    ADBGrid.DataSource.DataSet.EnableControls;

    result:=True;
  except
    result:=False;
  end;
end;

function SqlToExcel(ADatabaseName, ASql: string; worksheet: variant): boolean;
var
  i, j: integer;
  qrTemp: TQuery;
begin
  result:=False;

  qrTemp:=TQuery.Create(nil);
  qrTemp.DatabaseName:=ADatabaseName;
  if not QueryOpen(qrTemp, ASql) then
  begin
    ShowInfo('无数据');
    qrTemp.Free;
    Exit;
  end;

  with qrTemp do
  begin
    try
      for i:=1 to FieldCount do
      begin
        WorkSheet.Cells[1, i]:=Fields[i-1].DisplayLabel;

      if Fields[i-1].DataType
        in [ftString, ftMemo, ftFmtMemo, ftWideString] then
        WorkSheet.Columns.Item[i].NumberFormatLocal:='@';
      end;

      First;
      j:=2;
      while not EOF do
      begin
        for i:=1 to FieldCount do
          WorkSheet.Cells[j, i]:=Fields[i-1].AsString;
        Next;
        Inc(j);
      end;

      result:=True;
    except
      result:=False;
    end;
    Free;
  end;
end;

function DataSetToExcel(ADataSet: TDataSet; worksheet: variant): boolean;
var
  i, j: integer;
begin
  result:=False;

  with ADataSet do
    try
      for i:=1 to FieldCount do
      begin
        WorkSheet.Cells[1, i]:=Fields[i-1].DisplayLabel;

      if Fields[i-1].DataType
        in [ftString, ftMemo, ftFmtMemo, ftWideString] then
        WorkSheet.Columns.Item[i].NumberFormatLocal:='@';
      end;

      First;
      j:=2;
      while not EOF do
      begin
        for i:=1 to FieldCount do
          WorkSheet.Cells[j, i]:=Fields[i-1].AsString;
        Next;
        Inc(j);
      end;

      result:=True;
    except
      result:=False;
    end;
end;

function DataSetToExcel(ADataSet: TDataSet; worksheet: variant; FirstRow, FirstCol: integer; ColHead: boolean): boolean;
var
  i, j, r, iCount: integer;
begin
  result:=False;
  r:=FirstRow;

  with ADataSet do
    try
      if ColHead then
      begin
        for i:=1 to FieldCount do
        begin
          WorkSheet.Cells[r, FirstCol+i-1]:=Fields[i-1].DisplayLabel;

        if Fields[i-1].DataType
          in [ftString, ftMemo, ftFmtMemo, ftWideString] then
          WorkSheet.Columns.Item[FirstCol+i-1].NumberFormatLocal:='@';
        end;
        Inc(r);
      end;

      iCount:=RecordCount;
      j:=0;
      First;
      while not EOF do
      begin
        Inc(j);
        if j < iCount then
        begin
          WorkSheet.Rows[r].Insert;
          for i:=1 to FieldCount do
          begin
            WorkSheet.Cells[r, FirstCol+i-1].HorizontalAlignment:=WorkSheet.Cells[r+1, FirstCol+i-1].HorizontalAlignment;
          end;
        end;

        for i:=1 to FieldCount do
          WorkSheet.Cells[r, FirstCol+i-1]:=Fields[i-1].AsString;
        Next;
        Inc(r);
      end;

      result:=True;
    except
      result:=False;
    end;
end;

function GetFullNameOfApp(filename: string): string;
begin
  result:=ExtractFilePath(Application.ExeName);
  if (result <> '') and (copy(result, length(result), 1) <> '\') then
    result:=result+'\';
  result:=result+filename;
end;

end.
