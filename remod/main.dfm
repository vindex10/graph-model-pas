object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 629
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnPaint = FormPaint
  OnShow = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 562
    Top = 8
    Width = 185
    Height = 105
    Caption = #1054#1073#1077#1088#1110#1090#1100' '#1076#1110#1102
    ItemIndex = 0
    Items.Strings = (
      #1044#1086#1076#1072#1090#1080'\'#1042#1080#1076#1072#1083#1080#1090#1080' '#1074#1077#1088#1096#1080#1085#1091
      #1055#1077#1088#1077#1089#1091#1085#1091#1090#1080' '#1074#1077#1088#1096#1080#1085#1091
      #1044#1086#1076#1072#1090#1080'\'#1042#1080#1076#1072#1083#1080#1090#1080' '#1088#1077#1073#1088#1086
      #1056#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103)
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 562
    Top = 152
    Width = 185
    Height = 105
    Caption = #1042#1083#1072#1089#1090#1080#1074#1086#1089#1090#1110' '#1074#1077#1088#1096#1080#1085#1080
    TabOrder = 1
    object Label1: TLabel
      Left = 19
      Top = 24
      Width = 24
      Height = 16
      Caption = #1030#1084#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 49
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = #1053#1086#1074#1072' '#1042#1077#1088#1096#1080#1085#1072
    end
    object Button1: TButton
      Left = 96
      Top = 72
      Width = 75
      Height = 25
      Caption = #1042#1080#1076#1072#1083#1080#1090#1080
      TabOrder = 1
      Visible = False
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 562
    Top = 280
    Width = 185
    Height = 105
    Caption = #1042#1083#1072#1089#1090#1080#1074#1086#1089#1090#1110' '#1088#1077#1073#1088#1072
    TabOrder = 2
    Visible = False
    object Label2: TLabel
      Left = 19
      Top = 32
      Width = 31
      Height = 16
      Caption = #1042#1072#1075#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CheckBox1: TCheckBox
      Left = 17
      Top = 54
      Width = 88
      Height = 17
      Caption = #1054#1088#1110#1108#1085#1090#1086#1074#1072#1085#1077
      TabOrder = 0
    end
    object Button2: TButton
      Left = 15
      Top = 77
      Width = 75
      Height = 25
      Caption = #1030#1085#1074#1077#1088#1090#1091#1074#1072#1090#1080
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 96
      Top = 77
      Width = 75
      Height = 25
      Caption = #1042#1080#1076#1072#1083#1080#1090#1080
      TabOrder = 2
      Visible = False
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 56
      Top = 27
      Width = 89
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object UpDown1: TUpDown
      Left = 151
      Top = 24
      Width = 17
      Height = 25
      TabOrder = 4
      OnClick = UpDown1Click
    end
  end
end
