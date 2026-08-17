object frm_email: Tfrm_email
  Left = 199
  Top = 128
  Caption = #21457#36865#37038#20214
  ClientHeight = 481
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 553
    Height = 185
    TabOrder = 0
    object Label7: TLabel
      Left = 30
      Top = 55
      Width = 36
      Height = 13
      Caption = #25910#20214#20154
    end
    object Label8: TLabel
      Left = 40
      Top = 79
      Width = 24
      Height = 13
      Caption = #25220#36865
    end
    object Label9: TLabel
      Left = 40
      Top = 104
      Width = 24
      Height = 13
      Caption = #23494#36865
    end
    object Label10: TLabel
      Left = 40
      Top = 147
      Width = 24
      Height = 13
      Caption = #38468#20214
    end
    object Label1: TLabel
      Left = 246
      Top = 31
      Width = 48
      Height = 13
      Caption = #37038#31665#23494#30721
    end
    object Label2: TLabel
      Left = 30
      Top = 31
      Width = 36
      Height = 13
      Caption = #21457#20214#20154
    end
    object EDtoAddress: TEdit
      Left = 83
      Top = 51
      Width = 326
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      TabOrder = 2
    end
    object EDtoCC: TEdit
      Left = 83
      Top = 75
      Width = 326
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      TabOrder = 3
    end
    object EDtoBCC: TEdit
      Left = 83
      Top = 100
      Width = 326
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      TabOrder = 4
    end
    object BTaddAttachments: TButton
      Left = 336
      Top = 128
      Width = 75
      Height = 25
      Caption = #28155#21152
      TabOrder = 5
      OnClick = BTaddAttachmentsClick
    end
    object BTdelAttachments: TButton
      Left = 336
      Top = 152
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 6
      OnClick = BTdelAttachmentsClick
    end
    object BTsend: TButton
      Left = 456
      Top = 129
      Width = 75
      Height = 24
      Caption = #21457#36865
      TabOrder = 7
      OnClick = BTsendClick
    end
    object BBexit: TBitBtn
      Left = 456
      Top = 152
      Width = 75
      Height = 25
      Cancel = True
      Caption = #36864#20986
      TabOrder = 8
      OnClick = BBexitClick
    end
    object EDpassword: TEdit
      Left = 307
      Top = 27
      Width = 102
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      PasswordChar = '*'
      TabOrder = 1
    end
    object EDfromAddress: TEdit
      Left = 83
      Top = 27
      Width = 158
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      TabOrder = 0
    end
    object LV_attachments: TListView
      Left = 83
      Top = 127
      Width = 250
      Height = 49
      Columns = <
        item
          Caption = #25991#20214#21517
          Width = 200
        end>
      TabOrder = 9
      ViewStyle = vsReport
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 185
    Width = 553
    Height = 48
    Caption = 'Panel2'
    TabOrder = 1
    object Label11: TLabel
      Left = 40
      Top = 16
      Width = 24
      Height = 13
      Caption = #20027#39064
    end
    object EDtoSubject: TEdit
      Left = 80
      Top = 12
      Width = 329
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      TabOrder = 0
    end
  end
  object MMmailBody: TMemo
    Left = 0
    Top = 233
    Width = 553
    Height = 224
    ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 463
    Width = 554
    Height = 18
    Panels = <>
    SimplePanel = True
    ExplicitTop = 460
  end
  object OpenDialog1: TOpenDialog
    Left = 480
    Top = 48
  end
  object DS_temp: TDataSource
    DataSet = QR_temp
    Left = 448
    Top = 16
  end
  object QR_temp: TQuery
    DatabaseName = 'SFSCMIS'
    Left = 480
    Top = 16
  end
  object SMTP: TIdSMTP
    OnStatus = SMTPStatus
    SASLMechanisms = <>
    Left = 448
    Top = 48
  end
  object IdMsgSend: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 448
    Top = 80
  end
end
