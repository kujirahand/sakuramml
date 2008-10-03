unit hashUnit;
{-------------------------------------------------------------------------------
�@���`���X�g��p�����ėp�n�b�V��
�@��@�ҁF�R�{���(mine@text2music.com)
�@�쐬���F2002/02/16
--------------------------------------------------------------------------------
�g�����F

var
	hash: TPtrHash;
    str: string;
begin
    str := 'test success!';

	hash := TPtrHash.Create ;         // ����
    hash['abc'] := PChar(str);        // �ǉ�
    ShowMessage(PChar(hash['abc']));  // �Q��
    hash.Free;                        // �j��
end;

-------------------------------------------------------------------------------}
interface
uses
  SysUtils, Classes;

const
  HASH_TABLE_SIZE = 256;

type
  //----------------------------------------------------------------------------
  //THash, THashNode ���A�p�������ăN���X�����
  THashNode = class(TObject) //���ێg���ꍇ�́A������p�����āA�f�[�^�^�����
  public
    Key: string;
    LinkNext: THashNode;
    constructor Create(Key: string);
  end;
  THashNodeTable = array of THashNode;

  THash = class
  private
    FCount: Integer;
    NodeTable: THashNodeTable;
    function MakeHashKeyNo(key: string): Integer;//key�𐮐�������
    function subLet(node: THashNode; RewriteMode: Boolean): Boolean;//Add, Let �̉�����
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(node: THashNode): Boolean; // HASH�֒ǉ��F��d�ǉ��͏o���Ȃ�
    procedure Let(node: THashNode);         // HASH�֑���FNODE���㏑��
    function Delete(key: string): Boolean;
    function Find(key: string): THashNode;
    function EnumKey: TStringList;
    property Count: Integer read FCount;
  end;
  //----------------------------------------------------------------------------
  //Pointer �^�� �n�b�V��
  TPtrHashNode = class(THashNode)
  public
    Ptr: Pointer;
    constructor Create(key: string; ptr: Pointer);
  end;
  TPtrHash = class(THash)
  private
    function GetValue(key: string): Pointer;
    procedure SetValue(key: string; ptr: Pointer);
  public
    property Items[key: string]:Pointer read GetValue write SetValue; default;
  end;

implementation

{ THash }

function THash.Add(node: THashNode): Boolean;
begin
	Result := subLet(node, False);
end;

procedure THash.Clear;
var
    i: Integer;
    node: THashNode;

    procedure FreeLinkNode(n: THashNode);
    begin
    	if n=nil then Exit;
        FreeLinkNode(n.LinkNext);
        n.Free;
    end;

begin
    for i:=0 to High(nodeTable) do
    begin
        node := nodeTable[i];
        if node<>nil then FreeLinkNode(node);
        nodeTable[i] := nil;
    end;
end;

constructor THash.Create;
var
    i:Integer;
begin
    SetLength(nodeTable, HASH_TABLE_SIZE);
    for i:=0 to High(nodeTable) do
    begin
    	nodeTable[i] := nil;
    end;
    FCount := 0;
end;


function THash.Delete(key: string): Boolean;
var
	no: Integer;
	n, prev: THashNode;
begin
    Result := False;
    if key='' then Exit;

    no := MakeHashKeyNo(key);
	n := nodeTable[no];
    if n = nil then Exit;

    //top?
    if n.Key = key then
    begin
    	n.Free;
        nodeTable[no] := nil;
        Result := True;
        Exit;
    end;
    //Find Loop
    while n.LinkNext <> nil do
    begin
    	prev := n; n := n.LinkNext ;
        if n.Key = key then
        begin // Find!
        	prev.LinkNext := n.LinkNext ;
            n.Free;
            Result := True;
            Exit;
        end;
    end;
end;

destructor THash.Destroy;
begin
    inherited;
    Clear;
end;

function THash.EnumKey: TStringList;
var
	i: Integer;
    n: THashNode;
begin
	Result := TStringList.Create;

	for i:=0 to High(nodeTable) do
    begin
		n := nodeTable[i];
    	if n=nil then Continue;
        while n<>nil do
        begin
        	Result.Add( n.Key );
            n := n.LinkNext ;
        end;
    end;
end;

function THash.Find(key: string): THashNode;
var
	n: THashNode;
begin
    Result := nil;
    if key='' then Exit;

	n := nodeTable[MakeHashKeyNo(key)];
    if n = nil then Exit;

    //Find Loop
    while n<>nil do
    begin
    	if n.Key = key then
        begin
        	Result := n;
            Break;
        end;
        n := n.LinkNext ;
    end;
end;


procedure THash.Let(node: THashNode);
begin
	subLet(node, True);
end;

function THash.MakeHashKeyNo(key: string): Integer;
var
	i,len: Integer;
begin
	len := Length(key) and $F;
    Result := 0;
    for i:=1 to len do
    begin
    	Result := Result + Ord(key[i]) + i;
    end;
    Result := Result mod HASH_TABLE_SIZE;
end;

function THash.subLet(node: THashNode; RewriteMode: Boolean): Boolean;
var
	n, nn: THashNode;
    no: Integer;
begin
    Result := False;
    if node.Key = '' then Exit;

    no := MakeHashKeyNo(node.key);
	n := nodeTable[ no ];

    if n=nil then //Table�֏��߂Ēǉ�����Ƃ�
    begin
    	nodeTable[no] := node;
        node.LinkNext := nil;
    end else
    begin //�ȉ��̃m�[�h�֒ǉ�
    	if n.Key = node.Key then // TOP �ŁA�L�[���_�u��
        begin
        	if RewriteMode = False then Exit; //�㏑���֎~�Ȃ玸�s
            n.Free;
            nodeTable[no] := node;
            Result := True;
            Exit;
        end;
        //�m�[�h�̈�ԉ��܂�
        while (n.LinkNext <> nil) do
        begin
            nn := n; n := n.LinkNext; // nn -> n �̊֌W
            if n.Key = node.Key then
            begin
            	if RewriteMode = False then Exit; //�㏑���֎~�Ȃ玸�s
                // nn -> n -> n.Next ���Ann-> node -> n.Next �ɏ�������
            	nn.LinkNext := node;
                node.LinkNext := n.LinkNext ;
                Result := True;
                Exit;
            end;
        end;
        //��ԉ��܂ŗ����Ƃ��́A�ǉ�
        n.LinkNext := node;
        node.LinkNext := nil;
    end;
    Result := True;
    Inc(FCount);
end;

{ THashNode }

constructor THashNode.Create(Key: string);
begin
	Self.Key := Key;
    LinkNext := nil;
end;

{ TPtrHashNode }

constructor TPtrHashNode.Create(key: string; ptr: Pointer);
begin
	inherited Create(key);
    Self.Ptr := ptr;
end;

{ TPtrHash }

function TPtrHash.GetValue(key: string): Pointer;
var
	node: THashNode;
begin
	node := Find(key);
    if node=nil then
    begin
    	Result := nil; Exit;
    end;
    Result := TPtrHashNode( node ).Ptr ;
end;

procedure TPtrHash.SetValue(key: string; ptr: Pointer);
var
	node: THashNode;
begin
	node := TPtrHashNode.Create(key, ptr);
   	Let(node);
end;

end.
