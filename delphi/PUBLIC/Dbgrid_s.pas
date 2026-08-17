
{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{                                                       }
{       Copyright (c) 1995,97 Borland International     }
{                                                       }
{*******************************************************}
unit Dbgrid_s;

{$R-}

interface

uses
 Windows, SysUtils, Variants, Messages, Classes, Controls, Forms, StdCtrls,
  Graphics, Grids, DBCtrls, Db,dbgrids,Menus,Registry{,dbugintf};

type
  TColumn_Value = (cvColor, cvWidth, cvFont, cvAlignment, cvReadOnly, cvTitleColor,
    cvTitleCaption, cvTitleAlignment, cvTitleFont, cvImeMode, cvImeName, cvWordWrap, cvLookupDisplayFields);
  TColumn_Values = set of TColumn_Value;

  TColumn_RestoreParam = (crpColIndexEh,crpColWidthsEh,crpSortMarkerEh);
  TColumn_RestoreParams = set of TColumn_RestoreParam;






const
  Column_TitleValues = [cvTitleColor..cvTitleFont];
{  cm_DeferLayout = WM_USER + 100;}

{ TColumn_ defines internal storage for column attributes.  Values assigned
  to properties are stored in this object, the grid- or field-based default
  sources are not modified.  Values read from properties are the previously
  assigned value, if any, or the grid- or field-based default values if
  nothing has been assigned to that property. This class also publishes the
  column attribute properties for persistent storage.  }

type
  TColumn_ = class;
  TCustomDBGrid_ = class;

  TSortMarker_ = (smNone, smDown, smUp);

  TColumnTitle_ = class(TPersistent)
  private
    FColumn: TColumn_;
    FCaption: string;
    FFont: TFont;
    FColor: TColor;
    FAlignment: TAlignment;
    //ddd
    FEndEllipsis: Boolean;
    //\\\
    procedure FontChanged(Sender: TObject);
    function GetAlignment: TAlignment;
    function GetColor: TColor;
    function GetCaption: string;
    function GetFont: TFont;
    function IsAlignmentStored: Boolean;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    function IsCaptionStored: Boolean;
    procedure SetAlignment(Value: TAlignment);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetCaption(const Value: string); virtual;
    procedure SetEndEllipsis(const Value: Boolean);
  protected
    //ddd
    FTitleButton: Boolean;
    FSortMarker: TSortMarker_;
    procedure SetTitleButton(Value: Boolean);
    procedure SetSortMarker(Value: TSortMarker_);
    //\\\
    procedure RefreshDefaultFont;
  public
    constructor Create(Column: TColumn_);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function DefaultAlignment: TAlignment;
    function DefaultColor: TColor;
    function DefaultFont: TFont;
    function DefaultCaption: string;
    procedure RestoreDefaults; virtual;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment stored IsAlignmentStored;
    property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property Color: TColor read GetColor write SetColor stored IsColorStored;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    //ddd
    property TitleButton: Boolean read FTitleButton write SetTitleButton;
    property SortMarker: TSortMarker_ read FSortMarker write SetSortMarker;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis;
    //\\\
  end;
{
  //ddd
  TFooterValueType = (fvtNon,fvtSum,fvtCount,fvtFieldValue,fvtStaticText);

  TColumnFooterEh = class(TPersistent)
  private
    FColumn: TColumnEH;
    FFont: TFont;
    FColor: TColor;
    FAlignment: TAlignment;
    FEndEllipsis: Boolean;
    FValue:String;
    FFieldName: string;
    FValueType: TFooterValueType;
    FWordWrap: Boolean;
    procedure FontChanged(Sender: TObject);
    function GetAlignment: TAlignment;
    function GetColor: TColor;
    function GetFont: TFont;
    function IsAlignmentStored: Boolean;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    procedure SetAlignment(Value: TAlignment);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetEndEllipsis(const Value: Boolean);
    procedure SetFieldName(const Value: String);
    procedure SetValueType(const Value: TFooterValueType);
    procedure SetValue(const Value: String);
    procedure SetWordWrap(const Value: Boolean);
  protected
    procedure RefreshDefaultFont;
  public
    constructor Create(Column: TColumnEH);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function DefaultAlignment: TAlignment;
    function DefaultColor: TColor;
    function DefaultFont: TFont;
    procedure RestoreDefaults; virtual;
    property Column: TColumnEH read FColumn;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment stored IsAlignmentStored;
    property Color: TColor read GetColor write SetColor stored IsColorStored;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis;
    property ValueType: TFooterValueType read FValueType write SetValueType;
    property FieldName: String read FFieldName write SetFieldName;
    property Value: String read FValue write SetValue;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
  end;
  //\\\

  //ddd
  TColumnEhType = (ctCommon, ctPickList, ctLookupField, ctKeyPickList, ctKeyImageList);
  //\\\

}

  TColumn_ = class(TCollectionItem)
  private
    FField: TField;
    FFieldName: string;
    FColor: TColor;
    FWidth: Integer;
    FTitle: TColumnTitle_;
    FFont: TFont;
    FImeMode: TImeMode;
    FImeName: TImeName;
    FPickList: TStrings;
    FPopupMenu: TPopupMenu;
    FDropDownRows: integer;
    FButtonStyle: TColumnButtonStyle;
    FAlignment: TAlignment;
    FReadonly: Boolean;
    FAssignedValues: TColumn_Values;
    FKeyList: TStrings;
    FImageList: TImageList;
    FNotInKeyListIndex: Integer;

{
        //ddd
    FKeyList: TStrings;
    FImageList: TImageList;
    FNotInKeyListIndex: Integer;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FNotInWidthRange:Boolean;
    //\\\

 }
    procedure FontChanged(Sender: TObject);
    function  GetAlignment: TAlignment;
    function  GetColor: TColor;
    function  GetField: TField;
    function  GetFont: TFont;
    function  GetImeMode: TImeMode;
    function  GetImeName: TImeName;
    function  GetPickList: TStrings;
    function  GetReadOnly: Boolean;
    function  GetWidth: Integer;
    function  IsAlignmentStored: Boolean;
    function  IsColorStored: Boolean;
    function  IsFontStored: Boolean;
    function  IsImeModeStored: Boolean;
    function  IsImeNameStored: Boolean;
    function  IsReadOnlyStored: Boolean;
    function  IsWidthStored: Boolean;
    procedure SetAlignment(Value: TAlignment); virtual;
    procedure SetButtonStyle(Value: TColumnButtonStyle);
    procedure SetColor(Value: TColor);
    procedure SetField(Value: TField); virtual;
    procedure SetFieldName(const Value: String);
    procedure SetFont(Value: TFont);
    procedure SetImeMode(Value: TImeMode); virtual;
    procedure SetImeName(Value: TImeName); virtual;
    procedure SetPickList(Value: TStrings);
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetTitle(Value: TColumnTitle_);
    procedure SetWidth(Value: Integer); virtual;

    procedure SetKeykList(const Value: TStrings);
    procedure SetNotInKeyListIndex(Value: Integer);
    procedure SetImageList(const  Value: TImageList);
    function GetKeykList: TStrings;


    {
     //ddd
    procedure SetFooter(const Value: TColumnFooterEH);
    procedure SetVisible(const Value: Boolean);
    function GetKeykList: TStrings;
    procedure SetKeykList(const Value: TStrings);
    procedure SetNotInKeyListIndex(const Value: Integer);
    procedure SetImageList(const Value: TImageList);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    //\\\

    }

  protected
//ddd
    FInitWidth:Integer;
    FAutoFitColWidth:Boolean;
    FWordWrap:Boolean;
    FEndEllipsis: Boolean;
    FDropDownWidth: Integer;
    FLookupDisplayFields:String;
    FAlwaysShowEditButton: Boolean;
    FAutoDropDown: Boolean;
    function  GetAutoFitColWidth: Boolean;
    function  GetLookupDisplayFields: String;
    function  GetWordWrap: Boolean;
    function  IsWordWrapStored: Boolean;
    function  IsLookupDisplayFieldsStored: Boolean;
    function  DefaultLookupDisplayFields: String;
    function  DefaultWordWrap: Boolean;
    procedure SetAlwaysShowEditButton(Value: Boolean);
    procedure SetAutoDropDown(Value: Boolean);
    procedure SetAutoFitColWidth(Value: Boolean); virtual;
    procedure SetWordWrap(Value: Boolean); virtual;
    procedure SetLookupDisplayFields(Value:String); virtual;
    procedure SetDropDownWidth(Value: Integer);
    procedure SetEndEllipsis(const Value: Boolean);
//\\\
{
    function  CreateFooter: TColumnFooterEH; virtual;
    function  GetColumnType: TColumnEhType;
    procedure SetNextFieldValue(GoForward: Boolean);
    function  CanModify(TryEdit:Boolean):Boolean;
    function  AllowableWidth(TryWidth:Integer):Integer;
//\\\

}


    function  CreateTitle: TColumnTitle_; virtual;
    function  GetGrid: TCustomDBGrid_;
    function  GetDisplayName: string; override;
    procedure RefreshDefaultFont;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  DefaultAlignment: TAlignment;
    function  DefaultColor: TColor;
    function  DefaultFont: TFont;
    function  DefaultImeMode: TImeMode;
    function  DefaultImeName: TImeName;
    function  DefaultReadOnly: Boolean;
    function  DefaultWidth: Integer;
    procedure RestoreDefaults; virtual;
    property  Grid: TCustomDBGrid_ read GetGrid;
    property  AssignedValues: TColumn_Values read FAssignedValues;
    property  Field: TField read GetField write SetField;
  published
    property  Alignment: TAlignment read GetAlignment write SetAlignment
      stored IsAlignmentStored;
    property  ButtonStyle: TColumnButtonStyle read FButtonStyle write SetButtonStyle
      default cbsAuto;
    property  Color: TColor read GetColor write SetColor stored IsColorStored;
    property  DropDownRows: integer read FDropDownRows write FDropDownRows default 7;
    property  FieldName: String read FFieldName write SetFieldName;
    property  Font: TFont read GetFont write SetFont stored IsFontStored;
    property  ImeMode: TImeMode read GetImeMode write SetImeMode stored IsImeModeStored;
    property  ImeName: TImeName read GetImeName write SetImeName stored IsImeNameStored;
    property  PickList: TStrings read GetPickList write SetPickList;
    property  PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property  ReadOnly: Boolean read GetReadOnly write SetReadOnly
      stored IsReadOnlyStored;
    property  Title: TColumnTitle_ read FTitle write SetTitle;
    property  Width: Integer read GetWidth write SetWidth stored IsWidthStored;
    //ddd
    property  AlwaysShowEditButton: Boolean read FAlwaysShowEditButton write SetAlwaysShowEditButton;
    property  AutoFitColWidth: Boolean read GetAutoFitColWidth write SetAutoFitColWidth default True;
    property  WordWrap: Boolean read GetWordWrap write SetWordWrap stored IsWordWrapStored;
    property  EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis;
    property  DropDownWidth: Integer read FDropDownWidth write SetDropDownWidth;
    property  LookupDisplayFields: String read GetLookupDisplayFields write SetLookupDisplayFields stored IsLookupDisplayFieldsStored;
    property  AutoDropDown: Boolean read FAutoDropDown write SetAutoDropDown;
    property  KeyList: TStrings read GetKeykList write SetKeykList;
    property  ImageList: TImageList read FImageList write SetImageList;
    property  NotInKeyListIndex: Integer read FNotInKeyListIndex write SetNotInKeyListIndex default -1;



    {
     property  Footer: TColumnFooterEH read FFooter write SetFooter;
    property  Visible: Boolean read FVisible write SetVisible default True;
    property  KeyList: TStrings read GetKeykList write SetKeykList;
    property  ImageList: TImageList read FImageList write SetImageList;
    property  NotInKeyListIndex: Integer read FNotInKeyListIndex write SetNotInKeyListIndex default -1;
    property  MinWidth: Integer read FMinWidth write SetMinWidth;
    property  MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    }
    //\\\
  end;

  TColumn_Class = class of TColumn_;


  TDBGridColumns_ = class(TCollection)
  private
    FGrid: TCustomDBGrid_;
    function GetColumn(Index: Integer): TColumn_;
    function GetState: TDBGridColumnsState;
    procedure SetColumn(Index: Integer; Value: TColumn_);
    procedure SetState(NewState: TDBGridColumnsState);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Grid: TCustomDBGrid_; ColumnClass: TColumn_Class);
    function  Add: TColumn_;
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromStream(S: TStream);
    procedure RestoreDefaults;
    procedure RebuildColumns;
    procedure SaveToFile(const Filename: string);
    procedure SaveToStream(S: TStream);
    property State: TDBGridColumnsState read GetState write SetState;
    property Grid: TCustomDBGrid_ read FGrid;
    property Items[Index: Integer]: TColumn_ read GetColumn write SetColumn; default;
    {
    //ddd
    function  ExistFooterValueType(AFooterValueType:TFooterValueType):Boolean;
    //\\\

    }
  end;


  {
    //ddd
  TDBGridVisibleColumnsEh = class(TList)
  private
    function GetColumn(Index: Integer): TColumnEH;
    procedure SetColumn(Index: Integer; const Value: TColumnEH);
  public
    property Items[Index: Integer]: TColumnEH read GetColumn write SetColumn; default;
  end;
  //\\\


  }
  TGridDataLink_ = class(TDataLink)
  private
    FGrid: TCustomDBGrid_;
    FFieldCount: Integer;
    FFieldMapSize: Integer;
    FFieldMap: Pointer;
    FModified: Boolean;
    FInUpdateData: Boolean;
    FSparseMap: Boolean;
    function GetDefaultFields: Boolean;
    function GetFields(I: Integer): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
    function  GetMappedIndex(ColIndex: Integer): Integer;
  public
    constructor Create(AGrid: TCustomDBGrid_);
    destructor Destroy; override;
    function AddMapping(const FieldName: string): Boolean;
    procedure ClearMapping;
    procedure Modified;
    procedure Reset;
    property DefaultFields: Boolean read GetDefaultFields;
    property FieldCount: Integer read FFieldCount;
    property Fields[I: Integer]: TField read GetFields;
    property SparseMap: Boolean read FSparseMap write FSparseMap;
  end;

  TBookmarkList_ = class
  private
    FList: TStringList;
    FGrid: TCustomDBGrid_;
    FCache: TBookmarkStr;
    FCacheIndex: Integer;
    FCacheFind: Boolean;
    FLinkActive: Boolean;
    function GetCount: Integer;
    function GetCurrentRowSelected: Boolean;
    function GetItem(Index: Integer): TBookmarkStr;
    procedure SetCurrentRowSelected(Value: Boolean);
    procedure StringsChanged(Sender: TObject);
  protected
    function CurrentRow: TBookmarkStr;
    function Compare(const Item1, Item2: TBookmarkStr): Integer;
    procedure LinkActive(Value: Boolean);
  public
    constructor Create(AGrid: TCustomDBGrid_);
    destructor Destroy; override;
    procedure Clear;           // free all bookmarks
    procedure Delete;          // delete all selected rows from dataset
    function  Find(const Item: TBookmarkStr; var Index: Integer): Boolean;
    function  IndexOf(const Item: TBookmarkStr): Integer;
    function  Refresh: Boolean;// drop orphaned bookmarks; True = orphans found
    property Count: Integer read GetCount;
    property CurrentRowSelected: Boolean read GetCurrentRowSelected
      write SetCurrentRowSelected;
    property Items[Index: Integer]: TBookmarkStr read GetItem; default;
  end;


// For MultiTitle

  THeadTreeNode = class;
  TDBGrid_ = class;

  LeafCol = record
    FLeaf:THeadTreeNode;
    FColumn:TColumn_;
  end;

  PLeafCol = ^LeafCol;
  TLeafCol = array[0..MaxListSize - 1] of LeafCol;
  PTLeafCol = ^TLeafCol;


{  THeadTreeNode }

  THeadTreeProc = procedure (node:THeadTreeNode) of object;
  THeadTreeNode = class(TObject) // new
  public
    Host:THeadTreeNode;
    Child:THeadTreeNode;
    Next:THeadTreeNode;
    Text:String;
    Height:Integer;
    Width:Integer;
    WIndent:Integer;
    Drawed:Boolean;
    constructor Create;
    constructor CreateText(AText:String;AHeight,AWidth:Integer);
    destructor Destroy; override;
    function Add(AAfter:THeadTreeNode;AText:String;AHeight,AWidth:Integer):THeadTreeNode ;
    function AddChild(ANode:THeadTreeNode;AText:String;AHeight,AWidth:Integer):THeadTreeNode ;
    function Find(ANode:THeadTreeNode):Boolean;
    procedure Union(AFrom,ATo :THeadTreeNode; AText:String;AHeight:Integer);
    procedure FreeAllChild;
    procedure CreateFieldTree(AGrid:TCustomDBGrid_);
    procedure DoForAllNode(proc:THeadTreeProc);
  end;


// For TCustomDBGrid_

(*  TDBGridOption = (dgEditing], dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect,
    dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect);
  TDBGrid_Options = set of TDBGridOption; *)

  { The DBGrid's DrawDataCell virtual method and OnDrawDataCell event are only
    called when the grid's Columns.State is csDefault.  This is for compatibility
    with existing code. These routines don't provide sufficient information to
    determine which column is being drawn, so the column attributes aren't
    easily accessible in these routines.  Column attributes also introduce the
    possibility that a column's field may be nil, which would break existing
    DrawDataCell code.   DrawDataCell, OnDrawDataCell, and DefaultDrawDataCell
    are obsolete, retained for compatibility purposes. }
(*  TDrawDataCellEvent = procedure (Sender: TObject; const Rect: TRect; Field: TField;
    State: TGridDrawState) of object; *)

  { The DBGrid's DrawColumnCell virtual method and OnDrawColumnCell event are
    always called, when the grid has defined column attributes as well as when
    it is in default mode.  These new routines provide the additional
    information needed to access the column attributes for the cell being
    drawn, and must support nil fields.  }

  TDrawColumn_CellEvent = procedure (Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn_; State: TGridDrawState) of object;
  TDBGrid_ClickEvent = procedure (Column: TColumn_) of object;
   TDBGrid_DblClickEvent = procedure (Column: TColumn_) of object;

  TDrawFooterCellEvent = procedure (Sender: TObject; DataCol, Row: Longint;
    Column: TColumn_; Rect: TRect; State: TGridDrawState) of object;

  TTitle_ClickEvent = procedure (Sender: TObject; ACol: Longint;
    Column: TColumn_) of object;
  TCheckTitleEHBtnEvent = procedure (Sender: TObject; ACol: Longint;
    Column: TColumn_; var Enabled: Boolean) of object;
  TGetBtn_ParamsEvent = procedure (Sender: TObject; Column: TColumn_;
    AFont: TFont; var Background: TColor; var SortMarker: TSortMarker_;
    IsDown: Boolean) of object;
  TGetCell_ParamsEvent = procedure (Sender: TObject; Column: TColumn_;
    AFont: TFont; var Background: TColor; State: TGridDrawState) of object;

  TDBGrid_Option = (dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColumnResize,dgColumnMove,dgColLines, dgRowLines, dgTabs, dgRowSelect,
    dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect);
  TDBGrid_Options = set of TDBGrid_Option;



  TCustomDBGrid_ = class(TCustomGrid)
  private
    FIndicators: TImageList;
    FTitleFont: TFont;
    FReadOnly: Boolean;
    FOriginalImeName: TImeName;
    FOriginalImeMode: TImeMode;
    FUserChange: Boolean;
    FLayoutFromDataset: Boolean;
    FOptions: TDBGrid_Options;
    FTitleOffset, FIndicatorOffset: Byte;
    FUpdateLock: Byte;
    FLayoutLock: Byte;
    FInColExit: Boolean;
    FDefaultDrawing: Boolean;
    FSelfChangingTitleFont: Boolean;
    FSelecting: Boolean;
    FSelRow: Integer;
    FDataLink: TGridDataLink_;
    FOnColEnter: TNotifyEvent;
    FOnColExit: TNotifyEvent;
    FOnDrawDataCell: TDrawDataCellEvent;
    FOnDrawColumnCell: TDrawColumn_CellEvent;
    FEditText: string;
    FColumns: TDBGridColumns_;
    FOnEditButtonClick: TNotifyEvent;
    FOnColumnMoved: TMovedEvent;
    FBookmarks: TBookmarkList_;
    FSelectionAnchor: TBookmarkStr;
    FOnCellClick: TDBGrid_ClickEvent;
    FOnCellDblClick: TDBGrid_DblClickEvent;
    FOnTitleClick:TDBGrid_ClickEvent;
    FOnGetCellParams: TGetCell_ParamsEvent;
    FOnGetFootCellParams: TGetCell_ParamsEvent;

    {
     //ddd
    FOnGetFooterParams: TGetFooterParamsEvent;
    FOnSumListRecalcAll: TNotifyEvent;
    FHorzScrollBar: TDBGridEhScrollBar;
    FVertScrollBar: TDBGridEhScrollBar;
    FOptionsEh: TDBGridEhOptions;
    FEditKeyValue: Variant; // For lookup fields and KeyList based column
    ThumbTracked:Boolean;
    //\\\


     }
    function  FindStringsIndex(_Strings:TStrings;FindText:String;DefatultIndex,MaxIndex:integer):integer;
    function  imgListVal:Boolean;
    function isImagList:boolean;
    function AcquireFocus: Boolean;
    procedure DataChanged;
    procedure EditingChanged;
    function GetDataSource: TDataSource;
    function GetFieldCount: Integer;
    function GetFields(FieldIndex: Integer): TField;
    function GetSelectedField: TField;
    function GetSelectedIndex: Integer;
    procedure InternalLayout;
    procedure MoveCol(RawCol: Integer);
    procedure ReadColumns(Reader: TReader);
    procedure RecordChanged(Field: TField);
    procedure SetIme;
    procedure SetColumns(Value: TDBGridColumns_);
    procedure SetDataSource(Value: TDataSource);
    procedure SetOptions(Value: TDBGrid_Options);
    procedure SetSelectedField(Value: TField);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetTitleFont(Value: TFont);
    procedure TitleFontChanged(Sender: TObject);
    procedure UpdateData;
    procedure UpdateActive;
    procedure UpdateIme;
    procedure UpdateScrollBar;
    procedure UpdateRowCount;
    procedure WriteColumns(Writer: TWriter);
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMDeferLayout(var Message); message cm_DeferLayout;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMIMEStartComp(var Message: TMessage); message WM_IME_STARTCOMPOSITION;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SetFOCUS;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure SetDrawMemoText(const Value: Boolean);
    {
     procedure SetSumList(const Value: TDBGridEhSumList);
    procedure SetHorzScrollBar(const Value: TDBGridEhScrollBar);
    procedure SetVertScrollBar(const Value: TDBGridEhScrollBar);
    procedure SetOptionsEh(const Value: TDBGridEhOptions);
    //ddd
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    //\\\

    }
  protected

    FUpdateFields: Boolean;
    FAcquireFocus: Boolean;
    FUpdatingEditor: Boolean;


    //ddd
    FTitleHeight: Integer;
    FTitleLines: Integer;
    FTitleHeightFull: Integer;

    FMarginText:Boolean;
    FVTitleMargin: Integer;
    FHTitleMargin: Integer;
    FUseMultiTitle: Boolean;

    FAutoFitColWidths:Boolean;
    FMinAutoFitWidth:Integer;
    FInitColWidth:TList;

    FFooterRowCount: Integer;
    FOnDrawFotterCell:TDrawFooterCellEvent;

    FHeadTree:THeadTreeNode;
    FLeafFieldArr:PTLeafCol;
    FNewRowsHeight: Integer;
    FRowLines: Integer;
    FRowSizingAllowed : Boolean;
    FDefaultRowChanged: Boolean;
    FAllowWordWrap: Boolean; // True if RowsHeight + 3 > TextHeight
    FDrawMemoText: Boolean;
    FSortMarkerImages:TImageList;
    FPressedCol: Longint;
    FPressed: Boolean;
    FTracking: Boolean;
    FSwapButtons: Boolean;
    FOnCheckButton: TCheckTitleEHBtnEvent;
    FOnGetBtnParams: TGetBtn_ParamsEvent;
    FOnTitleBtnClick: TTitle_ClickEvent;
    FInplaceEditorButtonWidth: Integer;
    FFrozenCols: Integer;
    //

    procedure Paint;override; //


    function  GetFooterRowCount: Integer;
    procedure SetFooterRowCount(Value: Integer);

    procedure ClearPainted(node:THeadTreeNode);
    function SetChildTreeHeight(ANode:THeadTreeNode):Integer;

    function  ReadTitleHeight: Integer;
    procedure WriteTitleHeight(th: Integer);
    function  ReadTitleLines: Integer;
    procedure WriteTitleLines(tl: Integer);

    procedure WriteMarginText(IsMargin:Boolean);
    procedure WriteVTitleMargin(Value: Integer);
    procedure WriteHTitleMargin(Value: Integer);
    procedure WriteUseMultiTitle(Value:Boolean);

    procedure WriteAutoFitColWidths(Value:Boolean);
    procedure WriteMinAutoFitWidth(Value:Integer);

    function GetColWidths(Index: Longint): Integer;
    procedure SetColWidths(Index: Longint; Value: Integer);

    procedure SetRowSizingAllowed(Value:Boolean);

    function  GetRowsHeight: Integer;
    procedure SetRowsHeight(Value: Integer);

    function  GetRowLines: Integer;
    procedure SetRowLines(Value: Integer);

    procedure RowHeightsChanged; override;
    function  StdDefaultRowHeight: Integer;

    procedure StopTracking;
    procedure TrackButton(X, Y: Integer);
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure DoTitleClick(ACol: Longint; AColumn: TColumn_); dynamic;
    procedure CheckTitleButton(ACol: Longint; var Enabled: Boolean); dynamic;
    procedure GetCellParams(Column: TColumn_; AFont: TFont; var Background: TColor;
      State: TGridDrawState ); dynamic;
    procedure GetFootCellParams(Column: TColumn_; AFont: TFont; var Background: TColor;
      State: TGridDrawState ); dynamic;

    procedure SetFrozenCols(Value: Integer);
    {
      procedure EnsureFooterValueType(AFooterValueType:TFooterValueType; AFieldName:String);
    procedure SumListChanged(Sender: TObject);
    procedure SumListRecalcAll(Sender: TObject);
    procedure GetFooterParams(DataCol, Row: Longint; Column: TColumnEH; AFont: TFont;
      var Background: TColor; var Alignment : TAlignment; State: TGridDrawState; var Text:String); dynamic;
    function  CanEditModifyText: Boolean;
    function  VisibleDataRowCount: Integer;
//\\\

    }

