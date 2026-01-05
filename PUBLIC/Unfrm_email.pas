unit Unfrm_email;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, {Psock, NMsmtp, NMpop3,} Db,DBTables,
  IdBaseComponent,IdMessage, IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient,
  IdSMTP, ImgList, IdExplicitTLSClientServerBase, IdSMTPBase, IdAttachmentFile,IdText;

type
  Tfrm_email = class(TForm)
    Panel1: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EDtoAddress: TEdit;
    EDtoCC: TEdit;
    EDtoBCC: TEdit;
    BTaddAttachments: TButton;
    BTdelAttachments: TButton;
    BTsend: TButton;
    BBexit: TBitBtn;
    Panel2: TPanel;
    Label11: TLabel;
    EDtoSubject: TEdit;
    MMmailBody: TMemo;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    EDpassword: TEdit;
    Label2: TLabel;
    EDfromAddress: TEdit;
    DS_temp: TDataSource;
    QR_temp: TQuery;
    SMTP: TIdSMTP;
    IdMsgSend: TIdMessage;
    LV_attachments: TListView;
    procedure BTaddAttachmentsClick(Sender: TObject);
    procedure BTdelAttachmentsClick(Sender: TObject);
    procedure BBexitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTsendClick(Sender: TObject);
    procedure SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
  private
    { Private declarations }
  public
     v_error:string;
    procedure ResetAttachmentListView;
    { Public declarations }
  end;

var
  frm_email: Tfrm_email;

implementation
uses
  unlib,unpub_sfsc,unfrmLogin,unDmMain,unConsts;
{$R *.DFM}

procedure Tfrm_email.BTaddAttachmentsClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
      begin
//         TIdAttachment.Create(IdMsgSend.MessageParts, OpenDialog1.FileName);
//         TIdAttachment should NO LONGER be used. Use IdAttachmentFile or IdAttachmentFile instead.
         TIdAttachmentFile.Create(IdMsgSend.MessageParts, OpenDialog1.FileName);
         ResetAttachmentListView;
      end;
end;

procedure Tfrm_email.ResetAttachmentListView;
var li: TListItem;
   idx: Integer;
begin
   LV_attachments.Items.Clear;
   for idx := 0 to Pred(IdMsgSend.MessageParts.Count) do
      begin
         li := LV_attachments.Items.Add;
         if IdMsgSend.MessageParts.Items[idx] is TIdAttachmentFile then
            begin
               li.ImageIndex := 0;
               li.Caption := TIdAttachmentFile(IdMsgSend.MessageParts.Items[idx]).Filename;
               li.SubItems.Add(TIdAttachmentFile(IdMsgSend.MessageParts.Items[idx]).ContentType);
            end
         else
            begin
               li.ImageIndex := 1;
               li.Caption := IdMsgSend.MessageParts.Items[idx].ContentType;
            end;
      end;
end;


procedure Tfrm_email.BTdelAttachmentsClick(Sender: TObject);
begin
  LV_attachments.Items.Delete(LV_attachments.Selected.Index);
end;

procedure Tfrm_email.BBexitClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_email.FormShow(Sender: TObject);
var
  s_sql : string;
begin
  s_sql := 'select * from fs_users where user_id = '''+GetCurUser.User_Id+'''';
  Query_open(QR_temp,s_sql);
  EDfromAddress.Text := QR_temp.fieldbyname('email').asstring;
end;

procedure Tfrm_email.BTsendClick(Sender: TObject);
var
  total_send, fail_send, success_flag, i, j : integer;
begin
  if pos('@',trim(EDfromAddress.Text)) = 0 then
  begin
    v_error:='发件人的Email地址不正确！!';
    showmessage('发件人的Email地址不正确！');
    Exit;
  end;
  if pos('@',trim(EDtoAddress.Text)) = 0 then
  begin
     v_error:='收件人的Email地址不正确！!';
    showmessage('收件人的Email地址不正确！');
    Exit;
  end;
  j := 0;
  for i := 1 to length(trim(EDfromAddress.Text)) do
  begin
    if (copy(trim(EDfromAddress.Text),i,1) = '@') and (j = 0) then
      j := i;
  end;
  with IdMsgSend do
  begin
    Body.Assign(MMmailBody.Lines);
    From.Text := copy(trim(EDfromAddress.Text),1,j-1);
    From.Address := trim(EDfromAddress.Text);
    //ReplyTo.EMailAddresses := trim(EDfromAddress.Text);
    Recipients.EMailAddresses := trim(EDtoAddress.Text); { To: header }
    Subject := EDtoSubject.Text; { Subject: header }
    CCList.EMailAddresses := EDtoCC.Text; {CC}
    BccList.EMailAddresses := EDtoBCC.Text; {BBC}
    {authentication settings}
    SMTP.Username := copy(trim(EDfromAddress.Text),1,j-1);
    SMTP.Password := EDpassword.Text;
    {General setup}
    SMTP.Host := 'mail.efesco.com';
    SMTP.Port := 25;
    {now we send the message}
    SMTP.Connect;
    try
      try
        SMTP.Send(IdMsgSend);
        v_error:='';
      except
        v_error:='发送错误!';

        showmessage('发送错误！');
      end;
    finally
      SMTP.Disconnect;
    end;
  end;
end;

procedure Tfrm_email.SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
  StatusBar1.SimpleText := AStatusText;
end;

end.
