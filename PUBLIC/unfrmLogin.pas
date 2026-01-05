unit unfrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry, Db, DBTables, Mask, DBCtrls, FileCtrl, Buttons,
  jpeg;

type
  TfrmLogin = class(TForm)
    edUser_Name: TEdit;
    btnCancel: TButton;
    btnEnter: TButton;
    edPassword: TEdit;
    qr_login: TQuery;
    qr_getmail: TQuery;
    SP_getnewpass: TStoredProc;
    qr_newpass: TQuery;
    M_body: TMemo;
    M_null: TMemo;
    SP_IsNextMonthMode: TStoredProc;
    sbtnCancel: TSpeedButton;
    sbtnLogin: TSpeedButton;
    Image1: TImage;
    Label1: TLabel;
    L_resetpass: TLabel;
    qryTemp: TQuery;
    procedure btnEnterClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure L_resetpassClick(Sender: TObject);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    IsLogOn: boolean;

    procedure WMnCHitTest(var M: tWMnCHitTest); message WM_nCHittest;
  public
    { Public declarations }
    function LogOn: boolean;
    procedure CreateDmme;
    procedure pubFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

type
  TCurUser = record
    User_Id, User_Name, Password, Sec_Pass, Name, Grp_Id, Grp_Name, Title, City_no, Is_Indept, Sfsc_code: string;
  end;

  TArrayId = record
    Count: integer;
    Id: array[0..100] of string;
  end;

  TCodeName = record
    Code, Name: string;
  end;

var
  frmLogin: TfrmLogin;

function GetRootDir: string;
function GetBinFileDir: string;
function GetIniFileDir: string;
function GetCurUser: TCurUser;
function GetNameByUser(userid: string): string;
function GetMatesByUser(userid: string): TArrayId;
function GetDeptByUser(userid: string): string;
function GetRolesByUser(userid: string): TArrayId;
function GetUsersByDept(grpid: string): TArrayId;
function GetUsersByRole(roleid: string): TArrayId;
function IsValidApp(userid: string; appid: string): boolean;
function IsCurDepartHead(user_name, password: string): boolean;
function IsValidRole(user_id, role_id: string): boolean;
function IsValidComp(user_id: string; company: string): boolean; //商社是否属于该用户
procedure ClearCurUser;
function SetCurUser(cGrp_Id,cGrp_name,cSfsc_code,cIS_INDEPT,cCity_no:string):boolean;  // 只修改 部门ID, 部门名称,账套
procedure PubAppException(Sender: TObject; E: Exception);
function IsNextMonthMode: Boolean; //是否当月收下月模式
function Get_Privilege_Sql(const Headquarter_App, Dept_App, Dept_Field, Comp_Field, User_Dept, User_id, Is_Indept :string):string; //返回权限查询条件
function IsValidPrivilege(const Headquarter_App, Dept_App, Dept_No, Company_No, User_Dept, User_id, Is_Indept :string):boolean; //多实体权限判断

implementation

uses unDmMain, unlib, unconsts, rsa, rsa_sh,undmMe;

{$R *.DFM}

const
  LoginCaption = '登录';
  FailLogin = '登录失败。';
  ReInput = '登录失败，请重新输入。';
  DEPART_HEAD = '科长';

var
  CurUser: TCurUser;
  FailTime: integer;
  dmMe: TdmMe;
procedure TfrmLogin.CreateDmme;
begin
  if dmMe = nil then
    dmMe := TdmMe.Create(nil);
end;

