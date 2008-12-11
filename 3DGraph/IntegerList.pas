unit IntegerList;

interface

uses Classes, SysUtils, Consts;

resourcestring
  SDuplicateInteger = 'Integer list does not allow duplicates';

type

{ EIntegerListError class }

  EIntegerListError = class(Exception);

{ TIntegers class }

  TIntegers = class(TPersistent)
  private
    FUpdateCount: Integer;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Error(const Msg: string; Data: Integer); overload;
    procedure Error(Msg: PResStringRec; Data: Integer); overload;
    function Get(Index: Integer): Integer; virtual; abstract;
    function GetTextStr: string;
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual; abstract;
    function GetObject(Index: Integer): TObject; virtual;
    procedure Put(Index: Integer; const I: Integer); virtual;
    procedure PutObject(Index: Integer; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
    procedure SetTextStr(const Value: string);
    procedure SetUpdateState(Updating: Boolean); virtual;
  public
    destructor Destroy; override;
    function Add(const I: Integer): Integer; virtual;
    function AddObject(const I: Integer; AObject: TObject): Integer; virtual;
    procedure Append(const I: Integer);
    procedure AddIntegers(Integers: TIntegers); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear; virtual; abstract;
    procedure Delete(Index: Integer); virtual; abstract;
    procedure EndUpdate;
    function Equals(Integers: TIntegers): Boolean;
    procedure Exchange(Index1, Index2: Integer); virtual;
    function IndexOf(const I: Integer): Integer; virtual;
    function IndexOfObject(AObject: TObject): Integer;
    procedure Insert(Index: Integer; const I: Integer); virtual; abstract;
    procedure InsertObject(Index: Integer; const I: Integer;
      AObject: TObject);
    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Integers[Index: Integer]: Integer read Get write Put; default;
  end;

{ TIntegerList class }

  TIntegerList = class;

  PIntegerItem = ^TIntegerItem;
  TIntegerItem = record
    FInteger: Integer;
    FObject: TObject;
  end;

  PIntegerItemList = ^TIntegerItemList;
  TIntegerItemList = array[0..MaxListSize] of TIntegerItem;
  TIntegerListSortCompare = function(List: TIntegerList; Index1, Index2: Integer): Integer;

  TIntegerList = class(TIntegers)
  private
    FList: PIntegerItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TIntegerListSortCompare);
    procedure InsertItem(Index: Integer; const I: Integer);
    procedure SetSorted(Value: Boolean);
  protected
    procedure Changed; virtual;
    procedure Changing; virtual;
    function Get(Index: Integer): Integer; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure Put(Index: Integer; const I: Integer); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    destructor Destroy; override;
    function Add(const I: Integer): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const I: Integer; var Index: Integer): Boolean; virtual;
    function IndexOf(const I: Integer): Integer; override;
    procedure Insert(Index: Integer; const I: Integer); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TIntegerListSortCompare); virtual;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
  end;

implementation

{ TIntegers }

destructor TIntegers.Destroy;
begin
  inherited Destroy;
end;

function TIntegers.Add(const I: Integer): Integer;
begin
  Result := GetCount;
  Insert(Result, I);
end;

function TIntegers.AddObject(const I: Integer; AObject: TObject): Integer;
begin
  Result := Add(I);
  PutObject(Result, AObject);
end;

procedure TIntegers.Append(const I: Integer);
begin
  Add(I);
end;