//\\\
    function  RawToDataColumn(ACol: Integer): Integer;
    function  DataToRawColumn(ACol: Integer): Integer;
    function  AcquireLayoutLock: Boolean;
    procedure BeginLayout;
    procedure BeginUpdate;
    procedure CancelLayout;
    function  CanEditAcceptKey(Key: Char): Boolean; override;
    function  CanEditModify: Boolean; override;
    function  CanEditShow: Boolean; override;
    procedure CellClick(Column: TColumn_); dynamic;
    procedure CellDblClick(Column: TColumn_); dynamic;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;

    procedure ColEnter; dynamic;
    procedure ColExit; dynamic;
    procedure ColWidthsChanged; override;
    function  CreateColumns: TDBGridColumns_; dynamic;
    function  CreateEditor: TInplaceEdit; override;
    procedure CreateWnd; override;
    procedure DeferLayout;

    procedure DefaultHandler(var Msg); override;

    procedure DefineFieldMap; virtual;
    procedure DefineProperties(Filer: TFiler); override;
    //ddd
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    //\\\

    {
      //ddd   procedure DefaultHandler(var Msg); override;
    procedure DefineFieldMap; virtual;
    procedure DefineProperties(Filer: TFiler); override;

    }
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); dynamic; { obsolete }
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn_; State: TGridDrawState); dynamic;
    procedure EditButtonClick; dynamic;
    procedure EndLayout;
    procedure EndUpdate;
    function  GetColField(DataCol: Integer): TField;
    function  GetEditLimit: Integer; override;
    function  GetEditMask(ACol, ARow: Longint): string; override;
    function  GetEditText(ACol, ARow: Longint): string; override;
    function  GetFieldValue(ACol: Integer): string;
    function  HighlightCell(DataCol, DataRow: Integer; const Value: string;
      AState: TGridDrawState): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LayoutChanged; virtual;
    procedure LinkActive(Value: Boolean); virtual;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    //ddd
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    //\\\
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Scroll(Distance: Integer); virtual;
    procedure SetColumnAttributes; virtual;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function  StoreColumns: Boolean;
    procedure TimedScroll(Direction: TGridScrollDirection); override;
    procedure TitleClick(Column: TColumn_); dynamic;
    property Columns: TDBGridColumns_ read FColumns write SetColumns;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLink: TGridDataLink_ read FDataLink;

    property LayoutLock: Byte read FLayoutLock;
    property Options: TDBGrid_Options read FOptions write SetOptions
      default [dgEditing, dgTitles, dgIndicator, dgColumnResize,dgColumnMove,dgColLines,
      dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
    property ParentColor default False;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property SelectedRows: TBookmarkList_ read FBookmarks;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property UpdateLock: Byte read FUpdateLock;
    property OnColEnter: TNotifyEvent read FOnColEnter write FOnColEnter;
    property OnColExit: TNotifyEvent read FOnColExit write FOnColExit;
    property OnDrawDataCell: TDrawDataCellEvent read FOnDrawDataCell
      write FOnDrawDataCell; { obsolete }
    property OnDrawColumnCell: TDrawColumn_CellEvent read FOnDrawColumnCell
      write FOnDrawColumnCell;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write FOnEditButtonClick;
    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnCellClick: TDBGrid_ClickEvent read FOnCellClick write FOnCellClick;
    property OnCellDblClick: TDBGrid_DblClickEvent read FOnCellDblClick write FOnCellDblClick;

    property OnTitleClick: TDBGrid_ClickEvent read FOnTitleClick write FOnTitleClick;

    {
     //ddd
    procedure SaveColumnsLayoutProducer(ARegIni: TObject; Section: String; DeleteSection: Boolean);
    procedure RestoreColumnsLayoutProducer(ARegIni: TObject; Section: String; RestoreParams:TColumnEhRestoreParams);
    //\\\

    }


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultDrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); { obsolete }
    procedure DefaultDrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn_; State: TGridDrawState);
    function ValidFieldIndex(FieldIndex: Integer): Boolean;
    property EditorMode;
    property FieldCount: Integer read GetFieldCount;
    property Fields[FieldIndex: Integer]: TField read GetFields;
    property SelectedField: TField read GetSelectedField write SetSelectedField;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;

    //ddd
    procedure SaveColumnsLayout(ARegIni: TRegIniFIle);
    procedure RestoreColumnsLayout(ARegIni: TRegIniFIle; RestoreParams:TColumn_RestoreParams);
   //\\


{   //    $IFDEF VER120 //Borland Delphi 4.0
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
   //$ENDIF

    procedure DefaultHandler(var Msg); override;
    procedure InvalidateFooter;

    procedure SaveColumnsLayout(ARegIni: TRegIniFile);
    procedure RestoreColumnsLayout(ARegIni: TRegIniFile; RestoreParams:TColumnEhRestoreParams);
    procedure SaveColumnsLayoutIni(IniFileName: String; Section: String; DeleteSection: Boolean);
    procedure RestoreColumnsLayoutIni(IniFileName: String; Section: String; RestoreParams:TColumnEhRestoreParams);

    function CellRect(ACol, ARow: Longint): TRect;
    procedure DefaultDrawFooterCell(const Rect: TRect; DataCol, Row: Integer;
      Column: TColumnEH; State: TGridDrawState);
    function GetFooterValue(Row: Integer; Column: TColumnEH): String; virtual;

  }
    property Canvas;
    property Col;
    property InplaceEditor;
    property LeftCol;
    property Row;
    property VisibleRowCount;
    property VisibleColCount;
    property IndicatorOffset: Byte read FIndicatorOffset;
    property TitleOffset: Byte read FTitleOffset;

    property FooterRowCount: Integer read GetFooterRowCount write SetFooterRowCount;
    property FrozenCols: Integer read FFrozenCols write SetFrozenCols;
    property OnDrawFotterCell:TDrawFooterCellEvent read FOnDrawFotterCell
      write FOnDrawFotterCell;

    property TitleHeight: Integer read ReadTitleHeight write WriteTitleHeight;
    property TitleLines: Integer read ReadTitleLines write WriteTitleLines;
    property VTitleMargin: Integer read FVTitleMargin write WriteVTitleMargin default 10;
//    property HTitleMargin: Integer read FHTitleMargin write WriteHTitleMargin default 0;
    property UseMultiTitle: Boolean read FUseMultiTitle write WriteUseMultiTitle default False;
    property AutoFitColWidths: Boolean read FAutoFitColWidths write WriteAutoFitColWidths default False;
    property MinAutoFitWidth: Integer read FMinAutoFitWidth write WriteMinAutoFitWidth default 0;
    property RowsHeight: Integer read GetRowsHeight write SetRowsHeight;
    property RowLines: Integer read GetRowLines write SetRowLines;
    property RowSizingAllowed:Boolean read FRowSizingAllowed write SetRowSizingAllowed default False;
    property DrawMemoText:Boolean read FDrawMemoText write SetDrawMemoText;
    property OnCheckButton: TCheckTitleEHBtnEvent read FOnCheckButton write FOnCheckButton;
    property OnGetBtnParams: TGetBtn_ParamsEvent read FOnGetBtnParams write FOnGetBtnParams;
    property OnTitleBtnClick: TTitle_ClickEvent read FOnTitleBtnClick write FOnTitleBtnClick;
    property OnGetCellParams: TGetCell_ParamsEvent read FOnGetCellParams write FOnGetCellParams;
     property OnGetFootCellParams: TGetCell_ParamsEvent read FOnGetFootCellParams write FOnGetFootCellParams;


    //\\\
    {
    property OnGetFooterParams: TGetFooterParamsEvent read FOnGetFooterParams write FOnGetFooterParams;
    property SumList:TDBGridEhSumList read FSumList write SetSumList;
    property OnSumListRecalcAll: TNotifyEvent read FOnSumListRecalcAll write FOnSumListRecalcAll;
    property VisibleColumns: TDBGridVisibleColumnsEh read FVisibleColumns write FVisibleColumns;
    property HorzScrollBar: TDBGridEhScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property VertScrollBar: TDBGridEhScrollBar read FVertScrollBar write SetVertScrollBar;
    property OptionsEh: TDBGridEhOptions read FOptionsEh write SetOptionsEh default [dghFixed3D];

    }

  end;

  TDBGrid_ = class(TCustomDBGrid_)
  public
    //ddd
    property GridHeight;
    property RowCount;
    //\\\
    property Canvas;
    property SelectedRows;
  published
    property Align;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property OnCellClick;
    property OnCellDblClick;
    
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
    property OnTitleClick;

{$IFDEF VER120} {Borland Delphi 4.0 }
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
{$ENDIF}

    //ddd
    property FooterRowCount;
    property FrozenCols;
    property TitleHeight;
    property TitleLines;
    property VTitleMargin;
//    property HTitleMargin;
    property UseMultiTitle;
    property AutoFitColWidths;
    property MinAutoFitWidth;
    property RowsHeight;
    property RowSizingAllowed;
    property RowLines;
    property DrawMemoText;
    property OnDrawFotterCell;

    property OnCheckButton;
    property OnGetBtnParams;
    property OnTitleBtnClick;
    property OnGetCellParams;
    property OnGetFootCellParams;



    {
    property OnGetFooterParams: TGetFooterParamsEvent read FOnGetFooterParams write FOnGetFooterParams;
    property SumList:TDBGridEhSumList read FSumList write SetSumList;
    property OnSumListRecalcAll: TNotifyEvent read FOnSumListRecalcAll write FOnSumListRecalcAll;
    property VisibleColumns: TDBGridVisibleColumnsEh read FVisibleColumns write FVisibleColumns;
    property HorzScrollBar: TDBGridEhScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property VertScrollBar: TDBGridEhScrollBar read FVertScrollBar write SetVertScrollBar;
    property OptionsEh: TDBGridEhOptions read FOptionsEh write SetOptionsEh default [dghFixed3D];
    }
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    //\\\

  end;

{const
  IndicatorWidth = 11;}
procedure DrawImageList(Imglst:TImageList
                        ;intIndex:integer
                        ;ACanvas: TCanvas
                        ;Color:TColor
                        ; ARect: TRect
                        ;isHighLight:boolean);
procedure WriteText_(ACanvas: TCanvas;      // Canvas
                      ARect: TRect;          // Draw rect and ClippingRect
                      FillRect:Boolean;      // Fill rect Canvas.Brash.Color
                      DX, DY: Integer;       // InflateRect(Rect, -DX, -DY) for text
                      const Text: string;    // Draw text
                      Alignment: TAlignment; // Text alignment
                      Layout: TTextLayout;   // Text layout
                      MultyL:Boolean;        // Word break
                      EndEllipsis:Boolean;   // Truncate long text by ellipsis
                      LeftMarg,              // Left margin
                      RightMarg:Integer);    // Right margin

implementation

uses DBConsts, Dialogs;

{$R DBGRID_.RES}


const
  bmArrow = 'DBGARROW_';
  bmEdit = 'DBEDIT_';
  bmInsert = 'DBINSERT_';
  bmMultiDot = 'DBMULTIDOT_';
  bmMultiArrow = 'DBMULTIARROW_';
//ddd
  bmSmDown = 'DBSMDOWN_';
  bmSmUp = 'DBSMUP_';
//\\\

  MaxMapSize = (MaxInt div 2) div SizeOf(Integer);  { 250 million }

{ Error reporting }


procedure RaiseGridError(const S: string);
begin
  raise EInvalidGridOperation.Create(S);
end;

procedure KillMessage(Wnd: HWnd; Msg: Integer);
// Delete the requested message from the queue, but throw back
// any WM_QUIT msgs that PeekMessage may also return
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
    PostQuitMessage(M.wparam);
end;

//ddd

//Pure RX
type
  //ddd
  TCharSet = Set of Char;
  //\\\

function ExtractWord(N: Integer; const S: string; WordDelims: TCharSet): string; forward;

function GetDefaultSection(Component: TComponent): string;
var
  F: TCustomForm;
  Owner: TComponent;
begin
  if Component <> nil then begin
    if Component is TCustomForm then Result := Component.ClassName
    else begin
      Result := Component.Name;
      if Component is TControl then begin
        F := GetParentForm(TControl(Component));
        if F <> nil then Result := F.ClassName + Result
        else begin
          if TControl(Component).Parent <> nil then
            Result := TControl(Component).Parent.Name + Result;
        end;
      end
      else begin
        Owner := Component.Owner;
        if Owner is TForm then
          Result := Format('%s.%s', [Owner.ClassName, Result]);
      end;
    end;
  end
  else Result := '';
end;

function Max(A, B: Longint): Longint;
begin
  if A > B then Result := A
  else Result := B;
end;

function Min(A, B: Longint): Longint;
begin
  if A < B then Result := A
  else Result := B;
end;

function iif(Condition:Boolean;V1,V2:Integer):Integer;
begin
  if (Condition) then Result := V1 else Result := V2;
end;

//\\\

procedure GridInvalidateRow(Grid: TCustomDBGrid_; Row: Longint);
var
  I: Longint;
begin
  for I := 0 to Grid.ColCount - 1 do Grid.InvalidateCell(I, Row);
end;

{ TDBGrid_InplaceEdit }

{ TDBGrid_InplaceEdit adds support for a button on the in-place editor,
  which can be used to drop down a table-based lookup list, a stringlist-based
  pick list, or (if button style is esEllipsis) fire the grid event
  OnEditButtonClick.  }

type
  TEditStyle = (esSimple, esEllipsis, esPickList, esDataList);
  TPopupListbox = class;

  TDBGrid_InplaceEdit = class(TInplaceEdit)
  private
    FButtonWidth: Integer;
    FDataList: TDBLookupListBox;
    FPickList: TPopupListbox;
    FActiveList: TWinControl;
    FLookupSource: TDatasource;
    FEditStyle: TEditStyle;
    FListVisible: Boolean;
    FTracking: Boolean;
    FPressed: Boolean;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //ddd
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //\\\
    procedure SetEditStyle(Value: TEditStyle);
    procedure StopTracking;
    procedure TrackButton(X,Y: Integer);
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure WMCancelMode(var Message: TMessage); message WM_CancelMode;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message wm_LButtonDblClk;
    procedure WMPaint(var Message: TWMPaint); message wm_Paint;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SetCursor;
  protected
    procedure BoundsChanged; override;
    procedure CloseUp(Accept: Boolean);
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
    procedure DropDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure PaintWindow(DC: HDC); override;
    procedure UpdateContents; override;
    procedure WndProc(var Message: TMessage); override;
    property  EditStyle: TEditStyle read FEditStyle write SetEditStyle;
    property  ActiveList: TWinControl read FActiveList write FActiveList;
    property  DataList: TDBLookupListBox read FDataList;
    property  PickList: TPopupListbox read FPickList;
  public
    constructor Create(Owner: TComponent); override;
  end;

{ TPopupListbox }

  TPopupListbox = class(TCustomListbox)
  private
    FSearchText: String;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

procedure TPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TPopupListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, wm_SetFocus, 0, 0);
end;

procedure TPopupListbox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTickCount > 2000 then FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SelectString, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TPopupListbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  TDBGrid_InplaceEdit(Owner).CloseUp((X >= 0) and (Y >= 0) and
      (X < Width) and (Y < Height));
end;


constructor TDBGrid_InplaceEdit.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FLookupSource := TDataSource.Create(Self);
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FEditStyle := esSimple;
end;

procedure TDBGrid_InplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  SetRect(R, 2, 2, Width - 2, Height);
  if FEditStyle <> esSimple then Dec(R.Right, FButtonWidth);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  if SysLocale.FarEast then
    SetImeCompositionWindow(Font, R.Left, R.Top);
end;

procedure TDBGrid_InplaceEdit.CloseUp(Accept: Boolean);
var
  MasterField: TField;
  ListValue: Variant;
