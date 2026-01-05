object Frm_cc_unitcode: TFrm_cc_unitcode
  Left = 0
  Top = 0
  Caption = #35831#36873#25321#21333#20301#36134#21495
  ClientHeight = 247
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 463
    Height = 206
    Align = alClient
    Caption = #36873#25321#21333#20301#36134#21495
    TabOrder = 0
    object dbgrdh1: TDBGridEh
      Left = 2
      Top = 15
      Width = 459
      Height = 189
      Align = alClient
      DataSource = ds_CCoepacc
      Flat = False
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dbgrdh1DblClick
      OnKeyPress = dbgrdh1KeyPress
      Columns = <
        item
          EditButtons = <>
          FieldName = 'UNIT_CODE'
          Footers = <>
          Title.Caption = #21333#20301#36134#21495
          Width = 89
        end
        item
          EditButtons = <>
          FieldName = 'UNIT_NAME'
          Footers = <>
          Title.Caption = #21333#20301#21517#31216
          Width = 106
        end
        item
          EditButtons = <>
          FieldName = 'ADDR_NAME'
          Footers = <>
          Title.Caption = #25237#20445#22320#28857
          Width = 110
        end
        item
          EditButtons = <>
          FieldName = 'ACC_YM'
          Footers = <>
          Title.Caption = #31038#20445#24180#26376
          Width = 73
        end
        item
          EditButtons = <>
          FieldName = 'ORGAN_NUM'
          Footers = <>
          Title.Caption = #20844#21496#20195#30721
        end
        item
          EditButtons = <>
          FieldName = 'DIST_NAME'
          Footers = <>
          Title.Caption = #21306#21439
        end
        item
          EditButtons = <>
          FieldName = 'USER_NAME'
          Footers = <>
          Title.Caption = #36127#36131#20154
        end
        item
          EditButtons = <>
          FieldName = 'UNIT_CODE_OLD'
          Footers = <>
          Title.Caption = #26087#31038#20445#36134#21495
          Width = 88
        end
        item
          EditButtons = <>
          FieldName = 'UNIT_TYPE'
          Footers = <>
          KeyList.Strings = (
            '1'
            '2')
          PickList.Strings = (
            #22823#30424
            #23567#30424)
          Title.Caption = #36134#25143#31867#22411
          Width = 59
        end
        item
          EditButtons = <>
          FieldName = 'PROC_FLAG'
          Footers = <>
          KeyList.Strings = (
            '0'
            '1')
          PickList.Strings = (
            #24320#36134
            #23553#24080)
          Title.Caption = #36134#21495#29366#24577
        end>
    end
  end
  object pnlpan1: TPanel
    Left = 0
    Top = 206
    Width = 463
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btn_ok: TButton
      Left = 104
      Top = 11
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_Cancel: TButton
      Left = 248
      Top = 11
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = btn_CancelClick
    end
  end
  object qry_ccOepacc: TQuery
    DatabaseName = 'sfscMis'
    SQL.Strings = (
      'select u.*,'
      
        '(select addr_name from sfsc_sec.SD_OEP_ADDRESS d where u.addr_co' +
        'de=d.addr_code  )as addr_name,'
      
        '(select n.name from sfsc.fs_users n  where u.manage_user=n.user_' +
        'id ) as user_name,'
      
        '(select t.name from dr_district t where t.NO=u.district  )as dis' +
        't_name from sfsc.sd_unitid u')
    Left = 184
    Top = 112
    object strngfld_ccOepaccUNIT_CODE: TStringField
      FieldName = 'UNIT_CODE'
      Size = 30
    end
    object strngfld_ccOepaccUNIT_NAME: TStringField
      FieldName = 'UNIT_NAME'
      Size = 100
    end
    object strngfld_ccOepaccUNIT_CODE_OLD: TStringField
      FieldName = 'UNIT_CODE_OLD'
      Size = 30
    end
    object strngfld_ccOepaccADDR_CODE: TStringField
      FieldName = 'ADDR_CODE'
      Size = 2
    end
    object strngfld_ccOepaccACC_YM: TStringField
      FieldName = 'ACC_YM'
      Size = 6
    end
    object fltfld_ccOepaccPROC_FLAG: TFloatField
      FieldName = 'PROC_FLAG'
    end
    object fltfld_ccOepaccMONTH_FLAG: TFloatField
      FieldName = 'MONTH_FLAG'
    end
    object strngfld_ccOepaccORGAN_NUM: TStringField
      FieldName = 'ORGAN_NUM'
      Size = 10
    end
    object strngfld_ccOepaccUNIT_TYPE: TStringField
      FieldName = 'UNIT_TYPE'
      Size = 1
    end
    object fltfld_ccOepaccDISTRICT: TFloatField
      FieldName = 'DISTRICT'
    end
    object strngfld_ccOepaccMANAGE_USER: TStringField
      FieldName = 'MANAGE_USER'
      Size = 6
    end
    object fltfld_ccOepaccIS_VALID: TFloatField
      FieldName = 'IS_VALID'
    end
    object strngfld_ccOepaccADDR_NAME: TStringField
      FieldName = 'ADDR_NAME'
      Size = 16
    end
    object strngfld_ccOepaccUSER_NAME: TStringField
      FieldName = 'USER_NAME'
      Size = 8
    end
    object strngfld_ccOepaccDIST_NAME: TStringField
      FieldName = 'DIST_NAME'
      Size = 8
    end
  end
  object ds_CCoepacc: TDataSource
    DataSet = qry_ccOepacc
    Left = 216
    Top = 112
  end
end