procedure TIntegers.AddIntegers(Integers: TIntegers);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Integers.Count - 1 do
      AddObject(Integers[I], Integers.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure TIntegers.Assign(Source: TPersistent);
begin
  if Source is TIntegers then
  begin
    BeginUpdate;
    try
      Clear;
      AddIntegers(TIntegers(Source));
    finally
      EndUpdate;
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TIntegers.BeginUpdate;
begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

procedure TIntegers.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TIntegers then
        Result := not Equals(TIntegers(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;

begin
  Filer.DefineProperty('Integers', ReadData, WriteData, DoWrite);
end;

procedure TIntegers.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then SetUpdateState(False);
end;

function TIntegers.Equals(Integers: TIntegers): Boolean;
var
  I, Count: Integer;
begin
  Result := False;
  Count := GetCount;
  if Count <> Integers.GetCount then Exit;
  for I := 0 to Count - 1 do if Get(I) <> Integers.Get(I) then Exit;
  Result := True;
end;

procedure TIntegers.Error(const Msg: string; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EIntegerListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TIntegers.Error(Msg: PResStringRec; Data: Integer);
begin
  Error(LoadResString(Msg), Data);
end;

procedure TIntegers.Exchange(Index1, Index2: Integer);
var
  TempObject: TObject;
  TempInteger: Integer;
begin
  BeginUpdate;
  try
    TempInteger := Integers[Index1];
    TempObject := Objects[Index1];
    Integers[Index1] := Integers[Index2];
    Objects[Index1] := Objects[Index2];
    Integers[Index2] := TempInteger;
    Objects[Index2] := TempObject;
  finally
    EndUpdate;
  end;
end;

function TIntegers.GetTextStr: string;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S: string;
begin
  Count := GetCount;
  Size := 0;
  for I := 0 to Count - 1 do Inc(Size, Length(IntToStr(Get(I))) + 2);
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := IntToStr(Get(I));
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    P^ := #13;
    Inc(P);
    P^ := #10;
    Inc(P);
  end;
end;

function TIntegers.GetCapacity: Integer;
begin
  Result := Count;
end;

function TIntegers.GetObject(Index: Integer): TObject;
begin
  Result := nil;
end;

function TIntegers.IndexOf(const I: Integer): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if Get(Result) = I then Exit;
  Result := -1;
end;

function TIntegers.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

procedure TIntegers.InsertObject(Index: Integer; const I: Integer;
  AObject: TObject);
begin
  Insert(Index, I);
  PutObject(Index, AObject);
end;

procedure TIntegers.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TIntegers.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: string;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, nil, Size);
    Stream.Read(Pointer(S)^, Size);
    SetTextStr(S);
  finally
    EndUpdate;
  end;
end;

procedure TIntegers.Move(CurIndex, NewIndex: Integer);
var
  TempObject: TObject;
  TempInteger: Integer;
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      TempInteger := Get(CurIndex);
      TempObject := GetObject(CurIndex);
      Delete(CurIndex);
      InsertObject(NewIndex, TempInteger, TempObject);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TIntegers.Put(Index: Integer; const I: Integer);
var
  TempObject: TObject;
begin
  TempObject := GetObject(Index);
  Delete(Index);
  InsertObject(Index, I, TempObject);
end;

procedure TIntegers.PutObject(Index: Integer; AObject: TObject);
begin
end;

procedure TIntegers.ReadData(Reader: TReader);
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do Add(Reader.ReadInteger);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TIntegers.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TIntegers.SaveToStream(Stream: TStream);
var
  S: String;
begin
  S := GetTextStr;
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

procedure TIntegers.SetCapacity(NewCapacity: Integer);
begin
end;

procedure TIntegers.SetTextStr(const Value: string);
var
  P, Start: PChar;
  S: string;
begin
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in [#0, #10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        Add(StrToIntDef(S, -1));
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
  finally
    EndUpdate;
  end;
end;

procedure TIntegers.SetUpdateState(Updating: Boolean);
begin
end;

procedure TIntegers.WriteData(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do Writer.WriteInteger(Get(I));
  Writer.WriteListEnd;
end;

{ TIntegerList }

destructor TIntegerList.Destroy;
begin
  FOnChange := nil;
  FOnChanging := nil;
  inherited Destroy;
  FCount := 0;
  SetCapacity(0);
end;

function TIntegerList.Add(const I: Integer): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(I, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error('Integer list does not allow duplicates', 0);
      end;
  InsertItem(Result, I);
end;

procedure TIntegerList.Changed;
begin
  if (FUpdateCount = 0) and Assigned(FOnChange) then FOnChange(Self);
end;

procedure TIntegerList.Changing;
begin
  if (FUpdateCount = 0) and Assigned(FOnChanging) then FOnChanging(Self);
end;

procedure TIntegerList.Clear;
begin
  if FCount <> 0 then
  begin
    Changing;
    FCount := 0;
    SetCapacity(0);
    Changed;
  end;
end;

procedure TIntegerList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error('Integer list does not allow duplicates', Index);
  Changing;
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TIntegerItem));
  Changed;
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error('Integer list does not allow duplicates', Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error('Integer list does not allow duplicates', Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TIntegerList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Integer;
  Item1, Item2: PIntegerItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := Integer(Item1^.FInteger);
  Integer(Item1^.FInteger) := Integer(Item2^.FInteger);
  Integer(Item2^.FInteger) := Temp;
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
end;

function TIntegerList.Find(const I: Integer; var Index: Integer): Boolean;
var
  L, H, J: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    J := (L + H) shr 1;
    if FList^[J].FInteger < I then L := J + 1 else
    begin
      H := J - 1;
      if FList^[J].FInteger = I then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := J;
      end;
    end;
  end;
  Index := L;
end;

function TIntegerList.Get(Index: Integer): Integer;
begin
  if (Index < 0) or (Index >= FCount) then Error('SListIndexError', Index);
  Result := FList^[Index].FInteger;
end;

function TIntegerList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TIntegerList.GetCount: Integer;
begin
  Result := FCount;
end;

function TIntegerList.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error('@SListIndexError', Index);
  Result := FList^[Index].FObject;
end;

procedure TIntegerList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TIntegerList.IndexOf(const I: Integer): Integer;
begin
  if not Sorted then Result := inherited IndexOf(I) else
    if not Find(I, Result) then Result := -1;
end;

procedure TIntegerList.Insert(Index: Integer; const I: Integer);
begin
  if Sorted then Error('@SSortedListError', 0);
  if (Index < 0) or (Index > FCount) then Error('@SListIndexError', Index);
  InsertItem(Index, I);
end;

procedure TIntegerList.InsertItem(Index: Integer; const I: Integer);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TIntegerItem));
  with FList^[Index] do
  begin
    Pointer(FInteger) := nil;
    FObject := nil;
    FInteger := I;
  end;
  Inc(FCount);
  Changed;
end;

procedure TIntegerList.Put(Index: Integer; const I: Integer);
begin
  if Sorted then Error('@SSortedListError', 0);
  if (Index < 0) or (Index >= FCount) then Error('@SListIndexError', Index);
  Changing;
  FList^[Index].FInteger := I;
  Changed;
end;

procedure TIntegerList.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error('@SListIndexError', Index);
  Changing;
  FList^[Index].FObject := AObject;
  Changed;
end;

procedure TIntegerList.QuickSort(L, R: Integer; SCompare: TIntegerListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TIntegerList.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TIntegerItem));
  FCapacity := NewCapacity;
end;

procedure TIntegerList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TIntegerList.SetUpdateState(Updating: Boolean);
begin
  if Updating then Changing else Changed;
end;

function IntegerListCompare(List: TIntegerList; Index1, Index2: Integer): Integer;
begin
  Result := List.FList^[Index1].FInteger - List.FList^[Index2].FInteger;
end;

procedure TIntegerList.Sort;
begin
  CustomSort(IntegerListCompare);
end;

procedure TIntegerList.CustomSort(Compare: TIntegerListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

end.