begin
  if FListVisible then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    if FActiveList = FDataList then
      ListValue := FDataList.KeyValue
    else
      if FPickList.ItemIndex <> -1 then
        ListValue := FPickList.Items[FPicklist.ItemIndex];
    SetWindowPos(FActiveList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    if Assigned(FDataList) then
      FDataList.ListSource := nil;
    FLookupSource.Dataset := nil;
    Invalidate;
    if Accept then begin
      if FActiveList = FDataList then
        with TCustomDBGrid_(Grid), Columns[SelectedIndex].Field do
        begin
          MasterField := DataSet.FieldByName(KeyFields);
          if MasterField.CanModify then
          begin
            DataSet.Edit;
            try
              MasterField.Value := ListValue;
            //ddd
            except
               on Exception do begin
                 Text := TCustomDBGrid_(Grid).Columns[TCustomDBGrid_(Grid).SelectedIndex].Field.Text + ' '; //May be delphi bag. But without ' ' don't assign
                 raise;
               end;
            end;
            Text := FDataList.SelectedItem;
            //\\\
          end;
        end
      else
        if (not VarIsNull(ListValue)) and EditCanModify then
          with TCustomDBGrid_(Grid), Columns[SelectedIndex].Field do
            Text := ListValue
    end
    //ddd
    else if FActiveList = FDataList then
      Text := TCustomDBGrid_(Grid).Columns[TCustomDBGrid_(Grid).SelectedIndex].Field.Text;
    //\\\
  end;
end;

procedure TDBGrid_InplaceEdit.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if ssAlt in Shift then
      begin
        if FListVisible then CloseUp(True) else DropDown;
        Key := 0;
      end;
    VK_RETURN, VK_ESCAPE:
      if FListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
  end;
end;

procedure TDBGrid_InplaceEdit.DropDown;
var
  P: TPoint;
  I,J,Y: Integer;
  Column: TColumn_;
  //ddd
  TM: TTextMetric;
  RestoreCanvas: Boolean;
  fList:TList;
  dlcw :Integer;
  //\\\
begin
  if not FListVisible and Assigned(FActiveList) then
  begin
    FActiveList.Width := Width;
    with TCustomDBGrid_(Grid) do
      Column := Columns[SelectedIndex];
    if FActiveList = FDataList then
    with Column.Field do
    begin
      FDataList.Color := Color;
      FDataList.Font := Font;
      FDataList.RowCount := Column.DropDownRows;
      FLookupSource.DataSet := LookupDataSet;
      FDataList.KeyField := LookupKeyFields;
//ddd      FDataList.ListField := {ddd LookupResultField}Column.LookupDisplayFields;
      FDataList.ListSource := FLookupSource;
      FDataList.KeyValue := DataSet.FieldByName(KeyFields).Value;
      //ddd
      FDataList.ListFieldIndex := 0;
      if (Column.DropDownWidth = -1) then begin
        RestoreCanvas := not HandleAllocated;
        if RestoreCanvas then
          TCustomDBGrid_(Grid).Canvas.Handle := GetDC(0);
        try
          fList := TList.Create;
          LookupDataSet.GetFieldList(fList,Column.LookupDisplayFields);
          TCustomDBGrid_(Grid).Canvas.Font := Self.Font;
          GetTextMetrics(TCustomDBGrid_(Grid).Canvas.Handle, TM);
          dlcw := 0;
          for i := 0 to fList.Count - 1 do begin
            Inc(dlcw,TField(fList[i]).DisplayWidth * (TCustomDBGrid_(Grid).Canvas.TextWidth('0') - TM.tmOverhang)
                                        + TM.tmOverhang + 4);
            if (TField(fList[i]).FieldName = LookupResultField) then FDataList.ListFieldIndex := i;
          end;
          FDataList.ClientWidth := dlcw;
          if (FDataList.Width < Self.Width) then FDataList.Width := Self.Width;
          fList.Free;
        finally
          if RestoreCanvas then
          begin
            ReleaseDC(0,TCustomDBGrid_(Grid).Canvas.Handle);
            TCustomDBGrid_(Grid).Canvas.Handle := 0;
          end;
        end
      end
      else if (Column.DropDownWidth > 0) then
        FDataList.ClientWidth := Column.DropDownWidth;
      FDataList.ListField := Column.LookupDisplayFields;  // Assignment ListField must be after ListFieldIndex
      //\\\
{      J := Column.DefaultWidth;
      if J > FDataList.ClientWidth then
        FDataList.ClientWidth := J;
}    end
    else
    begin
      FPickList.Color := Color;
      FPickList.Font := Font;
      FPickList.Items := Column.Picklist;
      if FPickList.Items.Count >= Column.DropDownRows then
        FPickList.Height := Column.DropDownRows * FPickList.ItemHeight + 4
      else
        FPickList.Height := FPickList.Items.Count * FPickList.ItemHeight + 4;
      if Column.Field.IsNull then
        FPickList.ItemIndex := -1
      else
        FPickList.ItemIndex := FPickList.Items.IndexOf(Column.Field.Value);
      J := FPickList.ClientWidth;
      for I := 0 to FPickList.Items.Count - 1 do
      begin
        Y := FPickList.Canvas.TextWidth(FPickList.Items[I]);
        if Y > J then J := Y;
      end;
      FPickList.ClientWidth := J;
    end;
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FActiveList.Height > Screen.Height then Y := P.Y - FActiveList.Height;
    //ddd Drop Down Width
    if (FActiveList.Width > Screen.Width) then FActiveList.Width := Screen.Width;
    if (P.X + FActiveList.Width > Screen.Width)  then
      P.X := Screen.Width - FActiveList.Width ;
    //\\
    SetWindowPos(FActiveList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FListVisible := True;
    Invalidate;
    Windows.SetFocus(Handle);
  end;
end;

type
  TWinControlCracker = class(TWinControl) end;

procedure TDBGrid_InplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
//ddd
var MasterField,Field: TField;
//\\\
begin
  if (EditStyle = esEllipsis) and (Key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    TCustomDBGrid_(Grid).EditButtonClick;
    KillMessage(Handle, WM_CHAR);
  end
  else
  //ddd
    if (EditStyle = esDataList) and (Key = VK_DELETE) and (Shift = []) and (SelStart = 0) and (SelLength = Length(Text)) then
    begin
      Field := TCustomDBGrid_(Grid).Columns[TCustomDBGrid_(Grid).SelectedIndex].Field;
      MasterField := Field.DataSet.FieldByName(Field.KeyFields);
      if MasterField.CanModify then
      begin
        MasterField.DataSet.Edit;
        MasterField.Clear;
        Text := '';
        Field.Clear;
        //\\\
      end;
    end else
  //\\\
    inherited KeyDown(Key, Shift);
end;

procedure TDBGrid_InplaceEdit.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

//ddd
procedure TDBGrid_InplaceEdit.ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (FEditStyle = esDataList) and (FDataList <> nil) and (ssLeft in Shift) then
    Text := FDataList.SelectedItem;
end;

procedure TDBGrid_InplaceEdit.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (FEditStyle = esDataList) and (FDataList <> nil) and (ssLeft in Shift) then
    Text := FDataList.SelectedItem;
end;
//\\\

procedure TDBGrid_InplaceEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Button = mbLeft) and (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), Point(X,Y)) then
  begin
    if FListVisible then
      CloseUp(False)
    else
    begin
      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      if Assigned(FActiveList) then
        DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TDBGrid_InplaceEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ListPos := FActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(FActiveList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(FActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        Exit;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TDBGrid_InplaceEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := FPressed;
  StopTracking;
  if (Button = mbLeft) and (FEditStyle = esEllipsis) and WasPressed then
    TCustomDBGrid_(Grid).EditButtonClick;
  inherited MouseUp(Button, Shift, X, Y);
end;

//ddd
procedure PaintInplaceButton(DC:HDC; EditStyle:TEditStyle; Rect:TRect; Pressed, Active: Boolean);
var W,H,Flags,VFlags: Integer;
begin
  Flags := 0;
  if EditStyle <> esSimple then
    if EditStyle in [esDataList, esPickList] then
    begin
      if Active = False then
        Flags := DFCS_INACTIVE
      else if Pressed then
        Flags := DFCS_FLAT or DFCS_PUSHED;
      DrawFrameControl(DC, Rect, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
    end
    else   { esEllipsis }
    begin
      if Pressed then
        Flags := BF_FLAT;
      DrawEdge(DC, Rect, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      Flags := ((Rect.Right - Rect.Left) shr 1) - 1 + Ord(Pressed);
      VFlags := ((Rect.Bottom - Rect.Top) shr 1) - 1 + Ord(Pressed);
      W := (Rect.Right - Rect.Left) shr 3;   H := (Rect.Bottom - Rect.Top) shr 3;
      if W = 0 then W := 1;                  if H = 0 then H := 1;
      if W > 2 then W := 2;                  if H > 2 then H := 2;
      PatBlt(DC, Rect.Left + Flags, Rect.Top + VFlags, W, H, BLACKNESS);
      PatBlt(DC, Rect.Left + Flags - (W * 2), Rect.Top + VFlags, W, H, BLACKNESS);
      PatBlt(DC, Rect.Left + Flags + (W * 2), Rect.Top + VFlags, W, H, BLACKNESS);
    end;
end;
//\\\

procedure TDBGrid_InplaceEdit.PaintWindow(DC: HDC);
var
  R: TRect;
//ddd  Flags: Integer;
//ddd  W: Integer;
begin

{  with TCustomDBGrid_(Grid) do
    Self.ReadOnly := Columns[SelectedIndex].
    }
  if FEditStyle <> esSimple then
  begin
    SetRect(R, Width - FButtonWidth, 0, Width, Height);
//ddd    Flags := 0;
    //ddd

    PaintInplaceButton(DC, FEditStyle, R, FPressed, True);
    (*if FEditStyle in [esDataList, esPickList] then
    begin
      ddd
      if FActiveList = nil then
        Flags := DFCS_INACTIVE
      else if FPressed then
        Flags := DFCS_FLAT or DFCS_PUSHED;
      DrawFrameControl(DC, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
    end
    else   { esEllipsis }
    begin
      if FPressed then
        Flags := BF_FLAT;
      DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      Flags := ((R.Right - R.Left) shr 1) - 1 + Ord(FPressed);
      W := Height shr 3;
      if W = 0 then W := 1;
      PatBlt(DC, R.Left + Flags, R.Top + Flags, W, W, BLACKNESS);
      PatBlt(DC, R.Left + Flags - (W * 2), R.Top + Flags, W, W, BLACKNESS);
      PatBlt(DC, R.Left + Flags + (W * 2), R.Top + Flags, W, W, BLACKNESS);
    end;*)
    //\\\
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
  end;
  inherited PaintWindow(DC);
end;

procedure TDBGrid_InplaceEdit.SetEditStyle(Value: TEditStyle);
begin
  if Value = FEditStyle then Exit;
  FEditStyle := Value;
  case Value of
    esPickList:
      begin
        if FPickList = nil then
        begin
          FPickList := TPopupListbox.Create(Self);
          FPickList.Visible := False;
          FPickList.Parent := Self;
          FPickList.OnMouseUp := ListMouseUp;
          FPickList.IntegralHeight := True;
          FPickList.ItemHeight := 11;
        end;
        FActiveList := FPickList;
      end;
    esDataList:
      begin
        if FDataList = nil then
        begin
          FDataList := TPopupDataList.Create(Self);
          FDataList.Visible := False;
          FDataList.Parent := Self;
          FDataList.OnMouseUp := ListMouseUp;
          //ddd
          FDataList.OnMouseMove := ListMouseMove;
          FDataList.OnMouseDown := ListMouseDown;
          //\\\
        end;
        FActiveList := FDataList;
      end;
  else  { cbsNone, cbsEllipsis, or read only field }
    FActiveList := nil;
  end;
  with TCustomDBGrid_(Grid) do
    Self.ReadOnly := Columns[SelectedIndex].ReadOnly;
  Repaint;
end;

procedure TDBGrid_InplaceEdit.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TDBGrid_InplaceEdit.TrackButton(X,Y: Integer);
var
  NewState: Boolean;
  R: TRect;
begin
  SetRect(R, ClientWidth - FButtonWidth, 0, ClientWidth, ClientHeight);
  NewState := PtInRect(R, Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    InvalidateRect(Handle, @R, False);
  end;
end;

function GetColumnEditStile(Column: TColumn_):TEditStyle;
var  MasterField: TField;
     ACanModify: Boolean;
begin
  Result := esSimple;
  case Column.ButtonStyle of
   cbsEllipsis: Result := esEllipsis;
   cbsAuto:
     if Assigned(Column.Field) then
     with Column.Field do
     begin
       { Show the dropdown button only if the field is editable }
       if FieldKind = fkLookup then
       begin
         MasterField := Dataset.FieldByName(KeyFields);
         { Column.DefaultReadonly will always be True for a lookup field.
           Test if Column.ReadOnly has been assigned a value of True }
         //ddd
         ACanModify := MasterField.CanModify or (Assigned(Column.Grid) and (csDesigning in Column.Grid.ComponentState));
         //\\\
         if Assigned(MasterField) and {ddd MasterField.CanModify} ACanModify and
           not ((cvReadOnly in Column.AssignedValues) and Column.ReadOnly) then
           with Column.Grid do
             if not ReadOnly and DataLink.Active and not Datalink.ReadOnly then
               Result := esDataList
       end
       else
       if Assigned(Column.Picklist) and (Column.PickList.Count > 0) and
         not Column.Readonly then
         Result := esPickList;
     end;
  end;
end;

procedure TDBGrid_InplaceEdit.UpdateContents;
var
  Column: TColumn_;
  NewStyle: TEditStyle;
  MasterField: TField;
  //ddd
  NewBackgrnd:TColor;
  //\\\
begin
  with TCustomDBGrid_(Grid) do
    Column := Columns[SelectedIndex];
  NewStyle := esSimple;
  case Column.ButtonStyle of
   cbsEllipsis: NewStyle := esEllipsis;
   cbsAuto:
     if Assigned(Column.Field) then
     with Column.Field do
     begin
       { Show the dropdown button only if the field is editable }
       if FieldKind = fkLookup then
       begin
         MasterField := Dataset.FieldByName(KeyFields);
         { Column.DefaultReadonly will always be True for a lookup field.
           Test if Column.ReadOnly has been assigned a value of True }
         if Assigned(MasterField) and MasterField.CanModify and
           not ((cvReadOnly in Column.AssignedValues) and Column.ReadOnly) then
           with TCustomDBGrid_(Grid) do
             if not ReadOnly and DataLink.Active and not Datalink.ReadOnly then
               NewStyle := esDataList
       end
       else
       if Assigned(Column.Picklist) and (Column.PickList.Count > 0) and
         not Column.Readonly then
         NewStyle := esPickList;
     end;
  end;
  EditStyle := NewStyle;
  //ddd Backgrnd And Color of Inplace Editor
  NewBackgrnd := Column.Color;
  Font.Assign(Column.Font);
  TCustomDBGrid_(Grid).GetCellParams(Column,Font,NewBackgrnd,[gdFocused]);
  Color := NewBackgrnd;
  //\\\
  inherited UpdateContents;
end;

procedure TDBGrid_InplaceEdit.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then
    CloseUp(False);
end;

procedure TDBGrid_InplaceEdit.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TDBGrid_InplaceEdit.WMKillFocus(var Message: TMessage);
begin
  if not SysLocale.FarEast then inherited
  else
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
    inherited;
    if Message.WParam <> TCustomDBGrid_(Grid).Handle then
      ActivateKeyboardLayout(Screen.DefaultKbLayout, KLF_ACTIVATE);
  end;
  CloseUp(False);
end;

procedure TDBGrid_InplaceEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  with Message do
  if (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), Point(XPos, YPos)) then
    Exit;
  inherited;
end;

procedure TDBGrid_InplaceEdit.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TDBGrid_InplaceEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  if (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), ScreenToClient(P)) then
    Windows.SetCursor(LoadCursor(0, idc_Arrow))
  else
    inherited;
end;

procedure TDBGrid_InplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    wm_KeyDown, wm_SysKeyDown, wm_Char:
      if EditStyle in [esPickList, esDataList] then
      with TWMKey(Message) do
      begin
        DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
        //ddd
        if (CharCode <> 0) and (Message.Msg = wm_Char) and (Char(CharCode) in [#32..#255]) and not FListVisible
              and TCustomDBGrid_(Grid).Columns[TCustomDBGrid_(Grid).SelectedIndex].AutoDropDown then
          DropDown;
        //\\\
        if (CharCode <> 0) and FListVisible then
        begin
          with TMessage(Message) do begin
            SendMessage(FActiveList.Handle, Msg, WParam, LParam);
            //ddd
            if (FEditStyle = esDataList) and (FDataList <> nil) then
                Text := FDataList.SelectedItem;
            //\\\
          end;
          Exit;
        end;
      end
  end;
  inherited;
end;



//\\\

{ TGridDataLink_ }

type
  TIntArray = array[0..MaxMapSize] of Integer;
  PIntArray = ^TIntArray;

constructor TGridDataLink_.Create(AGrid: TCustomDBGrid_);
begin
  inherited Create;
  FGrid := AGrid;
end;

destructor TGridDataLink_.Destroy;
begin
  ClearMapping;
  inherited Destroy;
end;

function TGridDataLink_.GetDefaultFields: Boolean;
var
  I: Integer;
begin
  Result := True;
  if DataSet <> nil then Result := DataSet.DefaultFields;
  if Result and SparseMap then
  for I := 0 to FFieldCount-1 do
    if PIntArray(FFieldMap)^[I] < 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function TGridDataLink_.GetFields(I: Integer): TField;
begin
  if (0 <= I) and (I < FFieldCount) and (PIntArray(FFieldMap)^[I] >= 0) then
    Result := DataSet.Fields[PIntArray(FFieldMap)^[I]]
  else
    Result := nil;
end;

function TGridDataLink_.AddMapping(const FieldName: string): Boolean;
var
  Field: TField;
  NewSize: Integer;
begin
  Result := True;
  if FFieldCount >= MaxMapSize then RaiseGridError(STooManyColumns);
  if SparseMap then
    Field := DataSet.FindField(FieldName)
  else
    Field := DataSet.FieldByName(FieldName);

  if FFieldCount = FFieldMapSize then
  begin
    NewSize := FFieldMapSize;
    if NewSize = 0 then
      NewSize := 8
    else
      Inc(NewSize, NewSize);
    if (NewSize < FFieldCount) then
      NewSize := FFieldCount + 1;
    if (NewSize > MaxMapSize) then
      NewSize := MaxMapSize;
    ReallocMem(FFieldMap, NewSize * SizeOf(Integer));
    FFieldMapSize := NewSize;
  end;
  if Assigned(Field) then
  begin
    PIntArray(FFieldMap)^[FFieldCount] := Field.Index;
    Field.FreeNotification(FGrid);
  end
  else
    PIntArray(FFieldMap)^[FFieldCount] := -1;
  Inc(FFieldCount);
end;

procedure TGridDataLink_.ActiveChanged;
begin
  FGrid.LinkActive(Active);
end;

procedure TGridDataLink_.ClearMapping;
begin
  if FFieldMap <> nil then
  begin
    FreeMem(FFieldMap, FFieldMapSize * SizeOf(Integer));
    FFieldMap := nil;
    FFieldMapSize := 0;
    FFieldCount := 0;
  end;
end;

procedure TGridDataLink_.Modified;
begin
  FModified := True;
end;

procedure TGridDataLink_.DataSetChanged;
begin
  FGrid.DataChanged;
  FModified := False;
end;

procedure TGridDataLink_.DataSetScrolled(Distance: Integer);
begin
  FGrid.Scroll(Distance);
end;

procedure TGridDataLink_.LayoutChanged;
var
  SaveState: Boolean;
begin
  { FLayoutFromDataset determines whether default column width is forced to
    be at least wide enough for the column title.  }
  SaveState := FGrid.FLayoutFromDataset;
  FGrid.FLayoutFromDataset := True;
  try
    FGrid.LayoutChanged;
  finally
    FGrid.FLayoutFromDataset := SaveState;
  end;
  inherited LayoutChanged;
end;

procedure TGridDataLink_.FocusControl(Field: TFieldRef);
begin
  if Assigned(Field) and Assigned(Field^) then
  begin
    FGrid.SelectedField := Field^;
    if (FGrid.SelectedField = Field^) and FGrid.AcquireFocus then
    begin
      Field^ := nil;
      FGrid.ShowEditor;
    end;
  end;
end;

procedure TGridDataLink_.EditingChanged;
begin
  FGrid.EditingChanged;
end;

procedure TGridDataLink_.RecordChanged(Field: TField);
begin
  FGrid.RecordChanged(Field);
  FModified := False;
end;

procedure TGridDataLink_.UpdateData;
begin
  FInUpdateData := True;
  try
    if FModified then FGrid.UpdateData;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;

function TGridDataLink_.GetMappedIndex(ColIndex: Integer): Integer;
begin
  if (0 <= ColIndex) and (ColIndex < FFieldCount) then
    Result := PIntArray(FFieldMap)^[ColIndex]
  else
    Result := -1;
end;

procedure TGridDataLink_.Reset;
begin
  if FModified then RecordChanged(nil) else Dataset.Cancel;
end;


{ TColumnTitle_ }
constructor TColumnTitle_.Create(Column: TColumn_);
begin
  inherited Create;
  FColumn := Column;
  FFont := TFont.Create;
  FFont.Assign(DefaultFont);
  FFont.OnChange := FontChanged;
  //ddd
  FTitleButton := False;
  SortMarker := smNone;
  //\\\
end;

destructor TColumnTitle_.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TColumnTitle_.Assign(Source: TPersistent);
begin
  if Source is TColumnTitle_ then
  begin
    if cvTitleAlignment in TColumnTitle_(Source).FColumn.FAssignedValues then
      Alignment := TColumnTitle_(Source).Alignment;
    if cvTitleColor in TColumnTitle_(Source).FColumn.FAssignedValues then
      Color := TColumnTitle_(Source).Color;
    if cvTitleCaption in TColumnTitle_(Source).FColumn.FAssignedValues then
      Caption := TColumnTitle_(Source).Caption;
    if cvTitleFont in TColumnTitle_(Source).FColumn.FAssignedValues then
      Font := TColumnTitle_(Source).Font;
    //ddd
    TitleButton := TColumnTitle_(Source).TitleButton;
    SortMarker := TColumnTitle_(Source).SortMarker;
    EndEllipsis := TColumnTitle_(Source).EndEllipsis;
    //\\\
  end
  else
    inherited Assign(Source);
end;

function TColumnTitle_.DefaultAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TColumnTitle_.DefaultColor: TColor;
var
  Grid: TCustomDBGrid_;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) then
    Result := Grid.FixedColor
  else
    Result := clBtnFace;
end;

function TColumnTitle_.DefaultFont: TFont;
var
  Grid: TCustomDBGrid_;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) then
    Result := Grid.TitleFont
  else
    Result := FColumn.Font;
end;

function TColumnTitle_.DefaultCaption: string;
var
  Field: TField;
begin
  Field := FColumn.Field;
  if Assigned(Field) then
    Result := Field.DisplayName
  else
    Result := FColumn.FieldName;
end;

procedure TColumnTitle_.FontChanged(Sender: TObject);
begin
  Include(FColumn.FAssignedValues, cvTitleFont);
  FColumn.Changed(True);
end;

function TColumnTitle_.GetAlignment: TAlignment;
begin
  if cvTitleAlignment in FColumn.FAssignedValues then
    Result := FAlignment
  else
    Result := DefaultAlignment;
end;

function TColumnTitle_.GetColor: TColor;
begin
  if cvTitleColor in FColumn.FAssignedValues then
    Result := FColor
  else
    Result := DefaultColor;
end;

function TColumnTitle_.GetCaption: string;
begin
  if cvTitleCaption in FColumn.FAssignedValues then
    Result := FCaption
  else
    Result := DefaultCaption;
end;

function TColumnTitle_.GetFont: TFont;
var
  Save: TNotifyEvent;
  Def: TFont;
begin
  if not (cvTitleFont in FColumn.FAssignedValues) then
  begin
    Def := DefaultFont;
    if (FFont.Handle <> Def.Handle) or (FFont.Color <> Def.Color) then
    begin
      Save := FFont.OnChange;
      FFont.OnChange := nil;
      FFont.Assign(DefaultFont);
      FFont.OnChange := Save;
    end;
  end;
  Result := FFont;
end;

function TColumnTitle_.IsAlignmentStored: Boolean;
begin
  Result := (cvTitleAlignment in FColumn.FAssignedValues) and
    (FAlignment <> DefaultAlignment);
end;

function TColumnTitle_.IsColorStored: Boolean;
begin
  Result := (cvTitleColor in FColumn.FAssignedValues) and
    (FColor <> DefaultColor);
end;

function TColumnTitle_.IsFontStored: Boolean;
begin
  Result := (cvTitleFont in FColumn.FAssignedValues);
end;

function TColumnTitle_.IsCaptionStored: Boolean;
begin
  Result := (cvTitleCaption in FColumn.FAssignedValues) and
    (FCaption <> DefaultCaption);
end;

procedure TColumnTitle_.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if (cvTitleFont in FColumn.FAssignedValues) then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
end;

procedure TColumnTitle_.RestoreDefaults;
var
  FontAssigned: Boolean;
begin
  FontAssigned := cvTitleFont in FColumn.FAssignedValues;
  FColumn.FAssignedValues := FColumn.FAssignedValues - Column_TitleValues;
  FCaption := '';
  RefreshDefaultFont;
  { If font was assigned, changing it back to default may affect grid title
    height, and title height changes require layout and redraw of the grid. }
  FColumn.Changed(FontAssigned);
end;

procedure TColumnTitle_.SetAlignment(Value: TAlignment);
begin
  if (cvTitleAlignment in FColumn.FAssignedValues) and (Value = FAlignment) then Exit;
  FAlignment := Value;
  Include(FColumn.FAssignedValues, cvTitleAlignment);
  FColumn.Changed(False);
end;

procedure TColumnTitle_.SetColor(Value: TColor);
begin
  if (cvTitleColor in FColumn.FAssignedValues) and (Value = FColor) then Exit;
  FColor := Value;
  Include(FColumn.FAssignedValues, cvTitleColor);
  FColumn.Changed(False);
end;

procedure TColumnTitle_.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TColumnTitle_.SetCaption(const Value: string);
begin
  if (cvTitleCaption in FColumn.FAssignedValues) and (Value = FCaption) then Exit;
  FCaption := Value;
  Include(FColumn.FAssignedValues, cvTitleCaption);
  FColumn.Changed(False);
end;


procedure TColumnTitle_.SetTitleButton(Value: Boolean);
begin
  if (Value = FTitleButton) then Exit;
  FTitleButton := Value;
  FColumn.Changed(False);
end;

procedure TColumnTitle_.SetSortMarker(Value: TSortMarker_);
begin
  if (Value = FSortMarker) then Exit;
  FSortMarker := Value;
  FColumn.Changed(False);
end;

procedure TColumnTitle_.SetEndEllipsis(const Value: Boolean);
begin
  FEndEllipsis := Value;
  FColumn.Changed(False);
end;

{ TColumn_ }

constructor TColumn_.Create(Collection: TCollection);
var
  Grid: TCustomDBGrid_;
begin
  Grid := nil;
  if Assigned(Collection) and (Collection is TDBGridColumns_) then
    Grid := TDBGridColumns_(Collection).Grid;
  if Assigned(Grid) then
    Grid.BeginLayout;
  try
    inherited Create(Collection);
    FDropDownRows := 7;
    FButtonStyle := cbsAuto;
    FFont := TFont.Create;
    FFont.Assign(DefaultFont);
    FFont.OnChange := FontChanged;
    FImeMode := imDontCare;
    FImeName := Screen.DefaultIme;
    FTitle := CreateTitle;
    //ddd
    FAutoFitColWidth := True;
    FInitWidth := Width;
    FNotInKeyListIndex:=-1;
    //\\\
  finally
    if Assigned(Grid) then
      Grid.EndLayout;
  end;
end;

destructor TColumn_.Destroy;
begin
  FTitle.Free;
  FFont.Free;
  FPickList.Free;
  FKeyList.Free;
 //  FImageList:=nil;
  inherited Destroy;
end;

procedure TColumn_.Assign(Source: TPersistent);
begin
  if Source is TColumn_ then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      RestoreDefaults;
      FieldName := TColumn_(Source).FieldName;
      if cvColor in TColumn_(Source).AssignedValues then
        Color := TColumn_(Source).Color;
      if cvWidth in TColumn_(Source).AssignedValues then
        Width := TColumn_(Source).Width;
      if cvFont in TColumn_(Source).AssignedValues then
        Font := TColumn_(Source).Font;
      if cvImeMode in TColumn_(Source).AssignedValues then
        ImeMode := TColumn_(Source).ImeMode;
      if cvImeName in TColumn_(Source).AssignedValues then
        ImeName := TColumn_(Source).ImeName;
      if cvAlignment in TColumn_(Source).AssignedValues then
        Alignment := TColumn_(Source).Alignment;
      if cvReadOnly in TColumn_(Source).AssignedValues then
        ReadOnly := TColumn_(Source).ReadOnly;
      Title := TColumn_(Source).Title;
      DropDownRows := TColumn_(Source).DropDownRows;
      ButtonStyle := TColumn_(Source).ButtonStyle;
      PickList := TColumn_(Source).PickList;
      PopupMenu := TColumn_(Source).PopupMenu;
      //ddd
      FInitWidth := TColumn_(Source).FInitWidth;
      AutoFitColWidth := TColumn_(Source).AutoFitColWidth;
      if cvWordWrap in TColumn_(Source).AssignedValues then
        WordWrap := TColumn_(Source).WordWrap;
      EndEllipsis := TColumn_(Source).EndEllipsis;
      DropDownWidth := TColumn_(Source).DropDownWidth;
      if cvLookupDisplayFields in TColumn_(Source).AssignedValues then
        LookupDisplayFields := TColumn_(Source).LookupDisplayFields;
      AutoDropDown := TColumn_(Source).AutoDropDown;
      AlwaysShowEditButton := TColumn_(Source).AlwaysShowEditButton;
      WordWrap := TColumn_(Source).WordWrap;
      //\\\
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

function TColumn_.CreateTitle: TColumnTitle_;
begin
  Result := TColumnTitle_.Create(Self);
end;

function TColumn_.DefaultAlignment: TAlignment;
begin
  if Assigned(Field) then
    Result := FField.Alignment
  else
    Result := taLeftJustify;
end;

function TColumn_.DefaultColor: TColor;
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.Color
  else
    Result := clWindow;
end;

function TColumn_.DefaultFont: TFont;
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.Font
  else
    Result := FFont;
end;

function TColumn_.DefaultImeMode: TImeMode;
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.ImeMode
  else
    Result := FImeMode;
end;

function TColumn_.DefaultImeName: TImeName;
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.ImeName
  else
    Result := FImeName;
end;

function TColumn_.DefaultReadOnly: Boolean;
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  Result := (Assigned(Grid) and Grid.ReadOnly) or (Assigned(Field) and FField.ReadOnly);
end;

function TColumn_.DefaultWidth: Integer;
var
//  W: Integer;
  RestoreCanvas: Boolean;
  TM: TTextMetric;
begin
  if GetGrid = nil then
  begin
    Result := 64;
    Exit;
  end;
  with GetGrid do
  begin
    if Assigned(Field) then
    begin
      RestoreCanvas := not HandleAllocated;
      if RestoreCanvas then
        Canvas.Handle := GetDC(0);
      try
        Canvas.Font := Self.Font;
        GetTextMetrics(Canvas.Handle, TM);
        Result := Field.DisplayWidth * (Canvas.TextWidth('0') - TM.tmOverhang)
          + TM.tmOverhang + 4;
        {if dgTitles in Options then  //ddd
        begin
          Canvas.Font := Title.Font;
          W := Canvas.TextWidth(Title.Caption) + 4;
          if Result < W then
            Result := W;
        end;}                       //\\\
      finally
        if RestoreCanvas then
        begin
          ReleaseDC(0,Canvas.Handle);
          Canvas.Handle := 0;
        end;
      end;
    end
    else
      Result := DefaultColWidth;
  end;
end;

procedure TColumn_.FontChanged;
begin
  Include(FAssignedValues, cvFont);
  Title.RefreshDefaultFont;
  Changed(False);
end;

function TColumn_.GetAlignment: TAlignment;
begin
  if cvAlignment in FAssignedValues then
    Result := FAlignment
  else
    Result := DefaultAlignment;
end;

function TColumn_.GetColor: TColor;
begin
  if cvColor in FAssignedValues then
    Result := FColor
  else
    Result := DefaultColor;
end;

function TColumn_.GetField: TField;
var
  Grid: TCustomDBGrid_;
begin    { Returns Nil if FieldName can't be found in dataset }
  Grid := GetGrid;
  if (FField = nil) and (Length(FFieldName) > 0) and Assigned(Grid) and
    Assigned(Grid.DataLink.DataSet) then
  with Grid.Datalink.Dataset do
    if Active or (not DefaultFields) then
      SetField(FindField(FieldName));
  Result := FField;
end;

function TColumn_.GetFont: TFont;
var
  Save: TNotifyEvent;
begin
  if not (cvFont in FAssignedValues) and (FFont.Handle <> DefaultFont.Handle) then
  begin
    Save := FFont.OnChange;
    FFont.OnChange := nil;
    FFont.Assign(DefaultFont);
    FFont.OnChange := Save;
  end;
  Result := FFont;
end;

function TColumn_.GetGrid: TCustomDBGrid_;
begin
  if Assigned(Collection) and (Collection is TDBGridColumns_) then
    Result := TDBGridColumns_(Collection).Grid
  else
    Result := nil;
end;

function TColumn_.GetDisplayName: string;
begin
  Result := FFieldName;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TColumn_.GetImeMode: TImeMode;
begin
  if cvImeMode in FAssignedValues then
    Result := FImeMode
  else
    Result := DefaultImeMode;
end;

function TColumn_.GetImeName: TImeName;
begin
  if cvImeName in FAssignedValues then
    Result := FImeName
  else
    Result := DefaultImeName;
end;

function TColumn_.GetPickList: TStrings;
begin
  if FPickList = nil then
    FPickList := TStringList.Create;
  Result := FPickList;
end;

function TColumn_.GetReadOnly: Boolean;
begin
  if cvReadOnly in FAssignedValues then
    Result := FReadOnly
  else
    Result := DefaultReadOnly;
end;

function TColumn_.GetWidth: Integer;
begin
  if cvWidth in FAssignedValues then
    Result := FWidth
  else
    Result := DefaultWidth;
(*  //ddd
  if Assigned(Grid) and (Grid.AutoFitColWidths = True) and
    (csWriting in Grid.ComponentState) {and (AutoFitColWidth = True)} then begin
    // Подсуним реальный Width
    Result := FInitWidth;
   //\\\

  end;*)
end;

function TColumn_.IsAlignmentStored: Boolean;
begin
  Result := (cvAlignment in FAssignedValues) and (FAlignment <> DefaultAlignment);
end;

function TColumn_.IsColorStored: Boolean;
begin
  Result := (cvColor in FAssignedValues) and (FColor <> DefaultColor);
end;

function TColumn_.IsFontStored: Boolean;
begin
  Result := (cvFont in FAssignedValues);
end;

function TColumn_.IsImeModeStored: Boolean;
begin
  Result := (cvImeMode in FAssignedValues) and (FImeMode <> DefaultImeMode);
end;

function TColumn_.IsImeNameStored: Boolean;
begin
  Result := (cvImeName in FAssignedValues) and (FImeName <> DefaultImeName);
end;

function TColumn_.IsReadOnlyStored: Boolean;
begin
  Result := (cvReadOnly in FAssignedValues) and (FReadOnly <> DefaultReadOnly);
end;

function TColumn_.IsWidthStored: Boolean;
begin
  Result := (cvWidth in FAssignedValues) and (FWidth <> DefaultWidth);
end;

procedure TColumn_.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if cvFont in FAssignedValues then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
end;

procedure TColumn_.RestoreDefaults;
var
  FontAssigned: Boolean;
begin
  FontAssigned := cvFont in FAssignedValues;
  FTitle.RestoreDefaults;
  FAssignedValues := [];
  RefreshDefaultFont;

  FKeyList.Free;
  FKeyList := nil;

  FPickList.Free;
  FPickList := nil;
  ButtonStyle := cbsAuto;
  Changed(FontAssigned);
  //ddd
//  FInitWidth := Width;
  //\\\
end;

procedure TColumn_.SetAlignment(Value: TAlignment);
begin
  if (cvAlignment in FAssignedValues) and (Value = FAlignment) then Exit;
  FAlignment := Value;
  Include(FAssignedValues, cvAlignment);
  Changed(False);
end;

procedure TColumn_.SetButtonStyle(Value: TColumnButtonStyle);
begin
  if Value = FButtonStyle then Exit;
  FButtonStyle := Value;
  Changed(False);
end;

procedure TColumn_.SetColor(Value: TColor);
begin
  if (cvColor in FAssignedValues) and (Value = FColor) then Exit;
  FColor := Value;
  Include(FAssignedValues, cvColor);
  Changed(False);
end;

procedure TColumn_.SetField(Value: TField);
begin
  if FField = Value   then Exit;
  FField := Value;
  if Assigned(Value) then
    FFieldName := Value.FieldName;
  Changed(False);
end;

procedure TColumn_.SetFieldName(const Value: String);
var
  AField: TField;
  Grid: TCustomDBGrid_;
begin
  AField := nil;
  Grid := GetGrid;
  if Assigned(Grid) and Assigned(Grid.DataLink.DataSet) and
    not (csLoading in Grid.ComponentState) and (Length(Value) > 0) then
      AField := Grid.DataLink.DataSet.FindField(Value); { no exceptions }
  FFieldName := Value;
  SetField(AField);
  //ddd
  FInitWidth := Width;
  //\\\
  Changed(False);
end;

procedure TColumn_.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Include(FAssignedValues, cvFont);
  Changed(False);
end;

procedure TColumn_.SetImeMode(Value: TImeMode);
begin
  if (cvImeMode in FAssignedValues) or (Value <> DefaultImeMode) then
  begin
    FImeMode := Value;
    Include(FAssignedValues, cvImeMode);
  end;
  Changed(False);
end;

procedure TColumn_.SetImeName(Value: TImeName);
begin
  if (cvImeName in FAssignedValues) or (Value <> DefaultImeName) then
  begin
    FImeName := Value;
    Include(FAssignedValues, cvImeName);
  end;
  Changed(False);
end;

procedure TColumn_.SetPickList(Value: TStrings);
begin
  if Value = nil then
  begin
    FPickList.Free;
    FPickList := nil;
    Exit;
  end;
  PickList.Assign(Value);
end;

procedure TColumn_.SetPopupMenu(Value: TPopupMenu);
begin
  FPopupMenu := Value;
  if Value <> nil then Value.FreeNotification(GetGrid);
end;

procedure TColumn_.SetReadOnly(Value: Boolean);
begin
  if (cvReadOnly in FAssignedValues) and (Value = FReadOnly) then Exit;
  FReadOnly := Value;
  Include(FAssignedValues, cvReadOnly);
  Changed(False);
end;

procedure TColumn_.SetTitle(Value: TColumnTitle_);
begin
  FTitle.Assign(Value);
end;

procedure TColumn_.SetWidth(Value: Integer);
begin
  if (cvWidth in FAssignedValues) or (Value <> DefaultWidth) then
  begin
    FWidth := Value;
    Include(FAssignedValues, cvWidth);
  end;
  //ddd
//  if (AutoFitColWidth = False) then FInitWidth := Width;
  //\\\
  Changed(False);
end;

//ddd

function TColumn_.GetAutoFitColWidth: Boolean;
begin
  Result := FAutoFitColWidth;
end;

procedure TColumn_.SetAutoFitColWidth(Value: Boolean);
begin
  FAutoFitColWidth := Value;
  if Assigned(Grid) and (Grid.AutoFitColWidths = True) and not (csLoading in Grid.ComponentState) then Width := FInitWidth;
  Changed(False);
end;

procedure TColumn_.SetAlwaysShowEditButton(Value: Boolean);
begin
  if (FAlwaysShowEditButton = Value) then Exit;
  FAlwaysShowEditButton := Value;
  Changed(False);
end;

//---- WordWrap
procedure TColumn_.SetWordWrap(Value: Boolean);
begin
  if (cvWordWrap in FAssignedValues) or (Value <> DefaultWordWrap) or
       (Assigned(Grid) and (csLoading in Grid.ComponentState)) then
  begin
    FWordWrap := Value;
    Include(FAssignedValues, cvWordWrap);
  end;
  Changed(False);
end;

function  TColumn_.GetWordWrap: Boolean;
begin
  if cvWordWrap in FAssignedValues then
    Result := FWordWrap
  else
    Result := DefaultWordWrap;
end;

function  TColumn_.IsWordWrapStored: Boolean;
begin
  Result := (cvWordWrap in FAssignedValues) and (FWordWrap <> DefaultWordWrap);
end;

function TColumn_.DefaultWordWrap: Boolean;
begin
  if GetGrid = nil then
  begin
    Result := False;
    Exit;
  end;
  with GetGrid do
  begin
    if Assigned(Field) then
    begin
      case Field.DataType of
        ftString,ftMemo,ftFmtMemo: Result := True;
      else
        Result := False;
      end;
    end
    else Result := False;
  end;
end;

procedure TColumn_.SetEndEllipsis(const Value: Boolean);
begin
  FEndEllipsis := Value;
  Changed(False);
end;

procedure TColumn_.SetDropDownWidth(Value: Integer);
begin
  if (Value = FDropDownWidth) then Exit;
  FDropDownWidth := Value;
  Changed(False);
end;

function TColumn_.DefaultLookupDisplayFields: String;
begin
  if Assigned(Field) then
    Result := FField.LookupResultField
  else
    Result := '';
end;

function TColumn_.GetLookupDisplayFields: String;
begin
  if cvLookupDisplayFields in FAssignedValues then
    Result := FLookupDisplayFields
  else
    Result := DefaultLookupDisplayFields;
end;

procedure TColumn_.SetLookupDisplayFields(Value: String);
begin
  if (cvLookupDisplayFields in FAssignedValues) or (Value <> DefaultLookupDisplayFields) then
  begin
    FLookupDisplayFields := Value;
    Include(FAssignedValues, cvLookupDisplayFields);
  end;
  Changed(False);
end;

function TColumn_.IsLookupDisplayFieldsStored: Boolean;
begin
  Result := (cvLookupDisplayFields in FAssignedValues) and (FLookupDisplayFields <> DefaultLookupDisplayFields);
end;

procedure TColumn_.SetAutoDropDown(Value: Boolean);
begin
  if (Value = FAutoDropDown) then Exit;
  FAutoDropDown := Value;
  Changed(False);
end;


function TColumn_.GetKeykList: TStrings;
begin
 if FKeyList = nil then
    FKeyList := TStringList.Create;
  Result := FKeyList;
end;

procedure TColumn_.SetImageList(const Value: TImageList);
begin
  if  Value= FImageList then Exit;
  FImageList:=Value;
  Changed(False);
 end;

procedure TColumn_.SetKeykList(const Value: TStrings);
begin
  if  Value= FKeyList then Exit;
  if Value = nil then
  begin
    FKeyList.Free;
    FKeyList := nil;
    Exit;
  end;
  KeyList.Assign(Value);
  Changed(False);
 end;

procedure TColumn_.SetNotInKeyListIndex(Value: Integer);
begin
 if   FNotInKeyListIndex=value then Exit;
  FNotInKeyListIndex:=Value;
  Changed(False);
end;



//\\\

{ TPassthroughColumn }

type
  TPassthroughColumnTitle = class(TColumnTitle_)
  private
    procedure SetCaption(const Value: string); override;
  end;

  TPassthroughColumn = class(TColumn_)
  private
    procedure SetAlignment(Value: TAlignment); override;
    procedure SetField(Value: TField); override;
    procedure SetIndex(Value: Integer); override;
    procedure SetReadOnly(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
    //ddd
//    procedure SetInitWidth(Value: Integer); override;
    //\\\
  protected
    function CreateTitle: TColumnTitle_; override;
  end;




{ TPassthroughColumnTitle }

procedure TPassthroughColumnTitle.SetCaption(const Value: string);
var
  Grid: TCustomDBGrid_;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(FColumn.Field) then
    FColumn.Field.DisplayLabel := Value
  else
    inherited SetCaption(Value);
end;


{ TPassthroughColumn }

function TPassthroughColumn.CreateTitle: TColumnTitle_;
begin
  Result := TPassthroughColumnTitle.Create(Self);
end;

procedure TPassthroughColumn.SetAlignment(Value: TAlignment);
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(Field) then
    Field.Alignment := Value
  else
    inherited SetAlignment(Value);
end;

procedure TPassthroughColumn.SetField(Value: TField);
begin
  inherited SetField(Value);
  if Value = nil then
    FFieldName := '';
  RestoreDefaults;
  //ddd
  FInitWidth := Width;
  //\\\

end;

procedure TPassthroughColumn.SetIndex(Value: Integer);
var
  Grid: TCustomDBGrid_;
  Fld: TField;
begin
  Grid := GetGrid;
  if Assigned(Grid) and Grid.Datalink.Active then
  begin
    Fld := Grid.Datalink.Fields[Value];
    if Assigned(Fld) then
      Field.Index := Fld.Index;
  end;
  inherited SetIndex(Value);
end;

procedure TPassthroughColumn.SetReadOnly(Value: Boolean);
var
  Grid: TCustomDBGrid_;
begin
  Grid := GetGrid;
  if Assigned(Grid) and Grid.Datalink.Active and Assigned(Field) then
    Field.ReadOnly := Value
  else
    inherited SetReadOnly(Value);
end;

procedure TPassthroughColumn.SetWidth(Value: Integer);
var
  Grid: TCustomDBGrid_;
  TM: TTextMetric;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
  begin
    if Grid.HandleAllocated and Assigned(Field) and Grid.FUpdateFields then
    with Grid do
    begin
      Canvas.Font := Self.Font;
      GetTextMetrics(Canvas.Handle, TM);
      Field.DisplayWidth := (Value + (TM.tmAveCharWidth div 2) - TM.tmOverhang - 3)
        div {VCL BUG TM.tmAveCharWidth} Canvas.TextWidth('0');
    end;
    if (not Grid.FLayoutFromDataset) or (cvWidth in FAssignedValues) then
      inherited SetWidth(Value);
  end
  else
    inherited SetWidth(Value);
end;

{ TDBGridColumns_ }

constructor TDBGridColumns_.Create(Grid: TCustomDBGrid_; ColumnClass: TColumn_Class);
begin
  inherited Create(ColumnClass);
  FGrid := Grid;
end;

function TDBGridColumns_.Add: TColumn_;
begin
  Result := TColumn_(inherited Add);
end;

function TDBGridColumns_.GetColumn(Index: Integer): TColumn_;
begin
  Result := TColumn_(inherited Items[Index]);
end;

function TDBGridColumns_.GetOwner: TPersistent;
begin
  Result := FGrid;
end;

function TDBGridColumns_.GetState: TDBGridColumnsState;
begin
  Result := TDBGridColumnsState((Count > 0) and not (Items[0] is TPassthroughColumn));
end;

procedure TDBGridColumns_.LoadFromFile(const Filename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

type
  TColumnsWrapper = class(TComponent)
  private
    FColumns: TDBGridColumns_;
  published
    property Columns: TDBGridColumns_ read FColumns write FColumns;
  end;

procedure TDBGridColumns_.LoadFromStream(S: TStream);
var
  Wrapper: TColumnsWrapper;
begin
  Wrapper := TColumnsWrapper.Create(nil);
  try
    Wrapper.Columns := FGrid.CreateColumns;
    S.ReadComponent(Wrapper);
    Assign(Wrapper.Columns);
  finally
    Wrapper.Columns.Free;
    Wrapper.Free;
  end;
end;

procedure TDBGridColumns_.RestoreDefaults;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count-1 do
      Items[I].RestoreDefaults;
  finally
    EndUpdate;
  end;
end;

procedure TDBGridColumns_.RebuildColumns;
var
  I: Integer;
begin
  if Assigned(FGrid) and Assigned(FGrid.DataSource) and
    Assigned(FGrid.Datasource.Dataset) then
  begin
    FGrid.BeginLayout;
    try
      Clear;
      with FGrid.Datasource.Dataset do
        for I := 0 to FieldCount-1 do
          Add.FieldName := Fields[I].FieldName
    finally
      FGrid.EndLayout;
    end
  end
  else
    Clear;
end;

procedure TDBGridColumns_.SaveToFile(const Filename: string);
var
  S: TStream;
begin
  S := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TDBGridColumns_.SaveToStream(S: TStream);
var
  Wrapper: TColumnsWrapper;
begin
  Wrapper := TColumnsWrapper.Create(nil);
  try
    Wrapper.Columns := Self;
    S.WriteComponent(Wrapper);
  finally
    Wrapper.Free;
  end;
end;

procedure TDBGridColumns_.SetColumn(Index: Integer; Value: TColumn_);
begin
  Items[Index].Assign(Value);
end;

procedure TDBGridColumns_.SetState(NewState: TDBGridColumnsState);
begin
  if NewState = State then Exit;
  if NewState = csDefault then
    Clear
  else
    RebuildColumns;
end;

procedure TDBGridColumns_.Update(Item: TCollectionItem);
var
  Raw: Integer;
  //ddd
  OldWidth: Integer;
  //\\\
begin
  if (FGrid = nil) or (csLoading in FGrid.ComponentState) then Exit;
  if (Item = nil) then
  begin
    FGrid.LayoutChanged;
  end
  else
  begin
    Raw := FGrid.DataToRawColumn(Item.Index);
    FGrid.InvalidateCol(Raw);
    //ddd
    //FGrid.ColWidths[Raw] := TColumn_(Item).Width;
    if (FGrid.AutoFitColWidths = False) or (csDesigning in FGrid.ComponentState) then begin
       FGrid.ColWidths[Raw] := TColumn_(Item).Width;
       if (FGrid.UseMultiTitle = True) and not (csDesigning in FGrid.ComponentState) then FGrid.LayoutChanged;
    end else begin
      OldWidth := TColumn_(Item).FInitWidth;
      TColumn_(Item).FInitWidth :=
          MulDiv(TColumn_(Item).FInitWidth,TColumn_(Item).Width,FGrid.ColWidths[Raw]);
       if (Raw <> FGrid.ColCount - 1) then begin
           Inc(FGrid.Columns[Raw - FGrid.FIndicatorOffset + 1].FInitWidth,OldWIdth - FGrid.FColumns[Raw - FGrid.FIndicatorOffset].FInitWidth);
           if (FGrid.Columns[Raw - FGrid.FIndicatorOffset + 1].FInitWidth < 0) then FGrid.Columns[Raw - FGrid.FIndicatorOffset + 1].FInitWidth := 0;
       end;
       FGrid.LayoutChanged;
    end;
    //\\\
  end;
end;

{ TBookmarkList_ }

constructor TBookmarkList_.Create(AGrid: TCustomDBGrid_);
begin
  inherited Create;
  FList := TStringList.Create;
  FList.OnChange := StringsChanged;
  FGrid := AGrid;
end;

destructor TBookmarkList_.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TBookmarkList_.Clear;
begin
  if FList.Count = 0 then Exit;
  FList.Clear;
  FGrid.Invalidate;
end;

function TBookmarkList_.Compare(const Item1, Item2: TBookmarkStr): Integer;
begin
  with FGrid.Datalink.Datasource.Dataset do
    Result := CompareBookmarks(TBookmark(Item1), TBookmark(Item2));
end;

function TBookmarkList_.CurrentRow: TBookmarkStr;
begin
  if not FLinkActive then RaiseGridError(sDataSetClosed);
  Result := FGrid.Datalink.Datasource.Dataset.Bookmark;
end;

function TBookmarkList_.GetCurrentRowSelected: Boolean;
var
  Index: Integer;
begin
  Result := Find(CurrentRow, Index);
end;

function TBookmarkList_.Find(const Item: TBookmarkStr; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  if (Item = FCache) and (FCacheIndex >= 0) then
  begin
    Index := FCacheIndex;
    Result := FCacheFind;
    Exit;
  end;
  Result := False;
  L := 0;
  H := FList.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(FList[I], Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
  FCache := Item;
  FCacheIndex := Index;
  FCacheFind := Result;
end;

function TBookmarkList_.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBookmarkList_.GetItem(Index: Integer): TBookmarkStr;
begin
  Result := FList[Index];
end;

function TBookmarkList_.IndexOf(const Item: TBookmarkStr): Integer;
begin
  if not Find(Item, Result) then
    Result := -1;
end;

procedure TBookmarkList_.LinkActive(Value: Boolean);
begin
  Clear;
  FLinkActive := Value;
end;

procedure TBookmarkList_.Delete;
var
  I: Integer;
begin
  with FGrid.Datalink.Datasource.Dataset do
  begin
    DisableControls;
    try
      for I := FList.Count-1 downto 0 do
      begin
        Bookmark := FList[I];
        Delete;
        FList.Delete(I);
      end;
    finally
      EnableControls;
    end;
  end;
end;

function TBookmarkList_.Refresh: Boolean;
var
  I: Integer;
begin
  Result := False;
  with FGrid.DataLink.Datasource.Dataset do
  try
    CheckBrowseMode;
    for I := FList.Count - 1 downto 0 do
      if not BookmarkValid(TBookmark(FList[I])) then
      begin
        Result := True;
        FList.Delete(I);
      end;
  finally
    UpdateCursorPos;
    if Result then FGrid.Invalidate;
  end;
end;

procedure TBookmarkList_.SetCurrentRowSelected(Value: Boolean);
var
  Index: Integer;
  Current: TBookmarkStr;
begin
  Current := CurrentRow;
  if (Length(Current) = 0) or (Find(Current, Index) = Value) then Exit;
  if Value then
    FList.Insert(Index, Current)
  else
    FList.Delete(Index);
  FGrid.InvalidateRow(FGrid.Row);
end;

procedure TBookmarkList_.StringsChanged(Sender: TObject);
begin
  FCache := '';
  FCacheIndex := -1;
end;


{ TCustomDBGrid_ }

var
  DrawBitmap: TBitmap;
  UserCount: Integer;

procedure UsesBitmap;
begin
  if UserCount = 0 then
    DrawBitmap := TBitmap.Create;
  Inc(UserCount);
end;

procedure ReleaseBitmap;
begin
  Dec(UserCount);
  if UserCount = 0 then DrawBitmap.Free;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
var
  B, R: TRect;
  I, Left: Integer;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, ETO_OPAQUE or
      ETO_CLIPPED, @ARect, PChar(Text), Length(Text), nil);
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
    DrawBitmap.Canvas.Lock;
    try
      with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
      begin                     { brush origin tics in painting / scrolling.    }
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);
        R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
        B := Rect(0, 0, Right - Left, Bottom - Top);
      end;
      with DrawBitmap.Canvas do
      begin
        Font := ACanvas.Font;
        Font.Color := ACanvas.Font.Color;
        Brush := ACanvas.Brush;
        Brush.Style := bsSolid;
        FillRect(B);
        SetBkMode(Handle, TRANSPARENT);
        DrawText(Handle, PChar(Text), Length(Text), R, AlignFlags[Alignment]);
      end;
      ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
    finally
      DrawBitmap.Canvas.Unlock;
    end;
  end;
end;


{new WriteText_}{}

procedure DrawImageList(Imglst:TImageList;intIndex:integer;ACanvas: TCanvas;Color:TColor; ARect: TRect;isHighLight:boolean);
begin


           if isHighLight then
             ACanvas.Brush.Color:=clHighlight
           else
               ACanvas.Brush.Color:=color;
              ACanvas.FillRect(ARect) ;
            if    (intIndex>-1) and (ARect.Right - ARect.Left -Imglst.Width>=0)  then
     {$IFDEF VER120} //Borland Delphi 4.0
             Imglst.Draw(ACanvas,(ARect.Right + ARect.Left -Imglst.Width) div 2 ,
            (ARect.Bottom + ARect.Top -Imglst.Height) div 2 ,intIndex,True);
    {$else}
           Imglst.Draw(ACanvas,(ARect.Right + ARect.Left -Imglst.Width) div 2 ,
            (ARect.Bottom + ARect.Top -Imglst.Height) div 2 ,intIndex);

    {$ENDIF}

end;

procedure WriteText_(ACanvas: TCanvas; ARect: TRect; FillRect:Boolean; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; Layout: TTextLayout; MultyL:Boolean; EndEllipsis:Boolean; LeftMarg,RightMarg:Integer);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_EXPANDTABS or DT_NOPREFIX );
var
  rect1:  TRect;
  I, Left, txth, DrawFlag: Integer;
  lpDTP :  TDrawTextParams;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    if (MultyL = False) and (EndEllipsis = False) then begin
      case Alignment of
        taLeftJustify:
          Left := ARect.Left + DX;
        taRightJustify:
          Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
      else { taCenter }
        Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
          - (ACanvas.TextWidth(Text) shr 1);
      end;
      if (FillRect = True) then
        DrawFlag := ETO_OPAQUE or ETO_CLIPPED
      else
        DrawFlag := ETO_OPAQUE or ETO_CLIPPED;
      ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, DrawFlag,
            @ARect, PChar(Text), Length(Text), nil)

    end
    else begin {}{/////////// MultyL}

       if FillRect  then ACanvas.FillRect(ARect);

       DrawFlag := 0;
       if MultyL then DrawFlag := DrawFlag or DT_WORDBREAK;
       if EndEllipsis then DrawFlag := DrawFlag or DT_END_ELLIPSIS;
       DrawFlag := DrawFlag or AlignFlags[Alignment];

        {}
       rect1.Left := 0; rect1.Top := 0; rect1.Right := 0; rect1.Bottom := 0;
       rect1 := ARect;  {}

       lpDTP.cbSize := SizeOf(lpDTP);
       lpDTP.uiLengthDrawn := Length(Text);
       lpDTP.iLeftMargin := LeftMarg;
       lpDTP.iRightMargin := RightMarg;

       InflateRect(rect1, -DX, -DY);

       if (Layout <> tlTop) and MultyL  then
         txth := DrawTextEx(ACanvas.Handle,PChar(Text), Length(Text),    {}
            rect1, DrawFlag or DT_CALCRECT,@lpDTP)
       else txth := 0;
       rect1 := ARect;  {}
       InflateRect(rect1, -DX, -DY);

       case Layout of
        tlTop: ;
        tlBottom: rect1.top := rect1.Bottom - txth;
        tlCenter: rect1.top := rect1.top + ((rect1.Bottom-rect1.top) div 2) - (txth div 2);
       end;


       DrawTextEx(ACanvas.Handle,PChar(Text), Length(Text),    {}
          rect1, DrawFlag,@lpDTP); {}

    end;      {}{\\\\\\\\\\\\\}
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
  end;
end;

constructor TCustomDBGrid_.Create(AOwner: TComponent);
var
  Bmp: TBitmap;
begin
  inherited Create(AOwner);
  inherited DefaultDrawing := False;
  FAcquireFocus := True;
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(HInstance, bmArrow);
    FIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmEdit);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmInsert);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiDot);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
    FIndicators.AddMasked(Bmp, clWhite);
//ddd
    Bmp.LoadFromResourceName(HInstance, bmSmDown);
    FSortMarkerImages := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    FSortMarkerImages.AddMasked(Bmp, clFuchsia);
    Bmp.LoadFromResourceName(HInstance, bmSmUp);
    FSortMarkerImages.AddMasked(Bmp, clFuchsia);
//\\\
  finally
    Bmp.Free;
  end;
  FTitleOffset := 1;
  FIndicatorOffset := 1;
  FUpdateFields := True;
  FOptions := [dgEditing, dgTitles, dgIndicator, dgColumnResize,dgColumnMove,
    dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
  DesignOptionsBoost := [goColSizing];
  VirtualView := True;
  UsesBitmap;
  ScrollBars := ssHorizontal;
  inherited Options := [goFixedHorzLine, goFixedVertLine, goHorzLine,
    goVertLine, goColSizing, goColMoving, goTabs, goEditing];
  FColumns := CreateColumns;
  inherited RowCount := 2;
  inherited ColCount := 2;
  FDataLink := TGridDataLink_.Create(Self);
  Color := clWindow;
  ParentColor := False;
  FTitleFont := TFont.Create;
  FTitleFont.OnChange := TitleFontChanged;
  FSaveCellExtents := False;
  FUserChange := True;
  FDefaultDrawing := True;
  FUpdatingEditor := False;
  FBookmarks := TBookmarkList_.Create(Self);
  HideEditor;

  //ddd

  FTitleHeight := 0;
  FTitleHeightFull := 0;
  FTitleLines := 0;
  FLeafFieldArr := nil;
  FHeadTree := THeadTreeNode.CreateText('корень',10,0);
  FVTitleMargin := 10;
  FHTitleMargin := 0;
  FUseMultiTitle := False;
  FInitColWidth := TList.Create;
  FRowSizingAllowed := False;
  FDefaultRowChanged := False;
  FInplaceEditorButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
end;

destructor TCustomDBGrid_.Destroy;
begin
  FColumns.Free;
  FColumns := nil;
  FDataLink.Free;
  FDataLink := nil;
  FIndicators.Free;
  FTitleFont.Free;
  FTitleFont := nil;
  FBookmarks.Free;
  FBookmarks := nil;
  inherited Destroy;
  ReleaseBitmap;

//ddd
  FSortMarkerImages.Free;
  if(FLeafFieldArr <> nil) then FreeMem(FLeafFieldArr);
  FHeadTree.Free;
  FInitColWidth.Free;
//\\\
end;



  function  TCustomDBGrid_.isImagList:Boolean;
  var
   intCol:integer;
  begin
     intCol:=Col-FIndicatorOffset;
     if  (Columns.Count>0) and (Col>0) then
        result:=   Assigned(Columns[intCol].ImageList) and (Columns[intCol].ImageList.Count>0)
                 and (Columns[intCol].keylist.Count+Columns[intCol].NotInKeyListIndex>-1)
     else      result:=False;
   end;

function TCustomDBGrid_.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
  end;
end;
function TCustomDBGrid_.ImgListVal:Boolean;
var
 iCount:integer;
 isFound:Boolean;
begin
  Result:=True;
  with Columns[Col-FIndicatorOffset] do
   if
      not Readonly
      and (dgEditing in Options)
      and  DataLink.Active
      and  Assigned(KeyList)
      and (KeyList.Count>1)
      and Assigned(Field)
      and   Field.CanModify
       then
    begin
      if DataLink.DataSet.State = dsBrowse then      DataLink.DataSet.Edit;
      if (DataLink.DataSet.State = dsEdit) or (DataLink.DataSet.State = dsInsert) then
      try
         isFound:=False;
         for iCount:=0 to   KeyList.Count-1 do
         if KeyList[iCount]=Field.Text then
         begin
           isFound:=True;
           Break;
         end;

         if not isFound or  (iCount=KeyList.Count-1) then
            Field.Value:=KeyList[0]
         else
             Field.Value:=KeyList[iCount+1]
       Except
        Result:=False;
       end;
    end;
 end;

function TCustomDBGrid_.RawToDataColumn(ACol: Integer): Integer;
begin
  Result := ACol - FIndicatorOffset;
end;

function TCustomDBGrid_.DataToRawColumn(ACol: Integer): Integer;
begin
  Result := ACol + FIndicatorOffset;
end;

function TCustomDBGrid_.AcquireLayoutLock: Boolean;
begin
  Result := (FUpdateLock = 0) and (FLayoutLock = 0);
  if Result then BeginLayout;
end;


procedure TCustomDBGrid_.BeginLayout;
begin
  BeginUpdate;
  if FLayoutLock = 0 then Columns.BeginUpdate;
  Inc(FLayoutLock);
end;

procedure TCustomDBGrid_.BeginUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TCustomDBGrid_.CancelLayout;
begin
  if FLayoutLock > 0 then
  begin
    if FLayoutLock = 1 then
      Columns.EndUpdate;
    Dec(FLayoutLock);
    EndUpdate;
  end;
end;

function TCustomDBGrid_.CanEditAcceptKey(Key: Char): Boolean;
begin
  with Columns[SelectedIndex] do
    Result := FDatalink.Active and Assigned(Field) and Field.IsValidChar(Key);
end;

function TCustomDBGrid_.CanEditModify: Boolean;
begin
  Result := False;
  if not ReadOnly and FDatalink.Active and not FDatalink.Readonly    then
  with Columns[SelectedIndex] do
    if (not ReadOnly) and Assigned(Field) and Field.CanModify
      and (not Field.IsBlob or Assigned(Field.OnSetText)) then
    begin
      FDatalink.Edit;
      Result := FDatalink.Editing;
      if Result then FDatalink.Modified;
    end;
end;

function TCustomDBGrid_.CanEditShow: Boolean;
begin
    Result := (LayoutLock = 0) and not isImagList and inherited CanEditShow ;
//   Result := (LayoutLock = 0) and  inherited CanEditShow ;

 end;

procedure TCustomDBGrid_.CellClick(Column: TColumn_);
begin
  if Assigned(FOnCellClick) then FOnCellClick(Column);
end;

procedure TCustomDBGrid_.CellDblClick(Column: TColumn_);
begin
  if Assigned(FOnCellDblClick) then FOnCellDblClick(Column);
end;

procedure TCustomDBGrid_.ColEnter;
begin
  UpdateIme;
  if Assigned(FOnColEnter) then FOnColEnter(Self);
end;

procedure TCustomDBGrid_.ColExit;
begin
  if Assigned(FOnColExit) then FOnColExit(Self);
end;

procedure TCustomDBGrid_.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  FromIndex := RawToDataColumn(FromIndex);
  ToIndex := RawToDataColumn(ToIndex);
  Columns[FromIndex].Index := ToIndex;
  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
end;

procedure TCustomDBGrid_.ColWidthsChanged;
var
  I: Integer;
  OldWidth:Integer;
begin
  inherited ColWidthsChanged;
  if (FDatalink.Active or (FColumns.State = csCustomized)) and
    AcquireLayoutLock then
  try
    for I := FIndicatorOffset to ColCount - 1 do

     //ddd
     // FColumns[I - FIndicatorOffset].Width := ColWidths[I];
     if (AutoFitColWidths = False) or (csDesigning in ComponentState) then
       FColumns[I - FIndicatorOffset].Width := ColWidths[I]
     else
       if (FColumns[I - FIndicatorOffset].Width <> ColWidths[I]) then begin
          if (FColumns[I - FIndicatorOffset].AutoFitColWidth = True) then begin
            OldWidth := FColumns[I - FIndicatorOffset].FInitWidth;
            FColumns[I - FIndicatorOffset].FInitWidth :=
              MulDiv(FColumns[I - FIndicatorOffset].FInitWidth,ColWidths[I],FColumns[I - FIndicatorOffset].Width);
            if (I <> ColCount - 1) then begin
              Inc(FColumns[I - FIndicatorOffset + 1].FInitWidth,OldWIdth - FColumns[I - FIndicatorOffset].FInitWidth);
              if (FColumns[I - FIndicatorOffset + 1].FInitWidth < 0) then FColumns[I - FIndicatorOffset + 1].FInitWidth := 0;
            end;
          end
          else FColumns[I - FIndicatorOffset].Width := ColWidths[I];
       end;
     //\\\
  finally
    EndLayout;
  end;
end;

function TCustomDBGrid_.CreateColumns: TDBGridColumns_;
begin
  Result := TDBGridColumns_.Create(Self,TColumn_);
end;

function TCustomDBGrid_.CreateEditor: TInplaceEdit;
begin
  Result := TDBGrid_InplaceEdit.Create(Self);
end;

 procedure TCustomDBGrid_.CreateWnd;
begin
  BeginUpdate;   { prevent updates in WMSize message that follows WMCreate }
  try
    inherited CreateWnd;
  finally
    EndUpdate;
  end;
  UpdateRowCount;
  UpdateActive;
  UpdateScrollBar;
  FOriginalImeName := ImeName;
  FOriginalImeMode := ImeMode;
end;

procedure TCustomDBGrid_.DataChanged;
begin
  if not HandleAllocated then Exit;
  UpdateRowCount;
  UpdateScrollBar;
  UpdateActive;
  InvalidateEditor;
  ValidateRect(Handle, nil);
  Invalidate;
end;

procedure TCustomDBGrid_.DefaultHandler(var Msg);
var
  P: TPopupMenu;
  Cell: TGridCoord;
begin
  inherited DefaultHandler(Msg);
  if TMessage(Msg).Msg = wm_RButtonUp then
    with TWMRButtonUp(Msg) do
    begin
      Cell := MouseCoord(XPos, YPos);
      if (Cell.X < FIndicatorOffset) or (Cell.Y < 0) then Exit;
      P := Columns[RawToDataColumn(Cell.X)].PopupMenu;
      if (P <> nil) and P.AutoPopup then
      begin
        SendCancelMode(nil);
        P.PopupComponent := Self;
        with ClientToScreen(SmallPointToPoint(Pos)) do
          P.Popup(X, Y);
        Result := 1;
      end;
    end;
end;

procedure TCustomDBGrid_.DeferLayout;
var
  M: TMsg;
begin
  if HandleAllocated and
    not PeekMessage(M, Handle, cm_DeferLayout, cm_DeferLayout, pm_NoRemove) then
    PostMessage(Handle, cm_DeferLayout, 0, 0);
  CancelLayout;
end;

procedure TCustomDBGrid_.DefineFieldMap;
var
  I: Integer;
begin
  if FColumns.State = csCustomized then
  begin   { Build the column/field map from the column attributes }
    DataLink.SparseMap := True;
    for I := 0 to FColumns.Count-1 do
      FDataLink.AddMapping(FColumns[I].FieldName);
  end
  else   { Build the column/field map from the field list order }
  begin
    FDataLink.SparseMap := False;
    with Datalink.Dataset do
      for I := 0 to FieldCount - 1 do
        with Fields[I] do if Visible then Datalink.AddMapping(FieldName);
  end;
end;

procedure TCustomDBGrid_.DefaultDrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
var
  Alignment: TAlignment;
  Value: string;
begin
  Alignment := taLeftJustify;
  Value := '';
  if Assigned(Field) then
  begin
    Alignment := Field.Alignment;
    Value := Field.DisplayText;
  end;
  WriteText(Canvas, Rect, 2, 2, Value, Alignment);
end;

procedure TCustomDBGrid_.DefaultDrawColumnCell(const Rect: TRect;
  DataCol: Integer; Column: TColumn_; State: TGridDrawState);
var
  Value: string;
begin
  Value := '';
  if Assigned(Column.Field) then
    Value := Column.Field.DisplayText;
  WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment);
end;

procedure TCustomDBGrid_.ReadColumns(Reader: TReader);
begin
  Columns.Clear;
  Reader.ReadValue;
  Reader.ReadCollection(Columns);
end;

procedure TCustomDBGrid_.WriteColumns(Writer: TWriter);
begin
  Writer.WriteCollection(Columns);
end;

procedure TCustomDBGrid_.DefineProperties(Filer: TFiler);
var
Sender:TComponent;
begin
  Filer.DefineProperty('Columns', ReadColumns, WriteColumns,
    ((Columns.State = csCustomized) and (Filer.Ancestor = nil)) or
    ((Filer.Ancestor <> nil) and
     ((Columns.State <> TCustomDBGrid_(Filer.Ancestor).Columns.State) or
      (not CollectionsEqual(Columns, TCustomDBGrid_(Filer.Ancestor).Columns,Sender,Sender)) )));
end;

{ ddd new DrawCell}
 function  TCustomDBGrid_.FindStringsIndex(_Strings:TStrings;FindText:String;DefatultIndex,MaxIndex:integer):integer;
 var
  intTmp:integer;
 begin
   if datalink.dataset.isempty then
   begin
    result:=-1;
    Exit;
   end;
   Result:=DefatultIndex;
   if   _Strings<>nil then
   for intTmp:=0 to _Strings.Count-1 do
   if trim(_Strings[intTmp])=trim(FindText) then
   begin
    result:=intTmp;
    Break;
   end;
   if Result>maxIndex then Result:=-1;
 end;



procedure TCustomDBGrid_.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  OldActive{, SorCol, SorRow}: Integer;
  Highlight: Boolean;
  Value,  Value_Text: string;
  DrawColumn: TColumn_;
  FrameOffs: Byte;
  ARect1{,SorRect}:TRect;
  Down: Boolean;
  MultiSelected: Boolean;
  Indicator,LeftMarg,RightMarg: Integer;
  BackColor: TColor;
  ASortMarker: TSortMarker_;
  SortMarkerIdx:Integer;
  NewBackgrnd:TColor;
  AEditStyle:TEditStyle;
  intImageIndex:integer;
  strTmp_:String;

  function strReplace(strTmp:String):String;
  var
    intTmp:integer;
  begin
      result:='';
      for intTmp:=1 to Length(strTmp) do
       if StrTmp[intTmp]='|' then
          result:=result+#13#10
       else
          result:=result+strTmp[intTmp];

  end;
  function RowIsMultiSelected: Boolean;
  var
    Index: Integer;
  begin
    Result := (dgMultiSelect in Options) and Datalink.Active and
      FBookmarks.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  end;

  procedure DrawHost(ALeaf:THeadTreeNode; DHRect:TRect; AEndEllipsis: Boolean);
  var curLeaf: THeadTreeNode;
     curW:Integer;
     leftM:Integer;
     drawRec, FrozenRectCell:TRect;
     OldColor:TColor;
  begin
    DHRect.Bottom := DHRect.Top-1;
    Dec(DHRect.Top,ALeaf.Host.Height);

    curLeaf := ALeaf.Host.Child;
    curW := 0;
    while curLeaf <> ALeaf do
    begin
             Inc(curW,curLeaf.Width);
             if dgColLines in Options then Inc(curW,1);
             curLeaf := curLeaf.Next;
    end;
    Dec(DHRect.Left,curW);
    DHRect.Right := DHRect.Left + ALeaf.Host.Width;

    leftM := 0;
    drawRec := DHRect;

    if (DHRect.Left < ColWidths[0]) and (dgIndicator in Options) then
    begin       leftM := DHRect.Left - ColWidths[0]-1;   drawRec.Left := ColWidths[0]+1;  end;


    if  FrozenCols > 0   then
     begin
      FrozenRectCell := CellRect(FixedCols-1,0);
       if  (FrozenRectCell.Right > drawRec.Left)
           and (FrozenRectCell.Right < drawRec.Right)
           and (FixedCols<ACol)
       then
       begin
        Dec(leftM,FrozenRectCell.Right - drawRec.Left);
            drawRec.Left := FrozenRectCell.Right + 1;

      end;
    end;


    InflateRect(DHRect, 1, 1);
    if(leftM  <> 0) then
      WriteText_(Canvas, drawRec, True, FrameOffs-1, FrameOffs,ALeaf.Host.Text , taCenter,tlCenter,True,AEndEllipsis,leftM,0)
    else
      WriteText_(Canvas, drawRec, True, FrameOffs, FrameOffs, ALeaf.Host.Text, taCenter,tlCenter,True,AEndEllipsis,leftM,0);

    ALeaf.Host.Drawed := True;

    if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
      [dgRowLines, dgColLines]) then
    begin
      if(leftM  <> 0) then
        DrawEdge(Canvas.Handle, drawRec, BDR_RAISEDINNER, BF_TOP)
      else
        DrawEdge(Canvas.Handle, drawRec, BDR_RAISEDINNER, BF_TOPLEFT);
      DrawEdge(Canvas.Handle, drawRec, BDR_RAISEDINNER, BF_BOTTOMRIGHT);

      InflateRect(DHRect, -1, -1);
    end;

    OldColor := Canvas.Pen.Color;
    Canvas.Pen.Color := clBlack;
    Canvas.MoveTo(drawRec.Left,drawRec.Bottom);
    Canvas.LineTo(drawRec.Right,drawRec.Bottom);
    Canvas.Pen.Color := OldColor;

    if(ALeaf.Host.Host <> nil) and not ALeaf.Host.Host.Drawed  then begin
      DrawHost(ALeaf.Host,DHRect,AEndEllipsis);
      ALeaf.Host.Host.Drawed := True;
    end;
  end;


begin
//ddd  SorRect := ARect; SorCol := ACol; SorRow := ARow;
  DrawColumn := nil;
  Down := False;
  intImageIndex:=-1;
  if csLoading in ComponentState then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ARect);
    Exit;
  end;

  Dec(ARow, FTitleOffset);
  Dec(ACol, IndicatorOffset);

  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) and
    //ddd
    ((FFooterRowCount = 0) or ((FFooterRowCount > 0) and (ARow <> RowCount - FFooterRowCount - 1 - FTitleOffset)) )
    and ((ACol < 0) or (ARow < 0)) then
    //\\\
  begin
    InflateRect(ARect, -1, -1);
    FrameOffs := 1;
  end
  else
    FrameOffs := 2;

  if (gdFixed in AState) and (ACol < 0) then 
  begin    //ddd
    if ((FFooterRowCount = 0) or ((FFooterRowCount > 0) and (ARow <> RowCount - FFooterRowCount - 1 - FTitleOffset))) then
      Canvas.Brush.Color := FixedColor
     else
      Canvas.Brush.Color := Color;
    //ddd
    Canvas.FillRect(ARect);
    if Assigned(DataLink) and DataLink.Active  then
    begin
      MultiSelected := False;
//ddd
      if (ARow >= 0)   and ( (ARow < FDatalink.RecordCount) or (FFooterRowCount = 0) ) then // Рисуем индикато?
//\\\
      begin
        OldActive := FDataLink.ActiveRecord;
        try
          FDatalink.ActiveRecord := ARow;
          MultiSelected := RowIsMultiselected;
        finally
          FDatalink.ActiveRecord := OldActive;
        end;
      end;
      if (ARow = FDataLink.ActiveRecord) or MultiSelected then
      begin
        Indicator := 0;
        if FDataLink.DataSet <> nil then
          case FDataLink.DataSet.State of
            dsEdit: Indicator := 1;
            dsInsert: Indicator := 2;
            dsBrowse:
              if MultiSelected then
                if (ARow <> FDatalink.ActiveRecord) then
                  Indicator := 3
                else
                  Indicator := 4;  // multiselected and current row
          end;
        FIndicators.BkColor := FixedColor;
        FIndicators.Draw(Canvas, ARect.Right - FIndicators.Width - FrameOffs,
          (ARect.Top + ARect.Bottom - FIndicators.Height) shr 1, Indicator);
        if ARow = FDatalink.ActiveRecord then
          FSelRow := ARow + FTitleOffset;
      end;
    end;
  end
  else with Canvas do
       begin
        DrawColumn := Columns[ACol];
{        if (gdFixed in AState) and ((ACol < 0) or (ARow < 0)) then
        begin
         Font := DrawColumn.Title.Font;
         Brush.Color := DrawColumn.Title.Color;
        end
       else
        begin
          Font := DrawColumn.Font;
          Brush.Color := DrawColumn.Color;
        end;
 }
//zhang begin

      if (gdFixed in AState) then
      begin
        if (ARow < 0) then
        begin
         Font := DrawColumn.Title.Font;
         Brush.Color := DrawColumn.Title.Color;
        end
        else
         begin
            if ((FFooterRowCount = 0) or ((FFooterRowCount > 0) and (ARow <> RowCount - FFooterRowCount - 1 - FTitleOffset))) then
                Canvas.Brush.Color := FixedColor
             else
               Brush.Color := DrawColumn.Color;
              Font := DrawColumn.Font;
         end;
       end
       else
        begin
          Font := DrawColumn.Font;
          Brush.Color := DrawColumn.Color;
        end;
//zhang end;

   if ARow < 0 then
   with DrawColumn.Title do
   begin
// new --

         ASortMarker := DrawColumn.Title.SortMarker;
         if (DrawColumn.Field <> nil) and Assigned(FOnGetBtnParams) then
         begin
           BackColor := Canvas.Brush.Color;
           FOnGetBtnParams(Self, DrawColumn, Canvas.Font, BackColor, ASortMarker, Down);
           Canvas.Brush.Color := BackColor;
         end;


         Down := (FPressedCol-IndicatorOffset  = ACol) and FPressed;
         if FUseMultiTitle then
            ARect.Top := ARect.Bottom
                        - FLeafFieldArr[ACol].FLeaf.Height
                        + 3;
         ARect1 := ARect;




         if Down then
         begin
           if FUseMultiTitle or (TitleHeight <> 0) or (TitleLines <> 0) then begin
             LeftMarg := 2; RightMarg := -2; Inc(ARect1.Top,2);
           end else   begin
                         LeftMarg := 1; RightMarg := -1; Inc(ARect1.Top,1);
                      end;
         end else begin
                    LeftMarg := 0;
                    RightMarg := 0;
                  end;
         case ASortMarker of
           smDown: SortMarkerIdx := 0;
           smUp: SortMarkerIdx := 1;
           else SortMarkerIdx := -1;
         end;
         if SortMarkerIdx <> -1 then Dec(ARect1.Right,16);
         Canvas.FillRect(ARect);
         if FUseMultiTitle  then
         begin
//           Font := TitleFont;    
           strTmp_:=FLeafFieldArr[ACol].FLeaf.Text;

           WriteText_(Canvas, ARect1, False, FrameOffs, FrameOffs, strTmp_, taCenter,tlCenter,True,EndEllipsis,LeftMarg,RightMarg);
           //Canvas.Pen.Color := clWindowFrame;
         end
         else if (TitleHeight <> 0) or (TitleLines <> 0) then
              begin
                 strTmp_:=strReplace(Caption);
                 WriteText_(Canvas, ARect1, False, FrameOffs, FrameOffs, strTmp_, Alignment,tlCenter,True,EndEllipsis,LeftMarg,RightMarg)
               end
              else  begin
                      ARect1.Left := ARect1.Left + LeftMarg;
                      ARect1.Right := ARect1.Right - RightMarg;
                      WriteText_(Canvas, ARect1, False, FrameOffs, FrameOffs, Caption, Alignment,tlTop,False,EndEllipsis,LeftMarg,RightMarg);
                    end;

         if (SortMarkerIdx <> -1)
           and(ARect.Right - FSortMarkerImages.Width - 4 + LeftMarg-ARect.Left>0)  then
         begin
           FSortMarkerImages.BkColor := Canvas.Brush.Color;
           FSortMarkerImages.Draw(Canvas, ARect.Right - FSortMarkerImages.Width - 4 + LeftMarg,
           (ARect.Bottom + ARect.Top - FSortMarkerImages.Height) div 2 + LeftMarg, SortMarkerIdx);
         end;

    end
//\\\\\\\\\\\\\\\\\
   else if (DataLink = nil) or not DataLink.Active then      FillRect(ARect)
    else
     begin  //
        Value := '';
        OldActive := DataLink.ActiveRecord;

       try

//zhang              if ((ARow >= 0) and (ARow < FDatalink.RecordCount)) or (FFooterRowCount = 0) then
          if   (ARow < FDatalink.RecordCount) or (FFooterRowCount = 0) then
             begin
                 DataLink.ActiveRecord := ARow;
                 if (DrawColumn.AlwaysShowEditButton) then
                 begin
                       AEditStyle := GetColumnEditStile(DrawColumn);
                       if (AEditStyle <> esSimple) then
                       begin
                          SetRect(ARect1,ARect.Right - FInplaceEditorButtonWidth,ARect.Top,ARect.Right,ARect.Bottom);
                          PaintInplaceButton(Canvas.Handle,AEditStyle,ARect1,False,DataLink.Active);
                          ARect.Right := ARect.Right - FInplaceEditorButtonWidth;
                       end;
                end;
          if Assigned(DrawColumn.Field) then
          begin
            if DrawMemoText  and (DrawColumn.Field.DataType = ftMemo) then
              Value := DrawColumn.Field.AsString
            else
             begin
               Value := DrawColumn.Field.DisplayText;
               Value_Text:=DrawColumn.Field.Text;
            end;

            if Assigned(DrawColumn.ImageList) and (DrawColumn.ImageList.Count>0)
                and (DrawColumn.keylist.Count+DrawColumn.NotInKeyListIndex>-1)
             then

               intImageIndex:= FindStringsIndex(DrawColumn.keylist,Value_Text,DrawColumn.NotInKeyListIndex,DrawColumn.ImageList.Count-1);
          end;
{
          Highlight := HighlightCell(ACol, ARow, Value, AState);
          if Highlight then
          begin
            Brush.Color := clHighlight;
            Font.Color := clHighlightText;
          end;

}
//zhang start
         Highlight:=False;
         if not  (gdFixed in Astate)  then
         begin
          Highlight := HighlightCell(ACol, ARow, Value, AState);
          if Highlight then
          begin
            Brush.Color := clHighlight;
            Font.Color := clHighlightText;
          end;
         end;
//zhang over;
          NewBackgrnd := Brush.Color;
          GetCellParams(DrawColumn,Font,NewBackgrnd,AState);
          Brush.Color := NewBackgrnd;

         if  DefaultDrawing  then
          begin
            if  intImageIndex=-1   then
               WriteText_(Canvas, ARect, True, 2, 2, Value, DrawColumn.Alignment,tlTop,DrawColumn.WordWrap and FAllowWordWrap, DrawColumn.EndEllipsis,0,0)
            else

               DrawImageList(DrawColumn.ImageList,intImageIndex,Canvas,Color,ARect,Highlight);
          end;
          if Columns.State = csDefault then      DrawDataCell(ARect, DrawColumn.Field, AState);
          DrawColumnCell(ARect, ACol, DrawColumn, AState);
        end
       else
        //ddd Draw Fotter Cells
        if     (FFooterRowCount > 0)
           and (ARow > RowCount - FFooterRowCount - 1 - FTitleOffset)
        then
          begin
            NewBackgrnd := Brush.Color;
            GetFootCellParams(DrawColumn,Font,NewBackgrnd,AState);
            Brush.Color := NewBackgrnd;
           if  Assigned(OnDrawFotterCell) then
           begin
              if FDefaultDrawing then FillRect(ARect);
               OnDrawFotterCell(Self,ACol,FFooterRowCount - RowCount + ARow + FTitleOffset,DrawColumn,ARect,AState);
           end
           else FillRect(ARect);
          end
       else
          FillRect(ARect);
        //\\\
      finally
        DataLink.ActiveRecord := OldActive;
      end;

       if   DefaultDrawing and (gdSelected in AState)
        and ((dgAlwaysShowSelection in Options) or Focused)
        and not (csDesigning in ComponentState)
        and (UpdateLock = 0)
        and not (dgRowSelect in Options)
        and (ValidParentForm(Self).ActiveControl = Self)
        and  not isImagList then
          Windows.DrawFocusRect(Handle, ARect);
    end;
  end;

  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) and
    //ddd
    ((FFooterRowCount = 0) or ((FFooterRowCount > 0) and (ARow <> RowCount - FFooterRowCount - 1 - FTitleOffset)) )
    and ((ACol < 0) or (ARow < 0)) then
    //\\\
  begin
    InflateRect(ARect, 1, 1);
    if Down then
    begin
      DrawEdge(Canvas.Handle, ARect, BDR_SUNKENINNER, BF_BOTTOMRIGHT);
      DrawEdge(Canvas.Handle, ARect, BDR_SUNKENINNER, BF_TOPLEFT);
    end else
        begin
          DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
          DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
        end;
   end;

   if (ARow < 0) and (ACol >= 0) and FUseMultiTitle  then
   with DrawColumn.Title do
   begin // Draw mastertitle
    if(FLeafFieldArr[ACol].FLeaf.Host <> nil) and  not FLeafFieldArr[ACol].FLeaf.Host.Drawed  then
       DrawHost(FLeafFieldArr[ACol].FLeaf,ARect,EndEllipsis);
   end;

