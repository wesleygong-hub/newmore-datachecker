object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #29275#39532#23545#36134#21161#25163
  ClientHeight = 213
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #31561#32447
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 213
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 162
    object btnExport: TButton
      Left = 17
      Top = 153
      Width = 320
      Height = 30
      Caption = #23548#20986#27604#23545#32467#26524
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #31561#32447
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnExportClick
    end
    object grp4: TGroupBox
      Left = 17
      Top = 12
      Width = 559
      Height = 133
      BiDiMode = bdLeftToRight
      Caption = #23548#20837#23545#36134#25968#25454
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #31561#32447
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
      object lbl3: TLabel
        Left = 29
        Top = 30
        Width = 78
        Height = 14
        Caption = #36873#25321#36895#21019#36134#21333
      end
      object Label1: TLabel
        Left = 16
        Top = 57
        Width = 91
        Height = 14
        Caption = #36873#25321#32858#21512#21147#36134#21333
      end
      object btnBrowse: TBitBtn
        Left = 511
        Top = 26
        Width = 36
        Height = 23
        TabOrder = 0
        OnClick = btnBrowseClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
          333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
          0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
          07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
          0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
          B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
          3BB33773333773333773B333333B3333333B7333333733333337}
        NumGlyphs = 2
      end
      object edtScBilling: TEdit
        Left = 112
        Top = 26
        Width = 393
        Height = 22
        ReadOnly = True
        TabOrder = 2
      end
      object edtHrallyBilling: TEdit
        Left = 112
        Top = 53
        Width = 393
        Height = 22
        ReadOnly = True
        TabOrder = 3
      end
      object BitBtn1: TBitBtn
        Left = 511
        Top = 53
        Width = 36
        Height = 23
        TabOrder = 1
        OnClick = BitBtn1Click
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
          333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
          0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
          07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
          0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
          B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
          3BB33773333773333773B333333B3333333B7333333733333337}
        NumGlyphs = 2
      end
      object btnImportThread: TButton
        Left = 14
        Top = 85
        Width = 533
        Height = 36
        Caption = #23548#20837
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #31561#32447
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnImportThreadClick
      end
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 193
      Width = 593
      Height = 19
      Panels = <
        item
          Width = 450
        end
        item
          Alignment = taRightJustify
          Text = 'Build 20260104'
          Width = 50
        end>
      ExplicitTop = 142
    end
    object btnRoll: TButton
      Left = 343
      Top = 153
      Width = 233
      Height = 30
      Caption = 'Roll'#19968#19979#12298#20170#26085#29275#39532#24773#32490#25773#25253#12299
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #31561#32447
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnRollClick
    end
    object btnImport: TButton
      Left = 516
      Top = 210
      Width = 60
      Height = 50
      Caption = #23548#20837
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #31561#32447
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Visible = False
      OnClick = btnImportClick
    end
  end
  object qry_temp: TQuery
    DatabaseName = 'SfscMis'
    Left = 376
  end
  object dlgOpenPath: TOpenDialog
    Left = 536
  end
  object fldrdlgReturnData: TFolderDialog
    Caption = #36873#25321#23548#20837#25991#20214#22841
    DialogX = 0
    DialogY = 0
    Version = '1.0.2.0'
    Left = 568
  end
  object qryAddress: TQuery
    DatabaseName = 'SfscMis'
    SQL.Strings = (
      'select t.addr_code,t.addr_name  from sfsc_sec.sd_oep_address t')
    Left = 472
  end
  object dsAddress: TDataSource
    DataSet = qryAddress
    Left = 504
  end
  object dsCode: TDataSource
    DataSet = qryCode
    Left = 440
  end
  object qryCode: TQuery
    DatabaseName = 'SfscMis'
    Left = 408
  end
end
