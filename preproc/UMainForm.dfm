object MainForm: TMainForm
  Left = 79
  Top = 12
  BorderStyle = bsSingle
  Caption = #1047#1072#1076#1072#1085#1080#1077' '#1085#1072#1095#1072#1083#1100#1085#1099#1093' '#1091#1089#1083#1086#1074#1080#1081' '#1080' '#1087#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1086#1073#1083#1072#1089#1090#1077#1081
  ClientHeight = 632
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    792
    632)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 772
    Height = 523
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
  end
  object Label1: TLabel
    Left = 458
    Top = 550
    Width = 19
    Height = 13
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'X:'
  end
  object Label2: TLabel
    Left = 458
    Top = 574
    Width = 19
    Height = 13
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Y:'
  end
  object Label3: TLabel
    Left = 353
    Top = 550
    Width = 36
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1058#1086#1095#1082#1072' :'
  end
  object Label4: TLabel
    Left = 249
    Top = 550
    Width = 46
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1088#1077#1079#1086#1082':'
  end
  object Label5: TLabel
    Left = 352
    Top = 573
    Width = 53
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1052#1072#1090#1077#1088#1080#1072#1083':'
  end
  object Label6: TLabel
    Left = 616
    Top = 549
    Width = 62
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1084#1077#1090#1082#1072' '#1090#1086#1095#1082#1080
  end
  object Label7: TLabel
    Left = 160
    Top = 583
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'F'
  end
  object Label8: TLabel
    Left = 616
    Top = 573
    Width = 75
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1084#1077#1090#1082#1072' '#1086#1090#1088#1077#1079#1082#1072
  end
  object ZoomIn: TBitBtn
    Left = 104
    Top = 546
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    TabStop = False
    OnClick = ZoomInClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9EC000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000
      00000000000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9EC000000000000000000D8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC000000000000000000000000000000D8E9EC0000000000000000
      00D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000000000FF9933FF9933FF9933FF
      9933000000000000000000000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000
      FFCC99FF9933FFCC99FFCC99FFCC99FFCC99FF9933FF9933000000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9EC000000FFCC99FFFFCCFFFFCC000000000000FF
      FFCCFFCC99FF9933000000000000D8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFF
      FFFFCCFFFFCCFFFFCC000000000000FFFFCCFFFFCCFFFFCCFF9933000000D8E9
      ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFFFCC00000000000000000000000000
      0000000000FFFFCCFF9933000000D8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFF
      FFFFCC000000000000000000000000000000000000FFFFCCFF9933000000D8E9
      ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFCC99FFFFCCFFFFCC000000000000FF
      FFCCFFFFCCFFFFCCFF9933000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000
      FFFFFFFFCC99FFFFCC000000000000FFFFCCFFCC99FFCC99000000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFFFFFFFCC99FFCC99FFCC99FF
      CC99FFFFFFFFFFFF000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000D8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00000000000000000000
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object ZoomOut: TBitBtn
    Left = 16
    Top = 546
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    TabStop = False
    OnClick = ZoomOutClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9EC000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000
      00000000000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9EC000000000000000000D8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC000000000000000000000000000000D8E9EC0000000000000000
      00D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000000000FF9933FF9933FF9933FF
      9933000000000000000000000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000
      FFCC99FF9933FFCC99FFCC99FFCC99FFCC99FF9933FF9933000000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9EC000000FFCC99FFFFCCFFFFCCFFFFCCFFFFCCFF
      FFCCFFCC99FF9933000000000000D8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFF
      FFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFF9933000000D8E9
      ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFFFCC00000000000000000000000000
      0000000000FFFFCCFF9933000000D8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFF
      FFFFCC000000000000000000000000000000000000FFFFCCFF9933000000D8E9
      ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFCC99FFFFCCFFFFCCFFFFCCFFFFCCFF
      FFCCFFFFCCFFFFCCFF9933000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000
      FFFFFFFFCC99FFFFCCFFFFCCFFFFCCFFFFCCFFCC99FFCC99000000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9EC000000FFFFFFFFFFFFFFCC99FFCC99FFCC99FF
      CC99FFFFFFFFFFFF000000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000D8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00000000000000000000
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object ToLeft: TBitBtn
    Left = 104
    Top = 578
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    TabStop = False
    OnClick = ToLeftClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000800000800000800000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080000080000080
      0000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000
      8000008000008000008000008000008000008000008000008000008000008000
      00D8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080000080000080
      0000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000800000800000800000D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object ToRight: TBitBtn
    Left = 16
    Top = 578
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    TabStop = False
    OnClick = ToRightClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080
      0000800000800000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9EC
      8000008000008000008000008000008000008000008000008000008000008000
      00800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080
      0000800000800000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80
      0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object ToUp: TBitBtn
    Left = 48
    Top = 578
    Width = 49
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    TabStop = False
    OnClick = ToUpClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9EC800000800000800000800000800000D8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080
      0000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9EC800000800000800000800000800000800000800000800000800000D8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080000080
      0000800000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object ToDown: TBitBtn
    Left = 48
    Top = 546
    Width = 49
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    TabStop = False
    OnClick = ToDownClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC800000800000800000D8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080000080000080
      0000800000800000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9EC800000800000800000800000800000800000800000800000800000D8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080000080000080
      0000800000800000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9EC800000800000800000800000800000D8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC80000080
      0000800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC800000D8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object SB: TStatusBar
    Left = 0
    Top = 613
    Width = 792
    Height = 19
    Panels = <
      item
        Text = #1058#1086#1095#1077#1082': 0'
        Width = 100
      end
      item
        Text = #1054#1090#1088#1077#1079#1082#1086#1074': 0'
        Width = 100
      end
      item
        Text = #1052#1077#1090#1086#1082': 0'
        Width = 100
      end
      item
        Text = 'X:'
        Width = 150
      end
      item
        Text = 'Y:'
        Width = 50
      end>
  end
  object Edit1: TEdit
    Left = 480
    Top = 546
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 480
    Top = 570
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 8
    OnKeyPress = Edit2KeyPress
  end
  object edtNowPoint: TEdit
    Left = 408
    Top = 546
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    OnKeyPress = edtNowPointKeyPress
  end
  object Edit4: TEdit
    Left = 296
    Top = 546
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    OnKeyPress = edtNowPointKeyPress
  end
  object Edit5: TEdit
    Left = 248
    Top = 578
    Width = 41
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 11
    OnKeyPress = edtNowPointKeyPress
  end
  object Edit6: TEdit
    Left = 296
    Top = 578
    Width = 41
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 12
    OnKeyPress = edtNowPointKeyPress
  end
  object Edit7: TEdit
    Left = 408
    Top = 570
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 13
    OnKeyPress = Edit7KeyPress
  end
  object edtNowPointMark: TEdit
    Left = 736
    Top = 546
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 14
    OnKeyPress = edtNowPointMarkKeyPress
  end
  object Edit9: TEdit
    Left = 184
    Top = 578
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 15
    OnKeyPress = Edit9KeyPress
  end
  object edtNowSideMark: TEdit
    Left = 736
    Top = 570
    Width = 41
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    TabOrder = 16
    OnKeyPress = edtNowSideMarkKeyPress
  end
  object MainMenu1: TMainMenu
    Left = 544
    Top = 16
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N4Click
      end
    end
    object N8: TMenuItem
      Caption = #1044#1072#1085#1085#1099#1077
      object N9: TMenuItem
        Caption = #1047#1072#1076#1072#1085#1080#1077' '#1090#1086#1095#1077#1082
        Checked = True
        RadioItem = True
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1047#1072#1076#1072#1085#1080#1077' '#1086#1090#1088#1077#1079#1082#1086#1074
        RadioItem = True
        OnClick = N10Click
      end
      object N11: TMenuItem
        Caption = #1047#1072#1076#1072#1085#1080#1077' '#1084#1077#1090#1086#1082
        RadioItem = True
        OnClick = N11Click
      end
      object D1: TMenuItem
        Caption = #1047#1072#1076#1072#1085#1080#1077' '#1090#1077#1085#1079#1086#1088#1072' D'
        OnClick = D1Click
      end
    end
    object N12: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100
      object N13: TMenuItem
        Caption = #1058#1086#1095#1082#1080
        Checked = True
        OnClick = N13Click
      end
      object N17: TMenuItem
        Caption = #1053#1086#1084#1077#1088#1072' '#1090#1086#1095#1077#1082
        Checked = True
        OnClick = N17Click
      end
      object N14: TMenuItem
        Caption = #1054#1090#1088#1077#1079#1082#1080
        Checked = True
        OnClick = N14Click
      end
      object N18: TMenuItem
        Caption = #1053#1086#1084#1077#1088#1072' '#1086#1090#1088#1077#1079#1082#1086#1074
        OnClick = N18Click
      end
      object N15: TMenuItem
        Caption = #1052#1077#1090#1082#1080
        Checked = True
        OnClick = N15Click
      end
      object N19: TMenuItem
        Caption = #1053#1086#1084#1077#1088#1072' '#1084#1077#1090#1086#1082
        Checked = True
        OnClick = N19Click
      end
    end
    object N5: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      object N6: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = #1050#1072#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103'?'
        Visible = False
      end
      object N16: TMenuItem
        Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1088#1080#1089#1091#1085#1086#1082
        OnClick = N16Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'd'
    Filter = #1060#1072#1081#1083#1099' '#1089' '#1076#1072#1085#1085#1099#1084#1080'|*.d'
    InitialDir = '.'
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Left = 544
    Top = 48
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'd'
    Filter = #1060#1072#1081#1083#1099' '#1089' '#1076#1072#1085#1085#1099#1084#1080'|*.d'
    InitialDir = '.'
    Title = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    Left = 544
    Top = 80
  end
end