end;


procedure TCustomDBGrid_.DrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
begin
  if Assigned(FOnDrawDataCell) then FOnDrawDataCell(Self, Rect, Field, State);
end;

procedure TCustomDBGrid_.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn_; State: TGridDrawState);
begin
   if Assigned(OnDrawColumnCell) then
    OnDrawColumnCell(Self, Rect, DataCol, Column, State);

end;

procedure TCustomDBGrid_.EditButtonClick;
begin
  if Assigned(FOnEditButtonClick) then FOnEditButtonClick(Self);
end;

procedure TCustomDBGrid_.EditingChanged;
begin
  if dgIndicator in Options then InvalidateCell(0, FSelRow);
end;

procedure TCustomDBGrid_.EndLayout;
begin
  if FLayoutLock > 0 then
  begin
    try
      try
        if FLayoutLock = 1 then
          InternalLayout;
      finally
        if FLayoutLock = 1 then
          FColumns.EndUpdate;
      end;
    finally
      Dec(FLayoutLock);
      EndUpdate;
    end;
  end;
end;

procedure TCustomDBGrid_.EndUpdate;
begin
  if FUpdateLock > 0 then
    Dec(FUpdateLock);
end;

function TCustomDBGrid_.GetColField(DataCol: Integer): TField;
begin
  Result := nil;
  if (DataCol >= 0) and FDatalink.Active and (DataCol < Columns.Count) then
    Result := Columns[DataCol].Field;