function IsValidComp(user_id: string; company: string): boolean;
begin //商社是否属于该用户
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select company_no'
      + ' from fs_client '
      + ' where sales = ''' + user_id + ''''
      + ' and company_no = ''' + company + '''');
    Open;
    if IsEmpty then
      Result := False
    else
      Result := True;
    Close;
  end;
end;

function GetRootDir: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  with reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('software\sfsc', True);
    Result := ReadString('RootDir');
    CloseKey;
  end;
  if Result = '' then
    Result := '..\'
  else
  begin
    if copy(Result, Length(Result), 1) <> '\' then
      Result := Result + '\';
  end;
end;

function GetBinFileDir: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  with reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('software\sfsc', True);
    Result := ReadString('BinDir');
    CloseKey;
  end;
  if Result = '' then
    Result := GetRootDir + 'bin\';
end;

function GetIniFileDir: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  with reg do
  begin
    OpenKey('software\sfsc', True);
    Result := ReadString('IniDir');
    CloseKey;
  end;
  if Result = '' then
    Result := GetRootDir + 'ini\';
end;

function GetDocFileDir: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  with reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('software\sfsc', True);
    Result := ReadString('DocDir');
    CloseKey;
  end;
  if Result = '' then
    Result := GetRootDir + 'doc\';
end;

function GetCurUser: TCurUser;
begin
  Result.User_Id := CurUser.User_Id;
  Result.User_Name := CurUser.User_Name;
  Result.Password := CurUser.Password;
  Result.Sec_Pass:=CurUser.Sec_Pass;
  Result.Name := CurUser.Name;
  Result.Grp_Id := CurUser.Grp_Id;
  Result.Grp_name := CurUser.Grp_Name;
  Result.Title := CurUser.Title;
  Result.City_no := CurUser.City_no;
  Result.Is_Indept:=CurUser.Is_Indept;
  Result.Sfsc_code := CurUser.Sfsc_code;
end;

function GetNameByUser(userid: string): string;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select name from fs_users'
      + ' where user_id = ''' + userid + '''');
    Open;
    Result := Fields[0].AsString;
    Close;
  end;
end;

function GetMatesByUser(userid: string): TArrayId;
var
  i: integer;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select user_id from fs_users'
      + ' where user_id <> ''' + userid + ''''
      + ' and group_id = '
      + ' (select group_id from fs_users'
      + ' where user_id = ''' + userid + ''')');
    Open;

    Result.Count := RecordCount;
    for i := 0 to RecordCount - 1 do
    begin
      Result.Id[i] := Fields[0].AsString;
      Next;
    end;
    Close;
  end;
end;

function GetDeptByUser(userid: string): string;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select group_id from fs_users'
      + ' where user_id = ''' + userid + '''');
    Open;
    Result := Fields[0].AsString;
    Close;
  end;
end;

function GetRolesByUser(userid: string): TArrayId;
var
  i: integer;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select role_id from fs_roleusr'
      + ' where user_id = ''' + userid + '''');
    Open;

    Result.Count := RecordCount;
    for i := 0 to RecordCount - 1 do
    begin
      Result.Id[i] := Fields[0].AsString;
      Next;
    end;
    Close;
  end;
end;

function GetUsersByDept(grpid: string): TArrayId;
var
  i: integer;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select user_id from fs_users'
      + ' where group_id = ''' + grpid + '''');
    Open;

    Result.Count := RecordCount;
    for i := 0 to RecordCount - 1 do
    begin
      Result.Id[i] := Fields[0].AsString;
      Next;
    end;
    Close;
  end;
end;

function GetUsersByRole(roleid: string): TArrayId;
var
  i: integer;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select user_id from fs_roleusr'
      + ' where role_id = ''' + roleid + '''');
    Open;

    Result.Count := RecordCount;
    for i := 0 to RecordCount - 1 do
    begin
      Result.Id[i] := Fields[0].AsString;
      Next;
    end;
    Close;
  end;
end;

function IsValidApp(userid: string; appid: string): boolean;
var qryTemp : TQuery;
begin
  qryTemp:=TQuery.Create(Application);
  try
    with qryTemp do
    begin
      DatabaseName := 'SfscMis';
      SQL.Text:='select sfsc.wf_public.IsValidApp('''+userid+''','''+appid+''') from dual';
      Open;
      Result:=Fields[0].AsInteger=1;
    end;
  finally
    qryTemp.Free;
  end;
end;

function IsCurDepartHead(user_name, password: string): boolean;
begin //是否当前用户的科长
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select u.user_id from fs_users u, fs_roles r, fs_roleusr ru'
      + ' where upper(u.user_name) = upper(''' + user_name + ''')'
      + ' and u.password = '''+password+''''
      + ' and r.role_name = ''' + DEPART_HEAD + ''''
      + ' and u.group_id = ''' + GetCurUser.Grp_Id + ''''
      + ' and r.role_id = ru.role_id'
      + ' and ru.user_id = u.user_id');
    Open;

    if IsEmpty then
      Result := False
    else
      Result := True;
    Close;
  end;
end;

function IsValidRole(user_id, role_id: string): boolean;
var qryTemp : TQuery;
begin
  qryTemp:=TQuery.Create(Application);
  try
    with qryTemp do
    begin
      DatabaseName := 'SfscMis';
      SQL.Text:='select sfsc.wf_public.IsValidRole('''+user_id+''','''+role_id+''') from dual';
      Open;
      Result:=Fields[0].AsInteger=1;
    end;
  finally
    qryTemp.Free;
  end;
end;

procedure ClearCurUser;
begin
  CurUser.User_id := '';
  CurUser.User_Name := '';
  CurUser.Password := '';
  CurUser.Sec_Pass := '';
  CurUser.Name := '';
  CurUser.Grp_id := '';
  CurUser.Grp_Name := '';
  CurUser.Title := '';
  CurUser.City_no := '';
  CurUser.Is_Indept := '';
  CurUser.Sfsc_code := '';
end;

function SetCurUser(cGrp_Id,cGrp_name,cSfsc_code,cIs_Indept,cCity_no:string):boolean;
begin
    CurUser.Grp_id := cGrp_Id;
    CurUser.Grp_Name := cGrp_name;
    CurUser.Sfsc_code := cSfsc_code;
    CurUser.Is_Indept:=cIs_Indept;
    CurUser.City_no := cCity_no;
    result:=True;
end;

function TfrmLogin.LogOn: boolean;
begin
  ShowModal;
  Result := IsLogOn;
end;

procedure TfrmLogin.btnEnterClick(Sender: TObject);
var user_name, password: string;
begin
  //modify by blue 2007-5-14
  user_name := uppercase(Trim(edUser_Name.Text));
  if user_name = '' then
  begin
    Application.MessageBox('请输入用户名！', LoginCaption, MB_OK);
    edUser_Name.SetFocus;
    exit;
  end;
  password := uppercase(Trim(edPassword.Text));
  if password = '' then
  begin
    Application.MessageBox('请输入密码！', LoginCaption, MB_OK);
    edPassword.SetFocus;
    exit;
  end;
  if Query_Value('sfscMis','select count(1) from sfsc.fs_fincsys ') = 1 then
    password := rsa.RSAstring(password)
  else
    password := rsa_sh.RSAstring(password);

  btnEnter.Cursor := crSQLWait;
  qr_login.Close;
  qr_login.ParamByName('user_name').asstring := user_name;
  qr_login.ParamByName('password').asstring := password;
  qr_login.Open;
  btnEnter.Cursor := crDefault;
  //  if dmMain.qrMain.IsEmpty then

  if qr_login.Eof then
  begin
    FailTime := FailTime + 1;
    if FailTime < 3 then
    begin
      Application.MessageBox(ReInput, LoginCaption, MB_OK);
    end
    else
    begin
      Application.MessageBox(FailLogin, LoginCaption, MB_OK);
      IsLogOn := False;
      Close;
    end;
  end
  else
  begin
    with qr_login do
    begin
      CurUser.User_Name := UpperCase(Trim(edUser_Name.Text));
      CurUser.Password := uppercase(Trim(edPassword.Text));
      CurUser.User_Id := Fields[0].AsString;
      CurUser.Name := Fields[1].AsString;
      CurUser.Grp_Id := Fields[2].AsString;
      CurUser.Grp_Name := Fields[3].AsString;
      CurUser.Title := Fields[5].AsString;
      CurUser.City_no := Fields[9].AsString;
      CurUser.Sfsc_code := Fields[10].AsString;
      CurUser.Is_Indept := Fieldbyname('Is_Indept').AsString;
      CurUser.Sec_Pass :=Fieldbyname('sec_pass').asstring;
    end;
    IsLogOn := True;

    if qr_login.Fieldbyname('months').asfloat > 6 then
    begin
      Application.MessageBox('密码过期，请去‘调派程序’进行修改。', LoginCaption, MB_OK);
      application.Terminate;
    end;
    if qr_login.Fieldbyname('months').asfloat > 5.5 then
      Application.MessageBox('密码即将过期，请及时修改', LoginCaption, MB_OK);
    Close;
    ShowMessage('全体工作人员注意：本系统内所有信息均为公司秘密（包括但不限于雇员个人信息，客户信息等）'
      + '，请按照公司规定严格履行保密义务，严禁违规对外泄露。'
      + '如有违反将按《员工手册》、《保密条例（试行）》等相关规定严肃处理。');
  end;
end;

procedure TfrmLogin.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (edPassword.Text <> '') then
    sbtnLogin.Click;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  IsLogOn := False;
  Close;
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  edPassword.Clear;
  FailTime := 0;
end;

procedure PubAppException(Sender: TObject; E: Exception);
begin
  if e is eDbEditError then
  begin
    if (Sender is TCustomMaskEdit) then
      if ClearMaskText(Sender) then Exit;
    e.Message := msg008;
  end
  else
    if (e is EDatabaseError) and (pos('must have a value', e.message) > 0) then
      e.Message := msg010;
  Application.ShowException(E);
end;

procedure TfrmLogin.pubFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Tmpobj: TObject;
begin
  if Sender is Tform then Tmpobj := TForm(Sender).Activecontrol else Tmpobj := Sender;

  if (key = VK_DELETE) then
  begin
    if (Tmpobj is TDBLookupComboBox)
      and not TDBLookupComboBox(Tmpobj).Readonly
      and not TDBLookupComboBox(Tmpobj).ListVisible
      then
      with TDBLookupComboBox(Tmpobj) do
        if not assigned(Field) then keyValue := null
        else if Field.CanModify then
        begin
          if not (Field.DataSet.State in [dsEdit, dsinsert]) then Field.DataSet.Edit;
          Field.Clear;
        end;
    if (Tmpobj is TDBComboBox) and not TDBComboBox(Tmpobj).Readonly then
      with TDBComboBox(Tmpobj) do
        if assigned(Field) and Field.CanModify then
        begin
          if not (Field.DataSet.State in [dsEdit, dsinsert]) then Field.DataSet.Edit;
          Field.Clear;
        end;
  end;

end;

procedure TfrmLogin.L_resetpassClick(Sender: TObject);
var
  user_name: string;
  newpass: string;
  v_error: string;
begin
  if Query_Value('sfscMis','select count(1) from sfsc.fs_fincsys ') > 1 then
  begin
    Application.MessageBox('请到全国速创中重置密码！', LoginCaption, MB_OK);
    Exit;
  end;
  user_name := uppercase(Trim(edUser_Name.Text));
  if user_name = '' then
  begin
    Application.MessageBox('请输入用户名！', LoginCaption, MB_OK);
    edUser_Name.SetFocus;
    exit;
  end;
  if MessageDlg('确认要重置密码?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    qr_getmail.Close;
    qr_getmail.ParamByName('user_name').asstring := user_name;
    qr_getmail.Open;
    if qr_getmail.eof then
    begin
      Application.MessageBox('对不起，不存在该用户名，无法产生新密码！', LoginCaption, MB_OK);
      exit;
    end;
    if (trim(qr_getmail.FieldByName('email').asstring) = '') or (pos('@', qr_getmail.FieldByName('email').asstring) = 0) then
    begin
      Application.MessageBox('对不起，系统无法获得您的Email信箱地址，请联系系统管理员！', LoginCaption, MB_OK);
      exit;
    end;
    //        IdMsgSend.Recipients.EMailAddresses:=qr_getmail.FieldByName('email').asstring;
    //        IdMsgSend.Recipients.EMailAddresses:=qr_getmail.FieldByName('email').asstring;

    SP_getnewpass.close;
    SP_getnewpass.ParamByName('NI_DIGIT').asinteger := 6;
    SP_getnewpass.ExecProc;
    newpass := uppercase(SP_getnewpass.ParamByName('Result').asstring);
    M_body.clear;
    M_body.Lines.Add('您的MIS系统的密码被重置为 ' + newpass);
    M_null.clear;
    v_error := send_email('MIS系统的密码重置', M_body, 'intranet@efesco.com', 'sfsc0926', qr_getmail.FieldByName('email').asstring, '', '', M_null);

    if v_error <> '' then
    begin
      Application.MessageBox('密码发送失败，请与系统管理员联系。', LoginCaption, MB_OK);
      exit;
    end;
    qr_newpass.close;
    qr_newpass.ParamByName('user_id').asstring := qr_getmail.FieldByName('user_id').asstring;
    qr_newpass.ParamByName('password').asstring := rsa.rsastring(newpass);

    qr_newpass.ExecSQL;
    query_exec('sfscmis', 'commit');
    qr_newpass.close;
    qr_getmail.Close;

    Application.MessageBox('密码已发送至您的EMAIL信箱。', LoginCaption, MB_OK);
  end;
end;

function IsNextMonthMode: boolean;
begin
  with dmMain.qrTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select fun_is_next_month_mode result from dual');
    Open;
    if FieldByName('result').AsString = '1' then
      Result := True
    else
      Result := False;
    Close;
  end;
end;

procedure TfrmLogin.WMnCHitTest(var M: tWMnCHitTest);
var P, p1, p2, p3, p4, p5, p6: TPoint;
begin
  inherited;
  //if m. then
  //if m. then
  // if m. then

  P := Point(m.XPos, m.YPos);
  p1 := Point(sbtnLogin.Left, sbtnLogin.Top);
  p2 := Point(sbtnLogin.Left + sbtnLogin.Width, sbtnLogin.Top + sbtnLogin.Height);
  p3 := Point(sbtnCancel.Left, sbtnCancel.Top);
  p4 := Point(sbtnCancel.Left + sbtnCancel.Width, sbtnCancel.Top + sbtnCancel.Height);
  p := ScreenToClient(P);
  p5 := Point(L_resetpass.Left, L_resetpass.Top);
  p6 := Point(L_resetpass.Left + L_resetpass.Width, L_resetpass.Top + L_resetpass.Height);
  // Button1.Left := P.x;
  // Button1.Top := p.Y;
  if (p.X >= p1.X) and (P.Y >= p1.Y) and (p.X <= p2.X) and (p.Y <= p2.Y) then // 登录按钮除外
  else if (p.X >= p3.X) and (P.Y >= p3.Y) and (p.X <= p4.X) and (p.Y <= p4.Y) then // 取消登录按钮除外
  else if (p.X >= p5.X) and (P.Y >= p5.Y) and (p.X <= p6.X) and (p.Y <= p6.Y) then // 密码重置按钮除外
  else if M.Result = HTCLient then
    M.result := htCaption;
end;

function Get_Privilege_Sql(const Headquarter_App, Dept_App, Dept_Field, Comp_Field, User_Dept, User_id, Is_Indept :string):string; //返回权限查询条件
var qryTemp : TQuery;
begin
  if IsValidApp(User_id, Headquarter_App) then
  begin
     Result:=' ';
     qryTemp:=TQuery.Create(Application);
     try
       with qryTemp do
       begin
         DatabaseName:='SFSCMIS';
         SQL.Text:='select 1 from fs_apps where is_entity_limit=1 and app_id='+QuotedStr(Headquarter_App);
         Open;
         if Not Eof then
         begin
            Result:=' and (select nvl(is_indept,0) from fs_depts where grp_id='+Dept_Field+')='+Is_Indept+' ';
         end;
       end;
     finally
       qryTemp.Free;
     end;
  end
  else begin
     if IsValidApp(User_id, Dept_App) then
     begin
        Result:=' and '+Dept_Field+'='+QuotedStr(User_Dept)+' ';
     end
     else begin
        Result:=' and sfsc.wf_public.IsValidGroup('+QuotedStr(User_id)+','+Comp_Field+')=1 ';
     end;
  end;
end;

function IsValidPrivilege(const Headquarter_App, Dept_App, Dept_No, Company_No, User_Dept, User_id, Is_Indept :string):boolean; //多账套权限判断
var qryTemp : TQuery;
begin
  if IsValidApp(User_id, Headquarter_App) then
  begin
     Result:=true;
     qryTemp:=TQuery.Create(Application);
     try
       with qryTemp do
       begin
         DatabaseName:='SFSCMIS';
         SQL.Text:='select 1 from fs_apps where is_entity_limit=1 and app_id='+QuotedStr(Headquarter_App);
         Open;
         if Not Eof then
         begin
            Close;
            SQL.Text:='select nvl(is_indept,0) from fs_depts where grp_id='+QuotedStr(Dept_No);
            Open;
            Result:=Fields[0].AsString=Is_Indept;
         end;
       end;
     finally
       qryTemp.Free;
     end;
  end
  else begin
     if IsValidApp(User_id, Dept_App) then
     begin
        Result:=Dept_No=User_Dept;
     end
     else begin
        Result:=IsValidGroup(User_id, Company_no);
     end;
  end;
end;

end.