end;

function TCustomDBGrid_.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TCustomDBGrid_.GetEditLimit: Integer;
begin
  Result := 0;
  if Assigned(SelectedField) and (SelectedField.DataType = ftString) then
    Result := SelectedField.Size;
end;

function TCustomDBGrid_.GetEditMask(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active then
  with Columns[RawToDataColumn(ACol)] do
    if Assigned(Field) then
      Result := Field.EditMask;
end;

function TCustomDBGrid_.GetEditText(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active then
  with Columns[RawToDataColumn(ACol)] do
    if Assigned(Field) then
      Result := Field.Text;
  FEditText := Result;
end;

function TCustomDBGrid_.GetFieldCount: Integer;
begin
  Result := FDatalink.FieldCount;
end;

function TCustomDBGrid_.GetFields(FieldIndex: Integer): TField;
begin
  Result := FDatalink.Fields[FieldIndex];
end;

function TCustomDBGrid_.GetFieldValue(ACol: Integer): string;
var
  Field: TField;
begin
  Result := '';
  Field := GetColField(ACol);
  if Field <> nil then Result := Field.DisplayText;
end;

function TCustomDBGrid_.GetSelectedField: TField;
var
  Index: Integer;
begin
  Index := SelectedIndex;
  if Index <> -1 then
    Result := Columns[Index].Field
  else
    Result := nil;
end;

function TCustomDBGrid_.GetSelectedIndex: Integer;
begin
  Result := RawToDataColumn(Col);
end;

function TCustomDBGrid_.HighlightCell(DataCol, DataRow: Integer;
  const Value: string; AState: TGridDrawState): Boolean;
var
  Index: Integer;
begin
  Result := False;
  if (dgMultiSelect in Options) and Datalink.Active then
    Result := FBookmarks.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  if not Result then
    Result := (gdSelected in AState)
      and ((dgAlwaysShowSelection in Options) or Focused)
        { updatelock eliminates flicker when tabbing between rows }
      and ((UpdateLock = 0) or (dgRowSelect in Options));
end;

procedure TCustomDBGrid_.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyDownEvent: TKeyEvent;

  procedure ClearSelection;
  begin
    if (dgMultiSelect in Options) then
    begin
      FBookmarks.Clear;
      FSelecting := False;
    end;
  end;

  procedure DoSelection(Select: Boolean; Direction: Integer);
  var
    AddAfter: Boolean;
  begin
    AddAfter := False;
    BeginUpdate;
    try
      if (dgMultiSelect in Options) and FDatalink.Active then
        if Select and (ssShift in Shift) then
        begin
          if not FSelecting then
          begin
            FSelectionAnchor := FBookmarks.CurrentRow;
            FBookmarks.CurrentRowSelected := True;
            FSelecting := True;
            AddAfter := True;
          end
          else
          with FBookmarks do
          begin
            AddAfter := Compare(CurrentRow, FSelectionAnchor) <> -Direction;
            if not AddAfter then
              CurrentRowSelected := False;
          end
        end
        else
          ClearSelection;
      FDatalink.Dataset.MoveBy(Direction);
      if AddAfter then FBookmarks.CurrentRowSelected := True;
    finally
      EndUpdate;
    end;
  end;

  procedure NextRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
    begin
      if (State = dsInsert) and not Modified and not FDatalink.FModified then
        if EOF then Exit else Cancel
      else
        DoSelection(Select, 1);
      if EOF and CanModify and (not ReadOnly) and (dgEditing in Options) then
        Append;
    end;
  end;

  procedure PriorRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
      if (State = dsInsert) and not Modified and EOF and
        not FDatalink.FModified then
        Cancel
      else
        DoSelection(Select, -1);
  end;

  procedure Tab(GoForward: Boolean);
  var
    ACol, Original: Integer;
  begin
    ACol := Col;
    Original := ACol;
    BeginUpdate;    { Prevent highlight flicker on tab to next/prior row }
    try
      while True do
      begin
        if GoForward then
          Inc(ACol) else
          Dec(ACol);
        if ACol >= ColCount then
        begin
          NextRow(False);
          ACol := FIndicatorOffset + {ddd}FrozenCols;
        end
        else if ACol < FIndicatorOffset + {ddd}FrozenCols then
        begin
          PriorRow(False);
          ACol := ColCount;
        end;
        if ACol = Original then Exit;
        if TabStops[ACol] then
        begin
          MoveCol(ACol);
          Exit;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  function DeletePrompt: Boolean;
  var
    Msg: string;
  begin
    if (FBookmarks.Count > 1) then
      Msg := SDeleteMultipleRecordsQuestion
    else
      Msg := SDeleteRecordQuestion;
    Result := not (dgConfirmDelete in Options) or
      (MessageDlg(Msg, mtConfirmation, mbOKCancel, 0) <> idCancel);
  end;

const
  RowMovementKeys = [VK_UP, VK_PRIOR, VK_DOWN, VK_NEXT, VK_HOME, VK_END];

begin
  KeyDownEvent := OnKeyDown;
  if Assigned(KeyDownEvent) then KeyDownEvent(Self, Key, Shift);
  if not FDatalink.Active or not CanGridAcceptKey(Key, Shift) then Exit;
  with FDatalink.DataSet do
    if ssCtrl in Shift then
    begin
      if (Key in RowMovementKeys) then ClearSelection;
      case Key of
        VK_UP, VK_PRIOR: MoveBy(-FDatalink.ActiveRecord);
        VK_DOWN, VK_NEXT: MoveBy(FDatalink.BufferCount - FDatalink.ActiveRecord - 1);
//ddd        VK_LEFT: MoveCol(FIndicatorOffset);
        VK_LEFT: MoveCol(FIndicatorOffset + FrozenCols);
        VK_RIGHT: MoveCol(ColCount - 1);
        VK_HOME: First;
        VK_END: Last;
        VK_DELETE:
          if (not ReadOnly) and not IsEmpty
            and CanModify and DeletePrompt then
          if FBookmarks.Count > 0 then
            FBookmarks.Delete
          else
            Delete;
      end
    end
    else
      case Key of
        VK_UP: PriorRow(True);
        VK_DOWN: NextRow(True);
        VK_LEFT:
          if dgRowSelect in Options then begin
            // ddd
             if(LeftCol > IndicatorOffset + FrozenCols) then LeftCol := LeftCol - 1
          end
            // ddd
            {PriorRow(False)} else
            MoveCol(Col - 1);
        VK_RIGHT:
          if dgRowSelect in Options then begin
            // ddd
                if(VisibleColCount + LeftCol < ColCount ) then
                    LeftCol := LeftCol + 1;  {new}

           { NextRow(False) }
            //\\\
           end else
            MoveCol(Col + 1);
        VK_HOME:
          if (ColCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            First;
          end
          else
            MoveCol(FIndicatorOffset);
        VK_END:
          if (ColCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            Last;
          end
          else
            MoveCol(ColCount - 1);
        VK_NEXT:
          begin
            ClearSelection;
            MoveBy(VisibleRowCount);
          end;
        VK_PRIOR:
          begin
            ClearSelection;
            MoveBy(-VisibleRowCount);
          end;
        VK_INSERT:
          if CanModify and (not ReadOnly) and (dgEditing in Options) then
          begin
            ClearSelection;
            Insert;
          end;
        VK_TAB: if not (ssAlt in Shift) then Tab(not (ssShift in Shift));
        VK_ESCAPE:
          begin
            FDatalink.Reset;
            ClearSelection;
            if not (dgAlwaysShowEditor in Options) then HideEditor;
          end;
        VK_F2: EditorMode := True;
      end;
end;

procedure TCustomDBGrid_.KeyPress(var Key: Char);
begin
   if  (Key = #13) and isImagList then
             imgListVal;

   if not (dgAlwaysShowEditor in Options) then
   if Key = #13 then
    FDatalink.UpdateData;

  inherited KeyPress(Key);
end;

{ InternalLayout is called with layout locks and column locks in effect }
procedure TCustomDBGrid_.InternalLayout;
var
  I, J, K: Integer;
  Fld: TField;
  Column: TColumn_;
  SeenPassthrough: Boolean;
  RestoreCanvas: Boolean;

  tm: TTEXTMETRIC;
  CW, {LineW, OldRow0,} CountedWidth: Integer;
  AFont:TFont;

  function FieldIsMapped(F: TField): Boolean;
  var
    X: Integer;
  begin
    Result := False;
    if F = nil then Exit;
    for X := 0 to FDatalink.FieldCount-1 do
      if FDatalink.Fields[X] = F then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  if (csLoading in ComponentState) then Exit;

  if HandleAllocated then KillMessage(Handle, cm_DeferLayout);

  { Check for Columns.State flip-flop }
  SeenPassthrough := False;
  for I := 0 to FColumns.Count-1 do
  begin
    if (FColumns[I] is TPassthroughColumn) then
      SeenPassthrough := True
    else
      if SeenPassthrough then
      begin   { We have both custom and passthrough columns. Kill the latter }
        for J := FColumns.Count-1 downto 0 do
        begin
          Column := FColumns[J];
          if Column is TPassthroughColumn then
            Column.Free;
        end;
        Break;
      end;
  end;

  FIndicatorOffset := 0;
  if dgIndicator in Options then
    Inc(FIndicatorOffset);
  FDatalink.ClearMapping;
  if FDatalink.Active then DefineFieldMap;
  if FColumns.State = csDefault then
  begin
     { Destroy columns whose fields have been destroyed or are no longer
       in field map }
    if (not FDataLink.Active) and (FDatalink.DefaultFields) then
      FColumns.Clear
    else
      for J := FColumns.Count-1 downto 0 do
        with FColumns[J] do
        if not Assigned(Field)
          or not FieldIsMapped(Field) then Free;
    I := FDataLink.FieldCount;
    if (I = 0) and (FColumns.Count = 0) then Inc(I);
    for J := 0 to I-1 do
    begin
      Fld := FDatalink.Fields[J];
      if Assigned(Fld) then
      begin
        K := J;
         { Pointer compare is valid here because the grid sets matching
           column.field properties to nil in response to field object
           free notifications.  Closing a dataset that has only default
           field objects will destroy all the fields and set associated
           column.field props to nil. }
        while (K < FColumns.Count) and (FColumns[K].Field <> Fld) do
          Inc(K);
        if K < FColumns.Count then
          Column := FColumns[K]
        else
        begin
          Column := TPassthroughColumn.Create(FColumns);
          Column.Field := Fld;
        end;
      end
      else
        Column := TPassthroughColumn.Create(FColumns);
      Column.Index := J;
    end;
  end
  else
  begin
    { Force columns to reaquire fields (in case dataset has changed) }
    for I := 0 to FColumns.Count-1 do
      FColumns[I].Field := nil;
  end;
  ColCount := FColumns.Count + FIndicatorOffset;
  //Zt begin

  if  ColCount>FIndicatorOffset + FrozenCols then
    inherited FixedCols := FIndicatorOffset + FrozenCols
  else
     inherited FixedCols := FIndicatorOffset ;
  //zt end;
  FTitleOffset := 0;
  if dgTitles in Options then FTitleOffset := 1;
  RestoreCanvas := not HandleAllocated;
  if RestoreCanvas then
    Canvas.Handle := GetDC(0);
  try
    Canvas.Font := Font;
    K := Canvas.TextHeight('Wg') + 3;
    if dgRowLines in Options then
      Inc(K, GridLineWidth);
    //ddd
    // DefaultRowHeight := K;
    GetTextMetrics(Canvas.Handle, tm);
    if (FNewRowsHeight > 0) or (FRowLines > 0) then
      DefaultRowHeight := FNewRowsHeight + (tm.tmExternalLeading + tm.tmHeight)*FRowLines
    else
      DefaultRowHeight := K;

    if (tm.tmExternalLeading + tm.tmHeight + tm.tmInternalLeading + 4 < DefaultRowHeight) then
      FAllowWordWrap := True
    else
      FAllowWordWrap := False;

    //\\\
    if dgTitles in Options then
    begin
      K := 0;
      for I := 0 to FColumns.Count-1 do
      begin
        Canvas.Font := FColumns[I].Title.Font;
        J := Canvas.TextHeight('Wg') + 4;
        if J > K then K := J;
      end;
      if K = 0 then
      begin
        Canvas.Font := FTitleFont;
        K := Canvas.TextHeight('Wg') + 4;
      end;
      RowHeights[0] := K;
    end;
  finally
    if RestoreCanvas then
    begin
      ReleaseDC(0,Canvas.Handle);
      Canvas.Handle := 0;
    end;
  end;


  // AutoFitColWidths
//  LineW := iif(dgColLines in Options,1,0);
  if (FAutoFitColWidths = True) and not(csDesigning in ComponentState) then begin
    CW := 0;
    K := 0;
    for i := 0 to Columns.Count - 1 do
      if (Columns[i].AutoFitColWidth = False) then
        Inc(CW,Columns[i].Width)
      else
        Inc(K, Columns[i].FInitWidth);

    UpdateScrollBar;
    if (ClientWidth > FMinAutoFitWidth) then CW := ClientWidth - CW else CW := FMinAutoFitWidth - CW;
    if (CW < 0) then CW := 0;
    if (dgIndicator in Options) then Dec(CW,ColWidths[0]);
    if (dgColLines in Options) then Dec(CW,ColCount);

    CountedWidth := 0;
    for i := 0 to Columns.Count - 1 do begin
     if (Columns[i].AutoFitColWidth = True) then begin
       Columns[i].Width := MulDiv(Columns[i].FInitWidth,CW,K);
       Inc(CountedWidth,Columns[i].Width);
     end;
    end;

    if (CountedWidth <> CW) then begin // Correct last AutoFitColWidth column
      for i := Columns.Count - 1 downto 0 do
       if (Columns[i].AutoFitColWidth = True) then begin
         Columns[i].Width := Columns[i].Width + CW - CountedWidth;
         if (Columns[i].Width < 0) then Columns[i].Width := 0;
         Break;
       end;
    end;
  end;

  // Title and MultyTitle
  if  (dgTitles in Options) then begin
    if (TitleHeight <> 0) or (TitleLines <> 0) then begin
      K := 0;
      for I := 0 to Columns.Count-1 do
      begin
        Canvas.Font := Columns[I].Title.Font;
        J := Canvas.TextHeight('Wg') + 4;
        if J > K then begin K := J; GetTextMetrics(Canvas.Handle, tm); end;
      end;
      if K = 0 then
      begin
       Canvas.Font := TitleFont;
       GetTextMetrics(Canvas.Handle, tm);
      end;

      FTitleHeightFull :=  tm.tmExternalLeading + tm.tmHeight*FTitleLines+2 +
                                FTitleHeight;

      if dgRowLines in Options then
          FTitleHeightFull := FTitleHeightFull + 1;


//      OldRow0 := RowHeights[0];
      RowHeights[0] := FTitleHeightFull;
    end;

    if(UseMultiTitle = true) then begin
      ReallocMem(FLeafFieldArr,SizeOf(LeafCol)*Columns.Count);
      AFont := Canvas.Font;
      Canvas.Font := TitleFont;
      for i := 0 to Columns.Count - 1 do
         FLeafFieldArr[i].FColumn := Columns[i];
      FHeadTree.CreateFieldTree(Self);
      RowHeights[0] := SetChildTreeHeight(FHeadTree) - 1; // +2;
      Canvas.Font := AFont;
    end;
  end;


  UpdateRowCount;
  SetColumnAttributes;
  UpdateActive;
  Invalidate;
end;

procedure TCustomDBGrid_.LayoutChanged;
begin
  if AcquireLayoutLock then
    EndLayout;
end;

procedure TCustomDBGrid_.LinkActive(Value: Boolean);
begin
  if not Value then HideEditor;
  FBookmarks.LinkActive(Value);
  LayoutChanged;
  UpdateScrollBar;
  if Value and (dgAlwaysShowEditor in Options) then ShowEditor;
end;

procedure TCustomDBGrid_.Loaded;
var i:Integer;
begin
  inherited Loaded;
  if FColumns.Count > 0 then begin
    ColCount := FColumns.Count;
  //ddd
    if (FAutoFitColWidths = True) then  begin
      Columns.BeginUpdate;
      for i := 0  to Columns.Count - 1 do begin
          Columns[i].FInitWidth := Columns[i].Width;
      end;
      Columns.EndUpdate;
      ScrollBars := ssNone;
    end;
  //\\\
  end;
  LayoutChanged;
end;

//ddd
function PointInRect(const P: TPoint; const R: TRect): Boolean;
begin
  with R do
    Result := (Left <= P.X) and (Top <= P.Y) and
      (Right >= P.X) and (Bottom >= P.Y);
end;
//\\\

procedure TCustomDBGrid_.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  OldCol,OldRow, Xm,Ym: Integer;
  EnableClick: Boolean;
  ARect:TRect;
  Flag: Boolean;
  MouseDownEvent: TMouseEvent;
//ddd  MCoor:TPoint;
  //ddd
  AEditStyle:TEditStyle;
  APointInRect:Boolean;
  //\\\
begin


  if not AcquireFocus then Exit;
    Cell := MouseCoord(X,Y);

  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    if (Cell.X >= FIndicatorOffset) and (Cell.Y >= FTitleOffset)   then
      CellDblClick(Columns[RawToDataColumn(Cell.X)]);
    DblClick;
    Exit;
  end;
  //ddd
  Xm := X; Ym := Y;
  //\\\
  if Sizing(X, Y) then
  begin
    FDatalink.UpdateData;
    inherited MouseDown(Button, Shift, X, Y)
  end
  else
  begin
//    Cell := MouseCoord(X, Y);
    ARect := CellRect(Cell.X,Cell.Y);

    //ddd
    if (FUseMultiTitle =  True) then begin
      if (Cell.X > IndicatorOffset-1) and
        (PtInRect(Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom - FLeafFieldArr[Cell.X-IndicatorOffset].FLeaf.Height + 1),
                  Point(X, Y))) then
       Flag := False
      else
       Flag := True;
    end else Flag := True;
    if (Datalink <> nil) and Datalink.Active and
      (Cell.Y < TitleOffset) and (Cell.X >= IndicatorOffset) and
      not (csDesigning in ComponentState) and Flag
    then
    begin
      if (dgColumnResize in Options) and (Button = mbRight) then begin
        Button := mbLeft;
        FSwapButtons := True;
        MouseCapture := True;
      end
      else if Button = mbLeft then begin
        EnableClick := Columns[Cell.X - IndicatorOffset].Title.TitleButton;
        CheckTitleButton(Cell.X - IndicatorOffset, EnableClick);
        if EnableClick then begin
          MouseCapture := True;
          FTracking := True;
          FPressedCol := Cell.X;
          TrackButton(X, Y);
          Exit;
        end;
      end;
    end;
    //\\\
//    if ((csDesigning in ComponentState) or (dgColumnResize in Options)) and

    if ((csDesigning in ComponentState) or (dgColumnMove in Options)) and
      (Cell.Y < FTitleOffset) then
    begin
      FDataLink.UpdateData;
      inherited MouseDown(Button, Shift, X, Y)
    end
    else begin
      if FDatalink.Active then
        with Cell do
        begin
          BeginUpdate;   { eliminates highlight flicker when selection moves }
          try
            HideEditor;
            OldCol := Col;
            OldRow := Row;
            if (Y >= FTitleOffset) and (Y - Row <> 0) then
              FDatalink.Dataset.MoveBy(Y - Row);
            if X >= FIndicatorOffset then
              MoveCol(X);
            if (dgMultiSelect in Options) and FDatalink.Active then
              with FBookmarks do
              begin
                FSelecting := False;
                if ssCtrl in Shift then
                  CurrentRowSelected := not CurrentRowSelected
                else
                begin
                  //ddd
                  if not ((Button = mbRight) and CurrentRowSelected ) then
                  begin
                  //\\\
                    Clear;
                    CurrentRowSelected := True;
                  end;
                end;
              end;
// ddd
(*            if (Button = mbLeft) and
              (((X = OldCol) and (Y = OldRow)) or (dgAlwaysShowEditor in Options)) then begin
                ShowEditor;         { put grid in edit mode }*)
            if (Button = mbLeft) then
            begin


               if (Cell.X > IndicatorOffset-1) and (Columns[Cell.X - IndicatorOffset].AlwaysShowEditButton) then
                 AEditStyle := GetColumnEditStile(Columns[Cell.X - IndicatorOffset])
               else
                 AEditStyle := esSimple;

               APointInRect := PointInRect(Point(Xm,Ym),Rect(ARect.Right - FInplaceEditorButtonWidth ,ARect.Top,ARect.Right,ARect.Bottom));

               if (Shift=[ssLeft])
               and (oldRow=cell.y)
               and (oldCol=cell.x)
                and PointInRect(Point(Xm,Ym),ARect)
                and isImagList
              then
                ImgListVal;


               if (dgAlwaysShowEditor in Options) or ((AEditStyle <> esSimple) and APointInRect) or ((X = OldCol) and (Y = OldRow)) then
                 ShowEditor;

               if (InplaceEditor <> nil) and InplaceEditor.Visible and APointInRect then
                 InplaceEditor.Perform(WM_LBUTTONDOWN,MK_LBUTTON,
                     Longint(PointToSmallPoint(InplaceEditor.ScreenToClient(ClientToScreen(Point(Xm,Ym))))));
{                if ((dgAlwaysShowEditor in Options) and (InplaceEditor <> nil) and (InplaceEditor.Visible)) then
                   InplaceEditor.Perform(WM_LBUTTONDOWN,MK_LBUTTON,
                     Longint(PointToSmallPoint(InplaceEditor.ScreenToClient(ClientToScreen(Point(Xm,Ym))))));}
//\\\
              end
            else
              InvalidateEditor;  { draw editor, if needed }
          finally
            EndUpdate;
          end;
        end;
      //ddd
      MouseDownEvent := OnMouseDown;
      if Assigned(MouseDownEvent) then MouseDownEvent(Self, Button, Shift, X, Y);
      //\\\
    end;
  end;
end;

//ddd
procedure TCustomDBGrid_.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FTracking then TrackButton(X, Y);
  inherited MouseMove(Shift, X, Y);
end;
//

procedure TCustomDBGrid_.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  SaveState: TGridState;

  DoClick: Boolean;
  ACol: Longint;

begin
  SaveState := FGridState;
//ddd
  if (GetCursor = Screen.Cursors[crVSplit]) then FDefaultRowChanged := True;  // Отпустил посл?ресайз?строки

  ///rx
  if FTracking and (FPressedCol >= 0) then begin
    Cell := MouseCoord(X, Y);
    DoClick := PtInRect(Rect(0, 0, ClientWidth, ClientHeight), Point(X, Y))
      and (Cell.Y = 0) and (Cell.X = FPressedCol);
    StopTracking;
    if DoClick then begin
      ACol := Cell.X;
      if (dgIndicator in Options) then Dec(ACol);
      if (DataLink <> nil) and DataLink.Active and (ACol >= 0) and
        (ACol < Columns.Count) then
      begin
        DoTitleClick(ACol, Columns[ACol]);
      end;
    end;
  end
  else if FSwapButtons then begin
    FSwapButtons := False;
    MouseCapture := False;
    if Button = mbRight then Button := mbLeft;
  end;
  //\rx

//\\\

  inherited MouseUp(Button, Shift, X, Y);
  if (SaveState = gsRowSizing) or (SaveState = gsColSizing) or
    ((InplaceEditor <> nil) and (InplaceEditor.Visible) and
     (PtInRect(InplaceEditor.BoundsRect, Point(X,Y)))) then Exit;
  Cell := MouseCoord(X,Y);
  if (Button = mbLeft) and (Cell.X >= FIndicatorOffset) and (Cell.Y >= 0) then
    if Cell.Y < FTitleOffset then
      TitleClick(Columns[RawToDataColumn(Cell.X)])
    else
       CellClick(Columns[RawToDataColumn(Cell.X)]);

   //   CellClick(Columns[SelectedIndex]);
//ddd
  FDefaultRowChanged := False;
//\\\
end;

procedure TCustomDBGrid_.MoveCol(RawCol: Integer);
var
  OldCol: Integer;
begin
  FDatalink.UpdateData;
  if RawCol >= ColCount then
    RawCol := ColCount - 1;
  if RawCol < FIndicatorOffset + {ddd}FrozenCols then RawCol := FIndicatorOffset + {ddd}FrozenCols;
  OldCol := Col;
  if RawCol <> OldCol then
  begin
    if not FInColExit then
    begin
      FInColExit := True;
      try
        ColExit;
      finally
        FInColExit := False;
      end;
      if Col <> OldCol then Exit;
    end;
    if not (dgAlwaysShowEditor in Options) then HideEditor;
    Col := RawCol;
    ColEnter;
  end;
end;

procedure TCustomDBGrid_.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
  NeedLayout: Boolean;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent is TPopupMenu) then
    begin
      for I := 0 to Columns.Count-1 do
        if Columns[I].PopupMenu = AComponent then
          Columns[I].PopupMenu := nil;
    end
    else if (FDataLink <> nil) then
      if (AComponent = DataSource)  then
        DataSource := nil
      else if (AComponent is TField) then
      begin
        NeedLayout := False;
        BeginLayout;
        try
          for I := 0 to Columns.Count-1 do
            with Columns[I] do
              if Field = AComponent then
              begin
                Field := nil;
                NeedLayout := True;
              end;
        finally
          if NeedLayout and Assigned(FDatalink.Dataset)
            and not FDatalink.Dataset.ControlsDisabled then
            EndLayout
          else
            DeferLayout;
        end;
      end;
  end;
end;

procedure TCustomDBGrid_.RecordChanged(Field: TField);
var
  I: Integer;
  CField: TField;
begin
  if not HandleAllocated then Exit;
  if Field = nil then
    Invalidate
  else
  begin
    for I := 0 to Columns.Count - 1 do
      if Columns[I].Field = Field then
        InvalidateCol(DataToRawColumn(I));
  end;
  CField := SelectedField;
  if ((Field = nil) or (CField = Field)) and
    (Assigned(CField) and (CField.Text <> FEditText)) then
  begin
    InvalidateEditor;
    if InplaceEditor <> nil then InplaceEditor.Deselect;
  end;
end;

//ddd
procedure TCustomDBGrid_.Scroll(Distance: Integer);
var
  OldRect, NewRect, ClipRegion: TRect;
  RowHeight: Integer;
begin
  if not HandleAllocated then Exit;
  OldRect := BoxRect(0, Row, ColCount - 1, Row);
  if (FDataLink.ActiveRecord >= RowCount - FTitleOffset) then UpdateRowCount;
  UpdateScrollBar;
  UpdateActive;
  NewRect := BoxRect(0, Row, ColCount - 1, Row);
  ValidateRect(Handle, @OldRect);
  InvalidateRect(Handle, @OldRect, False);
  InvalidateRect(Handle, @NewRect, False);
  if Distance <> 0 then
  begin
    HideEditor;
    try
      if Abs(Distance) > VisibleRowCount then
      begin
        Invalidate;
        Exit;
      end
      else
      begin
        RowHeight := DefaultRowHeight;
        if dgRowLines in Options then Inc(RowHeight, GridLineWidth);
        if dgIndicator in Options then
        begin
          OldRect := BoxRect(0, FSelRow, ColCount - 1, FSelRow);
          InvalidateRect(Handle, @OldRect, False);
        end;
        NewRect := BoxRect(0, FTitleOffset, ColCount - 1, 1000);
        //ddd
        if (FFooterRowCount > 0) then begin
          ClipRegion := BoxRect(0, FTitleOffset, ColCount - 1, RowCount-FFooterRowCount-2);
          ScrollWindowEx(Handle, 0, -RowHeight * Distance, @NewRect, @ClipRegion,
          0, nil, SW_Invalidate);
        end else
          ScrollWindowEx(Handle, 0, -RowHeight * Distance, @NewRect, @NewRect,
          0, nil, SW_Invalidate);
        //\\\ddd
        if dgIndicator in Options then
        begin
          NewRect := BoxRect(0, Row, ColCount - 1, Row);
          InvalidateRect(Handle, @NewRect, False);
        end;
      end;
    finally
      if dgAlwaysShowEditor in Options then ShowEditor;
    end;
  end;
  if UpdateLock = 0 then Update;
end;

procedure TCustomDBGrid_.SetColumns(Value: TDBGridColumns_);
begin
  Columns.Assign(Value);
end;

function ReadOnlyField(Field: TField): Boolean;
var
  MasterField: TField;
begin
  Result := Field.ReadOnly;
  if not Result and (Field.FieldKind = fkLookup) then
  begin
    Result := True;
    if Field.DataSet = nil then Exit;
    MasterField := Field.Dataset.FindField(Field.KeyFields);
    if MasterField = nil then Exit;
    Result := MasterField.ReadOnly;
  end;
end;

procedure TCustomDBGrid_.SetColumnAttributes;
var
  I: Integer;
begin
  for I := 0 to FColumns.Count-1 do
  with FColumns[I] do
  begin
    TabStops[I + FIndicatorOffset] := not ReadOnly and DataLink.Active and
      Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
    ColWidths[I + FIndicatorOffset] := Width;
  end;
  if (dgIndicator in Options) then
    ColWidths[0] := IndicatorWidth;
end;

procedure TCustomDBGrid_.SetDataSource(Value: TDataSource);
begin
  if Value = FDatalink.Datasource then Exit;
  FBookmarks.Clear;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  LinkActive(FDataLink.Active);
end;

procedure TCustomDBGrid_.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  FEditText := Value;
end;

procedure TCustomDBGrid_.SetOptions(Value: TDBGrid_Options);
const
  LayoutOptions = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection];
var
  NewGridOptions: TGridOptions;
  ChangedOptions: TDBGrid_Options;
begin
  if FOptions <> Value then
  begin
    NewGridOptions := [];
//ddd
    if (RowSizingAllowed = True) then
      NewGridOptions := NewGridOptions + [goRowSizing];
//\\\
    if dgColLines in Value then begin
//ddd
      NewGridOptions := NewGridOptions + [goFixedVertLine, goVertLine];
//      NewGridOptions := NewGridOptions + [goVertLine];
//      if (FUseMultiTitle = False) then
//        NewGridOptions := NewGridOptions + [goFixedVertLine];
    end;
//\\\
    if dgRowLines in Value then
      NewGridOptions := NewGridOptions + [goFixedHorzLine, goHorzLine];
{    if dgColumnResize in Value then
      NewGridOptions := NewGridOptions + [goColSizing, goColMoving];
      }

    if dgColumnResize in Value then
      NewGridOptions := NewGridOptions + [goColSizing];
    if dgColumnMove in Value then
      NewGridOptions := NewGridOptions + [goColMoving];



    if dgTabs in Value then Include(NewGridOptions, goTabs);
    if dgRowSelect in Value then
    begin
      Include(NewGridOptions, goRowSelect);
      Exclude(Value, dgAlwaysShowEditor);
      Exclude(Value, dgEditing);
    end;
    if dgEditing in Value then Include(NewGridOptions, goEditing);
    if dgAlwaysShowEditor in Value then Include(NewGridOptions, goAlwaysShowEditor);
    inherited Options := NewGridOptions;
    if dgMultiSelect in (FOptions - Value) then FBookmarks.Clear;
    ChangedOptions := (FOptions + Value) - (FOptions * Value);
    FOptions := Value;
    if ChangedOptions * LayoutOptions <> [] then LayoutChanged;
  end;
end;

procedure TCustomDBGrid_.SetSelectedField(Value: TField);
var
  I: Integer;
begin
  if Value = nil then Exit;
  for I := 0 to Columns.Count - 1 do
    if Columns[I].Field = Value then
      MoveCol(DataToRawColumn(I));
end;

procedure TCustomDBGrid_.SetSelectedIndex(Value: Integer);
begin
  MoveCol(DataToRawColumn(Value));
end;

procedure TCustomDBGrid_.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
  if dgTitles in Options then LayoutChanged;
end;

function TCustomDBGrid_.StoreColumns: Boolean;
begin
  Result := Columns.State = csCustomized;
end;

procedure TCustomDBGrid_.TimedScroll(Direction: TGridScrollDirection);
begin
  if FDatalink.Active then
  begin
    with FDatalink do
    begin
      if sdUp in Direction then
      begin
        DataSet.MoveBy(-ActiveRecord - 1);
        Exclude(Direction, sdUp);
      end;
      if sdDown in Direction then
      begin
        DataSet.MoveBy(RecordCount - ActiveRecord);
        Exclude(Direction, sdDown);
      end;
    end;
    if Direction <> [] then inherited TimedScroll(Direction);
  end;
end;

procedure TCustomDBGrid_.TitleClick(Column: TColumn_);
begin
  if Assigned(FOnTitleClick) then FOnTitleClick(Column);
end;

procedure TCustomDBGrid_.TitleFontChanged(Sender: TObject);
begin
  if (not FSelfChangingTitleFont) and not (csLoading in ComponentState) then
    ParentFont := False;
  if dgTitles in Options then LayoutChanged;
end;

procedure TCustomDBGrid_.UpdateActive;
var
  NewRow: Integer;
  Field: TField;
begin
  if FDatalink.Active and HandleAllocated and not (csLoading in ComponentState) then
  begin
    NewRow := FDatalink.ActiveRecord + FTitleOffset;
    if Row <> NewRow then
    begin
      if not (dgAlwaysShowEditor in Options) then HideEditor;
      MoveColRow(Col, NewRow, False, False);
      InvalidateEditor;
    end;
    Field := SelectedField;
    if Assigned(Field) and (Field.Text <> FEditText) then
      InvalidateEditor;
  end;
end;

procedure TCustomDBGrid_.UpdateData;
var
  Field: TField;
begin
  Field := SelectedField;
//  if Assigned(Field)  then
  if Assigned(Field) and CanEditShow then
    Field.Text := FEditText;
end;


procedure TCustomDBGrid_.UpdateRowCount;
var BetweenRowHeight,FooterHeight, Delta,t:Integer;
begin
  if RowCount <= FTitleOffset then RowCount := FTitleOffset + 1;
  FixedRows := FTitleOffset;
  with FDataLink do
   if not Active or (RecordCount = 0) {or not HandleAllocated} then
    begin
      RowCount := 1 + FTitleOffset;
     if (HandleAllocated) then
     begin
        t := RowHeights[0];
        DefaultRowHeight := DefaultRowHeight;
        RowHeights[0] := t;
        if (FFooterRowCount > 0) then
        begin
          BetweenRowHeight := ClientHeight - GridHeight;
          RowCount := RowCount + FooterRowCount + 1;
          FooterHeight := (DefaultRowHeight + iif(dgRowLines in Options,GridLineWidth,0)) * FFooterRowCount;
          RowHeights[iif(dgTitles in Options,2,1)] :=
             iif(FooterHeight + 1 < BetweenRowHeight,BetweenRowHeight - FooterHeight - 1,0);
        end;
      end;
    end
    else
    begin
      RowCount := 1000;
      t := RowHeights[0];
      DefaultRowHeight := DefaultRowHeight;
      RowHeights[0] := t;

      FDataLink.BufferCount := VisibleRowCount;
      RowCount := RecordCount + FTitleOffset;
      if dgRowSelect in Options then TopRow := FixedRows;

      //ddd
      if (FFooterRowCount > 0) then
      begin
        FooterHeight := (DefaultRowHeight + iif(dgRowLines in Options,GridLineWidth,0)) * FFooterRowCount;
        BetweenRowHeight := ClientHeight - GridHeight;
        if (FooterHeight < (ClientHeight - GridHeight)) then begin
          RowCount := RowCount + FooterRowCount + 1;
          RowHeights[RowCount - FooterRowCount - 1] := BetweenRowHeight - FooterHeight - 1;
        end
      else
        if ((ClientHeight - GridHeight) <= DefaultRowHeight) then
        begin
          if (BetweenRowHeight = 0) or (BetweenRowHeight = -1) then
           begin
             FDataLink.BufferCount := FDataLink.BufferCount - FFooterRowCount - 1;
              if (FDataLink.BufferCount <= 0) then
              begin
                FDataLink.BufferCount := 1;
                RowCount := 2 + iif(dgTitles in Options,1,0) + FFooterRowCount;
                RowHeights[iif(dgTitles in Options,2,1)] := 0;
              end
              else   if (BetweenRowHeight = 0) then            RowHeights[RowCount - FooterRowCount - 1] := DefaultRowHeight
                     else  RowHeights[RowCount - FooterRowCount - 1] := DefaultRowHeight-1;
          end
         else
          begin
            RowCount := RowCount + 1;
            FDataLink.BufferCount := FDataLink.BufferCount - FFooterRowCount;
            if (FDataLink.BufferCount <= 1) then begin
                FDataLink.BufferCount := 1;
                RowCount := 2 + iif(dgTitles in Options,1,0) + FFooterRowCount;
                t := ClientHeight - ( iif(dgTitles in Options,RowHeights[0],0) + RowHeights[1] +
                    iif(dgRowLines in Options,GridLineWidth,0)*(2+iif(dgTitles in Options,1,0)) +
                    FooterHeight);
                RowHeights[iif(dgTitles in Options,2,1)] := iif( t > 0,t,0);
            end
           else
           begin
             if (BetweenRowHeight = DefaultRowHeight) then FDataLink.BufferCount := FDataLink.BufferCount - 1;
              RowHeights[RowCount - FooterRowCount - 1] := BetweenRowHeight - 1;
            end;
          end;
        end
        else     if (FooterHeight - (ClientHeight - GridHeight) < (DefaultRowHeight + iif(dgRowLines in Options,GridLineWidth,0))*RecordCount) then
                 begin
                          Delta := (FooterHeight - (ClientHeight - GridHeight)) div (DefaultRowHeight + iif(dgRowLines in Options,GridLineWidth,0)) + 1;
                          BetweenRowHeight := (ClientHeight - GridHeight + 1) mod (DefaultRowHeight + iif(dgRowLines in Options,GridLineWidth,0));
                          RowCount := RowCount + (FFooterRowCount - Delta) + 1;
                          FDataLink.BufferCount := FDataLink.RecordCount - Delta;
                         if (FDataLink.BufferCount <= 0) then
                         begin
                            FDataLink.BufferCount := 1;
                            RowCount := 2 + iif(dgTitles in Options,1,0) + FFooterRowCount;
                            RowHeights[iif(dgTitles in Options,2,1)] := 0;
                         end
                         else    if (BetweenRowHeight = 1) or (BetweenRowHeight = 0) then
                                      RowHeights[RowCount - FooterRowCount - 1] := DefaultRowHeight - (1 - BetweenRowHeight)
                                 else
                                      RowHeights[RowCount - FooterRowCount - 1] := BetweenRowHeight - 2;
                    end
                    else
                    begin
                      FDataLink.BufferCount := 1;
                      RowCount := 2 + iif(dgTitles in Options,1,0) + FFooterRowCount;
                      RowHeights[iif(dgTitles in Options,2,1)] := 0;
                    end;
      end;
      //\\\

//ddd      if dgRowSelect in Options then TopRow := FixedRows;
        UpdateActive;
    end;

end;

procedure TCustomDBGrid_.UpdateScrollBar;
var
  SIOld, SINew: TScrollInfo;
begin
  if FDatalink.Active and HandleAllocated then
    with FDatalink.DataSet do
    begin
      SIOld.cbSize := sizeof(SIOld);
      SIOld.fMask := SIF_ALL;
      GetScrollInfo(Self.Handle, SB_VERT, SIOld);
      SINew := SIOld;
      if IsSequenced then
      begin
        SINew.nMin := 1;
        SINew.nPage := Self.VisibleRowCount;
        SINew.nMax := RecordCount + SINew.nPage -1;
        if State in [dsInactive, dsBrowse, dsEdit] then
          SINew.nPos := RecNo;  // else keep old pos
      end
      else
      begin
        SINew.nMin := 0;
        SINew.nPage := 0;
        SINew.nMax := 4;
        if BOF then SINew.nPos := 0
        else if EOF then SINew.nPos := 4
        else SINew.nPos := 2;
      end;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
        (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
    end;
end;

function TCustomDBGrid_.ValidFieldIndex(FieldIndex: Integer): Boolean;
begin
  Result := DataLink.GetMappedIndex(FieldIndex) >= 0;
end;

procedure TCustomDBGrid_.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if ParentFont then
  begin
    FSelfChangingTitleFont := True;
    try
      TitleFont := Font;
    finally
      FSelfChangingTitleFont := False;
    end;
    LayoutChanged;
  end;
end;

procedure TCustomDBGrid_.CMExit(var Message: TMessage);
begin
  try
    if FDatalink.Active then
      with FDatalink.Dataset do
        if (dgCancelOnExit in Options) and (State = dsInsert) and
          not Modified and not FDatalink.FModified then
          Cancel else
          FDataLink.UpdateData;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TCustomDBGrid_.CMFontChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  BeginLayout;
  try
    for I := 0 to Columns.Count-1 do
      Columns[I].RefreshDefaultFont;
  finally
    EndLayout;
  end;
end;

procedure TCustomDBGrid_.CMDeferLayout(var Message);
begin
  if AcquireLayoutLock then
    EndLayout
  else
    DeferLayout;
end;

procedure TCustomDBGrid_.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  inherited;
  if (Msg.Result = 1) and ((FDataLink = nil) or
    ((Columns.State = csDefault) and
     (FDataLink.DefaultFields or (not FDataLink.Active)))) then
    Msg.Result := 0;
end;

procedure TCustomDBGrid_.WMSetCursor(var Msg: TWMSetCursor);
begin
  if (csDesigning in ComponentState) and ((FDataLink = nil) or
     ((Columns.State = csDefault) and
      (FDataLink.DefaultFields or (not FDataLink.Active)))) then
    Windows.SetCursor(LoadCursor(0, IDC_ARROW))
  else inherited;
end;

procedure TCustomDBGrid_.WMSize(var Message: TWMSize);
begin
  inherited;

//ddd
  if (FAutoFitColWidths = True) and (UpdateLock = 0) then LayoutChanged;
//\\\
  if UpdateLock = 0 then UpdateRowCount;

end;

procedure TCustomDBGrid_.WMVScroll(var Message: TWMVScroll);
var
  SI: TScrollInfo;
begin
  if not AcquireFocus then Exit;
  if FDatalink.Active then
    with Message, FDataLink.DataSet do
      case ScrollCode of
        SB_LINEUP: MoveBy(-FDatalink.ActiveRecord - 1);
        SB_LINEDOWN: MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord);
        SB_PAGEUP: MoveBy(-VisibleRowCount);
        SB_PAGEDOWN: MoveBy(VisibleRowCount);
        SB_THUMBPOSITION:
          begin
            if IsSequenced then
            begin
              SI.cbSize := sizeof(SI);
              SI.fMask := SIF_ALL;
              GetScrollInfo(Self.Handle, SB_VERT, SI);
              if SI.nTrackPos <= 1 then First
              else if SI.nTrackPos >= RecordCount then Last
              else RecNo := SI.nTrackPos;
            end
            else
              case Pos of
                0: First;
                1: MoveBy(-VisibleRowCount);
                2: Exit;
                3: MoveBy(VisibleRowCount);
                4: Last;
              end;
          end;
        SB_BOTTOM: Last;
        SB_TOP: First;
      end;
end;

procedure TCustomDBGrid_.SetIme;
var
  Column: TColumn_;
begin
  if not SysLocale.FarEast then Exit;

  ImeName := FOriginalImeName;
  ImeMode := FOriginalImeMode;
  Column := Columns[SelectedIndex];
  if Column.IsImeNameStored then ImeName := Column.ImeName;
  if Column.IsImeModeStored then ImeMode := Column.ImeMode;

  if InplaceEditor <> nil then
  begin
    TDBGrid_InplaceEdit(Self).ImeName := ImeName;
    TDBGrid_InplaceEdit(Self).ImeMode := ImeMode;
  end;
end;

procedure TCustomDBGrid_.UpdateIme;
begin
  if not SysLocale.FarEast then Exit;
  SetIme;
  SetImeName(ImeName);
  SetImeMode(Handle, ImeMode);
end;

procedure TCustomDBGrid_.WMIMEStartComp(var Message: TMessage);
begin
  inherited;
  ShowEditor;
end;

procedure TCustomDBGrid_.WMSetFocus(var Message: TWMSetFocus);
begin
  if not ((InplaceEditor <> nil) and
    (Message.FocusedWnd = InplaceEditor.Handle)) then SetIme;
  inherited;
end;

procedure TCustomDBGrid_.WMKillFocus(var Message: TMessage);
begin
  if not SysLocale.FarEast then inherited
  else
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
    inherited;
    if not ((InplaceEditor <> nil) and
      (Message.WParam = InplaceEditor.Handle)) then
      ActivateKeyboardLayout(Screen.DefaultKbLayout, KLF_ACTIVATE);
  end;
end;

// Dima changing

function  TCustomDBGrid_.GetFooterRowCount: Integer;
begin
 Result := FFooterRowCount;
end;

procedure TCustomDBGrid_.SetFooterRowCount(Value: Integer);
begin
  if (Value <> FFooterRowCount) and (Value >= 0) then begin
    FFooterRowCount := Value;
    LayoutChanged;
  end;
end;


                          {ReadTitleHeight}
function  TCustomDBGrid_.ReadTitleHeight: Integer;
begin
  Result :=  FTitleHeight;
end;

procedure TCustomDBGrid_.WriteTitleHeight(th: Integer); {WriteTitleHeight}
begin
 FTitleHeight :=  th;
 LayoutChanged;
end;
                          {ReadTitleLines}
function  TCustomDBGrid_.ReadTitleLines: Integer;
begin
  Result :=  FTitleLines;
end;

procedure TCustomDBGrid_.WriteTitleLines(tl: Integer); {WriteTitleLines}
begin
  FTitleLines := tl;
  LayoutChanged;
end;


procedure TCustomDBGrid_.Paint; //
var
 intTmp:integer;
begin


 if
    DefaultDrawing
    and   ( SelectedIndex=Col-FIndicatorOffset)
    and (dgEditing in Options)
    and  Assigned(DataLink)
    and  DataLink.Active
    and  (columns.count>0)
    and Assigned(Columns[col-FIndicatorOffset].Field)
    and isImaglist
    and  not (csDesigning in ComponentState)
    then
 with Columns[col-FIndicatorOffset] do
 begin;
 //  if Assigned(InplaceEditor) and InplaceEditor.Visible   then InplaceEditor.hide;
   HideEditor;
   intTmp:= FindStringsIndex(keylist,Field.Text,NotInKeyListIndex,ImageList.Count-1);
   DrawImageList(ImageList,intTmp,Canvas,color,boxRect(Col, Row, Col, Row),True);
 end;

     inherited Paint;
  if (dgTitles in Options) and UseMultiTitle then
   FHeadTree.DoForAllNode(ClearPainted);
  if not (csDesigning in ComponentState)
   and (dgRowSelect in Options)
   and DefaultDrawing
   and Focused
   and not  isImaglist then
  begin
    Canvas.Font.Color := clWindowText;
    with Selection do
      DrawFocusRect(Canvas.Handle, BoxRect(Left, Top, Right, Bottom));
  end;
end;

procedure TCustomDBGrid_.ClearPainted(node:THeadTreeNode); //new
begin
 node.Drawed := false;
end;


procedure TCustomDBGrid_.WriteMarginText(IsMargin:Boolean);
begin
  if(IsMargin <> FMarginText) then begin
    FMarginText := IsMargin;
    LayoutChanged;
  end;
end;


procedure TCustomDBGrid_.WriteVTitleMargin(Value: Integer);
begin
  FVTitleMargin := Value;
  LayoutChanged;
end;

procedure TCustomDBGrid_.WriteHTitleMargin(Value: Integer);
begin
  FHTitleMargin := Value;
  LayoutChanged;
end;

procedure TCustomDBGrid_.WriteUseMultiTitle(Value:Boolean);
begin
 if (FUseMultiTitle <> Value) then
   FUseMultiTitle := Value;
 LayoutChanged;
end;

procedure TCustomDBGrid_.SetRowSizingAllowed(Value:Boolean);
begin
  if Value <> FRowSizingAllowed then begin
    FRowSizingAllowed := Value;
    if FRowSizingAllowed then
      inherited Options := inherited Options + [goRowSizing]
    else
      inherited Options := inherited Options - [goRowSizing];
  end;
end;

function TCustomDBGrid_.GetRowsHeight:Integer;
begin
  Result := FNewRowsHeight;
end;

procedure TCustomDBGrid_.SetRowsHeight(Value: Integer);
begin
  if Value <> FNewRowsHeight then begin
    FNewRowsHeight := iif(Value < 0,0,Value);
    LayoutChanged;
  end;
end;

function  TCustomDBGrid_.GetRowLines: Integer;
begin
  Result := FRowLines;
end;

procedure TCustomDBGrid_.SetRowLines(Value: Integer);
begin
  if Value <> FRowLines then begin
    FRowLines := iif(Value < 0,0,Value);
    LayoutChanged;
  end;
end;


procedure TCustomDBGrid_.RowHeightsChanged;
var
  I, ThisHasChanged, Def: Integer;
begin
  if (FDefaultRowChanged = True) then begin
    FDefaultRowChanged := False;
    ThisHasChanged := -1;
    Def := DefaultRowHeight;
    for I := Ord(dgTitles in Options) to RowCount - iif(FooterRowCount > 0,FooterRowCount + 1,0) do
      if RowHeights[I] <> Def then
      begin
        ThisHasChanged := I;
        Break;
      end;
    if ThisHasChanged <> -1 then
    begin
      FRowLines := 0;
      SetRowsHeight(RowHeights[ThisHasChanged]);
    end;
  end;
  inherited;
end;

function TCustomDBGrid_.StdDefaultRowHeight: Integer;
var K:Integer;
begin
  if not HandleAllocated then
    Canvas.Handle := GetDC(0);
  try
    Canvas.Font := Font;
    K := Canvas.TextHeight('Wg') + 3;
    if dgRowLines in Options then
      Inc(K, GridLineWidth);
    Result := K;
  finally
    if not HandleAllocated then
    begin
      ReleaseDC(0,Canvas.Handle);
      Canvas.Handle := 0;
    end;
  end;

end;

procedure TCustomDBGrid_.StopTracking;
begin
  if FTracking then begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TCustomDBGrid_.TrackButton(X, Y: Integer);
var
  Cell: TGridCoord;
  NewPressed: Boolean;
begin
  Cell := MouseCoord(X, Y);
  NewPressed := PtInRect(Rect(0, 0, ClientWidth, ClientHeight), Point(X, Y))
    and (FPressedCol = Cell.X) and (Cell.Y = 0);
  if FPressed <> NewPressed then begin
    FPressed := NewPressed;
    GridInvalidateRow(Self,0);
  end;
end;

procedure TCustomDBGrid_.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TCustomDBGrid_.DoTitleClick(ACol: Longint; AColumn: TColumn_);
begin
  if Assigned(FOnTitleBtnClick) then FOnTitleBtnClick(Self, ACol, AColumn);
end;

procedure TCustomDBGrid_.CheckTitleButton(ACol: Longint; var Enabled: Boolean);
begin
  if (ACol >= 0) and (ACol < Columns.Count) then
  begin
    if Assigned(FOnCheckButton) then FOnCheckButton(Self, ACol, Columns[ACol], Enabled);
  end
  else Enabled := False;
end;

//new                    SetChildTreeHeight

function TCustomDBGrid_.SetChildTreeHeight(ANode:THeadTreeNode):Integer;
var htLast:THeadTreeNode;
    newh,maxh,th :Integer;
    rec:TRect;
    DefaultRowHeight : Integer;
begin
  DefaultRowHeight := 0;
  Result := 0;
  if(ANode.Child  = nil) then Exit;
  htLast := ANode.Child;
  maxh := 0;
  Canvas.Font := TitleFont;
  if(htLast.Child <> nil) then
   maxh := SetChildTreeHeight(htLast);

  rec := Rect(0,0,htLast.Width-4-htLast.WIndent,DefaultRowHeight);
  if (rec.Left >= rec.Right) then rec.Right := rec.Left + 1;
  th := DrawText(Canvas.Handle,PChar(htLast.Text),
         Length(htLast.Text), rec, DT_WORDBREAK or DT_CALCRECT);
  if (th > DefaultRowHeight) then maxh := maxh + th + FVTitleMargin
     else maxh := maxh + DefaultRowHeight;

  while  true  do begin
     if(ANode.Child = htLast.Next) then begin break; end;
     htLast := htLast.Next;
     newh := 0;
     if(htLast.Child <> nil) then
       newh := SetChildTreeHeight(htLast);
     rec := Rect(0,0,htLast.Width-4-htLast.WIndent,DefaultRowHeight);
     if (rec.Left >= rec.Right) then rec.Right := rec.Left + 1;
     th := DrawText(Canvas.Handle,PChar(htLast.Text),
         Length(htLast.Text), rec, DT_WORDBREAK or DT_CALCRECT);
     if (th > DefaultRowHeight) then newh := newh + th  + FVTitleMargin
        else newh := newh + DefaultRowHeight;

     if(maxh < newh) then maxh := newh;
  end;

  htLast := ANode.Child;
  while ANode.Child <> htLast.Next do begin
    if(htLast.Child = nil) then htLast.Height := maxh
      else htLast.Height := maxh - htLast.Height;
    htLast := htLast.Next;
  end;
  if(htLast.Child = nil) then htLast.Height := maxh
      else htLast.Height := maxh - htLast.Height;

  ANode.Height := maxh; //сохраняем высоту ChildTree ?Хост?
  Result := maxh;
end;


function TCustomDBGrid_.GetColWidths(Index: Longint): Integer;
begin
 Result := inherited ColWidths[Index];
end;

procedure TCustomDBGrid_.SetColWidths(Index: Longint; Value: Integer);
begin
  inherited ColWidths[Index] := Value;
  LayoutChanged;
end;


procedure TCustomDBGrid_.WriteAutoFitColWidths(Value:Boolean);
var i:Integer;
begin
  if (FAutoFitColWidths = Value) then Exit;
  FAutoFitColWidths := Value;
  if (csDesigning in ComponentState) then Exit;
  if (FAutoFitColWidths = True) then  begin
    if not (csLoading in ComponentState) then
      for i := 0  to Columns.Count - 1 do Columns[i].FInitWidth := Columns[i].Width;

    ScrollBars := ssNone;
  end
  else begin
    for i := 0  to Columns.Count - 1 do Columns[i].Width := Columns[i].FInitWidth;
    ScrollBars := ssHorizontal;
  end;
  LayoutChanged;
end;


//------------------------------------------------------------------------------
procedure TCustomDBGrid_.WriteMinAutoFitWidth(Value:Integer);
begin
  FMinAutoFitWidth := Value;
  LayoutChanged;
end;

//from RX

procedure TCustomDBGrid_.SaveColumnsLayout(ARegIni: TRegIniFIle);
var
  Section: string;
  I:Integer;
begin
  Section := GetDefaultSection(Self);
  ARegIni.EraseSection(Section);
  with Columns do begin
    for I := 0 to Count - 1 do begin
      ARegIni.WriteString(Section, Format('%s.%s', [Name, Items[I].FieldName]),
        Format('%d,%d,%d', [Items[I].Index, Items[I].Width, Integer(Items[I].Title.SortMarker)]));
    end;
  end;
end;

procedure TCustomDBGrid_.RestoreColumnsLayout(ARegIni: TRegIniFIle; RestoreParams:TColumn_RestoreParams);
type
  TColumnInfo = record
    Column: TColumn_;
    EndIndex: Integer;
    SortMarker:TSortMarker_;
  end;
  PColumnArray = ^TColumnArray;
  TColumnArray = array[0..0] of TColumnInfo;
const
  Delims = [' ',','];
var
  I, J: Integer;
  Section, S: string;
  ColumnArray: PColumnArray;
  AAutoFitColWidth: Boolean;
begin
  Section := GetDefaultSection(Self);
  AAutoFitColWidth := False;
  BeginUpdate;
  try
    if (AutoFitColWidths) then begin
      AutoFitColWidths := False;
      AAutoFitColWidth := True;
    end;
    with Columns do begin
      ColumnArray := AllocMem(Count * SizeOf(TColumnInfo));
      try
        for I := 0 to Count - 1 do begin
          S := ARegIni.ReadString(Section,
            Format('%s.%s', [Name, Items[I].FieldName]), '');
          ColumnArray^[I].Column := Items[I];
          ColumnArray^[I].EndIndex := Items[I].Index;
          if S <> '' then begin
            ColumnArray^[I].EndIndex := StrToIntDef(ExtractWord(1, S, Delims),
              ColumnArray^[I].EndIndex);
            if (crpColWidthsEh in RestoreParams) then
              Items[I].Width := StrToIntDef(ExtractWord(2, S, Delims),
                Items[I].Width);
            if (crpSortMarkerEh in RestoreParams) then
            Items[I].Title.SortMarker := TSortMarker_(StrToIntDef(ExtractWord(3, S, Delims),
              Integer(Items[I].Title.SortMarker)));
          end;
        end;
        if (crpColIndexEh in RestoreParams) then
          for I := 0 to Count - 1 do begin
            for J := 0 to Count - 1 do begin
              if ColumnArray^[J].EndIndex = I then begin
                ColumnArray^[J].Column.Index := ColumnArray^[J].EndIndex;
                Break;
              end;
            end;
          end;

      finally
        FreeMem(Pointer(ColumnArray));
      end;
    end;
  finally
    EndUpdate;
    if (AAutoFitColWidth = True) then AutoFitColWidths := True
    else LayoutChanged;
  end;
end;

//\\\from RX

procedure TCustomDBGrid_.SetFrozenCols(Value: Integer);
begin
  if (Value = FFrozenCols) and (Value < 0) then Exit;
  FFrozenCols := Value;
  LayoutChanged;
end;

{---------------------------------------------------------------------------}
{------------ THeadTreeNode ------------------------------------------------}
{---------------------------------------------------------------------------}
//ddd

function ExtractWordPos(N: Integer; const S: string; WordDelims: TCharSet;
  var Pos: Integer): string; forward;

//\\\


constructor THeadTreeNode.Create;
begin
   Child := Nil; Next := Self; Host := nil; WIndent := 0;
end;

constructor THeadTreeNode.CreateText(AText:String;AHeight,AWidth:Integer);
begin
  Create;
  Text := AText; Height := AHeight; Width := AWidth;
end;

destructor THeadTreeNode.Destroy;
begin
 inherited;
 if (Host = nil) then begin
   FreeAllChild;
 end;
end;

function THeadTreeNode.Add(AAfter:THeadTreeNode;AText:String;AHeight,AWidth:Integer):THeadTreeNode ;
var htLast,{htSelf,}th:THeadTreeNode;
begin
    if(Find(AAfter) = false) then raise Exception.Create('Node not in Tree');
    htLast := AAfter.Next;
//    while AAfter <> htLast.Next do htLast := htLast.Next; // Ишим последни?
    th := THeadTreeNode.CreateText(AText,AHeight,AWidth);
    th.Host := AAfter.Host;
    AAfter.Next := th;
    th.Next := htLast;
    Result := th;
end;

function THeadTreeNode.AddChild(ANode:THeadTreeNode;AText:String;AHeight,AWidth:Integer):THeadTreeNode ;
var htLast,th:THeadTreeNode;
begin
  if(Find(ANode) = false) then raise Exception.Create('Node not in Tree');

  if(ANode.Child = nil) then begin
   th := THeadTreeNode.CreateText(AText,AHeight,AWidth);
   th.Host := ANode;
   ANode.Child := th;
  end else begin
   htLast := ANode.Child;
   while ANode.Child <> htLast.Next do htLast := htLast.Next;
   th := THeadTreeNode.CreateText(AText,AHeight,AWidth);
   th.Host := ANode;
   htLast.Next := th;
   th.Next := ANode.Child;
  end;
  Result := th;
end;

procedure THeadTreeNode.FreeAllChild;
var htLast,htm:THeadTreeNode;
begin
  if(Child  = nil) then Exit;
  htLast := Child;

  while  true  do begin
     htLast.FreeAllChild;
     if(Child = htLast.Next) then begin htLast.Free; break; end;
     htm := htLast;
     htLast := htLast.Next;
     htm.Free;
  end;
  Child := nil;
end;



function THeadTreeNode.Find(ANode:THeadTreeNode):Boolean;
var htLast:THeadTreeNode;
begin
  Result := false;
//  if(Child  = nil) then Exit;

  htLast := Self;

  while  true  do begin
     if(htLast = ANode) then begin Result := true; break; end;
     if(htLast.Child <> nil) and (htLast.Child.Find(ANode) = true) then begin Result := true; break; end;
     if(Self = htLast.Next) then begin Result := false; break; end;
     htLast := htLast.Next;
  end;
end;


procedure THeadTreeNode.Union(AFrom,ATo :THeadTreeNode; AText:String;AHeight:Integer);
var th, tUn, TBeforFrom:THeadTreeNode;
    toFinded :Boolean;
     wid:Integer;
begin
  if(Find(AFrom) = false) then raise Exception.Create('Node not in Tree');
  toFinded := True;
  if (AFrom <> ATo)  then  begin   //new
    th := AFrom; toFinded := false;
    while AFrom.HOst.Child <> th.Next do begin
      if(th.Next = ATo) then begin toFinded := true; break; end;
       th := th.Next;
    end;
  end;

  if(toFinded = false) then raise Exception.Create('ATo not in level');

  tUn := ATo.Add(ATo,AText,AHeight,0);
  TBeforFrom := AFrom.Host.Child;
  while TBeforFrom.Next <> AFrom do TBeforFrom := TBeforFrom.Next;

  TBeforFrom.Next := tUn;

  th := AFrom; tUn.Child := AFrom;
  if(th = AFrom.Host.Child) then AFrom.Host.Child := tUn;
  Wid := 0;
  while th <> ATo.Next do begin
    Inc(Wid,th.Width);
    Inc(Wid,1);
    Dec(th.Height,AHeight);
    th.Host := TUn;
    th := th.Next;
  end;
  Dec(Wid,1);
  ATo.Next := AFrom;
  tUn.Width := Wid;
end;



//--------------------- CreateFieldTree ---------------------------------------
procedure THeadTreeNode.CreateFieldTree(AGrid:TCustomDBGrid_);
var i,pos,j:Integer;
    node,nodeFrom,nodeTo:THeadTreeNode;
    ss,ss1:String;
    sameWord,GroupDid :Boolean;
begin

  FreeAllChild;


  for i := 0 to AGrid.Columns.Count - 1 do
  begin
   node := AddChild(Self
                   ,AGrid.Columns[i].Title.Caption
                   ,AGrid.RowHeights[0]
                   ,AGrid.Columns[i].Width);
   if (AGrid.Columns[i].Title.SortMarker <> smNone) then node.WIndent := 16;
   AGrid.FLeafFieldArr[i].FLeaf := node;
  end;

  // Группируем.
  //sameWord := false;
  while True do
  begin //for k := 0 to ListNodeField.Count - 1 do begin
   GroupDid := false;
   for i := 0 to AGrid.Columns.Count - 1 do
   begin
    ss1 := ExtractWordPos(2,AGrid.FLeafFieldArr[i].FLeaf.Text,['|'],pos);



   if( ss1 <> '' ) then
     begin
      ss1 := ExtractWord(1,AGrid.FLeafFieldArr[i].FLeaf.Text,['|']);
      nodeFrom := AGrid.FLeafFieldArr[i].FLeaf;
        sameWord := false;
   //     sameWord := True;
      for j := i to AGrid.Columns.Count - 1 do
      begin
       if (AGrid.Columns.Count - 1 > j) and
           (ExtractWord(1,AGrid.FLeafFieldArr[j+1].FLeaf.Text,['|']) = ss1) then
       begin
          ss :=  AGrid.FLeafFieldArr[j].FLeaf.Text;
          Delete(ss,1,pos-1);
          AGrid.FLeafFieldArr[j].FLeaf.Text := ss;
          sameWord := true;
          GroupDid := true;
       end
     else  //{if ss1<>''}
       begin
          if sameWord  then
          begin
            ss := AGrid.FLeafFieldArr[j].FLeaf.Text;

            Delete(ss,1,pos-1);
//            TLeafField(ListNodeField.Items[j]).Field.DisplayLabel := ss;
            AGrid.FLeafFieldArr[j].FLeaf.Text := ss;
            nodeTo := AGrid.FLeafFieldArr[j].FLeaf;
            GroupDid := true;
          end;
          break;   {for i}
        end;
      end;


      if sameWord  then
      begin
        Union(nodeFrom,nodeTo,ss1,20);
         break;
      end;

    end; //{if ss1<>''}
   end; //i
   if not GroupDid  then break;
  end; //k


end;


procedure THeadTreeNode.DoForAllNode(proc:THeadTreeProc);
var htLast:THeadTreeNode;
begin
  if(Child  = nil) then Exit;
  htLast := Child;
  while  true  do
  begin
     proc(htLast);
     if(htLast.Child <> nil ) then htLast.DoForAllNode(proc);
     if(Child = htLast.Next) then  break;
     htLast := htLast.Next;
  end;
end;


////////
///{strUtils}
////////

function WordPosition(const N: Integer; const S: string; WordDelims: TCharSet): Integer;
var
  Count, I: integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin
    { skip over delimiters }
    while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do Inc(I)
    else Result := I;
  end;
end;

function ExtractWord(N: Integer; const S: string; WordDelims: TCharSet): string;
var
  I: Word;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function ExtractWordPos(N: Integer; const S: string; WordDelims: TCharSet;
  var Pos: Integer): string;
var
  I, Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  Pos := I;
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;


procedure TCustomDBGrid_.SetDrawMemoText(const Value: Boolean);
begin
  FDrawMemoText := Value;
  Invalidate;
end;

procedure TCustomDBGrid_.GetCellParams(Column: TColumn_; AFont: TFont;
  var Background: TColor; State: TGridDrawState);
begin
  if Assigned(FOnGetCellParams) then
    FOnGetCellParams(Self, Column, AFont, Background, State);
end;
procedure TCustomDBGrid_.GetFootCellParams(Column: TColumn_; AFont: TFont;
  var Background: TColor; State: TGridDrawState);
begin
  if Assigned(FOnGetFootCellParams) then
    FOnGetFootCellParams(Self, Column, AFont, Background, State);
end;


end.

